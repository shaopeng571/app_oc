//
//  NSDateExt.m
//  SwiftExercises
//
//  Created by ADreamClusive on 20/11/2017.
//  Copyright © 2017 ADreamClusive. All rights reserved.
//

#import "NSDateExt.h"

static NSDateFormatter *formatter_;

@implementation NSDate (ZL)

// 第一次使用这个类的时候调用
// 优化性能,减少频繁的创建格式化对象
+ (void)initialize {
    [super initialize];
    formatter_ = [[NSDateFormatter alloc] init];
}

#pragma mark - 日期时间间隔判断

- (BOOL)isInOneMinute
{
    formatter_.dateFormat = @"yyyyMMddHHmm";
    
    NSString *selfSecond = [formatter_ stringFromDate:self];
    NSString *nowSecond = [formatter_ stringFromDate:[NSDate date]];
    
    return [selfSecond isEqualToString:nowSecond];
}

- (BOOL)isInOneHour
{
    formatter_.dateFormat = @"yyyyMMddHH";
    
    NSString *selfHour = [formatter_ stringFromDate:self];
    NSString *nowHour = [formatter_ stringFromDate:[NSDate date]];
    
    return [selfHour isEqualToString:nowHour];
}

- (BOOL)isYesterday
{
    formatter_.dateFormat = @"yyyyMMdd";
    
    NSString *selfDay = [formatter_ stringFromDate:self];
    NSString *nowDay = [formatter_ stringFromDate:[NSDate date]];
    
    NSDate *selfDate = [formatter_ dateFromString:selfDay];
    NSDate *nowDate = [formatter_ dateFromString:nowDay];
    
    NSCalendar *calendar_ = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmp = [calendar_ components:units fromDate:nowDate toDate:selfDate options:0];
    
    return cmp.year == 0 && cmp.month == 0 && cmp.day == -1;
}
- (BOOL)isToday
{
    formatter_.dateFormat = @"yyyyMMdd";
    
    NSString *selfDay = [formatter_ stringFromDate:self];
    NSString *nowDay = [formatter_ stringFromDate:[NSDate date]];
    
    return [selfDay isEqualToString:nowDay];
}

- (BOOL)isTomorrow
{
    formatter_.dateFormat = @"yyyyMMdd";
    
    NSString *selfDay = [formatter_ stringFromDate:self];
    NSString *nowDay = [formatter_ stringFromDate:[NSDate date]];
    
    NSDate *selfDate = [formatter_ dateFromString:selfDay];
    NSDate *nowDate = [formatter_ dateFromString:nowDay];
    
    NSCalendar *calendar_ = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmp = [calendar_ components:units fromDate:nowDate toDate:selfDate options:0];
    
    return cmp.year == 0 && cmp.month == 0 && cmp.day == 1;
}

- (BOOL)isThisYear
{
    formatter_.dateFormat = @"yyyy";
    NSString *selfYear = [formatter_ stringFromDate:self];
    NSString *currentYear = [formatter_ stringFromDate:[NSDate date]];
    
    return [selfYear isEqualToString:currentYear];
}


#pragma mark - 日期时间-字符串 转换

+(NSInteger)timestampFromDateString:(NSString *)timeStr format:(NSString *)format {
    
    NSDate *date = [NSDate dateFromString:timeStr format:format];
    
    return [NSDate cTimestampFromDate:date];
}
+ (NSInteger)cTimestampFromDate:(NSDate *)date {
    
    return (long)[date timeIntervalSince1970];
}

+ (NSString *)stringFromTimestamp:(NSInteger)timeStamp withDateFormat:(NSString *)format {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    
    return [NSDate stringFromDate:date format:format];
}

+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format {
    
    formatter_.dateFormat = format; //指定转date得日期格式化形式
    
    return [formatter_ stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format {
    
    [formatter_ setTimeZone:[NSTimeZone localTimeZone]];
    
    formatter_.dateFormat = format;
    
    return [formatter_ dateFromString:dateString];
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}


//比较两个时间
+ (int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
            //date02比date01大
        case NSOrderedAscending:
            ci=1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci=-1;
            break;
            //date02=date01
        case NSOrderedSame:
            ci=0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
    return ci;
}
//传入今天的时间，返回明天的时间
+ (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateday stringFromDate:beginningOfWeek];
}
/* * 计算两个时间的差值 */
+ (long)getSubSecFromData:(NSDate *)fromDate ToData:(NSDate *)toDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    long sec;
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:fromDate toDate:toDate options:0];
    sec = [d hour]*3600+[d minute]*60+[d second];
    // NSLog(@"second = %ld",[d hour]*3600+[d minute]*60+[d second]);
    return sec;
}


@end
