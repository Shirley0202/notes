
#import "SSDownloaderManager.h"
#import "SSDownloadOperation.h"
#import "SSDownloadItem.h"

NSString * const SSDownloadCacheFolderName = @"SSDownloadCache";

static NSString *cacheFolderPath;

NSString * cacheFolder() {
    if (!cacheFolderPath) {
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
        cacheFolderPath = [cacheDir stringByAppendingPathComponent:SSDownloadCacheFolderName];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        NSError *error = nil;
        if(![filemgr createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Failed to create cache directory at %@", cacheFolderPath);
            cacheFolderPath = nil;
        }
    }
    return cacheFolderPath;
}
//
static void clearCacheFolder() {
    cacheFolderPath = nil;
}

// 报存的下载的receipte
static NSString * LocalReceiptsPath() {
    return [cacheFolder() stringByAppendingPathComponent:@"receipts.data"];
}

@interface SSDownloaderManager() <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
//下载的队列
@property (strong, nonatomic, nonnull) NSOperationQueue *downloadQueue;
// 最后添加的操作
@property (weak, nonatomic, nullable) NSOperation *lastAddedOperation;
@property (assign, nonatomic, nullable) Class operationClass;
// 所有的操作对象
@property (strong, nonatomic, nonnull) NSMutableDictionary<NSURL *, SSDownloadOperation *> *URLOperations;

//请求的header
@property (strong, nonatomic, nullable) SSHTTPHeadersMutableDictionary *HTTPHeaders;

//单一处理回掉的队列
@property (strong, nonatomic, nullable) dispatch_queue_t barrierQueue;

// The session in which data tasks will run
@property (strong, nonatomic) NSURLSession *session;
//所有的url作为key receipt 作为value
@property (nonatomic, strong) NSMutableDictionary *allDownloadReceipts;
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

@end
@implementation SSDownloaderManager

- (NSMutableDictionary *)allDownloadReceipts {
    if (_allDownloadReceipts == nil) {
        NSDictionary *receipts = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalReceiptsPath()];
        _allDownloadReceipts = receipts != nil ? receipts.mutableCopy : [NSMutableDictionary dictionary];
    }
    return _allDownloadReceipts;
}

+ (nonnull instancetype)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (nonnull instancetype)init {
    return [self initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (nonnull instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)sessionConfiguration {
    if ((self = [super init])) {
        _operationClass = [SSDownloadOperation class];
       
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 3;
        _downloadQueue.name = @"com.machao.SSDownloaderManager";
        _URLOperations = [NSMutableDictionary new];
        _barrierQueue = dispatch_queue_create("com.machao.SSDownloaderManagerBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _downloadTimeout = 15.0;
        
        sessionConfiguration.timeoutIntervalForRequest = _downloadTimeout;
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 10;
        /**
         *  Create the session for this task
         *  We send nil as delegate queue so that the session creates a serial operation queue for performing all delegate
         *  method calls and completion handler calls.
         */
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                     delegate:self
                                                delegateQueue:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

#pragma mark -  NSNotification
- (void)applicationWillTerminate:(NSNotification *)not {
    [self setAllStateToNone];
    [self saveAllDownloadReceipts];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)not {
    [self saveAllDownloadReceipts];
}

- (void)applicationWillResignActive:(NSNotification *)not {
    [self saveAllDownloadReceipts];
    /// 捕获到失去激活状态后
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
    if (hasApplication ) {
        __weak __typeof__ (self) wself = self;
        UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
        self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
            __strong __typeof (wself) sself = wself;
            
            if (sself) {
                [sself setAllStateToNone];
                [sself saveAllDownloadReceipts];
                
                [app endBackgroundTask:sself.backgroundTaskId];
                sself.backgroundTaskId = UIBackgroundTaskInvalid;
            }
        }];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)not {
    
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
    
    NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *cachePath = [cacheDir stringByAppendingPathComponent:SSDownloadCacheFolderName];
    NSString *existedCacheFolderPath = cacheFolder();
    if (existedCacheFolderPath && ![existedCacheFolderPath isEqualToString:cachePath]) {
        clearCacheFolder();
        [self.allDownloadReceipts enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[SSDownloadItem class]]) {
                SSDownloadItem *receipt = obj;
                [receipt setValue:nil forKey:@"filePath"];
            }
        }];
    }
}

- (void)setAllStateToNone {
    [self.allDownloadReceipts enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SSDownloadItem class]]) {
            SSDownloadItem *receipt = obj;
            if (receipt.state != SSDownloadStateCompleted) {
                [receipt setState:SSDownloadStateNone];
            }
        }
    }];
}

