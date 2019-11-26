//
//  ZLHeader.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#ifndef ZLHeader_h
#define ZLHeader_h

#ifdef __OBJC__


#import "UIViewExt.h"
#import "ZLDeviceUtils.h"
#import "ZLCheckUpdate.h"
#import "NSStringExt.h"
#import "ZLFileManager.h"

#import "ZLNetworkTools.h"
#import "ZLCheckDataTool.h"

#import "ZLCheckNullUtils.h"

#import "LocationManager.h"


#import "NSStringExt.h"
#import "ZLLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh.h>

#import <MBProgressHUD.h>
#import <Toast.h>
#import <MJExtension.h>
#import <IQKeyboardManager.h>

#import "QRManager.h"

#import <Masonry.h>
#import <FMDB.h>
#import "ZLFMDBHelper.h"
#import <LKDBHelper.h>
#import "ZLButtonFactory.h"
#import "ChineseToPinyin.h"
#import "NSDateExt.h"
#import "UIImage+ZLCompress.h"

#import "QRViewController.h"

#import <PYSearch.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <PYPhotoBrowser.h>
#import "ZLActionSheetManager.h"

#import "ZLAppManager.h"

#import "UIColor+Ext.h"

#import "AutoScrollLabel.h"

#import "PermissionCheck.h"

#import <JCAlertController.h>
#import "ZLAudioPlayer.h"
#import "ZLNotificationManager.h"

#endif

#pragma mark - 调试相关

#ifdef DEBUG
# define NSLog(format, ...) NSLog((@"[文件名:%s]" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);


#else
# define NSLog(...);

#endif


#pragma mark - 系统版本相关

// 获取应用支持的最低系统版本
#define kDEPLOYMENT_TARGET_OS_VERSION __IPHONE_OS_VERSION_MIN_REQUIRED

// 系统版本
#define kCURRENT_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]

// 检查系统版本
#define kSYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define kSYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define kSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define kSYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define kSYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#pragma mark - 应用版本相关

// App名称
#define kAPP_DISPLAY_NAME   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kAPP_BUNDLE_NAME   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]

// App版本
#define kAPP_VERSION    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define kAPP_BUILD_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
/**  BundleID */
#define kAPP_BUNDLEID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]



#pragma mark - 本地化

#define ZLLocalizedString(key, comment) NSLocalizedString((key), (comment))


#pragma mark - 字体
/** 字体 */
#define kFontOfSize(size)       [UIFont systemFontOfSize:size]
#define kSystemFont             kFontOfSize([UIFont systemFontSize])


#pragma mark - 判断设备是否为iPhone X及以上设备
// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define isIPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})



#pragma mark - 尺寸

/** 屏幕的宽度 */
#define kSCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
/** 屏幕的高度 */
#define kSCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height

/** navigationBarHeight */
#define kNavigationBarHeight    (isIPHONE_X ? (44+44) : (20+44))
/** tabBarHeight */
#define kTabBarHeight           (isIPHONE_X ? (49 + 34) : 49)
/** statusBarHeight */
#define kStatusBarHeight        [[UIApplication sharedApplication] statusBarFrame].size.height
//#define kNavigationBarHeight    (self.navigationController.navigationBar.frame.size.height + kStatusBarHeight)
//#define kTabBarHeight           self.tabBarController.tabBar.frame.size.height


 /** 判断是否横屏 */
#define kIsLandscape \
([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || \
[UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)

/** 横屏时安全区域 */
#define kSafeLeft   (kIsLandscape && isIPHONE_X ? 44.0 : 0.0)
#define kSafeRight  (isIPHONE_X && kIsLandscape ? 44.0 : 0.0)


#pragma mark - 颜色
/** 颜色 */
#define kRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define kCOLOR_WITH_HEX(hexValue)   [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]
#define kRANDOM_COLOR [UIColor colorWithRed:((arc4random_uniform(256))/255.0) green:((arc4random_uniform(256))/255.0) blue:((arc4random_uniform(256))/255.0) alpha:1.0]


#pragma mark - 弱引用
#define ZLWeakSelf __weak typeof(self) weakSelf = self;

#pragma mark - 路径相关

#define kDIRECTORY_HOME  NSHomeDirectory()

/// 存储用户数据或其它应该定期备份的信息
#define kDIRECTORY_DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/// 用于存放临时文件，保存应用程序再次启动过程中不需要的信息
#define kDIRECTORY_TMP NSTemporaryDirectory()

/// 用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息
#define kDIRECTORY_CACHES [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/// 应用程序的偏好设置文件
#define kUSERDEFAULTS [NSUserDefaults standardUserDefaults]


#pragma mark - 代码运行时间检测

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])


#pragma mark - 一些默认值

#define kDefaultImage [UIImage imageNamed:@"defaultImage"]









#endif /* ZLHeader_h */
