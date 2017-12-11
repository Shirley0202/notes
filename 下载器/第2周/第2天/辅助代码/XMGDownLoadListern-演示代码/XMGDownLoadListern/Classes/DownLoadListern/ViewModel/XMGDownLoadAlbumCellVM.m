//
//  XMGDownLoadAlbumCellVM.m
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDownLoadAlbumCellVM.h"
#import "UIImageView+WebCache.h"
#import "XMGModelOperationTool.h"
#import "XMGDownLoadedVoicInAlbumTVC.h"
#import "UIView+XMGNib.h"


@implementation XMGDownLoadAlbumCellVM


- (NSURL *)imageURL {
    return [NSURL URLWithString:self.albumModel.albumCoverMiddle];
}

- (NSString *)title {
    return self.albumModel.albumTitle;
}

- (NSString *)author {
    return self.albumModel.authorName;
}

- (NSString *)voiceCount {
    return [NSString stringWithFormat:@"%zd", self.albumModel.voiceCount];
}

- (NSString *)getFormatSizeWithSize: (long long)fileSize
{
    NSArray *unit = @[@"B", @"kb", @"M", @"G"];

    int index = 0;
    while (fileSize > 1024) {
        fileSize /= 1024;
        index ++;
    }
    return [NSString stringWithFormat:@"%lld%@",fileSize, unit[index]];
}

- (NSString *)totalSize {
    return [self getFormatSizeWithSize:self.albumModel.allVoiceSize];
}

- (void)bindWithCell: (XMGDownLoadAlbumCell *)cell {

    /** 专辑图片 */
    [cell.albumImageView sd_setImageWithURL:[self imageURL]];
    /** 专辑标题 */
    cell.albumTitleLabel.text = [self title];
    /** 专辑作者 */
    cell.albumAuthorLabel.text = [self author];
    /** 专辑集数 */
    [cell.albumPartsBtn setTitle:[self voiceCount] forState:UIControlStateNormal];
    /** 专辑大小 */
    [cell.albumPartsSizeBtn setTitle:[self totalSize] forState:UIControlStateNormal];

    /** 删除按钮点击执行代码块 */
    [cell setDeleteBlock:^{
        [XMGModelOperationTool deleteModels:NSClassFromString(@"XMGDownLoadVoiceModel") whereColumnName:@"albumId" isValue:@(self.albumModel.albumId) withUserID:nil];

        // 发送通知, 刷新表格
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCache" object:nil];
    }];

    /** 选中执行代码块 */
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    [cell setSelectBlock:^{
        XMGDownLoadedVoicInAlbumTVC *vc = [XMGDownLoadedVoicInAlbumTVC new];
        vc.albumID = self.albumModel.albumId;
        vc.navigationItem.title = weakSelf.albumModel.albumTitle;
        [weakCell.currentViewController.navigationController pushViewController:vc animated:YES];
    }];

}


@end
