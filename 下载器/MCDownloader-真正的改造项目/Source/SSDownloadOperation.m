
#import "SSDownloadOperation.h"


NS_ASSUME_NONNULL_BEGIN

NSString *const SSDownloadStartNotification = @"SSDownloadStartNotification";
NSString *const SSDownloadReceiveResponseNotification = @"SSDownloadReceiveResponseNotification";
NSString *const SSDownloadStopNotification = @"SSDownloadStopNotification";
NSString *const SSDownloadFinishNotification = @"SSDownloadFinishNotification";

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

typedef NSMutableDictionary<NSString *, id> SSCallbacksDictionary;


@interface SSDownloadOperation ()

@property (strong, nonatomic, nonnull) NSMutableArray<SSCallbacksDictionary *> *callbackBlocks;

@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

// This is weak because it is injected by whoever manages this session. If this gets nil-ed out, we won't be able to run
// the task associated with this operation
@property (weak, nonatomic, nullable) NSURLSession *unownedSession;
// This is set if we're using not using an injected NSURLSession. We're responsible of invalidating this one
@property (strong, nonatomic, nullable) NSURLSession *ownedSession;



@property (strong, nonatomic, readwrite, nullable) NSURLSessionTask *dataTask;
// 回掉的队列
@property (strong, nonatomic, nullable) dispatch_queue_t barrierQueue;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

@property (assign, nonatomic) long long totalBytesWritten;

@property (assign, nonatomic) long long totalBytesExpectedToWrite;

@property (strong, nonatomic) SSDownloadItem *receipt;
@end

@implementation SSDownloadOperation
{
    BOOL responseFroSSached;
}

@synthesize executing = _executing;
@synthesize finished = _finished;

- (SSDownloadItem *)receipt {
    if (_receipt == nil) {
        _receipt = [[SSDownloaderManager sharedDownloader] downloadReceiptForURLString:self.request.URL.absoluteString];
    }
    return _receipt;
}
- (nonnull instancetype)init {
    return [self initWithRequest:nil inSession:nil];
}

- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request inSession:(nullable NSURLSession *)session  {
    if ((self = [super init])) {
        _request = [request copy];
        _callbackBlocks = [NSMutableArray new];
        _executing = NO;
        _finished = NO;
        _expectedSize = 0;
        _unownedSession = session;
        responseFroSSached = YES; // Initially wrong until `- URLSession:dataTask:willCacheResponse:completionHandler: is called or not called
        _barrierQueue = dispatch_queue_create("com.machao.SSDownloaderManagerOperationBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        
        [self.receipt setState:SSDownloadStateWillResume];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (nullable id)addHandlersForProgress:(nullable SSDownloaderManagerProgressBlock)progressBlock
                            completed:(nullable SSDownloaderManagerCompletedBlock)completedBlock {
    SSCallbacksDictionary *callbacks = [NSMutableDictionary new];
    if (progressBlock) callbacks[kProgressCallbackKey] = [progressBlock copy];
    if (completedBlock) callbacks[kCompletedCallbackKey] = [completedBlock copy];
    dispatch_barrier_async(self.barrierQueue, ^{
        [self.callbackBlocks addObject:callbacks];
    });
    return callbacks;
}

- (nullable NSArray<id> *)callbacksForKey:(NSString *)key {
    __block NSMutableArray<id> *callbacks = nil;
    dispatch_sync(self.barrierQueue, ^{
        // We need to remove [NSNull null] because there might not always be a progress block for each callback
        callbacks = [[self.callbackBlocks valueForKey:key] mutableCopy];
        [callbacks removeObjectIdenticalTo:[NSNull null]];
    });
    return [callbacks copy];    // strip mutability here
}

- (BOOL)cancel:(nullable id)token {
    __block BOOL shouldCancel = NO;
    dispatch_barrier_sync(self.barrierQueue, ^{
        [self.callbackBlocks removeAllObjects];
        if (self.callbackBlocks.count == 0) {
            shouldCancel = YES;
        }
    });
    if (shouldCancel) {
        [self cancel];
    }
    return shouldCancel;
}

- (void)start {
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            [self reset];
            return;
        }
        
#if TARGET_OS_IOS
        Class UIApplicationClass = NSClassFromString(@"UIApplication");
        BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
        if (hasApplication && [self shouldContinueWhenAppEntersBackground]) {
            __weak __typeof__ (self) wself = self;
            UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
            self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
                __strong __typeof (wself) sself = wself;
                
                if (sself) {
                    [sself cancel];
                    
                    [app endBackgroundTask:sself.backgroundTaskId];
                    sself.backgroundTaskId = UIBackgroundTaskInvalid;
                }
            }];
        }
#endif
        NSURLSession *session = self.unownedSession;
        if (!self.unownedSession) {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.timeoutIntervalForRequest = 15;
            
            /**
             *  Create the session for this task
             *  We send nil as delegate queue so that the session creates a serial operation queue for performing all delegate
             *  method calls and completion handler calls.
             */
            self.ownedSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:self
                                                         delegateQueue:nil];
            session = self.ownedSession;
        }

        self.dataTask = [session dataTaskWithRequest:self.request];
        self.executing = YES;
    }
    
    [self.dataTask resume];
    
    if (self.dataTask) {
        for (SSDownloaderManagerProgressBlock progressBlock in [self callbacksForKey:kProgressCallbackKey]) {
            progressBlock(0, NSURLResponseUnknownLength, 0, self.request.URL);
        }
        [self.receipt setState:SSDownloadStateDownloading];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SSDownloadStartNotification object:self];
        });
    } else {
        [self callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Connection can't be initialized"}]];
    }
    
#if TARGET_OS_IOS
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
#endif
}

