//
//  XMGTodayFireVoiceCellVM.h
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMGDownLoadVoiceModel.h"
#import "XMGTodayFireVoiceCell.h"

@interface XMGTodayFireVoiceCellVM : NSObject

// 原始数据
@property (nonatomic, strong) XMGDownLoadVoiceModel *voiceM;


// cell 需要的数据

/** 图标URL地址 */
@property (nonatomic, strong) NSURL *imageUrl;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 作者 */
@property (nonatomic, copy) NSString *nickName;
/** 排序号码 */
@property (nonatomic, assign) NSInteger sortNum;

/** 状态 */
@property (nonatomic, assign) XMGTodayFireVoiceCellState state;
/** 是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
/** 播放和下载的URL */
@property (nonatomic, strong) NSURL *playAndDownLoadURL;




- (void)bindToCell: (XMGTodayFireVoiceCell *)cell;

@end
