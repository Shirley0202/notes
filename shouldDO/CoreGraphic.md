##  Core Graphics Framework介绍


### what
> The Core Graphics framework is based on the Quartz advanced drawing engine. It provides low-level, lightweight 2D rendering with unmatched output fidelity. You use this framework to handle path-based drawing, transformations, color management, offscreen rendering, patterns, gradients and shadings, image data management, image creation, and image masking, as well as PDF document creation, display, and parsing

```
Core Graphics Framework是一套基于C的API框架，使用了Quartz作为绘图引擎。它提供
了低级别、轻量级、高保真度的2D渲染。该框架可以用于基于路径的绘图、变换、颜色管理、脱
屏渲染，模板、渐变、遮蔽、图像数据管理、图像的创建、遮罩以及PDF文档的创建、显示和分
析。

```
> Core Graphics, also known as Quartz 2D, is an advanced, two-dimensional drawing engine available for iOS, tvOS and macOS application development. Quartz 2D provides low-level, lightweight 2D rendering with unmatched output fidelity regardless of display or printing device. Quartz 2D is resolution- and device-independent
 
> The Quartz 2D API is easy to use and provides access to powerful features such as transparency layers, path-based drawing, offscreen rendering, advanced color management, anti-aliased rendering, and PDF document creation, display, and parsing.

```
CoreGraphics也被称为Quartz 2D, UIKit 中的很多的控件都是基于Core Graphics来渲染的,而且我们可以随处看到CoreGraphics的影子比如UIView的frame center Transform ,实际的开发中更多的是使用UIKit框架,很少利用到CoreGraphic,但是有一些特殊的场景中也会用到,比如需要花一些线段,或者进度的圆环等等

```


###能做什么 *  绘制图形 : 线条\三角形\矩形\圆\弧等*  绘制文字*  绘制\生成图片(图像)*  读取\生成PDF*  截图\裁剪图片*  自定义UI控件* … …









## CGBase 



## CGContext  
绘制的上下文, 这是绘制的一个媒介,所有的操作都保存到这个context里面,在执行他的方法即可
很多的函数也都是在这个文件中




## CGBitmapContext
位图的上下文

## CGAffineTransform 

 仿射转化(3 X 3矩阵合成得到)
 UIView有CGAffineTransform类型的属性transform，它是定义在二维空间上完成View的平移，旋转，缩放等效果的实现。
 



## CGGeometry  
* 定义了一些结构体,创建方法比如 CGPoint CGSize CGVector CGRect 
* 这些结构体的一些函数 比热  make函数(CGRectMake)  Equal函数(CGRectEqualToRect) get函数(CGRectGetMinX) 等等





> 一定要提到的就是 UIBezierPath



[drawRect导致的内存问题](http://bihongbo.com/2016/01/11/memoryGhostMore/)