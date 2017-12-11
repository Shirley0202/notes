//
//  XMGSegmentConfig.h
//  Pods
//
//  Created by 王顺子 on 16/11/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XMGSegmentConfig : NSObject

+ (instancetype)defaultSegmentConfig;

// 选项卡选中颜色
@property (nonatomic, strong) UIColor *itemSelectedColor;

// 选项卡一般颜色
@property (nonatomic, strong) UIColor *itemNormalColor;

// 选项卡字体
@property (nonatomic, strong) UIFont *itemFont;

// 指示器颜色
@property (nonatomic, strong) UIColor *indicatorColor;

// 指示器高度
@property (nonatomic, assign) CGFloat indicatorHeight;


@end
