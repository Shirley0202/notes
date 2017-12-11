//
//  XMGDownLoadAlbumCellVM.h
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/25.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMGAlbumModel.h"
#import "XMGDownLoadAlbumCell.h"

@interface XMGDownLoadAlbumCellVM : NSObject

@property (nonatomic, strong) XMGAlbumModel *albumModel;

- (void)bindWithCell: (XMGDownLoadAlbumCell *)cell;

@end
