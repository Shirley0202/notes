//
//  XMGFileTool.h
//  XMGDownLoad
//
//  Created by 王顺子 on 16/11/17.
//  Copyright © 2016年 王顺子. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGFileTool : NSObject

+ (BOOL)isExistsWithFile: (NSString *)filePath;

+ (long long)fileSizeWithPath: (NSString *)filePath;

+ (void)moveFile: (NSString *)fromPath toFile: (NSString *)toPath;

+ (void)removeFileAtPath: (NSString *)filePath;

@end
