//
//  XMGDownLoadAlbumnTVC.m
//  XMGFMDownLoadListern
//
//  Created by 王顺子 on 16/11/20.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDownLoadAlbumnTVC.h"
#import "XMGDownLoadListernDataTool.h"
#import "XMGDownLoadAlbumCellVM.h"
#import "XMGDownLoadAlbumCell.h"

@interface XMGDownLoadAlbumnTVC ()

@end

@implementation XMGDownLoadAlbumnTVC


- (void)reloadCache {

    NSArray <XMGAlbumModel *>*albumMs = [XMGDownLoadListernDataTool getDownLoadedAlbums];
    NSMutableArray <XMGDownLoadAlbumCellVM *>*resultVMs = [NSMutableArray arrayWithCapacity:albumMs.count];
    for (XMGAlbumModel *albumM in albumMs) {
        XMGDownLoadAlbumCellVM *vm = [XMGDownLoadAlbumCellVM new];
        vm.albumModel = albumM;
        [resultVMs addObject:vm];
    }


    __weak typeof(self) weakSelf = self;
    [self setUpWithDataList:resultVMs getCell:^UITableViewCell *(NSIndexPath *indexPath) {
        return [XMGDownLoadAlbumCell cellWithTableView:weakSelf.tableView];
    } getCellHeight:^CGFloat(NSIndexPath *indexPath) {
        return 80;
    } andBind:^(id model, UITableViewCell *cell) {
        XMGDownLoadAlbumCellVM *vm = (XMGDownLoadAlbumCellVM *)model;
        XMGDownLoadAlbumCell *voiceCell = (XMGDownLoadAlbumCell *)cell;
        [vm bindWithCell:voiceCell];
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadCache];
}


@end
