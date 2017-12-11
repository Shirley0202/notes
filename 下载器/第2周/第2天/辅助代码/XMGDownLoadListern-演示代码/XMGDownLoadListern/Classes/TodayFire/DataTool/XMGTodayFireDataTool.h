//
//  XMGTodayFireDataTool.h
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMGCategoryModel.h"
#import "XMGDownLoadVoiceModel.h"

@interface XMGTodayFireDataTool : NSObject

+ (instancetype)shareInstance;

/**
 *  获取今日最火, 分享内容, 和分类列表
 *
 *  @param result 分享内容, 分类列表
 */
- (void)getTodayFireShareAndCategoryData:(void(^)(NSArray <XMGCategoryModel *>*categoryMs))result;

/**
 *  获取下载声音列表
 *
 *  @param key    类别key
 *  @param page   页数
 *  @param result 下载的声音模型数组
 */
- (void)getVoiceMsWithKey:(NSString *)key pageNum:(NSInteger)page result:(void(^)(NSArray <XMGDownLoadVoiceModel *>*voiceMs))result;
@end
