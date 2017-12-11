//
//  XMGDownLoaderManager.h
//  XMGDownLoad
//
//  Created by 王顺子 on 16/11/17.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMGDownLoader.h"

@interface XMGDownLoaderManager : NSObject


+ (instancetype)shareInstance;


- (XMGDownLoader *)getDownLoaderWithURL: (NSURL *)url;

- (XMGDownLoader *)downLoadWithURL: (NSURL *)url fileInfo:(DownLoadInfoType)downLoadInfoBlcok success:(SuccessBlockType)successBlock fail:(FailBlockType)failBlock progress:(ProgressType)progressBlock state:(StateChangeType)stateBlock;


- (void)pauseWithURL: (NSURL *)url;


- (void)resumeWithURL: (NSURL *)url;


- (void)cancelWithURL: (NSURL *)url;


- (void)cancelAndClearCacheWithURL: (NSURL *)url;



- (void)pauseAll;

- (void)resumeAll;





@end
