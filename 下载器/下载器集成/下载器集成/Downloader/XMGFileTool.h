//
//  XMGFileTool.h
//  下载器
//
//  Created by seemygo on 17/3/4.
//  Copyright © 2017年 seemygo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGFileTool : NSObject

/**
 如果目录不存在, 则创建

 @param path 路径
 @return 是否创建成功
 */
+ (BOOL)createDirectoryIfNotExists:(NSString *)path;

/**
 文件是否存在

 @param path 路径
 @return 是否存在
 */
+ (BOOL)fileExistsAtPath:(NSString *)path;

/**
 文件大小

 @param path 路径
 @return 文件大小
 */
+ (long long)fileSizeAtPath:(NSString *)path;

/**
 删除文件

 @param path 删除指定文件
 */
+ (void)removeFileAtPath:(NSString *)path;

//移动文件
+ (void)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;


@end
