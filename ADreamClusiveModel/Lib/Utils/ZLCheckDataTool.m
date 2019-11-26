//
//  ZLCheckDataTool.m
//
//  Created by Jiaozl on 15/11/2017.
//  Copyright © 2017 Jiaozl. All rights reserved.
//

#import "ZLCheckDataTool.h"

@implementation ZLCheckDataTool

#pragma mark - 私有方法
/**
 *  基本的验证方法
 *
 *  @param regEx 校验格式
 *  @param data  要校验的数据
 *
 *  @return YES:成功 NO:失败
 */
+(BOOL)baseCheckForRegEx:(NSString *)regEx data:(NSString *)data{
    
    NSPredicate *card = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    
    if (([card evaluateWithObject:data])) {
        return YES;
    }
    return NO;
}

#pragma mark - 车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    
    return [self baseCheckForRegEx:carRegex data:carNo];
}

#pragma mark - 邮箱校验
+(BOOL)checkForEmail:(NSString *)email{
    
    NSString *regEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self baseCheckForRegEx:regEx data:email];
}
#pragma mark - 验证手机号

/**
 如：手机号前带有区号
 +86 18844060846
 0086 18844060846
 
 "(\\+86|0086)?\\s?1\\d{10}";
 
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"+86 18833052506"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"+8618833052506"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"008618833052506"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"18833052506"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"+852 54897521"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"+85254897521"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"0085254897521"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"54897521"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"+85354897521"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"0085354897521"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"54821521"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"+886 1883305250"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"+8861883305250"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"008861883305250"]);
 NSLog(@"%d", [ZLCheckDataTool checkForMobilePhoneNo:@"18833052506"]);
 */
+(BOOL)checkForMobilePhoneNo:(NSString *)mobilePhone{
    
    NSString *regEx = @"^(\\+86|0086)?\\s?1[3-9][0-9]\\d{8}$|^(\\+852|00852)?\\s?\\d{8}$|^(\\+853|00853)?\\s?\\d{8}$|^(\\+886|00886)?\\s?\\d{10}$";
    return [self baseCheckForRegEx:regEx data:mobilePhone];
    
//    return [self isPRCPhone:mobilePhone] ||[self isHKPhone:mobilePhone] || [self isMOPhone:mobilePhone] || [self isTWPhone:mobilePhone];
}


/**
 * 大陆手机号码11位数 国际区号+86
 */
+(BOOL)isPRCPhone:(NSString *)mobilePhone {
    NSString *regEx = @"^(\\+86|0086)?\\s?1[3-9][0-9]\\d{8}$";
    return [self baseCheckForRegEx:regEx data:mobilePhone];
}
/**
 * 香港手机号码8位数，5|6|8|9开头+7位任意数  国际区号+852
 */
+(BOOL)isHKPhone:(NSString *)mobilePhone {
    NSString *regEx = @"^(\\+852|00852)?\\s?(5|6|8|9)\\d{7}$";
    return [self baseCheckForRegEx:regEx data:mobilePhone];
}
/**
 * 澳门手机号码8位数，6开头+7位任意数  国际区号+853
 */
+(BOOL)isMOPhone:(NSString *)mobilePhone {
    NSString *regEx = @"^(\\+853|00853)?\\s?(6)\\d{7}$";
    return [self baseCheckForRegEx:regEx data:mobilePhone];
}
/**
 * 台湾手机号码10位数，6开头+7位任意数  国际区号+886
 */
+(BOOL)isTWPhone:(NSString *)mobilePhone {
    NSString *regEx = @"^(\\+886|00886)?\\s?(09)\\d{8}$";
    return [self baseCheckForRegEx:regEx data:mobilePhone];
}


#pragma mark - 验证电话号
+(BOOL)checkForPhoneNo:(NSString *)phone{
    NSString *regEx = @"^(\\d{3,4}-)\\d{7,8}$";
    return [self baseCheckForRegEx:regEx data:phone];
}

#pragma mark - 身份证号验证
+ (BOOL) checkForIdCard:(NSString *)idCard{
    
    NSString *regEx = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    return [self baseCheckForRegEx:regEx data:idCard];
}
#pragma mark - 密码校验
+(BOOL)checkForPasswordWithShortest:(NSInteger)shortest longest:(NSInteger)longest password:(NSString *)pwd {
    NSString *regEx =[NSString stringWithFormat:@"^[a-zA-Z0-9]{%ld,%ld}+$", shortest, longest];
    return [self baseCheckForRegEx:regEx data:pwd];
}

//----------------------------------------------------------------------

#pragma mark - 由数字和26个英文字母组成的字符串
+ (BOOL) checkForNumberAndCase:(NSString *)data{
    NSString *regEx = @"^[A-Za-z0-9]+$";
    return [self baseCheckForRegEx:regEx data:data];
}

#pragma mark - 小写字母
+(BOOL)checkForLowerCase:(NSString *)data{
    NSString *regEx = @"^[a-z]+$";
    return [self baseCheckForRegEx:regEx data:data];
}

#pragma mark - 大写字母
+(BOOL)checkForUpperCase:(NSString *)data{
    NSString *regEx = @"^[A-Z]+$";
    return [self baseCheckForRegEx:regEx data:data];
}
#pragma mark - 26位英文字母
+(BOOL)checkForLowerAndUpperCase:(NSString *)data{
    NSString *regEx = @"^[A-Za-z]+$";
    return [self baseCheckForRegEx:regEx data:data];
}

#pragma mark - 特殊字符
+ (BOOL) checkForSpecialChar:(NSString *)data{
    NSString *regEx = @"[^%&',;=?$\x22]+";
    return [self baseCheckForRegEx:regEx data:data];
}

#pragma mark - 只能输入数字
+ (BOOL) checkForNumber:(NSString *)number{
    NSString *regEx = @"^[0-9]*$";
    return [self baseCheckForRegEx:regEx data:number];
}

#pragma mark - 校验只能输入n位的数字
+ (BOOL) checkForNumberWithLength:(NSString *)length number:(NSString *)number{
    NSString *regEx = [NSString stringWithFormat:@"^\\d{%@}$", length];
    return [self baseCheckForRegEx:regEx data:number];
}





@end
