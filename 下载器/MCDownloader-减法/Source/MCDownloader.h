
//这个是一个组织者
//这里维护这一个队列 



#import <Foundation/Foundation.h>
#import "MCDownloadReceipt.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Use dispatch_main_async_safe instead of dispatch_async(dispatch_get_main_queue(), block)
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif






// 定义常量的
FOUNDATION_EXPORT NSString * const MCDownloadCacheFolderName;
FOUNDATION_EXPORT NSString * cacheFolder();

//typedef 重命名
typedef NSDictionary<NSString *, NSString *> MCHTTPHeadersDictionary;
typedef NSMutableDictionary<NSString *, NSString *> MCHTTPHeadersMutableDictionary;

typedef MCHTTPHeadersDictionary * _Nullable (^MCDownloaderHeadersFilterBlock)(NSURL * _Nullable url, MCHTTPHeadersDictionary * _Nullable headers);






@interface MCDownloader : NSObject


 //最大并发 // 应该写一个默认值 3
@property (assign, nonatomic) NSInteger maxConcurrentDownloads;
 //当前的下载数量
@property (readonly, nonatomic) NSUInteger currentDownloadCount;
//超时时间
@property (assign, nonatomic) NSTimeInterval downloadTimeout;



// 单例
+ (nonnull instancetype)sharedDownloader;



 // 设置请求头的方式
@property (nonatomic, copy, nullable) MCDownloaderHeadersFilterBlock headersFilter;

/**
 * Sets a subclass of `MCDownloadOperation` as the default
 * `NSOperation` to be used each time MCDownload constructs a request
 * operation to download an data.
 *
 * @param operationClass The subclass of `MCDownloadOperation` to set
 *        as default. Passing `nil` will revert to `MCDownloadOperation`.
 */
- (void)setOperationClass:(nullable Class)operationClass;

/**
 Creates an `MCDownloadReceipt`
 */
- (nullable MCDownloadReceipt *)downloadDataWithURL:(nullable NSURL *)url
                                                  progress:(nullable MCDownloaderProgressBlock)progressBlock
                                                 completed:(nullable MCDownloaderCompletedBlock)completedBlock;



//通过url来创建 MCDownloadReceipt
- (nullable MCDownloadReceipt *)downloadReceiptForURLString:(nullable NSString *)URLString;

- (void)cancel:(nullable MCDownloadReceipt *)token completed:(nullable void (^)())completed;

- (void)remove:(nullable MCDownloadReceipt *)token completed:(nullable void (^)())completed;
/**
 * Sets the download queue suspension state
 */
- (void)setSuspended:(BOOL)suspended;

/**
 * Cancels all download operations in the queue
 */
- (void)cancelAllDownloads;

/**
 Romove All files in the cache folder.
 @Waring:
 This method is synchronized methods, you should be careful when using, will delete all the data in the cache folder
 */
- (void)removeAndClearAll;
@end

NS_ASSUME_NONNULL_END
