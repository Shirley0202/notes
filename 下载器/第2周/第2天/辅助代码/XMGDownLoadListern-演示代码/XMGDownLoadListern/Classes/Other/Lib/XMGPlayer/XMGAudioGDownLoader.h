//
//  XMGAudioDownLoader.h
//  XMGFMPlayer
//
//  Created by 王顺子 on 16/11/19.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol XMGAudioDownLoaderDelegate <NSObject>

- (void)downLoadDidRevieveData;

@end


@interface XMGAudioDownLoader : NSObject 

@property (nonatomic, weak) id<XMGAudioDownLoaderDelegate> delegate;

// 请求的偏移量
@property (nonatomic, assign) long long requestOffset;

// 当前已下载的长度
@property (nonatomic, assign) long long loadedLength;

// 文件的总长度
@property (nonatomic, assign) long long totalFileSize;

// 文件的mimetype
@property (nonatomic, copy) NSString *mimeType;


- (void)downLoadWithURL: (NSURL *)url offset: (long long)offset tmpPath: (NSString *)tmpPath cachePath: (NSString *)cachePath;





@end
