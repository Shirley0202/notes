#### runloop 

> tips

 * 1.主线程的runloop是默认开启的 并且模式是 NSDefaultRunLoopMode
 
 *  1.子线程默认不开启 runloop，它会向一个 C语言程序那样在运行完所有代码后退出线程



### Runloop的几种模式



#### Runloop的概念 
RunLoop 实际上就是一个对象，这个对象管理了其需要处理的事件和消息，并提供了一个入口函数来执行上面 Event Loop 的逻辑。线程执行了这个函数后，就会一直处于这个函数内部 "接受消息->等待->处理" 的循环中，直到这个循环结束（比如传入 quit 的消息），函数返回。
OSX/iOS 系统中，提供了两个这样的对象：NSRunLoop 和 CFRunLoopRef。
CFRunLoopRef 是在 CoreFoundation 框架内的，它提供了纯 C 函数的 API，所有这些 API 都是线程安全的。
NSRunLoop 是基于 CFRunLoopRef 的封装，提供了面向对象的 API，但是这些 API 不是线程安全的。


#### RunLoop 与线程的关系
苹果不允许直接创建 RunLoop，它只提供了两个自动获取的函数：CFRunLoopGetMain() 和 CFRunLoopGetCurrent()
从上面的代码可以看出，线程和 RunLoop 之间是一一对应的，其关系是保存在一个全局的 Dictionary 里。线程刚创建时并没有 RunLoop，如果你不主动获取，那它一直都不会有。RunLoop 的创建是发生在第一次获取时，RunLoop 的销毁是发生在线程结束时。你只能在一个线程的内部获取其 RunLoop（主线程除外）

####RunLoop 对外的接口
在 CoreFoundation 里面关于 RunLoop 有5个类:

* CFRunLoopRef
* CFRunLoopModeRef
* CFRunLoopSourceRef
* CFRunLoopTimerRef
* CFRunLoopObserverRef







####开源的地方 https://opensource.apple.com

[多线程](http://www.cocoachina.com/ios/20170829/20404.html)
[参考的博客](https://blog.ibireme.com/2015/05/18/runloop/)
