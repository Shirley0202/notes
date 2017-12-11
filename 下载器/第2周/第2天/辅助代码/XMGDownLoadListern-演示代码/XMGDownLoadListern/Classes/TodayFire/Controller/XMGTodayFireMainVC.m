//
//  XMGTodayFireMainVC.m
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTodayFireMainVC.h"
#import "XMGSegmentContentVC.h"
#import "XMGTodayFireVoiceListTVC.h"

#import "XMGTodayFireDataTool.h"

@interface XMGTodayFireMainVC ()

@property (nonatomic, weak) XMGSegmentContentVC *segContentVC;

@property (nonatomic, strong) NSArray<XMGCategoryModel *> *categoryMs;

@end

@implementation XMGTodayFireMainVC

- (XMGSegmentContentVC *)segContentVC {
    if (!_segContentVC) {
        XMGSegmentContentVC *contentVC = [[XMGSegmentContentVC alloc] init];
        [self addChildViewController:contentVC];
        _segContentVC = contentVC;
    }
    return _segContentVC;
}

- (void)setCategoryMs:(NSArray<XMGCategoryModel *> *)categoryMs {
    _categoryMs = categoryMs;

    NSInteger vcCount = _categoryMs.count;
    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:vcCount];
    for (XMGCategoryModel *model in _categoryMs) {
        XMGTodayFireVoiceListTVC *vc = [[XMGTodayFireVoiceListTVC alloc] init];
        vc.loadKey = model.key;
        [vcs addObject:vc];
    }

    [self.segContentVC setUpWith:[categoryMs valueForKeyPath:@"name"] andChildVCs:vcs];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"今日最火";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.segContentVC.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    [self.view addSubview:self.segContentVC.view];


    __weak typeof(self) weakSelf = self;
    [[XMGTodayFireDataTool shareInstance] getTodayFireShareAndCategoryData:^(NSArray<XMGCategoryModel *> *categoryMs) {
        weakSelf.categoryMs = categoryMs;
    }];



}



@end
