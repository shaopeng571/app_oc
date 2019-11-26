//
//  ZLUncaughtExceptionModel.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/19.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ZLUncaughtExceptionFilePath;
extern NSString * const ZLSignalExceptionFilePath;
extern NSString * const ZLExceptionFileName;

//!< 手机系统版本号
#define PHONE_VERSION [[UIDevice currentDevice] systemVersion]
//!< 设备对app供应商的唯一标示（对供应商的，也就是这个供应商有两个app，那么在这两个app上返回的这个标识是一致的）
#define IDENTIFIER_NUMBER [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//!< 手机型号
#define PHONE_TYPE [ZLDeviceUtils deviceType]
//!< app版本号
#define APP_VERSION [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]



@interface ZLUncaughtExceptionModel : NSObject

@end

NS_ASSUME_NONNULL_END
