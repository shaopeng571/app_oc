//
//  NSStringExt.h
//  SwiftExercises
//
//  Created by ADreamClusive on 16/11/2017.
//  Copyright © 2017 ADreamClusive. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NSString (ZL)

#pragma mark - 字符串中空格处理
/// 去除左右两边空格
- (NSString *)clearEdgeSpace;

/// 去除字符串两端所有空行和空格
- (NSString *)clearEdgeSpaceAndNewLine;

/// 去除字符串中所有空格
- (NSString *)clearAllSpace;

/// 去除字符串所有空行
- (NSString *)clearAllNewLine;

/// 去除字符串中所有空格和空行
- (NSString *)clearAllSpaceAndNewLine;

/// 替换字符串中指定字符串
- (NSString *)replaceString:(NSString *)oldStr withString:(NSString *)newStr;

#pragma mark - 获取字符串中的电话号码
/** 返回字符串中的手机号   格式： {Range1:phone1, Range2:phone2}
 NSDictionary *phoneNums = [someStr phoneNums];
 if (phoneNums && phoneNums.allKeys.count>0) {
    [phoneNums enumerateKeysAndObjectsUsingBlock:^(NSString *rangeStr, NSString *phonenum, BOOL * _Nonnull stop) {
 
    }];
 }
 */
- (NSDictionary *)phoneNums;

#pragma mark - 字符串size处理
/**
 *  计算字符串的尺寸
 *
 *  @param textString 字符串
 *  @param textFont   字符串的字体大小
 *
 *  @return 字符串的尺寸
 */
+ (CGSize)sizeWithTextString:(NSString *)textString textFont:(UIFont *)textFont;
/**
 *  计算字符串的尺寸(限制最大宽度)
 *
 *  @param textString 字符串
 *  @param textFont   字符串的字体大小
 *  @param maxWidth   最大宽度
 *
 *  @return 文字尺寸
 */
+ (CGSize)sizeWithTextString:(NSString *)textString textFont:(UIFont *)textFont maxWidth:(CGFloat)maxWidth;

#pragma mark - 字符串中数字的处理
/** 改变字符串中数字的颜色 */
- (NSAttributedString *)changeNumberWithColor:(UIColor *)color;

/** 改变字符串中数字的颜色 */
- (NSAttributedString *)changeNumberColor:(UIColor *)color
                                 withFont:(CGFloat)font;

#pragma mark - 添加中划线和下划线
- (NSMutableAttributedString *)addStrikethroughWithColor:(UIColor *)color fontSize:(float)fontsize;
- (NSMutableAttributedString *)addUnderlineWithColor:(UIColor *)color fontSize:(float)fontsize;

/** 获取num个随机数 */
+ (NSString *)randomStringLength:(NSInteger)len;

/** 判断是否含有汉字 */
- (BOOL)isIncludeChinese;

#pragma mark - 检查两个字符串的相似度
/**
 检查两个字符串的相似度

 @param originText 字符串1
 @param targetText 字符串2
 @return 相似度
 
 [NSString likePercentByCompareOriginText:@"导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已" targetText:@"导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的Pree，就在栈中的对象而已"];
 */
+ (float)likePercentByCompareOriginText:(NSString *)originText targetText:(NSString *)targetText;

@end
