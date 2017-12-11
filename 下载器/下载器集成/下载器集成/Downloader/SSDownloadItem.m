//
//  SSDownloadItem.m
//  下载器集成
//
//  Created by 波 on 2017/12/6.
//  Copyright © 2017年 波波. All rights reserved.
//

#import "SSDownloadItem.h"
#import "XMGFileTool.h"
#define kCache  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject


@interface SSDownloadItem()
///下载的路径
@property(nonatomic,strong)NSURL *  url;

@end
@implementation SSDownloadItem
-(NSString *)path{
    return self.url.absoluteString;
    
}

- (instancetype)initWithURL:(NSString *)url progress:(SSDownloaderProgressBlock) progressBlock complete:(SSDownloaderCompletedBlock)completedBlock{
    
    self = [super init];
    if (self) {
        self.progress = [[NSProgress alloc]init];
        self.url =[NSURL URLWithString:url];
        self.completedBlock = completedBlock;
        self.progressBlock = progressBlock;
    }
    return self;
    
}

-(NSMutableURLRequest *)request{
#warning 需要处理 需要从manager中拿到一些东西来设置 请求头的配置
    NSTimeInterval timeoutInterval = 15;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.url];
    if (self.writeSize > 0) {
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.writeSize];
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
    
    request.HTTPShouldUsePipelining = YES;
    
    return request;
    
}
-(NSString *)downLoadedFilePath{
    return  [self.downLoadedPath stringByAppendingPathComponent:self.path.lastPathComponent];
}
-(NSString *)downLoadingFilePath{
    
    
   return  [self.downLoadingPath stringByAppendingPathComponent:self.path.lastPathComponent];
}

- (NSString *)downLoadedPath {
    NSString *path = [kCache stringByAppendingPathComponent:@"downLoader/downloaded"];
    
    BOOL result = [XMGFileTool createDirectoryIfNotExists:path];
    if (result) {
        return path;
    }
    return @"";
}
- (NSString *)downLoadingPath {
    
    NSString *path = [kCache stringByAppendingPathComponent:@"downLoader/downloading"];
    
    BOOL result = [XMGFileTool createDirectoryIfNotExists:path];
    if (result) {
        return path;
    }
    return @"";
    
}



@end
