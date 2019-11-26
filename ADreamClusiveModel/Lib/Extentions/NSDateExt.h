//
//  NSDateExt.h
//  SwiftExercises
//
//  Created by ADreamClusive on 20/11/2017.
//  Copyright © 2017 ADreamClusive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZL)

/** 判断是否是一分钟内 */
- (BOOL)isInOneMinute;
/** 判断是否是一小时内 */
- (BOOL)isInOneHour;
/** 判断是否是昨天 */
- (BOOL)isYesterday;
/** 判断是否是今天 */
- (BOOL)isToday;
/** 判断是否是明天 */
- (BOOL)isTomorrow;
/** 判断是否是今年 */
- (BOOL)isThisYear;

/** 日期字符串转时间戳 */
+ (NSInteger)timestampFromDateString:(NSString *)dateStr format:(NSString *)format;
/** 时间戳转日期字符串 */
+ (NSString *)stringFromTimestamp:(NSInteger)timeStamp withDateFormat:(NSString *)format;
/** 日期转字符串 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;
/** 字符串转日期 */
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;

/** 日期转week */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;




//比较两个时间的前后  date02>date01：返回1; date02<date01: -1; 相等：返回0.
+ (int)compareDate:(NSString*)date01 withDate:(NSString*)date02;
// 传入今天的时间，返回明天的时间
+ (NSString *)GetTomorrowDay:(NSDate *)aDate;
/* * 计算两个时间的差值 */
+ (long)getSubSecFromData:(NSDate *)fromDate ToData:(NSDate *)toDate;


@end
