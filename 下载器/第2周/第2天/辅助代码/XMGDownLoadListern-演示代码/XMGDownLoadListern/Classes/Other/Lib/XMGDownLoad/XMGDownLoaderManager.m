//
//  XMGDownLoaderManager.m
//  XMGDownLoad
//
//  Created by 王顺子 on 16/11/17.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import "XMGDownLoaderManager.h"
#import "NSString+XMGMD5.h"

@interface XMGDownLoaderManager()

@property (nonatomic, strong) NSMutableDictionary <NSString *, XMGDownLoader *>*downLoaderDic;

@end

@implementation XMGDownLoaderManager

static XMGDownLoaderManager *_shareInstance;

+ (instancetype)shareInstance {

    if (!_shareInstance) {
        _shareInstance = [[XMGDownLoaderManager alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [super allocWithZone:zone];
    });

    return _shareInstance;

}


- (NSMutableDictionary *)downLoaderDic {
    if (!_downLoaderDic) {
        _downLoaderDic = [NSMutableDictionary dictionary];
    }
    return _downLoaderDic;
}

- (XMGDownLoader *)getDownLoaderWithURL: (NSURL *)url {

    NSString *md5Name = [url.absoluteString MD5Str];
    XMGDownLoader *downLoader = self.downLoaderDic[md5Name];
    return downLoader;
}

- (XMGDownLoader *)downLoadWithURL: (NSURL *)url fileInfo:(DownLoadInfoType)downLoadInfoBlcok success:(SuccessBlockType)successBlock fail:(FailBlockType)failBlock progress:(ProgressType)progressBlock state:(StateChangeType)stateBlock {

    NSString *md5Name = [url.absoluteString MD5Str];
    XMGDownLoader *downLoader = self.downLoaderDic[md5Name];
    if (downLoader == nil) {
        downLoader = [[XMGDownLoader alloc] init];
        [self.downLoaderDic setValue:downLoader forKey:md5Name];
    }

    __weak typeof(self) weakSelf = self;
    [downLoader downLoadWithURL:url fileInfo:downLoadInfoBlcok success:^(NSString *cachePath, long long totalFileSize) {
        if (successBlock) {
            successBlock(cachePath, totalFileSize);
        }
        [weakSelf.downLoaderDic removeObjectForKey:md5Name];
    } fail:failBlock progress:progressBlock state:stateBlock];
   
    return downLoader;
}


- (void)pauseWithURL: (NSURL *)url {

    NSString *md5Name = [url.absoluteString MD5Str];
    XMGDownLoader *downLoader = self.downLoaderDic[md5Name];
    [downLoader pause];

}


- (void)resumeWithURL: (NSURL *)url {
    NSString *md5Name = [url.absoluteString MD5Str];
    XMGDownLoader *downLoader = self.downLoaderDic[md5Name];
    [downLoader resume];
}


- (void)cancelWithURL: (NSURL *)url {
    NSString *md5Name = [url.absoluteString MD5Str];
    XMGDownLoader *downLoader = self.downLoaderDic[md5Name];
    [downLoader cancel];
}


- (void)cancelAndClearCacheWithURL: (NSURL *)url {
    NSString *md5Name = [url.absoluteString MD5Str];
    XMGDownLoader *downLoader = self.downLoaderDic[md5Name];
    [downLoader cancelAndClearCache];

}

- (void)pauseAll {

    [[self.downLoaderDic allValues] makeObjectsPerformSelector:@selector(pause)];

}

- (void)resumeAll {

    [[self.downLoaderDic allValues] makeObjectsPerformSelector:@selector(resume)];

}



@end
