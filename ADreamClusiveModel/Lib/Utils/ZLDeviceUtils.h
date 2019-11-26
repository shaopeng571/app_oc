//
//  ZLDeviceUtil.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLDeviceUtils : NSObject


/**
 获取设备类型号
 
 @return 设备类型号
 */
+ (NSString*)deviceType;

/**
 判断设备是否为模拟器

 @return YES: 是； or NO: 不是
 */
+ (BOOL)isSimulator;

/**
 获取设备IP地址（不能获取蜂窝网络下IP地址）

 @return IP地址
 */
+ (NSString *)IPAddress;

/**
 获取设备IP地址（可以获取蜂窝网络下IP地址）

 @param preferIPv4 获取IPv4地址
 @return IP地址
 */
+ (NSString *)IPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
