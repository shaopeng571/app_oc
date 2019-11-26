//
//  UIColor+Ext.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Ext)


/**
 十六进制字符串转为UIColor

 @param color 十六进制颜色字符串
 @return color
 */
+ (UIColor *)colorwithHexString:(NSString *)hexStr;


@end

NS_ASSUME_NONNULL_END
