//
//  XMGAudioDownLoader.m
//  XMGFMPlayer
//
//  Created by 王顺子 on 16/11/19.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import "XMGAudioGDownLoader.h"
#import "XMGFileManager.h"




@interface XMGAudioDownLoader () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, copy) NSString *tmpPath;
@property (nonatomic, copy) NSString *cachePath;

@end

@implementation XMGAudioDownLoader

- (NSURLSession *)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}


- (void)downLoadWithURL: (NSURL *)url offset: (long long)offset tmpPath: (NSString *)tmpPath cachePath: (NSString *)cachePath {

    // 记录数据
    _requestOffset = offset;
    _loadedLength = 0;
    _tmpPath = tmpPath;
    _cachePath = cachePath;

    // 取消之前下载
    [self.session invalidateAndCancel];
    self.session = nil;

    // 清理缓存
    [XMGFileManager removeFileAtPath:tmpPath];

    // 重新下载
    //  重新下载
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}





- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {

    // 记录下载信息
    // 内容长度
    // MIMETYPE
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields] ;
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    _totalFileSize = [length longLongValue];
    _mimeType = httpResponse.MIMEType;



    // 开始写入缓存
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.tmpPath append:YES];
    [self.outputStream open];

    completionHandler(NSURLSessionResponseAllow);
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {

    _loadedLength += data.length;
    [self.outputStream write:data.bytes maxLength:data.length];

    if ([self.delegate respondsToSelector:@selector(downLoadDidRevieveData)]) {
        [self.delegate downLoadDidRevieveData];
    }

}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    if (error == nil && _requestOffset == 0 && _loadedLength == _totalFileSize) {
        [XMGFileManager moveFile:self.tmpPath toPath:self.cachePath];
    }

    [self.outputStream close];
    self.outputStream = nil;

}

@end
