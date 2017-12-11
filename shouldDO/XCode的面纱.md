##解开Xcode的面纱给你看他的本质


>Xcode作为iOS开发的IDE,确实使用起来特别的方便,你只需要下载Xcode,不需要额外的配置你就可以开发iOS程序了.可以说Xcode封装的特别好,那么就导致我们对他的了解就很少,我们只知道如何使用.但是不了解他的运行过程.


>还有就是集成了cocoapad 生成了一个新的.xcworkspace的文件.我们就使用这个打开项目,那么cocoapod 都为我们做了什么?

带着这些问题开始我们的探秘之旅把

1. 先了解一些基本的概念 

[clang编译器](https://objccn.io/issue-6-2/)

[Mach-O 可执行文件](https://www.objccn.io/issue-6-3/)

[build过程](https://objccn.io/issue-6-1/)

[深入理解 CocoaPods](https://www.objccn.io/issue-6-4/)

[Xcode 工具链](http://chaosky.me/2017/01/04/Xcode-Toolchain/)


[浏览器是怎么工作的](http://itrain.top/2016/11/javascript_how_broswers_work/)