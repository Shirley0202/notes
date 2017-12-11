//
//  SSDownloadItem.h
//  下载器集成
//
//  Created by 波 on 2017/12/6.
//  Copyright © 2017年 波波. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSDownloadItem;
/** The download state */
typedef NS_ENUM(NSUInteger, SSDownloadState) {
    SSDownloadStateNone,           /** default */
    SSDownloadStateWillResume,     /** 等待下载*/
    SSDownloadStateDownloading,    /** 下载中 */
    SSDownloadStateSuspened,       /** 暂停 */
    SSDownloadStateCompleted,      /** 完成 */
    SSDownloadStateFailed          /** 失败*/
};

// 下载进度的回掉
typedef void (^SSDownloaderProgressBlock)(SSDownloadItem *item);


typedef void (^SSDownloaderCompletedBlock)(SSDownloadItem *  item, NSError * error, BOOL finished);

@interface SSDownloadItem : NSObject

///下载的path
@property(nonatomic,copy,readonly)NSString * _Nullable path;

///<#annotation#>
@property(nonatomic,assign)SSDownloadState state;

//进度的回掉
@property (nonatomic,copy)SSDownloaderProgressBlock progressBlock;
//完成的回掉
@property (nonatomic,copy)SSDownloaderCompletedBlock completedBlock;

/// 上次回来的时间
@property(nonatomic,strong)NSDate *date;
/// 一段时间的总的大小 单次
@property(nonatomic,assign)long long sigleSize;
//速度
@property (nonatomic, copy, nullable) NSString *speed;  // KB/s

///
///<#annotation#>
@property(nonatomic,assign)long long totalSize;
///<#annotation#>
@property(nonatomic,assign)long long writeSize;

/// <#annotation#>
@property(nonatomic,strong)NSProgress *progress;

//
/// <#annotation#>
@property(nonatomic,strong)NSMutableURLRequest *request;

@property (nonatomic, copy) NSString *downLoadedFilePath;
@property (nonatomic, copy) NSString *downLoadingFilePath;



- (instancetype)initWithURL:(NSString * _Nonnull)url progress:(SSDownloaderProgressBlock) progressBlock complete:(SSDownloaderCompletedBlock)completedBlock;

@end

