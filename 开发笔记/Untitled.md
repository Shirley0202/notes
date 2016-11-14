-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.myTf becomeFirstResponder];
}
   if (nickName.length>16) {
        [SVProgressHUD showInfoWithStatus:@"昵称限制在16个字范围内,请修改后再试"];
        return;
    }
    