
#import "MCDownloader.h"
#import "MCDownloadOperation.h"
#import "MCDownloadReceipt.h"
// 对应.h的两个常量
NSString * const MCDownloadCacheFolderName = @"MCDownloadCache";
static NSString *cacheFolderPath;
//缓存的地址
NSString * cacheFolder() {
    if (!cacheFolderPath) {
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
        cacheFolderPath = [cacheDir stringByAppendingPathComponent:MCDownloadCacheFolderName];
        NSFileManager *filemgr = [NSFileManager defaultManager];
        NSError *error = nil;
        if(![filemgr createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Failed to create cache directory at %@", cacheFolderPath);
            cacheFolderPath = nil;
        }
    }
    return cacheFolderPath;
}



//清除缓存的文件夹
static void clearCacheFolder() {
    cacheFolderPath = nil;
}

// 报存的下载的receipte
static NSString * LocalReceiptsPath() {
    return [cacheFolder() stringByAppendingPathComponent:@"receipts.data"];
}

@interface MCDownloader() <NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
//下载的队列
@property (strong, nonatomic, nonnull) NSOperationQueue *downloadQueue;

// 这个是用来配置自定义的时候使用的

// 所有的operations
@property (strong, nonatomic, nonnull) NSMutableDictionary<NSURL *, MCDownloadOperation *> *URLOperations;

//请求的header
@property (strong, nonatomic, nullable) MCHTTPHeadersMutableDictionary *HTTPHeaders;

//单一处理回掉的队列
@property (strong, nonatomic, nullable) dispatch_queue_t barrierQueue;

// The session in which data tasks will run
@property (strong, nonatomic) NSURLSession *session;
//所有的url作为key receipt 作为value
@property (nonatomic, strong) NSMutableDictionary *allDownloadReceipts;
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

@end
@implementation MCDownloader

- (NSMutableDictionary *)allDownloadReceipts {
    if (_allDownloadReceipts == nil) {
        NSDictionary *receipts = [NSKeyedUnarchiver unarchiveObjectWithFile:LocalReceiptsPath()];
        _allDownloadReceipts = receipts != nil ? receipts.mutableCopy : [NSMutableDictionary dictionary];
    }
    return _allDownloadReceipts;
}


// 1. 单例
+ (nonnull instancetype)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
// 2 初始化方法,
- (nonnull instancetype)init {
    return [self initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}
// 3. 这个可以把 NSURLSessionConfiguration 暴露给外界来配置一些请求的配置
- (nonnull instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)sessionConfiguration {
    if ((self = [super init])) {
        
       //给属性基本的附一些值
        _downloadQueue = [NSOperationQueue new];
        
        _downloadQueue.name = @"com.machao.MCDownloader";
        
        self.maxConcurrentDownloads = 3;
      
        _URLOperations = [NSMutableDictionary new];
        
        _barrierQueue = dispatch_queue_create("com.machao.MCDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        
        _downloadTimeout = 15.0;
        
        sessionConfiguration.timeoutIntervalForRequest = _downloadTimeout;
        // 还需要了解下是什么意思
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 10;
 
        // 给队列一个 nil 就会创建一个默认的同步的队列geidelegate
        self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                     delegate:self
                                                delegateQueue:nil];
      // 先删除对程序变化的控制
    }
    return self;
}
// 初始化完成 MCDownloader 的基本的配置就完成了






- (void)setAllStateToNone {
    [self.allDownloadReceipts enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MCDownloadReceipt class]]) {
            MCDownloadReceipt *receipt = obj;
            if (receipt.state != MCDownloadStateCompleted) {
                [receipt setState:MCDownloadStateNone];
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


- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    _downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}


// 开启了一个下载的任务

- (nullable MCDownloadReceipt *)downloadDataWithURL:(nullable NSURL *)url
                                                  progress:(nullable MCDownloaderProgressBlock)progressBlock
                                                 completed:(nullable MCDownloaderCompletedBlock)completedBlock {
    __weak MCDownloader *wself = self;
    // 拿到 MCDownloadReceipt
    MCDownloadReceipt *receipt = [self downloadReceiptForURLString:url.absoluteString];
    
    //判断是否已经完成
    // 如果已经完成就直接回调完成的block
    if (receipt.state == MCDownloadStateCompleted) {
        dispatch_main_async_safe(^{
            //MCDownloadFinishNotification 发出通知
            if (completedBlock) {
                completedBlock(receipt ,nil ,YES);
            }
            if (receipt.downloaderCompletedBlock) {
                receipt.downloaderCompletedBlock(receipt, nil, YES);
            }
            
        });
        return receipt;
    }
    // 如果没有完成就要
    return [self addProgressCallback:progressBlock completedBlock:completedBlock forURL:url createCallback:^MCDownloadOperation *{
        
        // 需要创建一个 operation对象
        
        
        __strong __typeof (wself) sself = wself;
        
        NSTimeInterval timeoutInterval = sself.downloadTimeout;
        if (timeoutInterval == 0.0) {
            timeoutInterval = 15.0;
        }
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        //开始创建请求的头
        MCDownloadReceipt *receipt = [sself downloadReceiptForURLString:url.absoluteString];
        if (receipt.totalBytesWritten > 0) {
            NSString *range = [NSString stringWithFormat:@"bytes=%zd-", receipt.totalBytesWritten];
            [request setValue:range forHTTPHeaderField:@"Range"];
        }
        // 不懂
        request.HTTPShouldUsePipelining = YES;

        if (sself.headersFilter) {
            request.allHTTPHeaderFields = sself.headersFilter(url, [sself.HTTPHeaders copy]);
        }
        else {
            request.allHTTPHeaderFields = sself.HTTPHeaders;
        }
        
       //创建一个操作并添加到下载的队列中
        MCDownloadOperation *operation = [[MCDownloadOperation alloc] initWithRequest:request inSession:sself.session];

        [sself.downloadQueue addOperation:operation];
        
        return operation;
    }];
}

#pragma mark -  通过一个url 来创建一个 MCDownloadReceipt
//  先从总的列表中找 看是否已经有了, 如果有了那就直接返回, 没有就创建一个空的对象
//已经可以保证会被添加到这个allDownloadReceipts数组中了
- (MCDownloadReceipt *)downloadReceiptForURLString:(NSString *)URLString {
    if (URLString == nil) {
        return nil;
    }
    //判断 是否在下载
    if (self.allDownloadReceipts[URLString]) {
        return self.allDownloadReceipts[URLString];
    }else {
        //没有在现在的队列中 那么就添加到 下载的数组中
        MCDownloadReceipt *receipt = [[MCDownloadReceipt alloc] initWithURLString:URLString downloadOperationCancelToken:nil downloaderProgressBlock:nil downloaderCompletedBlock:nil];
        self.allDownloadReceipts[URLString] = receipt;
        return receipt;
    }
    
    return nil;
}


// 对管理 任务数组中的下载任务

- (nullable MCDownloadReceipt *)addProgressCallback:(MCDownloaderProgressBlock)progressBlock
                                           completedBlock:(MCDownloaderCompletedBlock)completedBlock
                                                   forURL:(nullable NSURL *)url
                                           createCallback:(MCDownloadOperation *(^)())createCallback {
    // The URL will be used as the key to the callbacks dictionary so it cannot be nil. If it is nil immediately call the completed block with no image or data.
    
    //校验下url
    
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, NO);
        }
        return nil;
    }
    
    __block MCDownloadReceipt *Receipt = nil;  //
    // 再这个对列中添加一个同步的任务
    //why 是添加一个同步的任务在
    dispatch_barrier_sync(self.barrierQueue, ^{
        //先从所有的操作中找到这个操作 ,要是没有就创建
        MCDownloadOperation *operation = self.URLOperations[url];
        if (!operation) {
            //调用block来创建这个operation
            operation = createCallback();
            //添加到所有的操作中
            self.URLOperations[url] = operation;
            
            __weak MCDownloadOperation *woperation = operation;
            //监听操作完成的回掉
            operation.completionBlock = ^{
                MCDownloadOperation *soperation = woperation;
                if (!soperation) return;
                //完成的时候把这个从 操作的数组中删除
                if (self.URLOperations[url] == soperation) {
                    [self.URLOperations removeObjectForKey:url];
                };
            };
        }
        
        // 个人总结这两个block 是没有必要的 因为 receipt中已经有这个block了
         //这是放是两个回掉的 block
        id downloadOperationCancelToken = [operation addHandlersForProgress:progressBlock completed:completedBlock];
        
        // 如果这个任务没有在 下载的数组中
        
        //又是一次保证 Receipt 这个要有值 并给 downloadOperationCancelToken 付一个值
        
        
        if (!self.allDownloadReceipts[url.absoluteString]) {
            Receipt = [[MCDownloadReceipt alloc] initWithURLString:url.absoluteString
                                    downloadOperationCancelToken:downloadOperationCancelToken
                                         downloaderProgressBlock:nil
                                        downloaderCompletedBlock:nil];
            self.allDownloadReceipts[url.absoluteString] = Receipt;
        }else {
            Receipt = self.allDownloadReceipts[url.absoluteString];

        }

    });
    
    return Receipt;
}

