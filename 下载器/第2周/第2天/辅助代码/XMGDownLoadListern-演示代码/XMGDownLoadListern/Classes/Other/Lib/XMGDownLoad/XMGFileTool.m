//
//  XMGFileTool.m
//  XMGDownLoad
//
//  Created by 王顺子 on 16/11/17.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import "XMGFileTool.h"

@implementation XMGFileTool

+ (BOOL)isExistsWithFile: (NSString *)filePath {

    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return result;
}

+ (long long)fileSizeWithPath: (NSString *)filePath {

    // 如果路径不存在, 返回0
    if (![self isExistsWithFile:filePath]) {
        return 0;
    }

    NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    long long fileSize = [fileInfoDic[NSFileSize] longLongValue];
    return fileSize;
}


+ (void)moveFile: (NSString *)fromPath toFile: (NSString *)toPath {
    // 如果路径不存在, 返回0
    if (![self isExistsWithFile:fromPath]) {
        return;
    }
    [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];

}

+ (void)removeFileAtPath: (NSString *)filePath {
    // 如果路径不存在, 返回0
    if (![self isExistsWithFile:filePath]) {
        return;
    }
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

}

@end
