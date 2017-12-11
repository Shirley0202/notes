//
//  SSDownloadOperation.m
//  下载器集成
//
//  Created by 波 on 2017/12/6.
//  Copyright © 2017年 波波. All rights reserved.
//

#import "SSDownloadOperation.h"
#import "SSDownloadManager.h"
#import "XMGFileTool.h"
@interface SSDownloadOperation ()
/// 保存的item
@property(nonatomic,strong)SSDownloadItem *item;
/// 响应的信息
@property(nonatomic,strong)NSURLResponse *response;




@property (nonatomic, strong) NSOutputStream *outputStream;


///
@property(nonatomic,weak)NSURLSession *session;
@property (assign, nonatomic) BOOL sexecuting;
@property (assign, nonatomic) BOOL sfinished;
// 回掉的队列
@property (strong, nonatomic, nullable) dispatch_queue_t barrierQueue;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;
@end
@implementation SSDownloadOperation

- (nonnull instancetype)initWithRequest:(SSDownloadItem *)item inSession:(nullable NSURLSession *)session{
    self = [super init];
    if (self) {
        _sexecuting = NO;
        _sfinished = NO;
        self.item = item;
        self.session = session;
        [self.item setState:SSDownloadStateWillResume];
         _barrierQueue = dispatch_queue_create("com.machao.MCDownloaderOperationBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
   
    }
    return self;
}


- (void)dealloc {
    NSLog(@"dealloc");
}


- (BOOL)cancel:(nullable id)token {
    [self cancel];
    return YES;
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
        NSURLSession *session = self.session;
      
        self.dataTask = [session dataTaskWithRequest:self.item.request];
        self.executing = YES;
        
    }
    //直接开始下载任务了
    [self.dataTask resume];
    
#warning 需要判断这个任务是否有值
    
    
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
        [self.item setState:SSDownloadStateNone];
     
        
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
    self.dataTask = nil;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _sfinished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _sexecuting = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}






#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    //'304 Not Modified' is an exceptional one
    if (![response respondsToSelector:@selector(statusCode)] || (((NSHTTPURLResponse *)response).statusCode < 400 && ((NSHTTPURLResponse *)response).statusCode != 304)) {
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        
        SSDownloadItem *receipt = self.item;
        receipt.totalSize = receipt.writeSize + expected;
        receipt.date = [NSDate date];
        //回掉一个block
        !self.item.progressBlock?:self.item.progressBlock(self.item);
        self.item.state = SSDownloadStateDownloading;
        // 创建文件输出流
        self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.item.downLoadingFilePath append:YES];
        [self.outputStream open];
        
        self.response = response;
   
    }else {
        NSUInteger code = ((NSHTTPURLResponse *)response).statusCode;
        NSError *error = [NSError errorWithDomain:@"下载失败" code:code userInfo:nil];
         self.item.state = SSDownloadStateFailed;
        !self.item.completedBlock?:self.item.completedBlock(self.item, error, YES);
#warning 需要释放掉这个对象
        return;
    }
    
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    __block NSError *error = nil;
    
    // Speed
    self.item.sigleSize += data.length;
    NSDate *currentDate = [NSDate date];
    if ([currentDate timeIntervalSinceDate:self.item.date] >= 1) {
        double time = [currentDate timeIntervalSinceDate:self.item.date];
        long long speed = data.length/time;
        self.item.speed = [self formatByteCount:speed];
        self.item.sigleSize = 0.0;
        self.item.date = currentDate;
    }
    
    // Write Data
    
    [self.outputStream write:data.bytes maxLength:data.length];
    //更新属性
    self.item.writeSize += data.length;
    self.item.progress.totalUnitCount = self.item.totalSize;
    self.item.progress.completedUnitCount = self.item.writeSize;
    // 回调进度的block
    dispatch_main_async_safe(^{
         !self.item.progressBlock?:self.item.progressBlock(self.item);
        
    });
}



#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {

    if (!error) {
        // 开始字节 - 最后
        
        // w为了严谨, 再次验证
        // 文件完整性验证
        
        if (self.item.totalSize == self.item.writeSize) {
            //移动item
            [XMGFileTool moveFileFromPath:self.item.downLoadingFilePath toPath:self.item.downLoadedFilePath];
            self.item.state = SSDownloadStateCompleted;
            dispatch_main_async_safe(^{
                !self.item.completedBlock?:self.item.completedBlock(self.item, nil, YES);
                self.finished = YES;
                self.executing = NO;
                
            });
          
            
        }else{
      #warning 需要删除下载的那些文件
            //并需要结束这个操作
             [self callCompletionBlocksWithError:error];
        }
        
        
    }else {
        self.item.state = SSDownloadStateFailed;
#warning 需要删除下载的那些文件
         [self callCompletionBlocksWithError:error];
        
    }
    
    if (error) {
        
       
    } else {
      
    }
//    [self done];
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
    
#warning 需要从写
}

- (NSString*)formatByteCount:(long long)size
{
#warning 需要了解下是什么
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}



@end
