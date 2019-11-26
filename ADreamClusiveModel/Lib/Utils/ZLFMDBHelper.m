//
//  ZLFMDBHelper.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/30.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLFMDBHelper.h"


/**
 数据库名称
 */
#define kDBName [NSString stringWithFormat:@"%@.sqlite", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]]


typedef enum : NSUInteger {
    SQLStringTypeCreate,            //创建
    SQLStringTypeInsert,            //插入
    SQLStringTypeUpdate,            //更新
    SQLStringTypeGetTheLastData,    //获取最后一条
    SQLStringTypeGetSeveralData,    //倒叙查询几条
    SQLStringTypeGetAllData,        //获取全部
} SQLStringType;

@implementation ZLFMDBHelper

static id __sharedFMDB;
+ (instancetype)sharedFMDBHelper {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __sharedFMDB = [[ZLFMDBHelper alloc] init];
    });
    return __sharedFMDB;
}

- (id)init {
    self = [super init];
    if (self) {
        
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbpath = [docsdir stringByAppendingPathComponent:kDBName];
        NSLog(@"database file path: %@", dbpath);
        
        _database = [FMDatabase databaseWithPath:dbpath];
        
    }
    return self;
}

- (BOOL)createProductsTableWithItem:(id)clazz {

    NSString *sqlStr = [self concatenateSQLStringWithType:SQLStringTypeCreate tableName:@"Products" item:clazz];
    return [self executeupdate:sqlStr];
}

- (BOOL)addColumn {
    if (!_database.isOpen) {
        [_database open];
    }
    
    
    NSString *sqlstr = @"alter table Products add column showimagestr text";
    
    BOOL result = [_database executeUpdate:sqlstr];
    
    return result;
}

// 使用一个表来填充另一个表(复制当前表内容，并追加到表)
- (BOOL)insertAllTables {
    if (!_database.isOpen) {
        [_database open];
    }
    if (_database.isOpen) {
        NSString *sqlStr = @"insert into Products(productID, producPrice,producIntro,producName,productPicInfoItems, qrinfo,time, starscore, showimagestr) select productID, producPrice,producIntro,producName,productPicInfoItems, qrinfo,time, starscore, showimagestr from Products";
        BOOL result = [_database executeUpdate:sqlStr];
        
        NSString *desc = [NSString stringWithFormat:@"sql执行失败，请检查语句：%@", sqlStr];
        NSAssert(result, desc);
        return result;
    }
    NSAssert(_database.isOpen, @"数据库未连接!");
    return false;
}

- (BOOL)insertToProducts:(ProductItem *)item {
//    NSString *sqlStr = [self concatenateSQLStringWithType:SQLStringTypeInsert tableName:@"Products" item:item];
//    return [self executeupdate:sqlStr];
    
    if (!_database.isOpen) {
        [_database open];
    }
    if (_database.isOpen) {
        NSData *picdata = [NSKeyedArchiver archivedDataWithRootObject:item.productPicInfoItems];
        NSString *sqlStr = @"insert into Products(productID, producPrice,producIntro,producName,productPicInfoItems, qrinfo,time, starscore, showimagestr) values(?,?,?,?,?,?,?,?,?)";
        BOOL result = [_database executeUpdate:sqlStr, item.productID, item.producPrice, item.producIntro, item.producName, picdata, item.qrinfo, [NSDate date], item.starscore, item.showimagestr];
        
        NSString *desc = [NSString stringWithFormat:@"sql执行失败，请检查语句：%@", sqlStr];
        NSAssert(result, desc);
        return result;
    }
    NSAssert(_database.isOpen, @"数据库未连接!");
    return false;
}

