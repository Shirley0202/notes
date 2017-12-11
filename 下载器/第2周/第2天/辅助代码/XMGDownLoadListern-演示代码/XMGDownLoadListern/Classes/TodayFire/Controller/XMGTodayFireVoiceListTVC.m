//
//  XMGTodayFireVoiceListTVC.m
//  喜马拉雅FM
//
//  Created by 王顺子 on 16/8/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTodayFireVoiceListTVC.h"
#import "XMGTodayFireDataTool.h"
#import "XMGTodayFireVoiceCell.h"
#import "XMGTodayFireVoiceCellVM.h"


@interface XMGTodayFireVoiceListTVC ()

@property (nonatomic, strong) NSArray<XMGTodayFireVoiceCellVM *> *voiceVMs;

@end

@implementation XMGTodayFireVoiceListTVC


- (void)setVoiceVMs:(NSArray<XMGTodayFireVoiceCellVM *> *)voiceVMs {
    _voiceVMs = voiceVMs;
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    self.tableView.rowHeight = 80;
    __weak typeof(self) weakSelf = self;
    [[XMGTodayFireDataTool shareInstance] getVoiceMsWithKey:self.loadKey pageNum:1 result:^(NSArray<XMGDownLoadVoiceModel *> *voiceMs) {

        // 转换数据模型为viewModel
        NSMutableArray *voiceVMs = [NSMutableArray arrayWithCapacity:voiceMs.count];
        NSInteger index = 1;
        for (XMGDownLoadVoiceModel *voiceM in voiceMs) {
            XMGTodayFireVoiceCellVM *voiceCellVM = [XMGTodayFireVoiceCellVM new];
            voiceCellVM.voiceM = voiceM;
            voiceCellVM.sortNum = index;
            [voiceVMs addObject:voiceCellVM];

            index ++;
        }

        weakSelf.voiceVMs = voiceVMs;
    }];

}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.voiceVMs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XMGTodayFireVoiceCell *cell = [XMGTodayFireVoiceCell cellWithTableView:tableView];
    XMGTodayFireVoiceCellVM *voiceCellVM = self.voiceVMs[indexPath.row];

    [voiceCellVM bindToCell:cell];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    XMGTodayFireVoiceCellVM *model = self.voiceVMs[indexPath.row];

    NSLog(@"跳转到播放器界面进行播放--%@--", model.title);

}



@end
