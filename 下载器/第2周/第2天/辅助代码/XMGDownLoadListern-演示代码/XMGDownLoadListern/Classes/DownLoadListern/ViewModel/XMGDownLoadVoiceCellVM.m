//
//  XMGDownLoadVoiceCellVM.m
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDownLoadVoiceCellVM.h"
#import "XMGRemoteAudioPlayer.h"
#import "XMGDownLoaderManager.h"
#import "UIButton+WebCache.h"
#import "XMGModelOperationTool.h"

@interface XMGDownLoadVoiceCellVM ()

@property (nonatomic, weak) NSTimer *updateTimer;

@property (nonatomic, weak) XMGDownLoadVoiceCell *cell;

@end


@implementation XMGDownLoadVoiceCellVM

- (NSTimer *)updateTimer {
    if (!_updateTimer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _updateTimer = timer;
    }
    return _updateTimer;
}

- (instancetype)init {
    if (self = [super init]) {
        [self updateTimer];
    }
    return self;
}


- (NSString *)title {
    return self.voiceM.title;
}

- (NSString *)author {
    return self.voiceM.nickname;
}

- (NSString *)playCount {
    return [NSString stringWithFormat:@"%zd", self.voiceM.playtimes];
}

- (NSString *)commentCount {
    return [NSString stringWithFormat:@"%zd", self.voiceM.commentsCounts];
}

- (NSString *)duration {
    return [NSString stringWithFormat:@"%02zd:%02zd", self.voiceM.duration / 60, self.voiceM.duration % 60];
}

- (BOOL)isDownLoaded {
    return self.voiceM.isDownLoaded;
}

- (BOOL)isDownLoading {
    XMGDownLoader *downLoader = [[XMGDownLoaderManager shareInstance] getDownLoaderWithURL:self.playAndDownLoadURL];
    if (downLoader) {

        XMGDownLoaderState state = downLoader.state;
        return state == XMGDownLoaderStateDowning;
    }
    return NO;
}

- (BOOL)isPlaying {
    if ([self.playAndDownLoadURL isEqual:[XMGRemoteAudioPlayer shareInstance].url]) {
        XMGRemoteAudioPlayerState state = [XMGRemoteAudioPlayer shareInstance].state;
        return state == XMGRemoteAudioPlayerPlaying;
    }
    return NO;
}

- (NSString *)playProgress {
    return @"66%";
}

- (NSURL *)playAndDownLoadURL {
    return [NSURL URLWithString:self.voiceM.playPathAacv164];
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

- (NSString *)progressStr {
    NSString *totalSize = [self getFormatSizeWithSize:self.voiceM.totalSize];
    NSString *currentSize = [self getFormatSizeWithSize:self.voiceM.totalSize * self.downLoadProgress];

    return  [NSString stringWithFormat:@"%@/%@", currentSize, totalSize];
//    return @"xx";

}

- (float)downLoadProgress {

    // 如果当前有下载器在下载, 则直接获取
    // 如果没有, 则需要获取文件总大小, 以及本地的当前缓存大小
        return 1.0 * [XMGDownLoader tmpCacheSizeWithURL:self.playAndDownLoadURL] / self.voiceM.totalSize;

}

- (NSURL *)imageURL {
    return [NSURL URLWithString:self.voiceM.coverSmall];
}


- (void)bindWithCell: (XMGDownLoadVoiceCell *)cell {

    self.cell = cell;

    /** 声音标题 */
    cell.voiceTitleLabel.text = self.title;
    /** 声音作者 */
    cell.voiceAuthorLabel.text = self.author;
    /** 声音播放次数 */
    [cell.voicePlayCountBtn setTitle:self.playCount forState:UIControlStateNormal];
    /** 声音评论次数 */
    [cell.voiceCommentBtn setTitle:self.commentCount forState:UIControlStateNormal];
    /** 声音时长 */
    [cell.voiceDurationBtn setTitle:self.duration forState:UIControlStateNormal];
     [self.cell.playOrPauseBtn sd_setBackgroundImageWithURL:self.imageURL forState:UIControlStateNormal];

    /** 声音下载进度背景(需要控制隐藏显示) */
    cell.progressBackView.hidden = self.isDownLoaded;

    [self update];

//    if (self.isDownLoaded) {
//        [self.updateTimer invalidate];
//        self.updateTimer = nil;
//    }

    /** 选中执行代码块 */
    [cell setSelectBlock:^{
        NSLog(@"选中了这个cell");
    }];

    /** 播放执行代码块 */
    [cell setPlayBlock:^(BOOL isPlaying) {
        if (isPlaying) {
            [[XMGRemoteAudioPlayer shareInstance] playAudioWithURL:[self playAndDownLoadURL]];
        }else {
             [[XMGRemoteAudioPlayer shareInstance] pause];
        }
    }];

    /** 删除执行代码块 */
    [cell setDeleteBlock:^{
        // 清理记录
        [XMGModelOperationTool deleteModel:self.voiceM withUserID:nil];

        // 取消下载
        [[XMGDownLoaderManager shareInstance] cancelAndClearCacheWithURL:[self playAndDownLoadURL]];

        // 清理下载文件
        [XMGDownLoader clearCacheWithURL:[self playAndDownLoadURL]];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCache" object:nil];
    }];

    /** 下载代码块 */
    [cell setDownLoadBlock:^(BOOL isDownLoad) {
        if (isDownLoad) {
            [[XMGDownLoaderManager shareInstance] downLoadWithURL:self.playAndDownLoadURL fileInfo:nil success:^(NSString *cachePath, long long totalFileSize) {
                self.voiceM.isDownLoaded = YES;
                [XMGModelOperationTool saveModel:self.voiceM withUserID:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCache" object:nil];
            } fail:nil progress:nil state:nil];
        }else {
            [[XMGDownLoaderManager shareInstance] pauseWithURL:self.playAndDownLoadURL];
        }
    }];

}




- (void)update {
    /** 声音播放进度 */
    self.cell.voicePlayProgressLabel.text = self.playProgress;

    /** 声音播放暂停按钮 */
    self.cell.playOrPauseBtn.selected = self.isPlaying;

    /** 声音下载或者暂停按钮 */
    self.cell.downLoadOrPauseBtn.selected = self.isDownLoading;

    /** 声音下载进度条 */
    self.cell.downLoadProgressV.progress = self.downLoadProgress;

    /** 声音下载进度label */
    self.cell.progressLabel.text = self.progressStr;
}

- (void)dealloc {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}
@end
