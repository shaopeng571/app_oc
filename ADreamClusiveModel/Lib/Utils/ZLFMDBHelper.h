//
//  ZLFMDBHelper.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/30.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProductItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLFMDBHelper : NSObject


/**
 数据库
 */
@property(nonatomic, readonly) FMDatabase *database;

/**
 单例

 @return 返回ZLFMDBHelper对象
 */
+ (instancetype)sharedFMDBHelper;



/**
 根据模型创建table

 @param clazz 模型类
 @return 是否创建成功
 */
- (BOOL)createProductsTableWithItem:(id)clazz;

/**
 插入数据

 @param item 模型数据
 @return 是否插入成功
 */
- (BOOL)insertToProducts:(ProductItem *)item;

/**
 更新信息

 @param item 模型数据
 @return 返回状态
 */
- (BOOL)updateToProducts:(ProductItem *)item;


/**
 搜索searchStr字符串

 @param searchStr 搜索的字符串
 @return 结果数据
 */
- (NSArray *)queryProductsWithSearchStr:(NSString *)searchStr;
/**
 通过qrinfo查询数据

 @param qrinfo 基准信息
 @return 结果数据
 */
- (NSArray *)queryProductsWithQRinfo:(NSString *)qrinfo;

/**
 获取分页内容
 
 @param startIndex 起始索引
 @param count 总数量
 @return 结果数据
 */
- (NSArray *)getProductsFrom:(NSString *)startIndex count:(NSString *)count;

/**
 获取所有内容

 @return 结果数据
 */
- (NSArray *)getAllFromProducts;


/**
 删除一个商品

 @param item 商品模型
 @return 结果状体
 */
- (BOOL)deleteProduct:(ProductItem *)item;

/**
 清空数据表

 @return 结果状态
 */
- (BOOL)clearProducts;

/**
 删除数据表

 @param tableName 表名
 @return 结果状态
 */
-(BOOL)deleteTable:(NSString *)tableName;
/**
 关闭连接
 */
- (void)disConnect;

@end

NS_ASSUME_NONNULL_END
