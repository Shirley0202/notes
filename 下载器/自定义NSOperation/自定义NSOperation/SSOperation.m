//
//  SSOperation.m
//  自定义NSOperation
//
//  Created by 波 on 2017/12/6.
//  Copyright © 2017年 波波. All rights reserved.
//

#import "SSOperation.h"
@interface SSOperation(){
    BOOL finished;
    BOOL executing;
    
}

@end
@implementation SSOperation
- (id)init {
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
    }
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}

-(void)start{
    
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    NSLog(@"%s",__func__);
    
    [NSThread sleepForTimeInterval:2];
    
    
    [self completeOperation];
    
    
    
}
-(void)cancel{
      NSLog(@"%s",__func__);
    [self didChangeValueForKey:@"isCancelled"];

//    isCancelled
//    isConcurrent
//    isExecuting
//    isFinished
    
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}
- (void)completeOperation {
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
}
- (void)dealloc
{
    NSLog(@"dealloc");
}

@end
