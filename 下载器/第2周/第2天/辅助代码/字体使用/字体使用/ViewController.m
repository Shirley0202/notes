//
//  ViewController.m
//  字体使用
//
//  Created by 王顺子 on 16/11/16.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 使用系统已经存在的字体
    NSMutableArray *fontNames = [NSMutableArray array];

    NSArray *fontFamilys = [UIFont familyNames];
    for (NSString *fontF in fontFamilys) {
        NSArray *fonts = [UIFont fontNamesForFamilyName:fontF];
        [fontNames addObjectsFromArray:fonts];
    }

    CGFloat lastY = 20;
    NSInteger index = 0;
    for (NSString *fontName in fontNames) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, lastY, 500, 30)];
        lastY += 50;
        label.font = [UIFont fontWithName:fontName size:25];
        label.text = [NSString stringWithFormat:@"%zd: 实验, test, wangshunzi", index];
        NSLog(@"%zd--%@", index,fontName);
        [self.contentScrollView addSubview:label];
        index ++;
    }

    self.contentScrollView.contentSize = CGSizeMake(0, lastY);



    



}


@end