- (void)saveAllDownloadReceipts {
    [NSKeyedArchiver archiveRootObject:self.allDownloadReceipts toFile:LocalReceiptsPath()];
}

- (void)dealloc {
    [self.session invalidateAndCancel];
    self.session = nil;
    [self.downloadQueue cancelAllOperations];
}

- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field {
    if (value) {
        self.HTTPHeaders[field] = value;
    }
    else {
        [self.HTTPHeaders removeObjectForKey:field];
    }
}

- (nullable NSString *)valueForHTTPHeaderField:(nullable NSString *)field {
    return self.HTTPHeaders[field];
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    _downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

- (NSUInteger)currentDownloadCount {
    return _downloadQueue.operationCount;
}

- (NSInteger)maxConcurrentDownloads {
    return _downloadQueue.maxConcurrentOperationCount;
}

- (void)setOperationClass:(nullable Class)operationClass {
    if (operationClass && [operationClass isSubclassOfClass:[NSOperation class]] && [operationClass conformsToProtocol:@protocol(SSDownloaderManagerOperationInterface)]) {
        _operationClass = operationClass;
    } else {
        _operationClass = [SSDownloadOperation class];
    }
}

- (nullable SSDownloadItem *)downloadDataWithURL:(nullable NSURL *)url
                                                  progress:(nullable SSDownloaderManagerProgressBlock)progressBlock
                                                 completed:(nullable SSDownloaderManagerCompletedBlock)completedBlock {
    __weak SSDownloaderManager *wself = self;
    // 获取
    SSDownloadItem *receipt = [self downloadReceiptForURLString:url.absoluteString];
    
    //判断是否已经完成 
    if (receipt.state == SSDownloadStateCompleted) {
        dispatch_main_async_safe(^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SSDownloadFinishNotification object:self];
            if (completedBlock) {
                completedBlock(receipt ,nil ,YES);
            }
            if (receipt.downloaderCompletedBlock) {
                receipt.downloaderCompletedBlock(receipt, nil, YES);
            }
            
        });
        return receipt;
    }
    
    
    
    
    return [self addProgressCallback:progressBlock completedBlock:completedBlock forURL:url createCallback:^SSDownloadOperation *{
        __strong __typeof (wself) sself = wself;
        
        NSTimeInterval timeoutInterval = sself.downloadTimeout;
        if (timeoutInterval == 0.0) {
            timeoutInterval = 15.0;
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        SSDownloadItem *receipt = [sself downloadReceiptForURLString:url.absoluteString];
        if (receipt.totalBytesWritten > 0) {
            NSString *range = [NSString stringWithFormat:@"bytes=%zd-", receipt.totalBytesWritten];
            [request setValue:range forHTTPHeaderField:@"Range"];
        }
        
        request.HTTPShouldUsePipelining = YES;

        if (sself.headersFilter) {
            request.allHTTPHeaderFields = sself.headersFilter(url, [sself.HTTPHeaders copy]);
        }
        else {
            request.allHTTPHeaderFields = sself.HTTPHeaders;
        }
        

        SSDownloadOperation *operation = [[sself.operationClass alloc] initWithRequest:request inSession:sself.session];

        [sself.downloadQueue addOperation:operation];
        
        return operation;
    }];
}

#pragma mark -  通过一个url 来创建一个 SSDownloadItem
- (SSDownloadItem *)downloadReceiptForURLString:(NSString *)URLString {
    if (URLString == nil) {
        return nil;
    }
    //判断 是否在下载
    if (self.allDownloadReceipts[URLString]) {
        return self.allDownloadReceipts[URLString];
    }else {
        //没有再现在的队列就开始下载
        SSDownloadItem *receipt = [[SSDownloadItem alloc] initWithURLString:URLString downloadOperationCancelToken:nil downloaderProgressBlock:nil downloaderCompletedBlock:nil];
        self.allDownloadReceipts[URLString] = receipt;
        return receipt;
    }
    
    return nil;
}



