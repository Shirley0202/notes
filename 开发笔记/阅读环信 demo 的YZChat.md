/Users/sunshaobo/Library/Containers/com.tencent.qq/Data/Library/Application Support/QQ/Users/2507378794/QQ/Temp.db/6604E6C9-AA3E-4308-BA32-DAB1152E31AF.png


1.在 xib 中怎么添加多个 view 文件  还有就是 filesOwner--FirstResponder 具体是什么 怎么用
2.NSLocalizedString 这个宏的使用
3.判断模拟器还是真机
4.dispatch_source_merge_data   dispatch_source的使用
5CAEmitterLayer

#if TARGET_IPHONE_SIMULATOR (模拟器)
        
#elif TARGET_OS_IPHONE (真机)

#endif


精度 yzchat 这个项目

   >EMClient: 是 SDK 的入口，主要完成登录、退出、连接管理等功能。也是获取其他模块的入口。

  >EMChatManager: 管理消息的收发，完成会话管理等功能。

  >EMContactManager: 负责好友的添加删除，黑名单的管理。

   >EMGroupManager: 负责群组的管理，创建、删除群组，管理群组成员等功能。
   >EMChatroomManager: 负责聊天室的管理。

#阅读过程
1.appdelegate中切换登录页面和 tabbar 控制器 是使用 rootViewController 来切换的 