//
//  XMGTodayFireVoiceCellVM.m
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTodayFireVoiceCellVM.h"
#import "UIButton+WebCache.h"

#import "XMGRemoteAudioPlayer.h"
#import "XMGDownLoaderManager.h"

// 缓存
#import "XMGModelOperationTool.h"

@interface XMGTodayFireVoiceCellVM ()

@property (nonatomic, weak) XMGTodayFireVoiceCell *cell;

@end


@implementation XMGTodayFireVoiceCellVM

#pragma mark - 数据转换
- (NSURL *)playAndDownLoadURL {
    return [NSURL URLWithString:self.voiceM.playPathAacv164];
}

- (BOOL)isPlaying {

    if ([self.playAndDownLoadURL isEqual:[XMGRemoteAudioPlayer shareInstance].url] && [XMGRemoteAudioPlayer shareInstance].state == XMGRemoteAudioPlayerPlaying) {
        return YES;
    }
    return NO;

}

- (void)setIsPlaying:(BOOL)isPlaying {
    self.cell.playOrPauseBtn.selected = isPlaying;
}

- (void)setState:(XMGTodayFireVoiceCellState)state {
    self.cell.state = state;
}


- (XMGTodayFireVoiceCellState)state {

    if ([XMGDownLoader cachePathWithURL:self.playAndDownLoadURL].length > 0) {
        return  XMGTodayFireVoiceCellStateDownLoaded;
    }else {
        XMGDownLoader *downLoader = [[XMGDownLoaderManager shareInstance] getDownLoaderWithURL:self.playAndDownLoadURL];
        XMGDownLoaderState state = downLoader.state;
        if (downLoader && state == XMGDownLoaderStateDowning) {
            return XMGTodayFireVoiceCellStateDownLoading;
        }else {
            return XMGTodayFireVoiceCellStateWaitDownLoad;
        }
    }

}


/** 图标URL地址 */
- (NSURL *)imageUrl
{
    return [NSURL URLWithString:self.voiceM.coverSmall];
}
/** 标题 */
- (NSString *)title
{
    return self.voiceM.title;
}
/** 作者 */
- (NSString *)nickName
{
    return self.voiceM.nickname;
}
/** 排序号码 */



#pragma mark - 数据绑定
- (void)bindToCell:(XMGTodayFireVoiceCell *)cell {

    self.cell = cell;

    cell.voiceTitleLabel.text = self.title;
    cell.voiceAuthorLabel.text = [NSString stringWithFormat:@"by %@", self.nickName];

    [cell.playOrPauseBtn sd_setBackgroundImageWithURL:self.imageUrl  forState:UIControlStateNormal];
    cell.sortNumLabel.text = [NSString stringWithFormat:@"%zd", self.sortNum];

    // 动态计算播放状态
    cell.playOrPauseBtn.selected = self.isPlaying;


    // 动态计算下载状态
    cell.state = self.state;


    // 播放动作
    [cell setPlayBlock:^(BOOL isPlay) {
        if (isPlay) {
            [[XMGRemoteAudioPlayer shareInstance] playAudioWithURL:self.playAndDownLoadURL];
        }else {
            [[XMGRemoteAudioPlayer shareInstance] pause];
        }
    }];


    // 下载动作
    [cell setDownLoadBlock:^{
        [[XMGDownLoaderManager shareInstance] downLoadWithURL:self.playAndDownLoadURL fileInfo:^(long long totalFileSize) {
            self.voiceM.totalSize = totalFileSize;
            [XMGModelOperationTool saveModel:self.voiceM withUserID:nil];
        } success:^(NSString *cachePath, long long totalFileSize) {
            self.voiceM.isDownLoaded = YES;
            [XMGModelOperationTool saveModel:self.voiceM withUserID:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCache" object:nil];
        } fail:nil progress:nil state:nil];

        // 缓存信息
//        [XMGModelOperationTool dropTableWithModelClass:[self.voiceM class] withUserID:nil];
        [XMGModelOperationTool saveModel:self.voiceM withUserID:nil];

    }];


    // 反向监听播放状态和下载状态, 对cell状态的影响
    // 添加通知, 监听下载状态和URL
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadStateOrURLChange:) name:kDownLoadURLOrStateChangeNotification object:nil];

    // 添加通知, 监听播放状态和URL
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playStateOrURLChange:) name:kPlayerURLOrStateChangeNotification object:nil];

}


// 监听当前的下载状态
- (void)downLoadStateOrURLChange: (NSNotification *)notice {

    NSDictionary *dic = notice.userInfo;

    NSURL *url = dic[@"url"];
    if ([url isEqual:self.playAndDownLoadURL]) {

        NSInteger state = [dic[@"state"] integerValue];
        if (state == XMGDownLoaderStatePause || state == XMGDownLoaderStateFailed) {
            self.state = XMGTodayFireVoiceCellStateWaitDownLoad;
        }else if (state == XMGDownLoaderStateDowning) {
            self.state = XMGTodayFireVoiceCellStateDownLoading;
        }else if(state == XMGDownLoaderStateSuccess) {
            self.state = XMGTodayFireVoiceCellStateDownLoaded;
        }
    }

}

- (void)playStateOrURLChange: (NSNotification *)notice {

    NSDictionary *dic = notice.userInfo;

    NSLog(@"%@", dic);

    NSURL *url = dic[@"url"];
    if ([url isEqual:self.playAndDownLoadURL]) {

        NSInteger state = [dic[@"state"] integerValue];
        if (state == XMGRemoteAudioPlayerPlaying ) {
            self.isPlaying = YES;
        }else  {
            self.isPlaying = NO;
        }
    }else {
        self.isPlaying = NO;
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
