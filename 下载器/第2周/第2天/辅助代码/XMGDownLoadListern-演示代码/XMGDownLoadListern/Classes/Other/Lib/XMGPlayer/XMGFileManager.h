//
//  XMGFileManager.h
//  XMGFMPlayer
//
//  Created by 王顺子 on 16/11/19.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGFileManager : NSObject

+ (BOOL)isFileExists:(NSString *)path;

+ (long long)fileSizeWithPath: (NSString *)path;

+ (void)moveFile:(NSString *)sourcePath toPath: (NSString *)toPath;

+ (void)removeFileAtPath: (NSString *)filePath;

@end