- (void)cancel {
    @synchronized (self) {
        [self cancelInternal];
    }
}

- (void)cancelInternal {
    if (self.isFinished) return;
    [super cancel];
    
    if (self.dataTask) {
        [self.dataTask cancel];
        [self.receipt setState:SSDownloadStateNone];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SSDownloadStopNotification object:self];
        });
        
        // As we cancelled the connection, its callback won't be called and thus won't
        // maintain the isFinished and isExecuting flags.
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    
    [self reset];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    dispatch_barrier_async(self.barrierQueue, ^{
        [self.callbackBlocks removeAllObjects];
    });
    self.dataTask = nil;
    if (self.ownedSession) {
        [self.ownedSession invalidateAndCancel];
        self.ownedSession = nil;
    }
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}


///ssb

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    //'304 Not Modified' is an exceptional one
    if (![response respondsToSelector:@selector(statusCode)] || (((NSHTTPURLResponse *)response).statusCode < 400 && ((NSHTTPURLResponse *)response).statusCode != 304)) {
        
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        
        SSDownloadItem *receipt = [[SSDownloaderManager sharedDownloader] downloadReceiptForURLString:self.request.URL.absoluteString];
        [receipt setTotalBytesExpectedToWrite:expected + receipt.totalBytesWritten];
        
        receipt.date = [NSDate date];
        
        self.expectedSize = expected;
        for (SSDownloaderManagerProgressBlock progressBlock in [self callbacksForKey:kProgressCallbackKey]) {
            progressBlock(0, expected, 0,self.request.URL);
        }

        self.response = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SSDownloadReceiveResponseNotification object:self];
        });
    }else if (![response respondsToSelector:@selector(statusCode)] || (((NSHTTPURLResponse *)response).statusCode == 416)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SSDownloadFinishNotification object:self];
        
        [self callCompletionBlocksWithFileURL:[NSURL fileURLWithPath:self.receipt.filePath] data:[NSData dataWithContentsOfFile:self.receipt.filePath] error:nil finished:YES];
        [self done];
    }
    else {
        NSUInteger code = ((NSHTTPURLResponse *)response).statusCode;
        
        //This is the case when server returns '304 Not Modified'. It means that remote image is not changed.
        //In case of 304 we need just cancel the operation and return cached image from the cache.
        if (code == 304) {
            [self cancelInternal];
        } else {
            [self.dataTask cancel];
            [self.receipt setState:SSDownloadStateNone];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SSDownloadStopNotification object:self];
        });
        
        [self callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:((NSHTTPURLResponse *)response).statusCode userInfo:nil]];
        [self.receipt setState:SSDownloadStateNone];
        [self done];
    }
    
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
  
    __block NSError *error = nil;
    SSDownloadItem *receipt = [[SSDownloaderManager sharedDownloader] downloadReceiptForURLString:self.request.URL.absoluteString];
    
    // Speed
    receipt.totalRead += data.length;
    NSDate *currentDate = [NSDate date];
    if ([currentDate timeIntervalSinceDate:receipt.date] >= 1) {
        double time = [currentDate timeIntervalSinceDate:receipt.date];
        long long speed = receipt.totalRead/time;
        receipt.speed = [self formatByteCount:speed];
        receipt.totalRead = 0.0;
        receipt.date = currentDate;
    }
    
    // Write Data
    NSInputStream *inputStream =  [[NSInputStream alloc] initWithData:data];
    
    NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:[NSURL fileURLWithPath:receipt.filePath] append:YES];
    
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    // 一个是从流中读取 一个去xie'r
    while ([inputStream hasBytesAvailable] && [outputStream hasSpaceAvailable]) {
        
        uint8_t buffer[1024];
        
        NSInteger bytesRead = [inputStream read:buffer maxLength:1024];
        if (inputStream.streamError || bytesRead < 0) {
            error = inputStream.streamError;
            break;
        }
        
        NSInteger bytesWritten = [outputStream write:buffer maxLength:(NSUInteger)bytesRead];
        if (outputStream.streamError || bytesWritten < 0) {
            error = outputStream.streamError;
            break;
        }
        
        if (bytesRead == 0 && bytesWritten == 0) {
            break;
        }
    }
    [outputStream close];
    [inputStream close];
    
    receipt.progress.totalUnitCount = receipt.totalBytesExpectedToWrite;
    receipt.progress.completedUnitCount = receipt.totalBytesWritten;
    
    dispatch_main_async_safe(^{
        for (SSDownloaderManagerProgressBlock progressBlock in [self callbacksForKey:kProgressCallbackKey]) {
            progressBlock(receipt.progress.completedUnitCount, receipt.progress.totalUnitCount, receipt.speed.integerValue, self.request.URL);
        }
        if (self.receipt.downloaderProgressBlock) {
            self.receipt.downloaderProgressBlock(receipt.progress.completedUnitCount, receipt.progress.totalUnitCount, receipt.speed.integerValue, self.request.URL);
        }
    });
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    responseFroSSached = NO; // If this method is called, it means the response wasn't read from cache
    NSCachedURLResponse *cachedResponse = proposedResponse;
    
    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    @synchronized(self) {
        self.dataTask = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SSDownloadStopNotification object:self];
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SSDownloadFinishNotification object:self];
            }
        });
    }
    
    if (error) {
        [self callCompletionBlocksWithError:error];
    } else {
        SSDownloadItem *receipt = self.receipt;
        [receipt setState:SSDownloadStateCompleted];
        if ([self callbacksForKey:kCompletedCallbackKey].count > 0) {
            
            [self callCompletionBlocksWithFileURL:[NSURL fileURLWithPath:receipt.filePath] data:[NSData dataWithContentsOfFile:receipt.filePath] error:nil finished:YES];

        }
        dispatch_main_async_safe(^{
            if (self.receipt.downloaderCompletedBlock) {
                self.receipt.downloaderCompletedBlock(receipt, nil, YES);
            }
        });
    }
    [self done];
}




- (BOOL)shouldContinueWhenAppEntersBackground {
    return YES;
}

- (void)callCompletionBlocksWithError:(nullable NSError *)error {
    [self callCompletionBlocksWithFileURL:nil data:nil error:error finished:YES];
}

- (void)callCompletionBlocksWithFileURL:(nullable NSURL *)fileURL
                            data:(nullable NSData *)data
                                error:(nullable NSError *)error
                             finished:(BOOL)finished {
    
    if (error) {
        [self.receipt setState:SSDownloadStateFailed];
    }else {
        [self.receipt setState:SSDownloadStateCompleted];
    }
    NSArray<id> *completionBlocks = [self callbacksForKey:kCompletedCallbackKey];
    dispatch_main_async_safe(^{
        for (SSDownloaderManagerCompletedBlock completedBlock in completionBlocks) {
            completedBlock(self.receipt, error, finished);
        }
        
        if (self.receipt.downloaderCompletedBlock) {
            self.receipt.downloaderCompletedBlock(self.receipt, error, YES);
        }
    });
}

- (NSString*)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}
@end


NS_ASSUME_NONNULL_END
