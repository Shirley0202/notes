
#import <Foundation/Foundation.h>
#import "MCDownloader.h"
#import "MCDownloadReceipt.h"

@interface MCDownloadOperation : NSOperation < NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

/**
 * 请求
 */
@property (strong, nonatomic, nullable) NSURLRequest *request;

/**
 * 用来下载的task 任务
 */
@property (strong, nonatomic, readonly, nullable) NSURLSessionTask *dataTask;


/**
 * 全部的大小
 */
@property (assign, nonatomic) NSInteger expectedSize;

/**
 * 连接上服务器获得的相应 里面是一个响应头信息
 */
@property (strong, nonatomic, nullable) NSURLResponse *response;


 // 初始化方法
- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request
                              inSession:(nullable NSURLSession *)session NS_DESIGNATED_INITIALIZER;

//添加进度的回掉和 完成的回掉
- (nullable id)addHandlersForProgress:(nullable MCDownloaderProgressBlock)progressBlock
                            completed:(nullable MCDownloaderCompletedBlock)completedBlock;


 //取消这个操作
- (BOOL)cancel:(nullable id)token;
@end
