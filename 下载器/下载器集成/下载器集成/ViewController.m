//
//  ViewController.m
//  下载器集成
//
//  Created by 波 on 2017/12/6.
//  Copyright © 2017年 波波. All rights reserved.
//

#import "ViewController.h"
#import "SSDownloadManager.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *pv;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SSDownloadManager *manager = [SSDownloadManager sharedManager];
    [manager downloadDataWithURL:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" progress:^(SSDownloadItem *item) {
        CGFloat progress =   item.writeSize*1.0/item.totalSize*1.0;
        NSLog(@"%f",progress);
        NSLog(@"%@",item.speed);
        
    } completed:^(SSDownloadItem * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
        self.label.text = @"完成";
    }];
   
}

- (IBAction)startAction:(id)sender {
     SSDownloadManager *manager = [SSDownloadManager sharedManager];
    NSLog(@"%d",manager.downloadQueue.operationCount);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
