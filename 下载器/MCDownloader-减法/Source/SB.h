//
//  SB.h
//  MCDownloaderDemo
//
//  Created by 波 on 2017/12/5.
//  Copyright © 2017年 M.C. All rights reserved.
//

#ifndef SB_h
#define SB_h


#endif /* SB_h */
/**
  MCDownloadReceipt 作用:
   1. 起到一个模型的作用 记录着下载的一些信息 url state 回调等
 
 MCDownloadOperation对象
   1. 初始化一定要传一个 urlRequest 这里会有下载的具体的信息
   2. addHandlersForProgress 用来添加进度的block 和完成的 block
   3. 利用 MCDownloader的urlsection 来创建下载任务并开启任务.
   4. 实现了delegate的代理方法, 来具体的处理下载下来的数据的缓存和保存任务
 
 备注:MCDownloadOperation对象 再表面上和MCDownloadReceipt没有实际的关系但是再内部的方法中还是使用了 MCDownloadReceipt对象的示例 所有其实两个也是一一的对应的关系
 
 
  MCDownloader 作用
   1. 是一个单例.
   2. 管理一个urlSection 负责下载的
   3. 管理一个 Receipt 数组 存放着全部的下载
   4. 管理一个 OperationQueue 用来并发的执行 operation
   5. 管理一个 Operation 的数组
   6. 管理一个 downloadQueue 下载的队列 来控制并发
   8. 实现了urlSection的delegate 但是并没有操作而是交个了operation去操作.
   9. 还实现了对程序的监听. 
 
 */

/**
 所涉及到的类 :
 iOS版本: 7.0以上
 
    1. NSURLSession --- NSURLSessionTask 网络请求
    2. NSOperationQueue ---
    3. NSOperation 自定义
    3. Block 的使用
    4. UIBackgroundTaskIdentifier 后台模式
 
 */

/*
 问题:
  1. 这里为啥使用 NSURLSessionTask
 **/

/**
 
 业务逻辑:
 
    都是下载自定义的文件夹中 下载中的和下载的.下载完成的就删除了归档的文件
 
 */