- (BOOL)updateToProducts:(ProductItem *)item {

    if (!_database.isOpen) {
        [_database open];
    }
    if (_database.isOpen) {
        NSData *picdata = [NSKeyedArchiver archivedDataWithRootObject:item.productPicInfoItems];
        NSString *sqlStr = @"UPDATE Products SET producName = ?, producPrice = ?, producIntro = ?, productPicInfoItems=?, qrinfo = ?, time = ?, starscore = ?, showimagestr=? WHERE productID = ?";
        BOOL result = [_database executeUpdate:sqlStr, item.producName, item.producPrice, item.producIntro, picdata, item.qrinfo, [NSDate date], item.starscore, item.showimagestr, item.productID];
        
        NSString *desc = [NSString stringWithFormat:@"sql执行失败，请检查语句：%@", sqlStr];
        NSAssert(result, desc);
        return result;
    }
    NSAssert(_database.isOpen, @"数据库未连接!");
    return false;
}

- (NSArray *)getProductsFrom:(NSString *)startIndex count:(NSString *)count {
    if (!_database.isOpen) {
        [_database open];
    }
    
    NSString *sql = @"select * from products order by id limit ? offset ?";
    
    FMResultSet *resultset = [_database executeQuery:sql, count, startIndex];
    
    NSArray *dataarr = [self itemsFromFMResultSet:resultset];
    
    return dataarr;
}

- (NSArray *)queryProductsWithSearchStr:(NSString *)searchStr {
    
    NSString *sql = [NSString stringWithFormat:@"select * from Products where productID like '%%%@%%' or producName like '%%%@%%' or qrinfo like '%%%@%%'", searchStr, searchStr, searchStr];
//    @"select * from Products where qrinfo = ?", searchStr
    
    FMResultSet *resultset = [_database executeQuery:sql];
    
    NSArray *dataarr = [self itemsFromFMResultSet:resultset];
    
    return dataarr;
}

- (NSArray *)queryProductsWithQRinfo:(NSString *)qrinfo {
    FMResultSet *resultset = [_database executeQuery:@"select * from Products where qrinfo=?", qrinfo];

    NSArray *dataarr = [self itemsFromFMResultSet:resultset];
    
    return dataarr;
}

- (NSArray *)getAllFromProducts {
    FMResultSet *resultset = [self executequery:@"select * from Products"];
    
    NSArray *dataarr = [self itemsFromFMResultSet:resultset];
    
    return dataarr;
}

- (NSArray *)itemsFromFMResultSet:(FMResultSet *)resultset {
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    while (resultset.next) {
        ProductItem *item = [[ProductItem alloc] init];
        item.productID = [resultset stringForColumn:@"productID"];
        item.producName = [resultset stringForColumn:@"producName"];
        item.producPrice = [resultset stringForColumn:@"producPrice"];
        item.producIntro = [resultset stringForColumn:@"producIntro"];
        item.starscore = [resultset stringForColumn:@"starscore"];
        item.qrinfo = [resultset stringForColumn:@"qrinfo"];
        item.showimagestr = [resultset stringForColumn:@"showimagestr"];
        NSData *picsdata = [resultset dataForColumn:@"productPicInfoItems"];
        item.productPicInfoItems = [NSKeyedUnarchiver unarchiveObjectWithData:picsdata];
        //        NSString *datestr = [NSDate stringFromTimestamp:[resultset longLongIntForColumn:@"time"] withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [dataArray addObject:item];
    }
    return dataArray;
}

- (BOOL)deleteProduct:(ProductItem *)item {
    NSString *sql = @"delete from Products where productID=?";
    return [_database executeUpdate:sql, item.productID];
}

- (BOOL)clearProducts {
    NSString * sql = @"delete from Products";
    return [self executeupdate:sql];
}

//删除数据表
-(BOOL)deleteTable:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
    return [self executeupdate:sql];
}

- (void)disConnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self->_database close]) {
            NSLog(@"fail to close db...");
        }
    });
}



#pragma mark - private

- (FMDatabase *)connect {
    if ([_database open]) {
        return _database;
    }
    NSLog(@"fail to open db...");
    return nil;
}

