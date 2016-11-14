
### 首先介绍下ViewController *vc = [[ViewController alloc] init]; 这个方法会做一下3个步骤
1. ViewController 首先会在找和他同名的nib加载进来作为他的view
2. 如果没有找到就找同名去掉Controller的nib作为他的View 但是要和他有own关系并且View要和ViewController的view有outlet连接 否则就报错
3. 如果1和2都没有找到合适的nib 就调-(void)loadView 自己创建一个view 
  注:只要重写了-(void)loadView 那么ViewController就不再去加载nib文件了 而是调用这个方法来加载一个View 
  
### -(void)loadView重写的时候要注意的事项
系统的方法 加载View的时候会调用的 一定要调 [super loadView];不能直接调用这个方法,一下是不同的方式创建一个viewController时候重写这个方法所产生不同的效果

1 如果viewController是从StoryBoard中加载初始化 不应该重写这个方法 就算重写了 也不能给viewController的View赋值 文档的解释: If you use Interface Builder to create your views and initialize the view controller, you must not override this method. 

```
-(void)loadView{
    [super loadView];
   // self.view = [[UIView alloc]init];//这个是错误的 
       NSLog(@"%s",__func__);
}

```

2 如果viewController是从nib中加载一个View的化 那么就不能从写这个方法,否则将不能从nib中为这个控制器加载view了,只要重写就会新创建一个view

```
-(void)loadView{
    [super loadView];
 // 也可以自己创建一个view给viewController的View赋值
}
```

3 如果viewController是用代码创建的化 是可以重写这个方法的 也可以给ViewController附一个新的View 如下


```
-(void)loadView{
//如果要给self.view 赋个新的值的化 [super loadView]就不用调
//    [super loadView];

    self.view =[[[NSBundle mainBundle]loadNibNamed:@"TestView" owner:self options:nil]firstObject];
    //或者 self.view = [[UIView alloc]init];
  self.view.backgroundColor =[UIColor grayColor];
       NSLog(@"%s",__func__);
}
```
   注: 如果不调[super loadView];一定要给viewController的View附一个值 否则系统就会一直调用这个方法,直到蹦掉.

