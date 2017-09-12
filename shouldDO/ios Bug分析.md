http://www.anoshkin.net/blog/2008/09/09/iphone-crash-logs/


打包的.xcarchive文件会在 ~/Library/Developer/Xcode/
编译的时候会生成的文件  /Users/bo/Library/Developer/Xcode/DerivedData/houDaProject-ansmrzofoepxdtcnaimbjofujcut/Build/Products/Debug-iphoneos/houDaProject.app 


工具symbolicatecrash隐藏在/Developer/Platforms/iPhoneOS.platform/Developer /Library/Xcode/Plug-ins/iPhoneRemoteDevice.xcodeplugin/Contents/Resources/symbolicatecrash



Builld Settings  
这个属性是生成符号表使用的,所以为了build快,可以在debug下关掉 这个
DEBUG_INFORMATION_FORMAT  dwarf-with-dsym














###xcodebuild  命令

先通过直接执行 xcodebuild build -sdk iphoneos -workspace '/path/to/***.xcworkspace' -scheme '***'  TARGET_BUILD_DIR='/var/folders/yr/***/T/***' CONFIGURATION_BUILD_DIR='/var/folders/yr/***/T/***' DWARF_DSYM_FOLDER_PATH='/***/fir_build' 2>&1 命令进行编译，发现也无法生成 dSYM 文件。

作者：酷酷的哀殿
链接：http://www.jianshu.com/p/7a79a6ad5df4
來源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