- (nullable SSDownloadItem *)addProgressCallback:(SSDownloaderManagerProgressBlock)progressBlock
                                           completedBlock:(SSDownloaderManagerCompletedBlock)completedBlock
                                                   forURL:(nullable NSURL *)url
                                           createCallback:(SSDownloadOperation *(^)())createCallback {
    // The URL will be used as the key to the callbacks dictionary so it cannot be nil. If it is nil immediately call the completed block with no image or data.
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, NO);
        }
        return nil;
    }
    
    __block SSDownloadItem *token = nil;
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        SSDownloadOperation *operation = self.URLOperations[url];
        if (!operation) {
            operation = createCallback();
            self.URLOperations[url] = operation;
            
            __weak SSDownloadOperation *woperation = operation;
            operation.completionBlock = ^{
                SSDownloadOperation *soperation = woperation;
                if (!soperation) return;
                if (self.URLOperations[url] == soperation) {
                    [self.URLOperations removeObjectForKey:url];
                };
            };
        }
        id downloadOperationCancelToken = [operation addHandlersForProgress:progressBlock completed:completedBlock];
        
        if (!self.allDownloadReceipts[url.absoluteString]) {
            token = [[SSDownloadItem alloc] initWithURLString:url.absoluteString
                                    downloadOperationCancelToken:downloadOperationCancelToken
                                         downloaderProgressBlock:nil
                                        downloaderCompletedBlock:nil];
            self.allDownloadReceipts[url.absoluteString] = token;
        }else {
            token = self.allDownloadReceipts[url.absoluteString];

            if (!token.downloadOperationCancelToken) {
                [token setDownloadOperationCancelToken:downloadOperationCancelToken];
            }
        }

    });
    
    return token;
}

#pragma mark - Control Methods

- (void)cancel:(nullable SSDownloadItem *)token completed:(nullable void (^)())completed {
    dispatch_barrier_async(self.barrierQueue, ^{
        SSDownloadOperation *operation = self.URLOperations[[NSURL URLWithString:token.url]];
        BOOL canceled = [operation cancel:token.downloadOperationCancelToken];
        if (canceled) {
            [self.URLOperations removeObjectForKey:[NSURL URLWithString:token.url]];
            [token setState:SSDownloadStateNone];
            //            [self.allDownloadReceipts removeObjectForKey:token.url];
       
        }
        dispatch_main_async_safe(^{
            if (completed) {
                completed();
            }
        });
    });
}

- (void)remove:(SSDownloadItem *)token completed:(nullable void (^)())completed{
    [token setState:SSDownloadStateNone];
    [self cancel:token completed:^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
    
        [fileManager removeItemAtPath:token.filePath error:nil];
        
        dispatch_main_async_safe(^{
            if (completed) {
                completed();
            }
        });
    }];
    
}

- (void)setSuspended:(BOOL)suspended {
    (self.downloadQueue).suspended = suspended;
}

- (void)cancelAllDownloads {
    [self.downloadQueue cancelAllOperations];
    [self setAllStateToNone];
    [self saveAllDownloadReceipts];
}

- (void)removeAndClearAll {
    [self cancelAllDownloads];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:cacheFolder() error:nil];
    clearCacheFolder();
}

#pragma mark Helper methods

- (SSDownloadOperation *)operationWithTask:(NSURLSessionTask *)task {
    SSDownloadOperation *returnOperation = nil;
    for (SSDownloadOperation *operation in self.downloadQueue.operations) {
        if (operation.dataTask.taskIdentifier == task.taskIdentifier) {
            returnOperation = operation;
            break;
        }
    }
    return returnOperation;
}





#pragma mark NSURLSessionDataDelegate
// 采用的是afn 的集体分发的方式
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    // Identify the operation that runs this task and pass it the delegate method
    SSDownloadOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    // Identify the operation that runs this task and pass it the delegate method
    SSDownloadOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    // Identify the operation that runs this task and pass it the delegate method
    SSDownloadOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // Identify the operation that runs this task and pass it the delegate method
    SSDownloadOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task didCompleteWithError:error];
}


@end
