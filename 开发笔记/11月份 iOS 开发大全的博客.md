[iOS10CAAnimationDelegate 的简单适配一](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155651&idx=1&sn=531a92cabe984dfe3f593fb3e157d726&chksm=8046cf62b7314674f097f03140dde09a3b3af3025a4ba841b6d84e73799c92484bcec015fcc4&mpshare=1&scene=23&srcid=12055NM1qw4IAQx2j47bA5Hm#rd)

CAAnimationDelegate这个类 在 iOS10 之前是 NSObject 的分类 现在是一个协议了  适配的方法判断 ios 版本

[iOS10CAAnimationDelegate 的简单适配一](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155651&idx=2&sn=d77d1ccc4decb5b2265cdf07ac879041&chksm=8046cf62b731467469dd701384f967039ed7236352fa2547202159af06207fb6ae5c76486941&mpshare=1&scene=23&srcid=1205vNSwHfjWgCtlj8aDwNkR#rd)

系统的 api 的改变,可以适配调警告,在之前的版本也不会出错,但是为了项目的一致性和作为框架还是要适配的

[iOS 应用间的跳转一](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155648&idx=1&sn=670e2a0d6596038cb1e09691345ee28a&chksm=8046cf61b73146771f39d3142bbda445a63b55e7e335db0acbf881cce5d0e3e0d0b728a8b10f&mpshare=1&scene=23&srcid=1205BPSEvCRkyOhsLFRildav#rd)   
应用间的跳转是通过配置 schemes 通过 openUrl来打开


[swift review](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155648&idx=2&sn=8ee5742c557901af986bbc5d9d0d5902&chksm=8046cf61b7314677d93fa18482a6b14267689f04cafea9434eadff20c1e905322e51beb12e3e&mpshare=1&scene=23&srcid=1205ZCmPquDRRCG7blsChceL#rd)
swift 的规范

[swift 面向协议说下去](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155604&idx=2&sn=647f8d4cb54f110db01ab303a6b1aa49&chksm=8046ceb5b73147a3121f18d59a029694c095feb2074854ab0b1138e9bca65ff7bd0689a42f9c&mpshare=1&scene=23&srcid=1205rVQecVP0UTVghubQ7UJd#rd)

[swift 资源](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155604&idx=1&sn=23b2501e8bacf2c4ddef8247155f65ac&chksm=8046ceb5b73147a389db3acb6d782fa68f54197a16f25c55f91c6fa015a695ea0bfaadb4d2cf&mpshare=1&scene=23&srcid=1205kFC5UqZ9S2x7OnQKnLCA#rd)

[swift json 解析](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155564&idx=1&sn=4485816ac5aa402f7e61c452d6641c45&chksm=8046cecdb73147dbe6999cf5570409a2cdcabbcd867d1ae76c0cda9378b1850b8d12dc23534d&mpshare=1&scene=23&srcid=1205LoIondwAHSW9Dnaecp1G#rd)


[关于写 UI 及屏幕适配的一些技巧](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155645&idx=1&sn=ed75fa1c2fb4de5feb6793c302e93519&chksm=8046ce9cb731478a30ed14283bf6f42c234d64f47c127f6897306c777b28aebd0e10c04817e6&mpshare=1&scene=23&srcid=1205wKqkDOUjEZeErmEvP3Ch#rd)
[关于写 UI 及屏幕适配的一些技巧](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155645&idx=2&sn=afb51b824ec0a39d122666c970e1e0ac&chksm=8046ce9cb731478ab961cdeabcf4d505cebbe3f2789c8fe3482f94b5ee0d867ce5d4407e8094&mpshare=1&scene=23&srcid=1205lCejqVYKrA0VkRJjlbFv#rd)

没有什么好的意见,有个一年的开发经验的认估计能够做到作者所说的东西 1 xib 存代码的选择 2屏幕按比例适配 3懒加载  4masonry  5View 的 strong 和 weak

[iOS10 适配的问题](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155592&idx=1&sn=36619a9412d2f82b92506f38b8462cb1&chksm=8046cea9b73147bf6574267785f7c8a1514ac7f064bbbb15bc7cfd0ac37ff264763e59a89ffb&mpshare=1&scene=23&srcid=12057NwtqB6hn1gIZXJjqYtG#rd)
1 系统版本的判断 2 色值 3 用户权限 4 https 5UIStatusBar 6cell的优化 7自带刷新控件属性

[iOS10权限带来的坑](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155636&idx=1&sn=f19025cf259222ebe2b05ddc31d55e32&chksm=8046ce95b7314783daac8a4d6ef805e5d95590d08980c0814b346d3934751aada18cee0e5af0&mpshare=1&scene=23&srcid=1205TVkAo6WUqeXzX1lEbRcn#rd)
 是说国行的手机首次安装应用会询问用户是否给此app使用网络,而这段时间的所有的网络请求都失效了(需要提供一个解决方案)

[webKit 加载 webPage](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155642&idx=3&sn=89c1bf651e08f4a1d8d5901da07689ed&chksm=8046ce9bb731478dd04311f882af2bb7b6be98b619819fd5597f119fd1927de51c255bf47896&mpshare=1&scene=23&srcid=1205ehQC3XBtRjgNt0P5xdMt#rd) 
[webKit 学习之路](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155616&idx=2&sn=42491d64dfec3b6555a662de04a184dc&chksm=8046ce81b731479777c96f8ce3e07c47a2f03aac6d42caf353b3583ab67787843a578dc04f88&mpshare=1&scene=23&srcid=1205dhO8cJCGXPV6RUFwVylg#rd)
[ WKWebKit 使用注意点](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155597&idx=1&sn=77ae80600886791602d78ebd800e6f9b&chksm=8046ceacb73147ba6fb478d5833e1681a375c010c6bc398e7ba5e850ff396be3ef4a6540ca45&mpshare=1&scene=23&srcid=1205GxAPysWQZdmHTaYB0zTO#rd)

 WKWebView的使用的坑和解决办法
 
[iOS 中的各种锁](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155639&idx=2&sn=05ba50f5f5988e31dd21467c8c9819bf&chksm=8046ce96b7314780f70489f13ff108ba0a3ca647e9a446381f56afcb9788dd4c803199ceddf5&mpshare=1&scene=23&srcid=1205VnzGnydnXw9koHGivTKy#rd)
//各种

[优先队列的一种实现方式](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155597&idx=2&sn=adaeddce407331cc92dc79bd4cb3b1ae&chksm=8046ceacb73147ba8a4e2b189c97718ba72a65341ee2097d19773e8624bc10ef3dc36a45f3fe&mpshare=1&scene=23&srcid=1205L48BdUb1qnu0rUny5wzJ#rd)


[LXNetWorking 基于 afn3.0的封装](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155639&idx=1&sn=7c9a4957422294d3f943b588d17e446a&chksm=8046ce96b73147805662deab889398a6e5bcc326ea9d439ceee9f61bdedfac72bb05d4d6dc9e&mpshare=1&scene=23&srcid=12056vy8iGpZrAaT5i2H74CM#rd)



[cocoapods 使用一二](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155622&idx=2&sn=cbee02a566b274250ddaf29f467f5f44&chksm=8046ce87b73147913ad20a31e768aac8cd0e67a4061737e213d476b0cdc3063c475ee82351af&mpshare=1&scene=23&srcid=1205mnnQGufgeAX8yUrTtzp5#rd)
[cocoapods 使用一二](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155636&idx=2&sn=cd3af5fb824198872990b025df372925&chksm=8046ce95b7314783850e0208276d8ad38f81fda99757c648c881d75869dd3022ce154dc3140c&mpshare=1&scene=23&srcid=1205r7Ou67D8RkOtpRwSr3pz#rd)

[工程文件助手](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155634&idx=2&sn=01648ed3775f80e3486e5e0b69302623&chksm=8046ce93b731478546994145c5583c2d1e6851f2c230ca4589d8e56b3ffa57835918159e920d&mpshare=1&scene=23&srcid=12057zbwVQMBLTBqQRjiSrC2#rd)

[KVO](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155634&idx=1&sn=3330f2812448719d7f1650f029a36e46&chksm=8046ce93b731478589beee9578a7b766c57fb4c804080bf1d20d99670875c18fcf993eb53d46&mpshare=1&scene=23&srcid=1205UyE33gGRSG29GOc1bYTP#rd)
kvo 的实现 系统又创建了一个派生类 来改变了原来类的指针,派生类中有被监听的属性,并重写了set方法 当改变是发出通知 并管理者原来类的生命周期


[自定义下拉刷新](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155574&idx=2&sn=ff6ea8827841f29df1259ee93d7490eb&chksm=8046ced7b73147c188bb3d5b7cff16fea7f035c1edbc1d1003d123aeab5e3dd386ef820990bb&mpshare=1&scene=23&srcid=12055eA9GxV554wlAh9XNQ0B#rd)
思路可以借鉴,但是对比MJRefresh 还是有距离的 

[仿 UC 浏览器首页下啦动画及实现](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155622&idx=1&sn=4fbbd1dd356a705e42ba46b646c3266c&chksm=8046ce87b7314791bc5f98dea14d27cf1243c5b23371a531359ae66e34a7acfaee1a08ec6727&mpshare=1&scene=23&srcid=1205rRGIokBM8yk8t5eQ1rtZ#rd)
利用贝塞尔曲线来化一个区域 画处了弧线


[仿淘宝上拉进入详情页面的动画和实现](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155592&idx=2&sn=4b8552a6e80914f17d5c7859d386596a&chksm=8046cea9b73147bf4db11f2ee5c27c85c1b60d2b8becb7d3cf31b6aef4b6bae162cef9a7a926&mpshare=1&scene=23&srcid=1205HxAdmwF6yOVj7MDJWhdR#rd)
//做好转场就好了

[NSOperation NSOperationQueen](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155619&idx=1&sn=600ecfc372e03e23bd431489cf04376c&chksm=8046ce82b7314794d3571775193c5c9c4f2bf2f1dae9299a7525b3f493ac4b3be81d1c817d92&mpshare=1&scene=23&srcid=1205kqg2BljsW97cOxvigs7E#rd)

[iOS dynamicFrameworking 对 APP 启动时间影响实测](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155619&idx=2&sn=b2681e7f497f3b56edf16daeee6ba181&chksm=8046ce82b7314794140f2b336615d68b560e511024f2dfd1c82c1dd48613023ea87de3589876&mpshare=1&scene=23&srcid=1205mghvNTiOwrunRvLMYFtY#rd)


[siriKit 初窥](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155616&idx=1&sn=1ebe087c30818ae7d16c41227fddd9c0&chksm=8046ce81b7314797cb3b162e0a373451ee57cdc8dbef0de17c2d31578c33d7b103aca2a314c7&mpshare=1&scene=23&srcid=1205wqmLV7cmsy7CIlbIkDQP#rd)

[ios 导航栏的那些事](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155613&idx=2&sn=f01c3439f077984297c3752f87085245&chksm=8046cebcb73147aa97d71eb02ecb39f82ce300d5e4f74cc9a38f31270af9be6725250eb63e38&mpshare=1&scene=23&srcid=1205tNKw92kI7SXPO2SZyOYG#rd)
//设置背景色 还是会有半透明效果 要这是背景图 但是如果背景图是存色的图片  那个translucent会被设置为 no 导致 view 的 frame 会有变化

[全栈工程师](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155613&idx=1&sn=b06840ec12660245b059488ad551d213&chksm=8046cebcb73147aaafe48feafd24a613e3b8a02c260c22c771244dca194c76af4c1933b576fe&mpshare=1&scene=23&srcid=1205duldxfpeVAe1BsUeXzKL#rd)


[ios 性能调优](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155609&idx=1&sn=30e66adf98fc533bef33591973521744&chksm=8046ceb8b73147ae4b7fd2e0e54730b1080aa132a4d8a4e66a46b0852ced33a1d7d20364c612&mpshare=1&scene=23&srcid=1205ifUDs7RKJs7oAwRmsmcS#rd)

[iOS 批量打包总结](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155594&idx=2&sn=1d6fae7932ed08f9a4f1ebc93e132a2c&chksm=8046ceabb73147bd9e42765e7256588f71c8857042ab92ae252843d800197a853fecac592bd6&mpshare=1&scene=23&srcid=1205IS08mH7SxgZAx2ULiBQ1#rd)

[基于 ORM 思想的数据库处理](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155564&idx=2&sn=bdae6660879f87bd264a2f16fa078346&chksm=8046cecdb73147db9674c14afe5a525e36d321f580ab47ed359996d99fa7550b11849e1fc97f&mpshare=1&scene=23&srcid=1205U2Adub1ACKCAleHeIUxW#rd)



[xcode8 debug 新特性](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155594&idx=1&sn=dedaa0c1f4df86273cec45ce489e15ab&chksm=8046ceabb73147bd3533ac26c6870a4607522189bd9e18d391e93ca067798c685f9a81ecd315&mpshare=1&scene=23&srcid=1205SGDGfqTIsPd7wQuBitNj#rd)


[xcode 调试技巧总结](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155572&idx=2&sn=c5548c4372e0f0af99bf69c5a48d7c1a&chksm=8046ced5b73147c30baad2fe66135693ecce0cd8b1499e626046aef3f324d1b53aaa22a012a8&mpshare=1&scene=23&srcid=1205uzwIykUGRN9GD692p2Iv#rd)


[javaScript 浅谈 ISO 与 H5的交互 JavaScriptCore 框架](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155586&idx=2&sn=55823871d3e630c0a3dcfdb424a75eef&chksm=8046cea3b73147b5c25897fef43f7fd9f5a9bc905d3c5db05e5ee75632d581fab3b73208c9cd&mpshare=1&scene=23&srcid=1205z2fogJ1A6lsjR5Xl9DZW#rd)

[老司机常用的自定义的控件](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155569&idx=1&sn=ba25a02bec8bce84cd98abb11bf81389&chksm=8046ced0b73147c614868bd1288d21b386ed05f355ac7721f04f85fd3756b955a71fddb018d3&mpshare=1&scene=23&srcid=1205nwtRD6wJNhZN0mv9RoNV#rd)

[从此不在担心键盘挡住输入框](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155569&idx=2&sn=33938db76d4af8fa7f7b168db6b192ed&chksm=8046ced0b73147c6c27b449a9d83a9e0c2536be45a7c85557889898e247c4c6885d7eb576098&mpshare=1&scene=23&srcid=1205KoGRpHcSeHj1noxYN8IR#rd)

[iOS 中静态库和动态库的使用和制作](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155562&idx=2&sn=9a84b9b9d7dc29e20622d4ac32d75a04&chksm=8046cecbb73147dd9b59db0e29ca0d7d0102ce14f09cbe68df43fc59d3d9b2a1158850c03afe&mpshare=1&scene=23&srcid=12051aUj1AgjvnwKK8mVFJbU#rd)


[iOS 开发 tips](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155586&idx=1&sn=817fb03b8db5cf3b8c4645e199deff6a&chksm=8046cea3b73147b548b035f59c63092793262d9ca7003a66a946682989a55914c782b308b8d6&mpshare=1&scene=23&srcid=1205fI9XnCCG4wgTlC5qLgct#rd)

[category 的一些事](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155562&idx=1&sn=163273add66359032d4c09769bcf9e38&chksm=8046cecbb73147dd559c5eaabdf366bc939eca9d441d44a8183807fbcfb09db5230b5cf32fb8&mpshare=1&scene=23&srcid=1205s1y7WdC643sz5LC6tQGX#rd)


[iOS 自动构建命令 xcodebuild](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155560&idx=1&sn=7ee9512d68b1dbe438b8a3213bca7d13&chksm=8046cec9b73147df54ff4778680eefb830824eae86983ae5c73fab99d65933c16d2c1a4d6961&mpshare=1&scene=23&srcid=1205RsCaJEUIdf9kXpgaXizb#rd)


[iOS 屏幕上实时打印 log 的小工具](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155574&idx=1&sn=e5229f6a5f2bfa86c719273820a5cb5e&chksm=8046ced7b73147c181ac8f9d03228d86411a85c1c5f8906bb79f0e9e03d9a08bcb96eeaf1b87&mpshare=1&scene=23&srcid=1205etr1yYrCdkzOaj2ygDw8#rd)


[ios 链式开发实战](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155560&idx=2&sn=3beee5fe8a248890e2f51b97f669853e&chksm=8046cec9b73147df46d837fb256fedaf8c34467ce48eb7611091535b21bd2e9cc504d81041f0&mpshare=1&scene=23&srcid=1205gvMS0qYm2vocRQU5MGb5#rd)
//链式编程特点：方法的返回值是block,block必须有返回值（本身对象），block参数（需要操作的值）

[iOS app 从点击到启动](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155558&idx=1&sn=5f594d019bdc5c849a4ff4b2926ca7fe&chksm=8046cec7b73147d147fa804df309104a0a52a2ae16fdf17d7aaedd716d3c35c9442787b0f195&mpshare=1&scene=23&srcid=1205YTvPOO5sT8MY9kVlh8uT#rd)
//main  ->UIApplication ->UiAplication.delegate = Application ->调用代理方法didFinishLaunchingWithOptions创建窗口 ->获取 info 里面的入口控制器设置窗口的跟控制器

[sceneKit iOS10 新特性制作3d 场景](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155556&idx=1&sn=840b8dde6b73992628e94e91b3ca0f97&chksm=8046cec5b73147d3ee2ae4c958347e7e49ecf2f1a855b905c1dfe17c8452f445d09c8bc2b6c6&mpshare=1&scene=23&srcid=1205zzGPcudS0ZUEQNiMUIVw#rd)

[RNC ](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155584&idx=2&sn=c8444c7c946d6ba2c6a341682bb403db&chksm=8046cea1b73147b7c570a77dcd0a17b4e9c8a7916f483086f72dd7db51d230436e1cd5eef416&mpshare=1&scene=23&srcid=1205jntVEYTQwG92WksqR2ZA#rd)

[RNC ](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155584&idx=1&sn=1585cde27616cc6ed1a9a89fb936466e&chksm=8046cea1b73147b7f511d5421a12fc198f0efe9983ecba6793a28e91603271e63dab317528ec&mpshare=1&scene=23&srcid=12057h2zgYvQl9dbV7XJJKg7#rd)

[二维码](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155558&idx=2&sn=4b3a2bf040c7e1956a02e4e79774c485&chksm=8046cec7b73147d19b712f3d1044f382e0f1caf6463f799578f93949f299622a2c92cdc52185&mpshare=1&scene=23&srcid=1205kl3zwV0oVBwCM8GkPSFX#rd)
//系统的框架

[播放远程音乐](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155554&idx=2&sn=c159ad2fae7e042da448d56d178f7207&chksm=8046cec3b73147d545ba75577dccf4823d60427295dd9405d971e706eda0fc672a1a69139f9b&mpshare=1&scene=23&srcid=1205h6L3WEKwSJ3wwSeW3GrM#rd)
//AVPlayer

[如何优雅的谈源码](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155554&idx=1&sn=10d10327e31a8fbe0faa5dda777a54bf&chksm=8046cec3b73147d5ceb5e79da20611c92604c5d4fd9b2d71caceff0cc5715c30c39becdda876&mpshare=1&scene=23&srcid=1205orGcEZcCLDIFYiiSkOUQ#rd)
SDWebImage 的解读

[预加载和智能加载](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155552&idx=2&sn=0606a0ab8cd155fcfec7bcd9160625db&chksm=8046cec1b73147d7838ca55dbeb19735f16f38a1069b75e56b5d451724f693c4d235a53c96c0&mpshare=1&scene=23&srcid=1205Ys1EVyyWI3s2d6OjHdl3#rd)
//这个值得学习,暂时没有深入了解

[ gif图](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155552&idx=1&sn=464a5e8703b5f2e4bc304a5cbc178a62&chksm=8046cec1b73147d72d106e0e677e4b6ad854fd89687dc25d225f4033a2882c6aa707c7708ae6&mpshare=1&scene=23&srcid=1205k9aj3TwWARz1PFtLS7hA#rd)

[仿微博，别下别播](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155549&idx=2&sn=004a5bf3026ab03c43f3c7653844fcfe&chksm=8046cefcb73147eae7554c73d3636724f9e7599df8b09b35cab855871bfed8a4d0958a2df062&mpshare=1&scene=23&srcid=12057XMcTdEHtHDA6XnrLSwC#rd)

[usernotification](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155549&idx=1&sn=c74f2b263d2ff3e5df60ec21b7fecd2e&chksm=8046cefcb73147ea1b34a209c53bd42da9d6604ae324068afa98d57f0d0898588a1c2884c384&mpshare=1&scene=23&srcid=1205zXYMOKiLcd9ft6C1NHK6#rd)
//iOS 的推送有很多的新功能啊 

[优化 app 启动时间](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155547&idx=2&sn=2d17b92ae9913d256401f8ce60b4f1a6&chksm=8046cefab73147ecc217d642d74055fd5bb0ebe37ae8e1ed88f3ef10eb3ab13ea2210951b7d6&mpshare=1&scene=23&srcid=1205dYkg3cla4e2UGEwTFMdH#rd)

[app直播推流](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155547&idx=1&sn=67461d928e4faafdc21d55ba1903f627&chksm=8046cefab73147ec89e61a620cd8262f817623d10bd2eb0ae4d51507bcf75e95835d689140e1&mpshare=1&scene=23&srcid=1205i3xP1smOYJBERTnep4so#rd)

[objc的前世今生](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155544&idx=1&sn=f46695a5a312b51f679f5ae623afab34&chksm=8046cef9b73147efbe93c281cad4d8c3625987ec64ca5c7ef8e951cac668b10cd9d29971b2ef&mpshare=1&scene=23&srcid=1205283ZAXXdCCsA7eoEn3EL#rd)
//类的创建和销毁的运行时过程



[微信小程序](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155572&idx=1&sn=bddf50cc78ace3599aa3fb696f583586&chksm=8046ced5b73147c320b9c5ea753a6286b3a1afcc837eec922d91a5db287618b4e78609166acc&mpshare=1&scene=23&srcid=1205vQkqlzQHHzwufQyuzxiO#rd)

[集成支付宝钱包支付 iOS SDK 的方法和经验](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155589&idx=2&sn=8875f7a48c40c30c4cea425fd56bae6b&chksm=8046cea4b73147b2f626d1a777b19cb27b16a4b06d1095a85ee26c99f6501ed0f726426bdddb&mpshare=1&scene=23&srcid=12056mzfpoFZBQsJiAnceQqn#rd)


[quickTouch  在 iOS 设备运行的 TouchBar](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155589&idx=1&sn=303fa4ebb25d5ad199bf2aaff48e6c2c&chksm=8046cea4b73147b2aa49f9e0f8cd0cbe2ac21ce04420816e2acda9c5032dc6b463387aec6400&mpshare=1&scene=23&srcid=1205C0Bxq9wZmARTk0tN1xzN#rd)

[网易面试大牛](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155527&idx=1&sn=b3c24f9635ffca632fc390fc95b49613&chksm=8046cee6b73147f03fc8ba9261013b42976022be9d96b30e26f1683ec2467a13125ed9dc0015&mpshare=1&scene=23&srcid=1205feEU9VQ43bcJ5xTr42VP#rd)

[让qq不能撤回](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155527&idx=2&sn=33b8ed1bb716563338f8adf8affd8f08&chksm=8046cee6b73147f0c4603224154ad9e850e8b0834dddd0784c824dd4d2d5e2ca08bfd24b3fbc&mpshare=1&scene=23&srcid=1205L0MwL1BYL5k8lExsDgh0#rd)
//iOS 逆向工程

[iOS 未来](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155526&idx=2&sn=4bc1aa1df5d31a8faa91ca9389ab0809&chksm=8046cee7b73147f185a7ae280b1adf0d8cb312c33440b27db4bebc49495c41c606fe37c6f783&mpshare=1&scene=23&srcid=1205NezoHdj8t42oBdYNoCKI#rd)
//闲谈

[ios位运算](http://mp.weixin.qq.com/s?__biz=MzAxMzE2Mjc2Ng==&mid=2652155523&idx=2&sn=ec7fff6e09bf65901dd04a73184b85c5&chksm=8046cee2b73147f435667e216ad694c6ab2cb254d5a32ab0a111615c6e273de62eceee353d9e&mpshare=1&scene=23&srcid=1205Jszh5aDhFAqQYTaC52Ko#rd)
//位运算现在都属于底层的只是了 很少在代码里使用到了,大多都被重新的封装了起来 



