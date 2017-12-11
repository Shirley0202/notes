//
//  XMGDownLoadMainVC.m
//  XMGFMDownLoadListern
//
//  Created by 王顺子 on 16/11/20.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDownLoadMainVC.h"
#import "XMGSegmentContentVC.h"

#import "XMGDownLoadAlbumnTVC.h"
#import "XMGDownLoadTrackTVC.h"
#import "XMGDownLoadingTrackTVC.h"

@interface XMGDownLoadMainVC ()

@property (nonatomic, weak) XMGSegmentContentVC *segContentVC;

@end

@implementation XMGDownLoadMainVC

- (XMGSegmentContentVC *)segContentVC {
    if (!_segContentVC) {
        XMGSegmentContentVC *contentVC = [[XMGSegmentContentVC alloc] init];
        [self addChildViewController:contentVC];
        _segContentVC = contentVC;
    }
    return _segContentVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    XMGDownLoadAlbumnTVC *albumTVC = [[XMGDownLoadAlbumnTVC alloc] init];

    XMGDownLoadTrackTVC *trackTVC = [[XMGDownLoadTrackTVC alloc] init];

    XMGDownLoadingTrackTVC *loadingTrackTVC = [[XMGDownLoadingTrackTVC alloc] init];

    [self.segContentVC setUpWith:@[@"专辑", @"声音", @"下载中"] andChildVCs:@[albumTVC, trackTVC, loadingTrackTVC]];


    XMGSegmentBar *segBar = self.segContentVC.segmentBar;
    segBar.frame = CGRectMake(0, 0, 300, 40);
    self.navigationItem.titleView = segBar;

    self.segContentVC.view.frame = self.view.bounds;
    [self.view addSubview:self.segContentVC.view];


    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg_64"] forBarMetrics:UIBarMetricsDefault];

}



@end
