## UITextField 的占位文字的属性修改的几种方法
###1.利用 attributedPlaceholder
###2.自定义 
       重写 -(void)drawPlaceholderInRect:(CGRect)rect;
###3.利用runtime 获取属性label 来设置他的属性 


##UITextField改变高亮的状态可以自定义UITextField 来重写 
    - (BOOL)becomeFirstResponder;//成为第一响应者
    - (BOOL)resignFirstResponder;//取消第一响应者


##SDWebImage 中下载图片可以提供进度 也可以加载gif图片,
图片的格式:提取图片data的第一个字节 就可以得到真实的类型 或者看 扩展名