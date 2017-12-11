
#import <Foundation/Foundation.h>
#import "MCDownloader.h"


extern NSString * _Nonnull const MCDownloadStartNotification;
extern NSString * _Nonnull const MCDownloadReceiveResponseNotification;
extern NSString * _Nonnull const MCDownloadStopNotification;
extern NSString * _Nonnull const MCDownloadFinishNotification;

/**
 Describes a downloader operation. If one wants to use a custom downloader op, it needs to inherit from `NSOperation` and conform to this protocol
 */
@protocol MCDownloaderOperationInterface<NSObject>

- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request
                              inSession:(nullable NSURLSession *)session;

- (nullable id)addHandlersForProgress:(nullable MCDownloaderProgressBlock)progressBlock
                            completed:(nullable MCDownloaderCompletedBlock)completedBlock;

@end


@interface MCDownloadOperation : NSOperation <MCDownloaderOperationInterface, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

/**
 * The request used by the operation's task.
 */
@property (strong, nonatomic, nullable) NSURLRequest *request;

/**
 * The operation's task
 */
@property (strong, nonatomic, readonly, nullable) NSURLSessionTask *dataTask;


/**
 * The expected size of data.
 */
@property (assign, nonatomic) NSInteger expectedSize;

/**
 * The response returned by the operation's connection.
 */
@property (strong, nonatomic, nullable) NSURLResponse *response;

/**
 *  Initializes a `MCDownloadOperation` object
 *
 *  @see MCDownloadOperation
 *
 *  @param request        the receipt
 *  @param session        the URL session in which this operation will run
 *
 *  @return the initialized instance
 */
- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request
                              inSession:(nullable NSURLSession *)session NS_DESIGNATED_INITIALIZER;

/**
 *  Adds handlers for progress and completion. Returns a tokent that can be passed to -cancel: to cancel this set of
 *  callbacks.
 *
 *  @param progressBlock  the block executed when a new chunk of data arrives.
 *                        @note the progress block is executed on a background queue
 *  @param completedBlock the block executed when the download is done.
 *                        @note the completed block is executed on the main queue for success. If errors are found, there is a chance the block will be executed on a background queue
 *
 *  @return the token to use to cancel this set of handlers
 */
- (nullable id)addHandlersForProgress:(nullable MCDownloaderProgressBlock)progressBlock
                            completed:(nullable MCDownloaderCompletedBlock)completedBlock;

/**
 *  Cancels a set of callbacks. Once all callbacks are canceled, the operation is cancelled.
 *
 *  @param token the token representing a set of callbacks to cancel
 *
 *  @return YES if the operation was stopped because this was the last token to be canceled. NO otherwise.
 */
- (BOOL)cancel:(nullable id)token;
@end
