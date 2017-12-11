//
//  XMGTodayFireVoiceCell.m
//  喜马拉雅FM
//
//  Created by 王顺子 on 16/8/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTodayFireVoiceCell.h"



@implementation XMGTodayFireVoiceCell


static NSString *const cellID = @"todayFireVoice";

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    XMGTodayFireVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XMGTodayFireVoiceCell" owner:nil options:nil] firstObject];
        [cell addObserver:cell forKeyPath:@"sortNumLabel.text" options:NSKeyValueObservingOptionNew context:nil];
    }

    return cell;
}



- (void)addRotationAnimation {
    [self removeRotationAnimation];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2.0);
    animation.duration = 10;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    [self.downLoadBtn.imageView.layer addAnimation:animation forKey:@"rotation"];

}

- (void)removeRotationAnimation {

    [self.downLoadBtn.imageView.layer removeAllAnimations];

}


- (IBAction)downLoad {
    NSLog(@"下载");
    if (self.downLoadBlock && self.state == XMGTodayFireVoiceCellStateWaitDownLoad) {
        self.downLoadBlock();
    }
}

- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (self.playBlock) {
        self.playBlock(sender.selected);
    }

}

- (void)setState:(XMGTodayFireVoiceCellState)state {

    _state = state;
    switch (state) {
        case XMGTodayFireVoiceCellStateWaitDownLoad:
            NSLog(@"等待下载");
            [self removeRotationAnimation];
            [self.downLoadBtn setImage:[UIImage imageNamed:@"cell_download"] forState:UIControlStateNormal];
            break;
        case XMGTodayFireVoiceCellStateDownLoading:
        {
            NSLog(@"正在下载");
             [self.downLoadBtn setImage:[UIImage imageNamed:@"cell_download_loading"] forState:UIControlStateNormal];
            [self addRotationAnimation];
            break;
        }
        case XMGTodayFireVoiceCellStateDownLoaded:
            NSLog(@"下载完毕");
            [self removeRotationAnimation];
            [self.downLoadBtn setImage:[UIImage imageNamed:@"cell_downloaded"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }

}



- (void)awakeFromNib {
    [super awakeFromNib];

    self.playOrPauseBtn.layer.masksToBounds = YES;
    self.playOrPauseBtn.layer.borderWidth = 3;
    self.playOrPauseBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.playOrPauseBtn.layer.cornerRadius = 20;

}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"sortNumLabel.text"]) {
        NSInteger sort = [change[NSKeyValueChangeNewKey] integerValue];
        if (sort == 1) {
            self.sortNumLabel.textColor = [UIColor redColor];
        }else if (sort == 2) {
            self.sortNumLabel.textColor = [UIColor orangeColor];
        }else if (sort == 3) {
            self.sortNumLabel.textColor = [UIColor greenColor];
        }else {
            self.sortNumLabel.textColor = [UIColor grayColor];
        }
        return;
    }

}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"sortNumLabel.text"];
}

@end