- (FMResultSet *)executequery:(NSString *)sqlstr {
    if (!_database.isOpen) {
        [_database open];
    }
    if (_database.isOpen) {
        FMResultSet *result = [_database executeQuery:sqlstr];
        NSString *desc = [NSString stringWithFormat:@"sql执行失败，请检查语句：%@", sqlstr];
//        NSAssert(result, desc);
        return result;
    }
    NSAssert(_database.isOpen, @"数据库未连接!");
    return 0x00;
}

- (BOOL)executeupdate:(NSString *)sqlstr {
    if (!_database.isOpen) {
        [_database open];
    }
    if (_database.isOpen) {
        BOOL result = [_database executeUpdate:sqlstr];
        NSString *desc = [NSString stringWithFormat:@"sql执行失败，请检查语句：%@", sqlstr];
        NSAssert(result, desc);
        return result;
    }
    NSAssert(_database.isOpen, @"数据库未连接!");
    return false;
}


- (NSString *)concatenateSQLStringWithType:(SQLStringType)type tableName:(NSString *)tableName item:(id)item {
    NSMutableString *statementString = [NSMutableString stringWithCapacity:0];
    
    switch (type) {
        case SQLStringTypeCreate: {
//            CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL, pets blob, car blob);
            NSDictionary *ivardic = [self getIvarList:item];
            
            [statementString appendFormat:@"CREATE TABLE IF NOT EXISTS %@(id integer PRIMARY KEY AUTOINCREMENT,", tableName];
            
            [ivardic enumerateKeysAndObjectsUsingBlock:^(NSString *kvarsName, NSString *kvarsType, BOOL * _Nonnull stop) {
                
                NSString *typeStr = @"text";
                
//                integer : 整型值
//                real : 浮点值
//                text : 文本字符串
//                blob : 二进制数据（比如文件）
                //c - char   C - unsigned char
                if ([kvarsType isEqualToString:@"c"] ||
                    [kvarsType isEqualToString:@"C"] ||
                    [kvarsType isEqualToString:@"i"] ||
                    [kvarsType isEqualToString:@"s"] ||
                    [kvarsType isEqualToString:@"l"] ||
                    [kvarsType isEqualToString:@"q"] ||
                    [kvarsType isEqualToString:@"I"] ||
                    [kvarsType isEqualToString:@"S"] ||
                    [kvarsType isEqualToString:@"L"] ||
                    [kvarsType isEqualToString:@"Q"] ||
                    [kvarsType isEqualToString:@"B"] ||
                    [kvarsType isEqualToString:@"f"] ||
                    [kvarsType isEqualToString:@"d"] ||
                    [kvarsType containsString:@"NSString"]) {
                    
                    typeStr = @"text";
                    
                } else if ([kvarsType containsString:@"NSArray"]          ||
                           [kvarsType containsString:@"NSMutableArray"]   ||
                           [kvarsType containsString:@"NSDictionary"]     ||
                           [kvarsType containsString:@"NSMutableDictionary"] ) {
                    
                    typeStr = @"blob";
                }
                
                
//                if ([kvarsType isEqualToString:@"c"] || [kvarsType isEqualToString:@"C"]) {
//                    typeStr = @"text";
//                }
//                // i - int; s - short; l - long; q - long long; I - unsigned int; S - unsigned short;
//                // L - unsigned long; Q - unsigned long long; B - bool or a C99 _Bool
//                else if ([kvarsType isEqualToString:@"i"] ||
//                         [kvarsType isEqualToString:@"s"] ||
//                         [kvarsType isEqualToString:@"l"] ||
//                         [kvarsType isEqualToString:@"q"] ||
//                         [kvarsType isEqualToString:@"I"] ||
//                         [kvarsType isEqualToString:@"S"] ||
//                         [kvarsType isEqualToString:@"L"] ||
//                         [kvarsType isEqualToString:@"Q"] ||
//                         [kvarsType isEqualToString:@"B"]) {
//
//                    typeStr = @"integer";
//                }
//                //f - float   d - double
//                else if ([kvarsType isEqualToString:@"f"] || [kvarsType isEqualToString:@"d"]) {
//                    typeStr = @"real";
//                } else if ([kvarsType containsString:@"NSArray"]          ||
//                         [kvarsType containsString:@"NSMutableArray"]   ||
//                         [kvarsType containsString:@"NSDictionary"]     ||
//                         [kvarsType containsString:@"NSMutableDictionary"]) {
//
//                    typeStr = @"blob";
//                } else if ([kvarsType containsString:@"NSString"]) {
//                   typeStr = @"text";
//                }
            
                [statementString appendFormat:@"%@ %@,", kvarsName, typeStr];
            }];
            
            [statementString deleteCharactersInRange:NSMakeRange(statementString.length-1, 1)];
            [statementString appendFormat:@",time datetime)"];
        }
            break;
        case SQLStringTypeInsert: {
            
            NSDictionary *ivardic = [self getIvarList:item];
            NSMutableString *valuestr = [[NSMutableString alloc] initWithCapacity:0];
            
            [statementString appendFormat:@"insert into %@(", tableName];
            [valuestr appendString:@") values("];
            
            [ivardic enumerateKeysAndObjectsUsingBlock:^(NSString *kvarsName, NSString *kvarsType, BOOL * _Nonnull stop) {
                
                [statementString appendFormat:@"%@,", kvarsName];
                
                id datavalue = nil;
                if ([kvarsType isEqualToString:@"c"] ||
                    [kvarsType isEqualToString:@"C"] ||
                    [kvarsType isEqualToString:@"i"] ||
                    [kvarsType isEqualToString:@"s"] ||
                    [kvarsType isEqualToString:@"l"] ||
                    [kvarsType isEqualToString:@"q"] ||
                    [kvarsType isEqualToString:@"I"] ||
                    [kvarsType isEqualToString:@"S"] ||
                    [kvarsType isEqualToString:@"L"] ||
                    [kvarsType isEqualToString:@"Q"] ||
                    [kvarsType isEqualToString:@"B"] ||
                    [kvarsType isEqualToString:@"f"] ||
                    [kvarsType isEqualToString:@"d"] ||
                    [kvarsType containsString:@"NSString"]) {
                    
                    datavalue = [NSString stringWithFormat:@"%@", [item valueForKey:kvarsName]];
                
                } else if ([kvarsType containsString:@"NSArray"]          ||
                           [kvarsType containsString:@"NSMutableArray"]   ||
                           [kvarsType containsString:@"NSDictionary"]     ||
                           [kvarsType containsString:@"NSMutableDictionary"]) {
                    
                    if ([[item valueForKey:kvarsName] count] > 0) {
                    
                        datavalue = [NSKeyedArchiver archivedDataWithRootObject:[item valueForKey:kvarsName]];

                        
                        NSArray *dd = [NSKeyedUnarchiver unarchiveObjectWithData:datavalue];
    
                    }
                    
                }
                
                [valuestr appendFormat:@"'%@',", datavalue];
                
            }];
            
            [statementString deleteCharactersInRange:NSMakeRange(statementString.length-1, 1)];
            
            [valuestr deleteCharactersInRange:NSMakeRange(valuestr.length-1, 1)];
            [valuestr appendFormat:@")"];
            
            [statementString appendString:valuestr];
            
//            insert into log_keepers(local_id, logkeeper_id, add_time, content, device_id, device_type, channel) values(?, ?, ?, ?, ?, ?, ?)
        }

        default:
            break;
    }
    return statementString;
}

