//
//  XMGNoDownLoadView.m
//  喜马拉雅FM
//
//  Created by 王顺子 on 16/8/20.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGNoDownLoadView.h"

@interface XMGNoDownLoadView()

@property (weak, nonatomic) IBOutlet UIImageView *noDataImageView;


@end

@implementation XMGNoDownLoadView

+ (instancetype)noDownLoadView {

    NSBundle *_currentBundle = [NSBundle mainBundle];
    XMGNoDownLoadView *noDataView = [[_currentBundle loadNibNamed:@"XMGNoDownLoadView" owner:nil options:nil] firstObject];
    return noDataView;
}

- (void)setNoDataImg:(UIImage *)noDataImg {
    _noDataImg = noDataImg;
    self.noDataImageView.image = noDataImg;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (IBAction)goView {
    if (self.clickBlock) {
        self.clickBlock();
    }
}


@end
