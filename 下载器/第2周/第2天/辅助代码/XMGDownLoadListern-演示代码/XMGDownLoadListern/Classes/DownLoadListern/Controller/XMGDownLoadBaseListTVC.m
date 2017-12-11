//
//  XMGDownLoadBaseListTVC.m
//  XMGFMDownLoadListern
//
//  Created by 王顺子 on 16/11/20.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDownLoadBaseListTVC.h"
#import "XMGNoDownLoadView.h"

#import "XMGTodayFireMainVC.h"

#import "XMGDownLoaderManager.h"

@interface XMGDownLoadBaseListTVC ()

@property (nonatomic, strong) XMGNoDownLoadView *noDownLoadView;

@property (nonatomic, copy) GetCellBlockType getCellBlock;

@property (nonatomic, copy) BindBlockType bindBlock;

@property (nonatomic, copy) GetCellHeightType getCellHeightBlock;

@end

@implementation XMGDownLoadBaseListTVC

#pragma mark - 对外接口
- (void)setUpWithDataList: (NSMutableArray *)dataLists getCell: (GetCellBlockType)getCellBlock getCellHeight: (GetCellHeightType)getCellHeightBlock andBind: (BindBlockType)bindBlock {

    self.getCellBlock = getCellBlock;
    self.bindBlock = bindBlock;
    self.dataLists = dataLists;
    self.getCellHeightBlock = getCellHeightBlock;

    [self.tableView reloadData];
    
}


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.backgroundColor  = [UIColor colorWithRed: 200/255.0 green: 200/255.0 blue: 200/255.0 alpha:1];
    self.tableView.tableFooterView = [UIView new];

    NSString *currentClass = NSStringFromClass([self class]);
    if ([currentClass isEqualToString:@"XMGDownLoadingTrackTVC"]) {
        self.noDownLoadView.noDataImg = [UIImage imageNamed:@"noData_downloading"];
    }else {
        self.noDownLoadView.noDataImg = [UIImage imageNamed:@"noData_download"];
    }

    __weak typeof(self) weakSelf = self;
    [self.noDownLoadView setClickBlock:^{
        NSLog(@"跳转到下载界面");
        [weakSelf.navigationController pushViewController:[XMGTodayFireMainVC new] animated:YES];
    }];


    // 监听重新加载数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCache) name:@"reloadCache" object:nil];


}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadCache {
    NSLog(@"等待被重写");
}


#pragma mark - 表格数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.noDownLoadView.hidden = self.dataLists.count != 0;
    return self.dataLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.getCellBlock(indexPath);
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = self.dataLists[indexPath.row];
    self.bindBlock(model, cell);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.getCellHeightBlock(indexPath);
}

#pragma mark - getter setter


#pragma mark - 懒加载方法
- (XMGNoDownLoadView *)noDownLoadView {
    if (!_noDownLoadView) {
        _noDownLoadView = [XMGNoDownLoadView noDownLoadView];
        _noDownLoadView.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.4);

        [self.view addSubview:_noDownLoadView];
    }
    return _noDownLoadView;
}



@end
