//
//  ViewController.m
//  自定义NSOperation
//
//  Created by 波 on 2017/12/6.
//  Copyright © 2017年 波波. All rights reserved.
//

#import "ViewController.h"
#import "SSOperation.h"
@interface ViewController ()
/// <#annotation#>
@property(nonatomic,strong)NSOperationQueue *queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    self.queue = queue;
    queue.maxConcurrentOperationCount = 1;
  
    for (int i = 0 ; i<50; i++) {
        NSBlockOperation *bo = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"%d",i);
            NSLog(@"%@",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }];
         SSOperation *op = [[SSOperation alloc]init];
        [queue addOperation:op];
   
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%d",self.queue.operationCount);
//    self.queue.suspended = !self.queue.isSuspended;
    [self.queue cancelAllOperations];
}

@end
