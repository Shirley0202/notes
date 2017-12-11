//
//  XMGSegmentConfig.m
//  Pods
//
//  Created by 王顺子 on 16/11/16.
//
//

#import "XMGSegmentConfig.h"

@implementation XMGSegmentConfig

+ (instancetype)defaultSegmentConfig {

    XMGSegmentConfig *_defaultConfig = [[XMGSegmentConfig alloc] init];
    _defaultConfig.itemNormalColor = [UIColor grayColor];
    _defaultConfig.itemSelectedColor = [UIColor redColor];
    _defaultConfig.itemFont = [UIFont systemFontOfSize:12];
    _defaultConfig.indicatorColor = [UIColor redColor];
    _defaultConfig.indicatorHeight = 2;

    return _defaultConfig;
}


@end
