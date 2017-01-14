###__weak

在开始讲解__weak机制之前，先来一些铺垫

ARC 的实现
苹果的官方说明中称，ARC是“由编译器进行内存管理”的，但实际上只有编译器是无法完全胜任的，ARC还依赖OC运行时库，也就是说ARC是通过以下工具、库来实现的：

● clang (LLVM 编译器)3.0以上

● objc4 OC运行时库 493.9以上

如果按照苹果的说明，仅仅是编译器管理内存的，那么__weak修饰符也可以在iOS 4中使用

__weak 修饰符
就像我们知道的那样__weak修饰符提供了如同魔法般的公能。

● 若使用__weak修饰符的变量引用对象被废弃时，则将nil赋值给该变量

● 使用附有__weak修饰符的变量，就是使用注册到autoreleasepool的对象。

我们来看看它的实现：

{id __weak obj_weak = obj;//obj已被赋值，并且是strong类型的}
/*编译器的模拟代码*/id obj_weak;objc_initWeak(&obj_weak,obj);//初始化附有__weak修饰符的变量objc_destroyWeak(&obj_weak);//释放该变量
其中objc_initWeak objc_destroyWeak都是调用了objc_storeWeak函数，所以，上面的代码可以转化为下面的代码

id obj_weak;obj_weak = 0;objc_storeWeak(&obj_weak,obj);objc_storeWeak(&obj,0);objc_storeWeak函数以把obj的地址作为键值，obj_weak的地址作为值存放到weak表（weak是一个hash表）中。


释放对象时，废弃对象的同时，程序的动作是怎样的呢？对象通过objc_release释放。

1. objc_release

2. 因为引用计数为0所以执行dealloc

3. _objc_rootDealloc

4. object_dispose

5. objc_destructInstance

6. objc_clear_deallocating

而，调用objc_clear_deallocating的动作如下：

1. 从weak表中获取废弃对象的地址为键值的记录。

2. 将包含在记录中的所有附有__weak修饰符变量的地址，赋值为nil

3. 从weak表中删除记录

4. 从引用计数表中删除废弃对象的地址作为键值的记录

根据以上步骤，前面说的如果附有__weak修饰符的变量所引用的对象被废弃，则将nil赋值给这个变量，这个功能即被实现。

__weak的第二个功能，使用__weak 修饰符的变量，即是使用注册到autoreleasepool中的对象。

{id __weak obj_weak = obj;//obj已被赋值，并且是strong类型的NSLog(@"%@",obj_weak);}
该代码转化为如下形式：

/*编译器的模拟代码*/id obj_weak;objc_initweak(&obj_weak,obj);id tmp = objc_loadWeakRetained(&obj_weak);objc_autorelease(tmp);NSLog(@"%@",tmp);objc_destroyWeak(&obj_weak);
与被赋值时相比，在使用附有__weak修饰符变量的情形下，增加了对objc_loadWeakRetained函数和objc_autorelease函数的调用。这些函数的动作如下：

1. objc_loadWeakRetained函数取出附有__weak修饰符变量所引用的对象并retain

2. objc_autorelease函数将对象注册到autorelease中。

由此可知，因为附有__weak修饰符变量所引用的对象这样被注册到autorelease中，所以在@autoreleasepool块结束之前都可以放心使用。

注：OC中有一些类，并不支持ARC，例如NSMachPort类。可以通过allowsWeakReference/retainWeakReference方法来判断是否支持ARC