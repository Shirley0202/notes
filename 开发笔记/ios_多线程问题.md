##iOS 多线程问题

GCD串行队列与并发队列


GCD延时执行操作使用


GCD线程组的操作使用

- (void)setGCDGroup {
    // 初始化线程组
    GCDGroup *group = [[GCDGroup alloc] init];

    // 创建一个线程队列
    GCDQueue *queue = [[GCDQueue alloc] initConcurrent];

    // 让线程在group中执行 线程1
    [queue execute:^{
        sleep(1);// 休眠
        NSLog(@"线程1执行完毕");
    } inGroup:group];

    // 让线程在group中执行 线程2
    [queue execute:^{
        sleep(3);
        NSLog(@"线程2执行完毕");
    } inGroup:group];

    // 监听线程组是否执行完毕，然后执行线程3
    [queue notify:^{
        NSLog(@"线程3执行完毕");
    } inGroup:group];
}

GCD定时器的使用


GCD信号量将异步操作转变成同步操作的使用
GCD 派发源 Dispatch Source （派发源）




### 多线程 数据的安全问题



