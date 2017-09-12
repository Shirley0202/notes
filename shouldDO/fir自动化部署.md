####1.注册fir.拿到token

####2.安装 (如果有ruby 可以跳过)
fir-cli 使用 Ruby 构建, 无需编译, 只要安装相应 gem 即可.

```
$ ruby -v # > 1.9.3
$ gem install fir-cli
```
####常见的安装问题
使用系统自带的 Ruby 安装, 需确保 ruby-dev 已被正确的安装:

```
$ xcode-select --install        # OS X 系统
$ sudo apt-get install ruby-dev # Linux 系统
```

出现 Permission denied 相关错误:

在命令前加上 sudo

出现 Gem::RemoteFetcher::FetchError 相关错误:

更换 Ruby 的淘宝源(由于国内网络原因, 你懂的), 并升级下系统自带的 gem

```
$ gem sources --remove https://rubygems.org/
$ gem sources -a https://gems.ruby-china.org
$ gem sources -l
*** CURRENT SOURCES ***
https://ruby.taobao.org
```

请确保只有 https://gems.ruby-china.org, 如果有其他的源, 请 remove 掉
gem update --system
gem install fir-cli
Mac OS X 10.11 以后的版本, 由于10.11引入了 rootless, 无法直接安装 fir-cli, 有以下三种解决办法:

使用 Homebrew 及 RVM 安装 Ruby, 再安装 fir-cli(推荐!实测最佳)

######Install Homebrew:

```
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
######Install RVM:

```
$ \curl -sSL https://get.rvm.io | bash -s stable --ruby

$ gem install fir-cli
```

####3.登录fir
```
$ fir login  
```
按照提示输入token,然后

```
$fir me
```

登录成功,就会显示用户信息

####4.打包
现在基本都是cocoapods来管理第三方库,所以说这一种

cd到工程根目录下,输入

$ fir build_ipa path/to/workspace -w -S 项目名

成功后就可以看到工程目录多了一个文件 "fir_build",这里面放的就是打包后的ipa文件.

####5.发布到fir
```
$ fir publish /Users/***/Desktop/****/fir_build/chatNew-1.0-build-1.ipa
```


*******


#附录: 脚本上传  使用shell脚本进行自动打包上传 (当然你的能手动成功,才可以啊,这里并没有配置证书和描述文件的)


先看一下脚本代码：

```
#! bin/bash
#Author:Bruce http://www.heyuan110.com
#Update Date:2015.06.23
#Use:命令行进入目录直接执行sh Build+DeployToFir.sh即可完成打包发布到fir.im

export LC_ALL=zh_CN.GB2312;
export LANG=zh_CN.GB2312

###############设置需编译的项目配置名称
buildConfig="Release" #编译的方式,有Release,Debug，自定义的AdHoc等

##########################################################################################
##############################以下部分为自动生产部分，不需要手动修改############################
##########################################################################################
projectName=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'` #项目名称
projectDir=`pwd` #项目所在目录的绝对路径
wwwIPADir=~/Desktop/$projectName-IPA #ipa，icon最后所在的目录绝对路径
isWorkSpace=true  #判断是用的workspace还是直接project，workspace设置为true，否则设置为false

echo "~~~~~~~~~~~~~~~~~~~开始编译~~~~~~~~~~~~~~~~~~~"
if [ -d "$wwwIPADir" ]; then
echo $wwwIPADir
echo "文件目录存在"
else
echo "文件目录不存在"
mkdir -pv $wwwIPADir
echo "创建${wwwIPADir}目录成功"
fi

###############进入项目目录
cd $projectDir
rm -rf ./build
buildAppToDir=$projectDir/build #编译打包完成后.app文件存放的目录

###############获取版本号,bundleID
infoPlist="$projectName/Info.plist"
bundleVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $infoPlist`
bundleIdentifier=`/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $infoPlist`
bundleBuildVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $infoPlist`

###############开始编译app
if $isWorkSpace ; then  #判断编译方式
echo  "开始编译workspace...."
xcodebuild  -workspace $projectName.xcworkspace -scheme $projectName  -configuration $buildConfig clean build SYMROOT=$buildAppToDir
else
echo  "开始编译target...."
xcodebuild  -target  $projectName  -configuration $buildConfig clean build SYMROOT=$buildAppToDir
fi
#判断编译结果
if test $? -eq 0
then
echo "~~~~~~~~~~~~~~~~~~~编译成功~~~~~~~~~~~~~~~~~~~"
else
echo "~~~~~~~~~~~~~~~~~~~编译失败~~~~~~~~~~~~~~~~~~~"
exit 1
fi

###############开始打包成.ipa
ipaName=`echo $projectName | tr "[:upper:]" "[:lower:]"` #将项目名转小写
findFolderName=`find . -name "$buildConfig-*" -type d |xargs basename` #查找目录
appDir=$buildAppToDir/$findFolderName/  #app所在路径
echo "开始打包$projectName.app成$projectName.ipa....."
xcrun -sdk iphoneos PackageApplication -v $appDir/$projectName.app -o $appDir/$ipaName.ipa #将app打包成ipa

###############开始拷贝到目标下载目录
#检查文件是否存在
if [ -f "$appDir/$ipaName.ipa" ]
then
echo "打包$ipaName.ipa成功."
else
echo "打包$ipaName.ipa失败."
exit 1
fi

path=$wwwIPADir/$projectName$(date +%Y%m%d%H%M%S).ipa
cp -f -p $appDir/$ipaName.ipa $path   #拷贝ipa文件
echo "复制$ipaName.ipa到${wwwIPADir}成功"
echo "~~~~~~~~~~~~~~~~~~~结束编译，处理成功~~~~~~~~~~~~~~~~~~~"
#open $wwwIPADir

#####开始上传，如果只需要打ipa包出来不需要上传，可以删除下面的代码
export LANG=en_US
export LC_ALL=en_US;
echo "正在上传到fir.im...."
#####http://fir.im/api/v2/app/appID?token=APIToken，里面的appID是你要上传应用的appID，APIToken是你fir上的APIToken
fir p $path
changelog=`cat $projectDir/README`
curl -X PUT --data "changelog=$changelog" http://fir.im/api/v2/app/appID?token=APIToken
echo "\n打包上传更新成功！"
rm -rf $buildAppToDir
rm -rf $projectDir/tmp

```

上面对关键代码都做了详细解释，下面只需要执行shell脚本就能打包上传了。

# you should do 执行shell脚本，打包上传

首先把这个脚本文件放到你的项目工程目录下

然后打开终端，cd到脚本文件在的目录下，执行命名 (给脚本命名为build_deployto_fir.sh,当然其他也是可以的,)

```
sh build_deployto_fir.sh
```

[参考的博客](http://blog.csdn.net/wang631106979/article/details/52299083) 感谢博主的内容,这里只是为学习,不为copy