/** 获取属性列表 */
- (NSDictionary *)getIvarList:(id)item{

    NSMutableDictionary *ivarDic = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int ivarCount = 0; //count记录变量的数量
    // 获取类的所有成员变量
    Ivar *members = class_copyIvarList([item class], &ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        Ivar ivar = members[i];
        // 取得变量名并转成字符串类型
        const char *memberName = ivar_getName(ivar);
        const char *memberType = ivar_getTypeEncoding(ivar);
//
//        NSLog(@"变量名 = %s, 类型 = %s",memberName, memberType);
//        @"NSString"
        NSString *ivarName = [[NSString stringWithUTF8String:memberName] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    
        NSString *ivarType = [NSString stringWithUTF8String:memberType];
        // 处理类型字符串 @\"User\" -> User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        [ivarDic setObject:ivarType
                    forKey:ivarName];
    }
    free(members);
    return ivarDic;
}

//拼接SQL语句方法
//- (NSString *)concatenateSQLStringWithType:(SQLStringType)type withModel:(id)model withDataCount:(NSUInteger)count
//{
//    NSString *statementString = @"";
//
//    switch (type) {
//        case SQLStringTypeCreate: {
//            statementString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,JSON TEXT)",_dbTableName,AUTOINCREMENT_FIELD];
//        }
//            break;
//        case SQLStringTypeInsert: {
//            NSString *jsonString = @"";
//
//            NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
//
//            unsigned int numIvars;      //成员变量个数
//            NSString *kvarsKey = @"";   //获取成员变量的名字
//            NSString *kvarsType = @"";  //成员变量类型
//
//            NSMutableArray *kvarsKeyArr = [NSMutableArray array];  //成员变量名字数组
//            NSMutableArray *kvarsTypeArr = [NSMutableArray array]; //成员变量类型数组
//
//            Ivar *vars = class_copyIvarList([model class], &numIvars);
//
//            //获取成员变量名字/类型
//            for(int i = 0; i < numIvars; i++) {
//
//                Ivar thisIvar = vars[i];
//                kvarsKey = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
//                if ([kvarsKey hasPrefix:@"_"]) {
//                    kvarsKey = [kvarsKey stringByReplacingOccurrencesOfString:@"_" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, 1)];
//                }
//                kvarsType = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)];
//
//                [kvarsKeyArr addObject:kvarsKey];
//                [kvarsTypeArr addObject:kvarsType];
//            }
//
//            //拼接字典 key - 变量名称 value - 变量值
//            [kvarsKeyArr enumerateObjectsUsingBlock:^(NSString *memberKey, NSUInteger idx, BOOL * _Nonnull stop) {
//                id memberValue = [model valueForKey:memberKey]?:@"";
//                if ([[kvarsTypeArr objectAtIndex:idx] isEqualToString:@"@"]) { //对id类型数据进行特殊处理
//                    memberValue = [DPDatabaseUtils setIDVariableToString:[model valueForKey:memberKey]];
//                } else if ([[kvarsTypeArr objectAtIndex:idx] containsString:@"NSArray"] ||
//                           [[kvarsTypeArr objectAtIndex:idx] containsString:@"NSMutableArray"] ||
//                           [[kvarsTypeArr objectAtIndex:idx] containsString:@"NSDictionary"] ||
//                           [[kvarsTypeArr objectAtIndex:idx] containsString:@"NSMutableDictionary"]) {
//
//                    memberValue = [[NSJSONSerialization dataWithJSONObject:[model valueForKey:memberKey] options:NSJSONWritingPrettyPrinted error:nil] base64EncodedStringWithOptions:0];
//                }
//                [jsonDic setObject:memberValue forKey:memberKey];
//            }];
//
//            //字典转json
//            jsonString = [DPDatabaseUtils dictionaryToJson:jsonDic];
//
//            statementString = [NSString stringWithFormat:@"INSERT INTO %@ (JSON) VALUES ('%@')",_dbTableName,jsonString];
//
//            free(vars);
//        }
//            break;
//        case SQLStringTypeUpdate: {
//            //暂不支持
//        }
//            break;
//        case SQLStringTypeGetSeveralData: {
//            statementString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC LIMIT %ld",_dbTableName,AUTOINCREMENT_FIELD,count];
//        }
//            break;
//        case SQLStringTypeGetTheLastData: {
//            statementString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC LIMIT 1",_dbTableName,AUTOINCREMENT_FIELD];
//        }
//            break;
//
//        case SQLStringTypeGetAllData: {
//            statementString = [NSString stringWithFormat:@"SELECT * FROM %@",_dbTableName];
//        }
//            break;
////
//        default:
//            break;
//    }
//
//    return statementString;
//}

@end
