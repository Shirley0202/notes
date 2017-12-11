//
//  XMGDownLoader.h
//  XMGDownLoad
//
//  Created by 王顺子 on 16/11/17.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDownLoadURLOrStateChangeNotification @"downLoadURLOrStateChangeNotification"

typedef enum : NSUInteger {
    /** 下载暂停 */
    XMGDownLoaderStatePause,
    /** 正在下载 */
    XMGDownLoaderStateDowning,
    /** 已经下载 */
    XMGDownLoaderStateSuccess,
    /** 下载失败 */
    XMGDownLoaderStateFailed
} XMGDownLoaderState;

typedef void(^DownLoadInfoType)(long long totalFileSize);
typedef void(^SuccessBlockType)(NSString *cachePath, long long totalFileSize);
typedef void(^FailBlockType)(NSString *errorMsg);
typedef void(^StateChangeType)(XMGDownLoaderState state);
typedef void(^ProgressType)(float progress);

@interface XMGDownLoader : NSObject


// 当前文件的下载状态
@property (nonatomic, assign, readonly) XMGDownLoaderState state;
// 当前文件的下载进度
@property (nonatomic, assign, readonly) float progress;

/** 文件下载信息的block */
@property (nonatomic, copy)  DownLoadInfoType downLoadInfoBlcok;
/** 状态改变的block */
@property (nonatomic, copy)  StateChangeType stateChangeBlcok;
/** 进度改变的block */
@property (nonatomic, copy)  ProgressType progressBlock;
/** 下载成功的block */
@property (nonatomic, copy) SuccessBlockType successBlock;
/** 下载失败的block */
@property (nonatomic, copy) FailBlockType failBlock;


// 根据url查找对应缓存, 如果不存在, 则返回nil
+ (NSString *)cachePathWithURL: (NSURL *)url;
+ (long long)tmpCacheSizeWithURL: (NSURL *)url;
+ (void)clearCacheWithURL: (NSURL *)url;

// 根据url地址, 进行下载
- (void)downLoadWithURL: (NSURL *)url;
- (void)downLoadWithURL: (NSURL *)url fileInfo: (DownLoadInfoType)downLoadInfoBlcok success: (SuccessBlockType)successBlock fail: (FailBlockType)failBlock progress: (ProgressType)progressBlock state: (StateChangeType)stateBlock;


// 继续
- (void)resume;

// 暂停
- (void)pause;

// 取消
- (void)cancel;

// 取消下载, 并删除缓存
- (void)cancelAndClearCache;

@end
