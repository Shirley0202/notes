# CoreGraphics初始认识

很简单,apple的api命名都有一定的规范,一般是类是用它所在的框架的首字母作为开头,(因为OC没有命名空间,这样可以很好的避免类的命名冲突)比如UIKit下的类都是以UI开的的(UIView,UIButton...) 所以只要是CG开头的就是CoreGraphicsFramwork下的,比如CGRect CGAffineTransform.

so

你已经使用了很多的CoreGraphics框架里面的东西了

###CoreGraphics的作用
CoreGraphics是一套c语言的API,apple对其进行了很大成都的封装,一般我们都不需要直接使用.

UIKit中的控件的渲染也很多都是基于CoreGraphics实现的 比如UIImage是对CGImage的封装 


