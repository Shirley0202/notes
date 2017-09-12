###xcodebuild学习
####1、xcodebuild 简介

在终端中输入man xcodebuild 查看其 man page介绍

xcodebuild -showsdks: 列出 Xcode 所有可用的 SDKs

>NAME

>xcodebuild – build Xcode projects and workspaces

>SYNOPSIS

>1、xcodebuild [-project name.xcodeproj] [[-target targetname] … | -alltargets] [-configuration configurationname] [-sdk [sdkfullpath | sdkname]] [action …] [buildsetting=value …] [-userdefault=value …]

>2、xcodebuild [-project name.xcodeproj] -scheme schemename [[-destination destinationspecifier] …] [-destination-timeout value] [-configuration configurationname] [-sdk [sdkfullpath | sdkname]] [action …] [buildsetting=value …] [-userdefault=value …]

>3、xcodebuild -workspace name.xcworkspace -scheme schemename [[-destination destinationspecifier] …] [-destination-timeout value] [-configuration configurationname] [-sdk [sdkfullpath | sdkname]] [action …] [buildsetting=value …] [-userdefault=value …]

>4、xcodebuild -version [-sdk [sdkfullpath | sdkname]] [infoitem]

>5、xcodebuild -showsdks

>6、xcodebuild -showBuildSettings [-project name.xcodeproj | [-workspace name.xcworkspace -scheme schemename]]

>7、xcodebuild -list [-project name.xcodeproj | -workspace name.xcworkspace]

>8、xcodebuild -exportArchive -archivePath xcarchivepath -exportPath destinationpath -exportOptionsPlist path

>9、xcodebuild -exportLocalizations -project name.xcodeproj -localizationPath path [[-exportLanguage language] …]

>10、xcodebuild -importLocalizations -project name.xcodeproj -localizationPath path
>
> Xcode Builds Settings Reference [官方的指南](https://developer.apple.com/
     documentation/DeveloperTools/Reference/XcodeBuildSettingRef/)

大致显示这些东西可以看一下 下面介绍就个常见的命令




####几个常用的命令有：(编号对应上面的option) (cd 到的你的项目中 )

* 5 xcodebuild -showsdks: 列出 Xcode 所有可用的 SDKs
iOS SDKs:

```
	iOS 10.2                      	-sdk iphoneos10.2

iOS Simulator SDKs:
	Simulator - iOS 10.2          	-sdk iphonesimulator10.2

macOS SDKs:
	macOS 10.12                   	-sdk macosx10.12

tvOS SDKs:
	tvOS 10.1                     	-sdk appletvos10.1

tvOS Simulator SDKs:
	Simulator - tvOS 10.1         	-sdk appletvsimulator10.1

watchOS SDKs:
	watchOS 3.1                   	-sdk watchos3.1

watchOS Simulator SDKs:
	Simulator - watchOS 3.1       	-sdk watchsimulator3.1
	
```


* 6 xcodebuild -showBuildSettings: 的使用方式，查看当前工程 build setting 的配置参数，Xcode 详细的 build setting 参数参考官方文档 Xcode Build Setting Reference， 已有的配置参数可以在终端中以 buildsetting=value 的形式进行覆盖重新设置

```
 很多项目中的buildsetings中的一些设置都会显示出来 这里不一一列举了,大家可以自己看下
```

* 7 xcodebuild -list: 的使用方式，查看 project 中的 targets 和 configurations，或者 workspace 中 schemes, 输出如下:

```
Targets:
        weixinProject

    Build Configurations:
        Debug
        Release

    If no build configuration is specified and -scheme is not passed then "Release" is used.

    Schemes:
        weixinProject
```

* 1 xcodebuild [-project name.xcodeproj] [[-target targetname] ... | -alltargets] build: 的使用方式，会 build 指定 project，其中 -target 和 -configuration 参数可以使用 xcodebuild -list 获得，-sdk 参数可由 xcodebuild -showsdks 获得，[buildsetting=value ...] 用来覆盖工程中已有的配置。



* 3 xcodebuild -workspace name.xcworkspace -scheme scheme name build: 的使用方式，build 指定 workspace，(当我们使用 CocoaPods 来管理第三方库时，会生成 xcworkspace 文件，这样就会用到这种打包方式)

  参数其实也很容易理解的 

```
-project -workspace：这两个对应的就是项目的名字也就是说哪一个工程要打包。如果有多个工程，这里又没有指定，则默认为第一个工程。

-target：打包对应的targets，如果没有指定这默认第一个。


buildsetting=value ...：使用此命令去修改工程的配置。但是在实际应用中，我选择了读取文件去修改一个配置，而没有应用此种方法。

-scheme：指定打包的scheme。
-configuration 指定模式 Debug or Release
```
####下面举例说明下

#####1 编译 pod管理的项目  打包  (打包方式一)
 * 1.命令行进入我现在的一个项目目录，查看一下项目信息，xcodebuild -list

 * 2 然后进行了一下命令 (下面weixin是你的项目名)
 
```
xcodebuild -workspace weixin.xcworkspace -scheme weixin -configuration Release
```

如果 build 成功，会看到 ** BUILD SUCCEEDED **字样, 
编译成功的 文件会在 ~/Library/Developer/Xcode/DerivedData/houDaProject-ansmrzofoepxdtcnaimbjofujcut/Build/Products/Release-iphoneos  
（如果想更好一个路径 那你可以在你的命令后面添加SYMROOT=buildDir指定一个build文件夹）

 * 3 打包用到的是另一个命令 xcrun

在 Release-iphoneos 文件夹下，有我们需要的.app文件，但是要安装到真机上，我们需要将该文件导出为ipa文件，这里使用xcrun命令:
xcrun -sdk iphoneos -v PackageApplication /Users/egintramacbook01/Library/Developer/Xcode/DerivedData/EPayment-bawbxskzmobkcybizafgxpnrdcbe/Build/Products/Release-iphoneos/微信.app -o ~/Desktop/微信.ipa
```
产生警告warning: PackageApplication is deprecated, use xcodebuild -exportArchive instead. 
```


##### 2 生成 .xcarchive 再导出 .ipa (打包方式二)

进入到 xcode 工程文件所在目录，然后执行 xcodebuild clean 进行清除

 * step1 xcodebuild archive生成 .xcarchive
 
 ```
xcodebuild archive -workspace podsoecTest.xcworkspace -scheme podsoecTest -configuration Release -archivePath "~/Desktop/1.xcarchive"
```

* step2 xcodebuild -exportArchive导出.ipa：

 ```
xcodebuild -exportArchive -archivePath ~/Desktop/podsoecTest.xcarchive -exportPath ~/Desktop/podsoecTest.ipa -exportFormat IPA
```
这中方式的打包 要在你的项目打包都没有问题的前提下 而且这个是打的线上宝

[参考的微博](http://www.jianshu.com/p/2d1c6fdc88f2) 只为了学习.不为copy 感谢博主