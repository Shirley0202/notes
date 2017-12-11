//
//  XMGTodayFireDataTool.m
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/21.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGTodayFireDataTool.h"
#import "XMGSessionManager.h"
#import "MJExtension.h"


#define kBaseUrl @"http://mobile.ximalaya.com/"

@interface XMGTodayFireDataTool ()

@property (nonatomic, strong) XMGSessionManager *sessionManager;

@end


@implementation XMGTodayFireDataTool

static XMGTodayFireDataTool *_dataTool;
+ (instancetype)shareInstance {
    if (!_dataTool) {
        _dataTool = [[XMGTodayFireDataTool alloc] init];
    }
    return _dataTool;
}


- (XMGSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[XMGSessionManager alloc] init];
    }
    return _sessionManager;
}

- (void)getTodayFireShareAndCategoryData:(void(^)(NSArray <XMGCategoryModel *>*categoryMs))result {

    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/rankingList/track"];
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"key": @"ranking:track:scoreByTime:1:0",
                            @"pageId": @"1",
                            @"pageSize": @"0"
                            };

    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {


        XMGCategoryModel *categoryM = [[XMGCategoryModel alloc] init];
        categoryM.key = @"ranking:track:scoreByTime:1:0";
        categoryM.name = @"总榜";

        NSMutableArray <XMGCategoryModel *>*categoryMs = [XMGCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"categories"]];
        if (categoryMs.count > 0) {
            [categoryMs insertObject:categoryM atIndex:0];
        }


        result(categoryMs);
        
    }];
    

}

- (void)getVoiceMsWithKey:(NSString *)key pageNum:(NSInteger)page result:(void(^)(NSArray <XMGDownLoadVoiceModel *>*voiceMs))result
{

    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseUrl, @"mobile/discovery/v2/rankingList/track"];
    NSDictionary *param = @{
                            @"device": @"iPhone",
                            @"key": key,
                            @"pageId": @"1",
                            @"pageSize": @"30"
                            };

    [self.sessionManager request:RequestTypeGet urlStr:url parameter:param resultBlock:^(id responseObject, NSError *error) {


        NSMutableArray <XMGDownLoadVoiceModel *>*voiceyMs = [XMGDownLoadVoiceModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        NSLog(@"%@", [voiceyMs valueForKeyPath:@"playPathAacv164"]);
        result(voiceyMs);
        
    }];
    
}

@end
