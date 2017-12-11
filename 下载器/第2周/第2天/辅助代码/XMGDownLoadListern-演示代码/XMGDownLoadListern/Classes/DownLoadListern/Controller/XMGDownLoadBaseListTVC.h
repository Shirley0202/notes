//
//  XMGDownLoadBaseListTVC.h
//  XMGFMDownLoadListern
//
//  Created by 王顺子 on 16/11/20.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BindBlockType)(id model, UITableViewCell *cell);
typedef UITableViewCell *(^GetCellBlockType)(NSIndexPath *indexPath);
typedef CGFloat(^GetCellHeightType)(NSIndexPath *indexPath);

@interface XMGDownLoadBaseListTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *dataLists;

// 子控制器需要重写这个方法即可
- (void)setUpWithDataList: (NSMutableArray *)dataLists getCell: (GetCellBlockType)getCellBlock getCellHeight: (GetCellHeightType)getCellHeightBlock andBind: (BindBlockType)bindBlock;

@end
