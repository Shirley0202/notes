


RACSignal---> createSignal-->实现一个 block 有一个参数subscriber 一个RACDisposable类型的返回值
1. 创建  RACDynamicSignal *signal = [[self alloc] init];
     signal->_didSubscribe = [didSubscribe copy];
     signal.name = @"+createSignal"
     
     
     
     
subscriber 遵守了一个协议拥有了里面的四个方法

//接收

RACDisposable *disposable = [signal subscribeNext:^(id x) {}

//调用了 sigal 的 subscribeNext 方法 这个方法会做如下的事件
1.创建了一个 RACSubscriber 对象 
 1.1遵守RACSubscriber协议 并实现了协议的方法 所以这个对象就是 block 中的那个唯一的参数
 1.2保存了三个block 分别是 next error complete
 (这三个 block 对应这协议中三个方法 调用方法就会调用这个 block)
 
 
2.调用自己的方法  subscribe: 把1的对象作为参数传入 
 2.1 创建 RACCompoundDisposable 对象
 2.2 调用 RACPassthroughSubscriber对象的initWithSubscriber方法 传入 RACSubscriber对象和RACCompoundDisposable对象得到一个新的 RACSubscriber对象 
 2.3 判断自己之前保存的 block 是否为空 如果不为空 
 再创建一个RACDisposable对象 调用下面的方法来创建并在这个方法的一个 block 中调用了之前保存的 block返回的 RACDisposable对象 并把对象添加刀自己数组中 
 把刚才创建的RACDisposable也添加刀自己的数组中
 
 
   RACDisposable *schedulingDisposable =       [RACScheduler.subscriptionScheduler   schedule:^{
			RACDisposable *innerDisposable = self.didSubscribe(subscriber);
			[disposable addDisposable:innerDisposable];
		}];

		[disposable addDisposable:schedulingDisposable];
		
		
		
