//
//  XMGReourceLoaderManager.m
//  XMGFMPlayer
//
//  Created by 王顺子 on 16/11/18.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import "XMGReourceLoaderManager.h"
#import "XMGAudioGDownLoader.h"
#import "XMGFileManager.h"
#import <MobileCoreServices/MobileCoreServices.h>


#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

#define kTmpPath NSTemporaryDirectory()

@interface XMGReourceLoaderManager () <XMGAudioDownLoaderDelegate>

@property (nonatomic, strong) XMGAudioDownLoader *downLoader;

@property (nonatomic, strong) NSMutableArray <AVAssetResourceLoadingRequest *>*loadingRequests;

@property (nonatomic, copy) NSString *cacheFilePath;
@property (nonatomic, copy) NSString *tempFilePath;

@end

@implementation XMGReourceLoaderManager

- (XMGAudioDownLoader *)downLoader {
    if (!_downLoader) {
        _downLoader = [[XMGAudioDownLoader alloc] init];
        _downLoader.delegate = self;
    }
    return _downLoader;
}

- (NSMutableArray <AVAssetResourceLoadingRequest *>*)loadingRequests {
    if (!_loadingRequests) {
        _loadingRequests = [NSMutableArray array];
    }
    return _loadingRequests;
}





// 处理所有的请求
- (void)handleAllRequest {

    NSMutableArray *completeRequest = [NSMutableArray array];

    for (AVAssetResourceLoadingRequest *loadingRequest in self.loadingRequests) {
        NSLog(@"%@", loadingRequest);

        // 1. 给每个请求, 填充头部信息
        loadingRequest.contentInformationRequest.contentType = self.downLoader.mimeType;
        loadingRequest.contentInformationRequest.contentLength = self.downLoader.totalFileSize;
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;

        // 2. 计算填充区域
        long long requestOffset = loadingRequest.dataRequest.currentOffset;
        if (requestOffset == 0) {
            requestOffset = loadingRequest.dataRequest.requestedOffset;
        }
        long long requestLength = loadingRequest.dataRequest.requestedLength;
        long long responseOffset = requestOffset - self.downLoader.requestOffset;
        long long responseLength = MIN(requestLength, self.downLoader.requestOffset + self.downLoader.loadedLength - requestOffset);

        // 3. 根据每个请求的区间, 填充数据
        NSData *data = [NSData dataWithContentsOfFile:self.tempFilePath options:NSDataReadingMappedIfSafe error:nil];
        if (data == nil) {
            data = [NSData dataWithContentsOfFile:self.cacheFilePath options:NSDataReadingMappedIfSafe error:nil];
        }

        NSData *subData = [data subdataWithRange:NSMakeRange(responseOffset, responseLength)];
        [loadingRequest.dataRequest respondWithData:subData];

        if (requestLength == responseLength) {
            [loadingRequest finishLoading];
            [completeRequest addObject:loadingRequest];
        }
    }


    [self.loadingRequests removeObjectsInArray:completeRequest];

}



// 开始播放器需要资源管理者加载的 资源请求
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {


    // 1. 检测本地缓存是否存在, 如果存在, 则直接从本地缓存返回相应额信息
    self.cacheFilePath = [kCachePath stringByAppendingPathComponent:loadingRequest.request.URL.lastPathComponent];
    self.tempFilePath = [kTmpPath stringByAppendingPathComponent:loadingRequest.request.URL.lastPathComponent];

    if ([XMGFileManager isFileExists:self.cacheFilePath]) {
        // 1. 根据文件后缀名, 获取对应的mimeType
        NSString *fileExtension = self.cacheFilePath.pathExtension;
        CFStringRef contentTypeCF = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(fileExtension), NULL);
        NSString *contentType = CFBridgingRelease(contentTypeCF);

        // 2. 获取文件的总大小
        long long contentSize = [XMGFileManager fileSizeWithPath:self.cacheFilePath];

        // 3. 获取数据
        // NSDataReadingMappedIfSafe 会进行地址映射, 不会让内存飙升
        NSData *data = [NSData dataWithContentsOfFile:self.cacheFilePath options:NSDataReadingMappedIfSafe error:nil];
        NSRange range = NSMakeRange(loadingRequest.dataRequest.requestedOffset, loadingRequest.dataRequest.requestedLength);
        NSData *subData = [data subdataWithRange:range];

        loadingRequest.contentInformationRequest.contentType = contentType;
        loadingRequest.contentInformationRequest.contentLength = contentSize;
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;

        [loadingRequest.dataRequest respondWithData:subData];

        // 4. 完成请求
        [loadingRequest finishLoading];
        return YES;
    }



    // ----------以下属于需要下载处理的情况
    [self.loadingRequests addObject:loadingRequest];

    NSURLComponents *compents = [NSURLComponents componentsWithString:loadingRequest.request.URL.absoluteString];
    [compents setScheme:@"http"];
    // 2. 如果不存在, 判断当前是否有正在下载, 没有则开始下载
    if (self.downLoader.loadedLength == 0) {
        [self.downLoader downLoadWithURL:[compents URL] offset:0 tmpPath:self.tempFilePath cachePath:self.cacheFilePath];
        return YES;
    }

    // 3. 如果已经在下载, 则判断是否需要重新下载
    long long requestOffset = loadingRequest.dataRequest.currentOffset;
    if (requestOffset == 0) {
        requestOffset = loadingRequest.dataRequest.requestedOffset;
    }

    if (requestOffset < self.downLoader.requestOffset || requestOffset > self.downLoader.requestOffset + self.downLoader.loadedLength) {
         [self.downLoader downLoadWithURL:[compents URL] offset:requestOffset tmpPath:self.tempFilePath cachePath:self.cacheFilePath];
        return YES;
    }

    // 4. 如果不需要重新下载, 保存到数组, 然后边下载, 边判断响应
    [self handleAllRequest];

    return YES;
}

// 取消某个请求
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {

    [self.loadingRequests removeObject:loadingRequest];

}


-(void)downLoadDidRevieveData {

    [self handleAllRequest];

}


@end
