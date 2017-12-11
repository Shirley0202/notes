//
//  XMGSegmentContentVC.m
//  Pods
//
//  Created by 王顺子 on 16/11/15.
//
//

#import "XMGSegmentContentVC.h"


#define kSegmentBarHeight 35

@interface XMGSegmentContentVC () <XMGSegmentBarDelegate, UIScrollViewDelegate>

/** 内容视图 */
@property (nonatomic, weak) UIScrollView *contentScrollView;

@end

@implementation XMGSegmentContentVC

- (XMGSegmentBar *)segmentBar {
    if (!_segmentBar) {
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, kSegmentBarHeight);
        XMGSegmentBar *segmentBar = [XMGSegmentBar segmentBarWithFrame:frame];
        segmentBar.backgroundColor = [UIColor whiteColor];
        segmentBar.delegate = self;
        [self.view addSubview:segmentBar];
        _segmentBar = segmentBar;
    }
    return _segmentBar;
}


- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {

        CGRect frame = CGRectMake(0, kSegmentBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kSegmentBarHeight);
        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:frame];
        contentScrollView.delegate = self;
        contentScrollView.pagingEnabled = YES;
        contentScrollView.showsHorizontalScrollIndicator = NO;

        [self.view addSubview:contentScrollView];
        _contentScrollView = contentScrollView;
    }
    return _contentScrollView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat contentH = 0;
    if (self.segmentBar.superview == self.view) {
        CGRect segBarFrame = CGRectMake(0, 0, self.view.bounds.size.width, kSegmentBarHeight);
        self.segmentBar.frame = segBarFrame;
        contentH = kSegmentBarHeight;
    }


    CGRect contentFrame = CGRectMake(0, contentH, self.view.bounds.size.width, self.view.bounds.size.height - contentH);
    self.contentScrollView.frame = contentFrame;

    // 设置所有的子控制器视图的frame
    NSInteger index = 0;
    for (UIViewController *vc in self.childViewControllers) {
        if (vc.view.superview) {
            vc.view.frame = CGRectMake(contentFrame.size.width * index, 0, contentFrame.size.width, contentFrame.size.height);
        }
        index ++;
    }
    // 设置 滚动区域
    [self showChildVC:self.segmentBar.selectIndex isAnimated:NO];

    // 设置内容视图大小
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width * self.childViewControllers.count, 0);
}


- (void)setUpWith: (NSArray <NSString *>*)items andChildVCs: (NSArray <UIViewController *>*)childVCs {

    NSAssert(items.count == childVCs.count && items.count != 0, @"应该保证, 选项个数和子控制器个数一致, 并且不为空!");



    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];

    for (UIViewController *vc in childVCs) {

        // 注意, 一定要添加成子控制器, 因为后期涉及到事件传递, 和父子控制器链条遍历
        [self addChildViewController:vc];
    }

    [self.segmentBar setUpWithDataSources:items];

    self.segmentBar.selectIndex = 0;


}


- (void)showChildVC: (NSInteger)selectIndex isAnimated: (BOOL)isAnimated {

    if (self.childViewControllers.count == 0) {
        return;
    }
    UIViewController *vc = self.childViewControllers[selectIndex];
    CGFloat x = self.contentScrollView.bounds.size.width * selectIndex;
    vc.view.frame = (CGRect){{x ,0}, self.contentScrollView.bounds.size};
    [self.contentScrollView addSubview:vc.view];

    // 滚动到相应的位置
    [self.contentScrollView setContentOffset:CGPointMake(x, 0) animated:isAnimated];


}



#pragma mark - XMGSegmentBarDelegate

-(void)segmentBar:(XMGSegmentBar *)setmentBar didSelectIndex:(NSInteger)selectIndex fromIndex:(NSInteger)fromIndex
{

    [self showChildVC:selectIndex isAnimated:ABS(selectIndex - fromIndex) == 1];

}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.segmentBar setSelectIndex:index];
}


@end
