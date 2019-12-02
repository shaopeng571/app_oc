//
//  SLTNullUtil.m
//  SLTDriver
//
//  Created by zl jiao on 2019/12/2.
//  Copyright © 2019 oyahaok. All rights reserved.
//

#import "SLTNullUtil.h"

@implementation SLTNullUtil


/**
判断字符串是否为空
@param  aStr 字符串
@return YES  空 NO为有值
*/
+ (BOOL)isBlankString:(NSString *)aStr
{
    if ([self isBlankObject:aStr]) {
        return YES;
    }

    if (!aStr.length ) {
        return YES;
    }
    
    if ([aStr isEqualToString:@"(null)"] ||
        [aStr isEqualToString:@""] ||
        [aStr isEqualToString:@"null"] ||
        [aStr isEqualToString:@"<null>"] ) {
        return YES;
    }

    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length ) {
        return YES;
    }

    return NO;
}

/**
判断Number是否为空
@param  aNum 数据
@return YES  空 NO为有值
*/
+ (BOOL)isBlankNumber:(NSNumber *)aNum
{
    if ([self isBlankObject:aNum]) {
        return YES;
    }

    if ([aNum isEqualToNumber:@(0)] ) {
        return YES;
    }

    return NO;
}

/**
判断数组为空
@param arr 数组
@return YES 空 NO
*/
+ (BOOL)isBlankArr:(NSArray *)arr
{
    if ([self isBlankObject:arr]) {
        return YES;
    }

    if (!arr.count ) {
        return YES;
    }

    if (arr == NULL ) {
        return YES;
    }

    if (![arr isKindOfClass:[NSArray class]] ) {
        return YES;
    }
    
    return NO;
}



/**
判断字典为空
@param  dic 数组
@return YES 空 NO
*/
+ (BOOL)isBlankDictionary:(NSDictionary *)dic
{
    if ([self isBlankObject:dic]) {
        return YES;
    }
    
    if (dic == NULL ) {
        return YES;
    }
    
    if (!dic.count ) {
        return YES;
    }

    if (![dic isKindOfClass:[NSDictionary class]] ) {
        return YES;
    }

    return NO;
}

+ (BOOL)isBlankObject:(id)obj
{
    // 针对（null）的情况
    if (obj == nil ) {
        return YES;
    }
    
    // 针对 <null> 的情况
    if ([obj isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    // 对于对象类型的数据进行空值判断, 可以使用 !(非) 来判断
    if (!obj) {
        return YES;
    }
    
    return NO;
}

#pragma mark Null转换
+ (NSString *)nullToString:(id)string
{
    if ([self isBlankString:string]) {
        return @"";
    }
    return string;
}
+ (NSNumber *)nullToNumber:(id)num
{
    if ([self isBlankNumber:num]) {
        return @(0);
    }
    return num;
}
+ (NSArray *)nullToArray:(id)array
{
    if ([self isBlankArr:array]) {
        return @[];
    }
    return array;
}
+ (NSDictionary *)nullToDictionary:(id)dict
{
    if ([self isBlankDictionary:dict]) {
        return @{};
    }
    return dict;
}




@end
