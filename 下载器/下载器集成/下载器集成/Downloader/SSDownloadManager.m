//
//  SSDownloadManager.m
//  下载器集成
//
//  Created by 波 on 2017/12/6.
//  Copyright © 2017年 波波. All rights reserved.
//

#import "SSDownloadManager.h"
@interface SSDownloadManager()<NSURLSessionDelegate,NSURLSessionTaskDelegate>

///下载器
@property(nonatomic,strong)NSURLSession *urlSession;
/// 下载的item  用url做key item 为 value
@property(nonatomic,strong)NSMutableDictionary *itemDic;


@end
@implementation SSDownloadManager
static SSDownloadManager *manager = nil;
+ (instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SSDownloadManager alloc]init];
    });
    return manager;
    
}
#pragma mark - lazy

-(NSMutableDictionary *)itemDic{
    if (_itemDic == nil) {
        _itemDic = [[NSMutableDictionary alloc]init];
        
    }
    return _itemDic;
}
/// 
-(NSOperationQueue *)downloadQueue{
    if (_downloadQueue == nil) {
        _downloadQueue = [[NSOperationQueue  alloc]init];
        
    }
    return _downloadQueue;
}

/// <#annotation#>
-(NSURLSession *)urlSession{
    if (_urlSession == nil) {
#warning 需要配置这个
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        
    }
    return _urlSession;
}

#pragma mark - 对外的接口
//直接就开始一个任务
- (nullable SSDownloadItem *)downloadDataWithURL:(nullable NSString *)url progress:(nullable SSDownloaderProgressBlock)progressBlock completed:(nullable SSDownloaderCompletedBlock)completedBlock{
    
    SSDownloadItem *item = [self downloadItemForURL:url];
    item.completedBlock = completedBlock;
    item.progressBlock = progressBlock;
    //2判断state 已经完成
    if (item.state == SSDownloadStateCompleted) {
        dispatch_main_async_safe(^{
      !item.completedBlock?:item.completedBlock(item ,nil ,YES);
        });
         return item;
    }
    
    //判断这个item 是够正在下载中...
#warning 需要考虑线程的安全问题 state 的安全问题还有就是 回调的安全问题
    
    if (item.state ==SSDownloadStateDownloading||item.state == SSDownloadStateWillResume) {
        
        return item;
    }
    
    // 3没有完成的那么就要添加到当前的下载中去
    
    SSDownloadOperation *op = [self creatOperation:item];
    [self.downloadQueue addOperation:op];
    
    return item;
    
}

-(SSDownloadOperation *)creatOperation:(SSDownloadItem *)item{
    
    SSDownloadOperation *operation = [[SSDownloadOperation alloc]initWithRequest:item inSession:self.urlSession];
    return operation;
}



// 1通过url来创建 MCDownloadReceipt
- (nullable SSDownloadItem *)downloadItemForURL:(nullable NSString *)url{
    
    // 看本地是否已经有了
    SSDownloadItem *item = self.itemDic[url];
    if (item == nil) {
        item = [[SSDownloadItem alloc]initWithURL:url progress:nil complete:nil];
        [self.itemDic setObject:item forKey:url];
    }
    
    return item;
    
}


#pragma mark - 私有的方法
//5

- (SSDownloadOperation *)operationWithTask:(NSURLSessionDataTask *)task{
    SSDownloadOperation *returnOperation = nil;
    for (SSDownloadOperation *operation in self.downloadQueue.operations) {
        if (operation.dataTask.taskIdentifier == task.taskIdentifier) {
            returnOperation = operation;
            break;
        }
    }
    return returnOperation;
}


//4
#pragma mark - NSURLSessionDataDelegate


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


#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // Identify the operation that runs this task and pass it the delegate method
    SSDownloadOperation *dataOperation = [self operationWithTask:task];
    
    [dataOperation URLSession:session task:task didCompleteWithError:error];
}




@end
