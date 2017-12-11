//
//  XMGDownLoadListernDataTool.m
//  XMGDownLoadListern
//
//  Created by 王顺子 on 16/11/23.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "XMGDownLoadListernDataTool.h"
#import "XMGModelOperationTool.h"

@implementation XMGDownLoadListernDataTool

+ (NSArray <XMGDownLoadVoiceModel *>*)getDownLoadingVoiceMs {

    return [XMGModelOperationTool queryModels:[XMGDownLoadVoiceModel class] whereColumnName:@"isDownLoaded" isValue:@(NO) withUserID:nil];

}

+ (NSArray <XMGDownLoadVoiceModel *>*)getDownLoadedVoiceMs {
    return [XMGModelOperationTool queryModels:[XMGDownLoadVoiceModel class] whereColumnName:@"isDownLoaded" isValue:@(YES) withUserID:nil];
}

+ (NSArray <XMGDownLoadVoiceModel *>*)getDownLoadedVoiceMsInAlbumID: (NSInteger)albumID {

   return [XMGModelOperationTool queryModels:[XMGDownLoadVoiceModel class] withCondition:[NSString stringWithFormat:@"isDownLoaded = '1' and albumID = '%zd'", albumID] withUserID:nil];

}

+ (NSArray <XMGDownLoadVoiceModel *>*)getDownLoadedAlbums {

    NSArray *array = [XMGModelOperationTool queryModelsWithSql:@"select albumId, albumTitle, commentsCounts, coverSmall as albumCoverMiddle,nickName as authorName, count(*) as voiceCount, sum(totalSize) as allVoiceSize from XMGDownLoadVoiceModel where isDownLoaded = '1' group by albumId" withUserID:nil];

    NSMutableArray *albumMs = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        XMGAlbumModel *model = [[XMGAlbumModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [albumMs addObject:model];
    }


    return albumMs;
}


@end
