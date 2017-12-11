//
//  SSDownloadManager.h
//  下载器集成
//
//  Created by 波 on 2017/12/6.
//  Copyright © 2017年 波波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSDownloadItem.h"
#import "SSDownloadOperation.h"
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

@interface SSDownloadManager : NSObject
+ (instancetype)sharedManager;
///
@property(nonatomic,strong)NSOperationQueue *downloadQueue;
- (void)setOperationClass:(nullable Class)operationClass;

/**
 Creates an `SSDownloadItem`
 */
- (nullable SSDownloadItem *)downloadDataWithURL:(nullable NSString *)url progress:(nullable SSDownloaderProgressBlock)progressBlock completed:(nullable SSDownloaderCompletedBlock)completedBlock;

//通过url来创建 SSDownloadItem
- (nullable SSDownloadItem *)downloadItemForURL:(nullable NSString *)url;




- (void)cancel:(nullable SSDownloadItem *)token completed:(nullable void (^)(void))completed;

- (void)remove:(nullable SSDownloadItem *)token completed:(nullable void (^)(void))completed;

- (void)setSuspended:(BOOL)suspended;

// 取消全部的下载
- (void)cancelAllDownloads;

/**
  * 清除全部
 @Waring:
 This method is synchronized methods, you should be careful when using, will delete all the data in the cache folder
 */
- (void)removeAndClearAll;

@end
