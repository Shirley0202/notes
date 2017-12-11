//
//  SSDownloadOperation.h
//  下载器集成
//
//  Created by 波 on 2017/12/6.
//  Copyright © 2017年 波波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSDownloadItem.h"

@interface SSDownloadOperation : NSOperation<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (nonatomic, weak) NSURLSessionDataTask *dataTask;

//初始化方法
- (nonnull instancetype)initWithRequest:(SSDownloadItem *)item inSession:(nullable NSURLSession *)session;
@end
