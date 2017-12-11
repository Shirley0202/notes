//
//  XMGSegmentContentVC.h
//  Pods
//
//  Created by 王顺子 on 16/11/15.
//
//  负责功能: 当外界传递给你需要展示的标题数组和, 控制器数据之后, 内部负责展示,
//  然后由外界或者 控制器视图  进行添加即可展示, 至于联动处理, 则由内部实现

#import <UIKit/UIKit.h>
#import "XMGSegmentBar.h"
@interface XMGSegmentContentVC : UIViewController

/** 选项卡 */
@property (nonatomic, weak) XMGSegmentBar *segmentBar;

- (void)setUpWith: (NSArray <NSString *>*)items andChildVCs: (NSArray <UIViewController *>*)childVCs;


@end
