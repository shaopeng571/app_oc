//
//  ColorManager.h
//
//
//  Created by ADreamClusive on 17/1/14.
//  Copyright © 2017年 ADreamClusive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 全局设置

#define kDefaultThemeColor kRGB(255, 110, 0)
#define kGetThemeColor [[ZLAppManager sharedInstance] getThemeColor]
#define kSetThemeColor(newColor) [[ZLAppManager sharedInstance] setThemeColor:(newColor)]


#define kGetThemeFont(size) kFontOfSize([[ZLAppManager sharedInstance] getScaleCoefficient]*(size))
#define kGetThemeFontSizeCoeff [[ZLAppManager sharedInstance] getFontSizeCoefficient]
#define kSetThemeFontSizeCoeff(aCoeff) [[ZLAppManager sharedInstance] setFontSizeCoefficient:(aCoeff)]



#define kGetThemeLargeTitle [[ZLAppManager sharedInstance] getPrefersLargeTitles]
#define kSetThemeLargeTitle(aBool) [[ZLAppManager sharedInstance] setPrefersLargeTitles:(aBool)]

#define kGetThemeNotiAt10 [[ZLAppManager sharedInstance] getNotiAt10]
#define kSetThemeNotiAt10(aBool) [[ZLAppManager sharedInstance] setNotiAt10:(aBool)]

#define kGetThemeNotiAtPosition [[ZLAppManager sharedInstance] getNotiAtPosition]
#define kSetThemeNotiAtPosition(aBool) [[ZLAppManager sharedInstance] setNotiAtPosition:(aBool)]

#define kPOST_NOTIFICATION(aNoti) [[NSNotificationCenter defaultCenter] postNotificationName:(aNoti) object:nil]



extern NSString *const ThemeColorChangeNotification;
extern NSString *const ThemeFontChangeNotifocation;
extern NSString *const ThemeLargeTitleChangeNotifocation;

@interface ZLAppManager : NSObject


/**
 获取实例对象

 @return 实例
 */
+(id)sharedInstance;

/**
 设置主题色

 @param color 颜色
 */
- (void)setThemeColor:(UIColor *)color;

/**
 获取主题色

 @return 颜色
 */
- (UIColor *)getThemeColor;


/**
 设置大标题导航标题

 @param preferLarge 是否开启
 */
- (void) setPrefersLargeTitles:(BOOL)preferLarge;


/**
 获取主题标题是否开大导航

 @return 是否开启
 */
- (BOOL) getPrefersLargeTitles;


/**
 设置字体大小系数
 
 @param coefficient 系数
 */
- (void)setFontSizeCoefficient:(NSInteger )coefficient;

/**
 获取字体系数
 
 @return 返回字体系数
 */
- (NSInteger)getFontSizeCoefficient;

/**
 获取字体缩放比
 
 @return 返回字体缩放比
 */
- (float )getScaleCoefficient;



/**
 设置是否开启签到提醒

 @param isOn 是否开启
 */
- (void)setNotiAt10:(BOOL)isOn;


/**
 获取是否开启签到提醒

 @return 是否开启
 */
- (BOOL)getNotiAt10;


- (void)setNotiAtPosition:(BOOL )isOn;

- (BOOL)getNotiAtPosition;




@end
