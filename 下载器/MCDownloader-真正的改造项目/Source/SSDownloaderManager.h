
//这个是一个组织者
//这里维护这一个队列 




#import "SSDownloadItem.h"
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



FOUNDATION_EXPORT NSString * const SSDownloadCacheFolderName;
FOUNDATION_EXPORT NSString * cacheFolder();


extern NSString * _Nonnull const SSDownloadStartNotification;
extern NSString * _Nonnull const SSDownloadStopNotification;

typedef NSDictionary<NSString *, NSString *> SSHTTPHeadersDictionary;
typedef NSMutableDictionary<NSString *, NSString *> SSHTTPHeadersMutableDictionary;

typedef SSHTTPHeadersDictionary * _Nullable (^SSDownloaderManagerHeadersFilterBlock)(NSURL * _Nullable url, SSHTTPHeadersDictionary * _Nullable headers);


@interface SSDownloaderManager : NSObject


 //最大并发
@property (assign, nonatomic) NSInteger maxConcurrentDownloads;
 //当前的下载数量
@property (readonly, nonatomic) NSUInteger currentDownloadCount;

//超时时间
@property (assign, nonatomic) NSTimeInterval downloadTimeout;

// 单例
+ (nonnull instancetype)sharedDownloader;



 // 设置请求头的方式
@property (nonatomic, copy, nullable) SSDownloaderManagerHeadersFilterBlock headersFilter;

// 直接来配置一个 NSURLSessionConfiguration 来配置NSURLSession
- (nonnull instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)sessionConfiguration NS_DESIGNATED_INITIALIZER;

//设置head
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(nullable NSString *)field;

//获取head里面的值
- (nullable NSString *)valueForHTTPHeaderField:(nullable NSString *)field;




/**
 * Sets a subclass of `SSDownloadOperation` as the default
 * `NSOperation` to be used each time SSDownload constructs a request
 * operation to download an data.
 *
 * @param operationClass The subclass of `SSDownloadOperation` to set
 *        as default. Passing `nil` will revert to `SSDownloadOperation`.
 */
- (void)setOperationClass:(nullable Class)operationClass;

/**
 Creates an `SSDownloadItem`
 */
- (nullable SSDownloadItem *)downloadDataWithURL:(nullable NSURL *)url
                                                  progress:(nullable SSDownloaderManagerProgressBlock)progressBlock
                                                 completed:(nullable SSDownloaderManagerCompletedBlock)completedBlock;

//通过url来创建 SSDownloadItem
- (nullable SSDownloadItem *)downloadReceiptForURLString:(nullable NSString *)URLString;

- (void)cancel:(nullable SSDownloadItem *)token completed:(nullable void (^)())completed;

- (void)remove:(nullable SSDownloadItem *)token completed:(nullable void (^)())completed;
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
