//
//  ZLCheckNullUtils.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/15.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLCheckNullUtils : NSObject

///主要调用该方法
+ (id)replaceNullData:(id)obj;
///处理字典
+ (id)replaceNullWithDictionary:(NSMutableDictionary *)dic;
///处理数组
+ (id)replaceNullWithArray:(NSMutableArray *)arr;
///处理字符串
+ (NSString *)replaceNullValue:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
