//
//  XMGSegmentBar.m
//  Pods
//
//  Created by 王顺子 on 16/11/11.
//
//

#import "XMGSegmentBar.h"

#define kMinMargin 20

@interface XMGSegmentBar ()
{
    UIButton *_lastBtn;
}
@property (nonatomic, weak) UIScrollView *contentScrollView;

@property (nonatomic, strong) NSMutableArray <UIButton *>*itemBtns;

@property (nonatomic, weak) UIView *indicatorView;

@property (nonatomic, strong) XMGSegmentConfig *defaultConfig;

@end


@implementation XMGSegmentBar
@synthesize defaultConfig = _defaultConfig;


+ (instancetype)segmentBarWithFrame: (CGRect)frame {
    XMGSegmentBar *segmentBar = [[XMGSegmentBar alloc] initWithFrame:frame];
    return segmentBar;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:contentScrollView];
        _contentScrollView = contentScrollView;
    }
    return _contentScrollView;
}

- (NSMutableArray<UIButton *> *)itemBtns
{
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        CGFloat indicatorH = self.defaultConfig.indicatorHeight;
        CGRect frame = CGRectMake(0, self.frame.size.height - indicatorH, 0, indicatorH);
        UIView *indicatorView = [[UIView alloc] initWithFrame:frame];
        indicatorView.backgroundColor = self.defaultConfig.indicatorColor;
        [self.contentScrollView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}


- (XMGSegmentConfig *)defaultConfig {
    if (!_defaultConfig) {
        _defaultConfig = [XMGSegmentConfig defaultSegmentConfig];
    }
    return _defaultConfig;
}


- (void)setUpWithDataSources:(NSArray <NSString *>*)items {

    // 添加承载视图 懒加载 scrollView
    // 0. 移除之前旧的btns
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtns = nil;
    // 设置指示器
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;

    // 1. 根据每一个item项, 添加子视图
    for (NSString *item in items) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = self.itemBtns.count;
        [btn setTitle:item forState:UIControlStateNormal];

        // 设置选中和非选中颜色
        [btn setTitleColor:self.defaultConfig.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.defaultConfig.itemSelectedColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.defaultConfig.itemFont;

        // 监听点击事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];


        [btn sizeToFit];
        [self.contentScrollView addSubview:btn];
        // 记录添加的btn
        [self.itemBtns addObject:btn];
    }

    // 2. 重新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];


}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (self.itemBtns.count == 0 || selectIndex < 0 || selectIndex > self.itemBtns.count - 1) {
        return;
    }
    _selectIndex = selectIndex;

    [self btnClick:self.itemBtns[selectIndex]];

}


- (void)updateWithSegmentConfig: (void(^)(XMGSegmentConfig *config))configBlock {

    configBlock(self.defaultConfig);

    // 根据配置, 重新修改所有显示状态
    for (UIButton *btn in self.itemBtns) {
        [btn setTitleColor:self.defaultConfig.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.defaultConfig.itemSelectedColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.defaultConfig.itemFont;
    }

    CGRect frame = self.indicatorView.frame;
    frame.origin.y = self.frame.size.height - self.defaultConfig.indicatorHeight;
    frame.size.height = self.defaultConfig.indicatorHeight;
    self.indicatorView.frame = frame;

    self.indicatorView.backgroundColor = self.defaultConfig.indicatorColor;

    [self setNeedsLayout];
    [self layoutIfNeeded];

}






- (void)btnClick: (UIButton *)btn {
    if (_lastBtn == btn) {
        return;
    }
    _selectIndex = btn.tag;

    // 0. 事件传递
    if ([self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBar:self didSelectIndex:btn.tag fromIndex:_lastBtn.tag];
    }

    // 1.设置选中颜色
    _lastBtn.selected = NO;
    btn.selected = YES;
    _lastBtn = btn;


    // 2. 设置指示器
    CGRect tempFrame = self.indicatorView.frame;
    tempFrame.size.width = btn.bounds.size.width;
    tempFrame.origin.x = btn.frame.origin.x;
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorView.frame = tempFrame;
    }];

    // 3. 设置滚动位置
    CGFloat shouldScrollX = btn.frame.origin.x + btn.frame.size.width * 0.5 - self.contentScrollView.bounds.size.width * 0.5;
    if (shouldScrollX < 0) {
        shouldScrollX = 0;
    }
    if (shouldScrollX > self.contentScrollView.contentSize.width - self.contentScrollView.bounds.size.width) {
        shouldScrollX = self.contentScrollView.contentSize.width - self.contentScrollView.bounds.size.width;
    }
    [self.contentScrollView setContentOffset:CGPointMake(shouldScrollX, 0) animated:YES];
}


- (void)layoutSubviews {
    [super layoutSubviews];

    // 0. 为了防止后期调整frame, 需要对contentScrollView进行重新布局
    self.contentScrollView.frame = self.bounds;


    // 对添加的所有选项进行布局
    // 注意: 不要直接, 遍历contentScrollView的子控件, 因为还包含了其他子控件
    // 1. 计算margin
    // 1.1 计算控件需要的所有宽度
    CGFloat itemBtnsWidth = 0;
    for (UIButton *btn in self.itemBtns) {
        [btn sizeToFit];
        itemBtnsWidth += btn.frame.size.width;
    }
    // 1.2 (自身宽度 - 所有控件宽度) / (控件个数 + 1)
    CGFloat margin = (self.bounds.size.width - itemBtnsWidth) / (self.itemBtns.count + 1);

    // 1.3 限定最小间距
    if (margin < kMinMargin) {
        margin = kMinMargin;
    }

    // 2. 布局
    CGFloat lastX = margin;
    for (UIButton *btn in self.itemBtns) {
        CGRect tempFrame = btn.frame;
        tempFrame.origin.x = lastX;
        tempFrame.origin.y = 0;
        btn.frame = tempFrame;

        lastX += (tempFrame.size.width + margin);
    }

    // 3. 调整承载视图的contentSize
    self.contentScrollView.contentSize = CGSizeMake(lastX, 0);

    // 4. 调整指示器位置
    if (self.itemBtns.count > 0) {
        CGRect tempFrame = self.indicatorView.frame;
        UIButton *selectBtn = self.itemBtns[self.selectIndex];
        tempFrame.size.width = selectBtn.bounds.size.width;
        tempFrame.origin.x = selectBtn.frame.origin.x;
        self.indicatorView.frame = tempFrame;
    }


}




@end
