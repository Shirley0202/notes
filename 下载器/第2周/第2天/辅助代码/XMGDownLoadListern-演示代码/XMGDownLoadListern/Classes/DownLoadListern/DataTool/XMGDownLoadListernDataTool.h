//
//  XMGDownLoadListernDataTool.h
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMGDownLoadVoiceModel.h"
#import "XMGAlbumModel.h"


@interface XMGDownLoadListernDataTool : NSObject

+ (NSArray <XMGDownLoadVoiceModel *>*)getDownLoadingVoiceMs;

+ (NSArray <XMGDownLoadVoiceModel *>*)getDownLoadedVoiceMs;
+ (NSArray <XMGDownLoadVoiceModel *>*)getDownLoadedVoiceMsInAlbumID: (NSInteger)albumID;

+ (NSArray <XMGAlbumModel *>*)getDownLoadedAlbums;

@end