#pragma mark - Control Methods
//取消一个任务  拿到MCDownloadOperation 调用他的方法
- (void)cancel:(nullable MCDownloadReceipt *)token completed:(nullable void (^)())completed {
    dispatch_barrier_async(self.barrierQueue, ^{
        MCDownloadOperation *operation = self.URLOperations[[NSURL URLWithString:token.url]];
        BOOL canceled = [operation cancel:nil];
        if (canceled) {
            //如果取消了会把 这个操作都删除,如果再需要下载的时候再添加进来
            [self.URLOperations removeObjectForKey:[NSURL URLWithString:token.url]];
            [token setState:MCDownloadStateNone];
            
        }
        dispatch_main_async_safe(^{
            if (completed) {
                completed();
            }
        });
    });
}
// 移除一个任务 1. 先状态改了 然后取消 然后删除这个文件
- (void)remove:(MCDownloadReceipt *)token completed:(nullable void (^)())completed{
    [token setState:MCDownloadStateNone];
    [self cancel:token completed:^{
        //
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:token.filePath error:nil];
        
        dispatch_main_async_safe(^{
            if (completed) {
                completed();
            }
        });
    }];
    
}
// 把整个下载的队列都挂起. 这个挂起 是没有执行的任务会停止, 到时执行的了就会继续执行
- (void)setSuspended:(BOOL)suspended {
    (self.downloadQueue).suspended = suspended;
}
//取消全部的下载
- (void)cancelAllDownloads {
    //1. 把队列都取消了
    [self.downloadQueue cancelAllOperations];
    // 设置全部的状态都为none
    [self setAllStateToNone];
    // 保存下载的模型
    [self saveAllDownloadReceipts];
}

- (void)removeAndClearAll {
    [self cancelAllDownloads];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:cacheFolder() error:nil];
    clearCacheFolder();
}

#pragma mark Helper methods
// 通过一个task来获取一个 操作
- (MCDownloadOperation *)operationWithTask:(NSURLSessionTask *)task {
    MCDownloadOperation *returnOperation = nil;
    for (MCDownloadOperation *operation in self.downloadQueue.operations) {
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
    NSLog(@"%@",[NSThread currentThread]);
    MCDownloadOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    // Identify the operation that runs this task and pass it the delegate method
    MCDownloadOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    // Identify the operation that runs this task and pass it the delegate method
    MCDownloadOperation *dataOperation = [self operationWithTask:dataTask];
    
    [dataOperation URLSession:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // Identify the operation that runs this task and pass it the delegate method
    MCDownloadOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task didCompleteWithError:error];
}

-(NSUInteger)currentDownloadCount{
    return  self.downloadQueue.operationCount;
}
@end
