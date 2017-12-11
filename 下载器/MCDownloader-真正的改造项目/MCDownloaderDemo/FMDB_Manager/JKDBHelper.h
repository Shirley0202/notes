//
//  JKDataBase.h
//  JKBaseModel
//
//  Created by zx_04 on 15/6/24.
//
//  github:https://github.com/Joker-King/JKDBModel

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface JKDBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (JKDBHelper *)shareInstance;

+ (NSString *)dbPath;

- (BOOL)changeDBWithDirectoryName:(NSString *)directoryName;
-(NSString *)selectCountWithTablename:(NSString *)tablename;


//select concat(round(sum(DATA_LENGTH/1024/1024),2),'M') from tables where table_schema=’数据库名’ AND table_name=’表名’;

@end
