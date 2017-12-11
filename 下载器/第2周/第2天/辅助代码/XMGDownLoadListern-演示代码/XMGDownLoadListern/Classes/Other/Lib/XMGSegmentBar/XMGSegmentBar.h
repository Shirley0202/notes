//
//  XMGSegmentBar.h
//  Pods
//
//  Created by 王顺子 on 16/11/11.
//
//

#import <UIKit/UIKit.h>
#import "XMGSegmentConfig.h"

@class XMGSegmentBar;
@protocol XMGSegmentBarDelegate <NSObject>
@optional

- (void)segmentBar:(XMGSegmentBar *)setmentBar didSelectIndex:(NSInteger)selectIndex fromIndex: (NSInteger)fromIndex;

@end


@interface XMGSegmentBar : UIView


/**
 快速创建segmentBar

 @return segmentBar
 */
+ (instancetype)segmentBarWithFrame: (CGRect)frame;


/**
 根据数据源进行初始化

 @param items 数据源内容
 */
- (void)setUpWithDataSources:(NSArray <NSString *>*)items;


/**
 设置代理, 用于内部的点击事件外传
 */
@property (nonatomic, weak) id<XMGSegmentBarDelegate> delegate;


/**
 用于外界设置选中索引, 内部需要展示响应动效
 */
@property (nonatomic, assign) NSInteger selectIndex;


- (void)updateWithSegmentConfig: (void(^)(XMGSegmentConfig *config))configBlock;


@end
