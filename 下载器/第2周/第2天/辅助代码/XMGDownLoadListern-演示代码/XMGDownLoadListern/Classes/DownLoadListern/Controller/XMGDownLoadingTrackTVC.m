//
//  XMGDownLoadingTrackTVC.m
//  XMGFMDownLoadListern
//
//  Created by 王顺子 on 16/11/20.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDownLoadingTrackTVC.h"
#import "XMGDownLoadListernDataTool.h"
#import "XMGDownLoadVoiceCellVM.h"
#import "XMGDownLoadVoiceCell.h"

@interface XMGDownLoadingTrackTVC ()

@end

@implementation XMGDownLoadingTrackTVC

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void)reloadCache {

    NSArray <XMGDownLoadVoiceModel *>*downLoadingMs = [XMGDownLoadListernDataTool getDownLoadingVoiceMs];
    NSMutableArray <XMGDownLoadVoiceCellVM *>*downLoadingVMs = [NSMutableArray arrayWithCapacity:downLoadingMs.count];
    for (XMGDownLoadVoiceModel *downLoadingM in downLoadingMs) {
        XMGDownLoadVoiceCellVM *vm = [XMGDownLoadVoiceCellVM new];
        vm.voiceM = downLoadingM;
        [downLoadingVMs addObject:vm];
    }


    __weak typeof(self) weakSelf = self;
    [self setUpWithDataList:downLoadingVMs getCell:^UITableViewCell *(NSIndexPath *indexPath) {
        return [XMGDownLoadVoiceCell cellWithTableView:weakSelf.tableView];
    } getCellHeight:^CGFloat(NSIndexPath *indexPath) {
        return 100;
    } andBind:^(id model, UITableViewCell *cell) {
        XMGDownLoadVoiceCellVM *vm = (XMGDownLoadVoiceCellVM *)model;
        XMGDownLoadVoiceCell *voiceCell = (XMGDownLoadVoiceCell *)cell;
        [vm bindWithCell:voiceCell];

    }];


}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadCache];
}



@end
