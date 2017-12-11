//
//  ViewController.m
//  SSDownloadManager
//
//  Created by 马超 on 16/9/5.
//  Copyright © 2016年 qikeyun. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SSDownloaderManager.h"



@interface ViewController () <TableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;



@property (strong, nonatomic) NSMutableArray *urls;
@end

@implementation ViewController

- (NSMutableArray *)urls
{
    if (!_urls) {
        self.urls = [NSMutableArray array];
        for (int i = 1; i<=10; i++) {
            [self.urls addObject:[NSString stringWithFormat:@"http://120.25.226.186:32812/resources/videos/minion_%02d.mp4", i]];

//       [self.urls addObject:@"http://localhost/MJDownload-master.zip"];
        }
    }
    return _urls;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [[SSDownloaderManager sharedDownloader] removeAndClearAll];
//    [SSDownloaderManager sharedDownloader].maxConcurrentDownloads = 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self urls].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.url = [self urls][indexPath.row];
    cell.delegate = self;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SSDownloadItem *receipt = [[SSDownloaderManager sharedDownloader] downloadReceiptForURLString:[self urls][indexPath.row]];
        [[SSDownloaderManager sharedDownloader] remove:receipt completed:^{
            [self.tableView reloadData];
        }];
        
    }
}

- (IBAction)nextAction:(UIBarButtonItem *)sender {
    
    
  
    NSArray *urls = [self urls];
    
    if ([sender.title isEqualToString:@"Start"]) {
        
        sender.enabled = NO;
        
        for (NSString *url in urls) {
            [[SSDownloaderManager sharedDownloader] downloadDataWithURL:[NSURL URLWithString:url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
                
            } completed:^(SSDownloadItem * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
                NSLog(@"==%@", error.description);
            }];

        }
        
        sender.enabled = YES;
        sender.title = @"Stop";
    } else {
        
        sender.enabled = NO;
        
        [[SSDownloaderManager sharedDownloader] cancelAllDownloads];
        
        sender.enabled = YES;
        sender.title = @"Start";
    }
   [self.tableView reloadData];
}


- (void)cell:(TableViewCell *)cell didClickedBtn:(UIButton *)btn {
    SSDownloadItem *receipt = [[SSDownloaderManager sharedDownloader] downloadReceiptForURLString:cell.url];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    MPMoviePlayerViewController *mpc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:receipt.filePath]];
    [vc presentViewController:mpc animated:YES completion:nil];
}


@end
