//这个类只是一个记录的功能, 记录着下载item 的状态以及属性




#import <Foundation/Foundation.h>

@class MCDownloadReceipt;

/** The download state */
typedef NS_ENUM(NSUInteger, MCDownloadState) {
    MCDownloadStateNone,           /** default */
    MCDownloadStateWillResume,     /** waiting */
    MCDownloadStateDownloading,    /** downloading */
    MCDownloadStateSuspened,       /** suspened */
    MCDownloadStateCompleted,      /** download completed */
    MCDownloadStateFailed          /** download failed */
};

/** The download prioritization */
typedef NS_ENUM(NSInteger, MCDownloadPrioritization) {
    MCDownloadPrioritizationFIFO,  /** first in first out */
    MCDownloadPrioritizationLIFO   /** last in first out */
};


typedef void (^MCDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize,  NSInteger speed, NSURL * _Nullable targetURL);
typedef void (^MCDownloaderCompletedBlock)(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished);

typedef NSString *_Nullable (^MCDownloaderReceiptCustomFilePathBlock)(MCDownloadReceipt * _Nullable receipt);

/**
 *  The receipt of a downloader,we can get all the informations from the receipt.
 */
@interface MCDownloadReceipt : NSObject

/**
 * Download State
 */
@property (nonatomic, assign, readonly) MCDownloadState state;

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
@property (nonatomic, copy, nullable) MCDownloaderReceiptCustomFilePathBlock customFilePathBlock;

/**
 The current download speed,
 */
@property (nonatomic, copy, readonly, nullable) NSString *speed;  // KB/s
//总字节
@property (assign, nonatomic, readonly) long long totalBytesWritten;
// 已经写入的字节
@property (assign, nonatomic, readonly) long long totalBytesExpectedToWrite;

/**
 The current download progress object
 */
@property (nonatomic, strong, readonly, nullable) NSProgress *progress;

@property (nonatomic, strong, readonly, nullable) NSError *error;


/**
 The call back block. When setting this block，the progress block will be called during downloading，the complete block will be called after download finished.
 */
@property (nonatomic,copy, nullable, readonly)MCDownloaderProgressBlock downloaderProgressBlock;

@property (nonatomic,copy, nullable, readonly)MCDownloaderCompletedBlock downloaderCompletedBlock;






#pragma mark - Private Methods
///=============================================================================
/// Method is at the bottom of the private method, do not need to use
///=============================================================================

/**
 The `MCDowmloadReceipt` method of initialization. Generally don't need to use this method.
 
 use `MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];` to get the `MCDowmloadReceipt`.

 */
- (nonnull instancetype)initWithURLString:(nonnull NSString *)URLString
             downloadOperationCancelToken:(nullable id)downloadOperationCancelToken
                  downloaderProgressBlock:(nullable MCDownloaderProgressBlock)downloaderProgressBlock
                 downloaderCompletedBlock:(nullable MCDownloaderCompletedBlock)downloaderCompletedBlock;

- (void)setTotalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite;
- (void)setState:(MCDownloadState)state;
- (void)setDownloadOperationCancelToken:(nullable id)downloadOperationCancelToken;
- (void)setDownloaderProgressBlock:(nullable MCDownloaderProgressBlock)downloaderProgressBlock;
- (void)setDownloaderCompletedBlock:(nullable MCDownloaderCompletedBlock)downloaderCompletedBlock;
- (void)setSpeed:(NSString * _Nullable)speed;



/**
 Auxiliary attributes and don't need to use
 */
@property (nonatomic, assign) NSUInteger totalRead;
@property (nonatomic, strong, nullable) NSDate *date;
@property (nonatomic, strong, nullable) id downloadOperationCancelToken;
@end
