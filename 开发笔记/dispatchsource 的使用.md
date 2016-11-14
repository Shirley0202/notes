 
 dispatch的定时功能 
 
 NSInteger timeLine =59;
    NSString *title=@"重新获取";
    NSString *subTitle=@"s再获取";
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setBackgroundImage:[UIImage imageNamed:@"btn_get_n"] forState:UIControlStateNormal];
                [sender setTitle:title forState:UIControlStateNormal];
                [sender setTitleColor:mainColor forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setBackgroundImage:[UIImage imageNamed:@"btn_get_select"] forState:UIControlStateNormal];
                [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                [sender setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
 
