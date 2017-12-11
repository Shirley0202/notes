//
//  XMGFileManager.m
//  XMGFMPlayer
//
//  Created by 王顺子 on 16/11/19.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import "XMGFileManager.h"

@implementation XMGFileManager

+ (BOOL)isFileExists:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (long long)fileSizeWithPath: (NSString *)path {
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    long long fileSize = [fileInfo[NSFileSize] longLongValue];
    return fileSize;
}

+ (void)moveFile:(NSString *)sourcePath toPath: (NSString *)toPath {

    [[NSFileManager defaultManager] moveItemAtPath:sourcePath toPath:toPath error:nil];

}

+ (void)removeFileAtPath: (NSString *)filePath {

    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

}

@end
