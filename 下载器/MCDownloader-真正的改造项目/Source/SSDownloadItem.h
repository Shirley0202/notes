//这个类只是一个记录的功能, 记录着下载item 的状态以及属性




#import <Foundation/Foundation.h>

@class SSDownloadItem;

/** The download state */
typedef NS_ENUM(NSUInteger, SSDownloadState) {
    SSDownloadStateNone,           /** default */
    SSDownloadStateWillResume,     /** 等待下载*/
    SSDownloadStateDownloading,    /** 下载中 */
    SSDownloadStateCompleted,      /** 完成 */
    SSDownloadStateFailed          /** 失败*/
};


typedef void (^SSDownloaderManagerProgressBlock)(NSInteger receivedSize, NSInteger expectedSize,  NSInteger speed, NSURL * _Nullable targetURL);
typedef void (^SSDownloaderManagerCompletedBlock)(SSDownloadItem * _Nullable receipt, NSError * _Nullable error, BOOL finished);

typedef NSString *_Nullable (^SSDownloaderManagerReceiptCustomFilePathBlock)(SSDownloadItem * _Nullable receipt);





@interface SSDownloadItem : NSObject

/**
 * Download State
 */
@property (nonatomic, assign, readonly) SSDownloadState state;

/**
 The download source url
 */
@property (nonatomic, copy, readonly, nonnull) NSString *url;

/**
 The file path, you can use it to get the downloaded data.
 */
@property (nonatomic, copy, readonly, nonnull) NSString *filePath;

/**
 The url's pathExtension through the MD5 processing.
 */
@property (nonatomic, copy, readonly, nullable) NSString *filename;

/**
 The url's pathExtension without through the MD5 processing.
 */
@property (nonatomic, copy, readonly, nullable) NSString *truename;

/**
 The url's pathExtension without through the MD5 processing.
 */
@property (nonatomic, copy, nullable) SSDownloaderManagerReceiptCustomFilePathBlock customFilePathBlock;

/**
 The current download speed,
 */
@property (nonatomic, copy, readonly, nullable) NSString *speed;  // KB/s
//总共写入多少字节
@property (assign, nonatomic, readonly) long long totalBytesWritten;
// 总字节
@property (assign, nonatomic, readonly) long long totalBytesExpectedToWrite;

/**
 The current download progress object
 */
@property (nonatomic, strong, readonly, nullable) NSProgress *progress;

@property (nonatomic, strong, readonly, nullable) NSError *error;


/**
 The call back block. When setting this block，the progress block will be called during downloading，the complete block will be called after download finished.
 */
@property (nonatomic,copy, nullable, readonly)SSDownloaderManagerProgressBlock downloaderProgressBlock;

@property (nonatomic,copy, nullable, readonly)SSDownloaderManagerCompletedBlock downloaderCompletedBlock;






#pragma mark - Private Methods
///=============================================================================
/// Method is at the bottom of the private method, do not need to use
///=============================================================================

/**
 The `SSDowmloadReceipt` method of initialization. Generally don't need to use this method.
 
 use `SSDownloadItem *receipt = [[SSDownloaderManager sharedDownloader] downloadReceiptForURLString:url];` to get the `SSDowmloadReceipt`.

 */
- (nonnull instancetype)initWithURLString:(nonnull NSString *)URLString
             downloadOperationCancelToken:(nullable id)downloadOperationCancelToken
                  downloaderProgressBlock:(nullable SSDownloaderManagerProgressBlock)downloaderProgressBlock
                 downloaderCompletedBlock:(nullable SSDownloaderManagerCompletedBlock)downloaderCompletedBlock;

- (void)setTotalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite;
- (void)setState:(SSDownloadState)state;
- (void)setDownloadOperationCancelToken:(nullable id)downloadOperationCancelToken;
- (void)setDownloaderProgressBlock:(nullable SSDownloaderManagerProgressBlock)downloaderProgressBlock;
- (void)setDownloaderCompletedBlock:(nullable SSDownloaderManagerCompletedBlock)downloaderCompletedBlock;
- (void)setSpeed:(NSString * _Nullable)speed;



/**
 Auxiliary attributes and don't need to use
 */
@property (nonatomic, assign) NSUInteger totalRead;
@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, strong, nullable) id downloadOperationCancelToken;
@end
