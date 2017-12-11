//
//  XMGDownLoadVoiceCell.m
//  喜马拉雅FM
//
//  Created by 王顺子 on 16/8/20.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDownLoadVoiceCell.h"

@interface XMGDownLoadVoiceCell()

@end


@implementation XMGDownLoadVoiceCell

static NSString *const cellID = @"downLoadVoice";

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    XMGDownLoadVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:self] loadNibNamed:@"XMGDownLoadVoiceCell" owner:nil options:nil] firstObject];
    }

    return cell;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.playOrPauseBtn.layer.cornerRadius = 20;
    self.playOrPauseBtn.layer.masksToBounds = YES;
    self.playOrPauseBtn.layer.borderWidth = 3;
    self.playOrPauseBtn.layer.borderColor = [[UIColor whiteColor] CGColor];

}

- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.playBlock) {
        self.playBlock(sender.selected);
    }

}

- (IBAction)downLoadOrPause:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (self.downLoadBlock) {
        self.downLoadBlock(sender.selected);
    }

}
- (IBAction)deleteFile {

    if (self.deleteBlock) {
        self.deleteBlock();
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        if (self.selectBlock) {
            self.selectBlock();
        }
    }
}



@end
