//
//  ColorManager.m
//  ADreamClusive
//
//  Created by ADreamClusive on 17/1/14.
//  Copyright © 2017年 ADreamClusive. All rights reserved.
//

#import "ZLAppManager.h"

NSString *const ThemeColorChangeNotification = @"kThemeColorChangeNotification";
NSString *const ThemeFontChangeNotifocation = @"kThemeFontChangeNotifocation";
NSString *const ThemeLargeTitleChangeNotifocation = @"kThemeLargeTitleChangeNotifocation";

static NSString *const THEME_COLOR_KEY = @"ThemeColor";
static NSString *const THEME_FONT_COEFFICIENT_KEY = @"SizeFontCoefficient";
static NSString *const THEME_PREFERLARGETITLE_KEY = @"preferLarge";

static NSString *const THEME_NOTIAT10_KEY = @"NOTIAT10Oclock";
static NSString *const THEME_NOTIATPOSITION_KEY = @"NOTIATPosition";


@implementation ZLAppManager
+(id)sharedInstance
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[ZLAppManager alloc] init];
    });
    return obj;
}
- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}


- (void)setThemeColor:(UIColor *)color {
    // 将颜色存入本地
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color];
    [kUSERDEFAULTS setObject:data forKey:THEME_COLOR_KEY];
}

- (UIColor *)getThemeColor {
//    [UserDefaults removeObjectForKey:@"ThemeColor"];
    id colorData = [kUSERDEFAULTS objectForKey:THEME_COLOR_KEY];
    if (colorData) {
        UIColor *color;
        @try {
            color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        } @catch (NSException *exception) {
            color = kDefaultThemeColor;
        }
        return color;
    }
    return kDefaultThemeColor;
}

- (void) setPrefersLargeTitles:(BOOL)preferLarge{
    [kUSERDEFAULTS setBool:preferLarge forKey:THEME_PREFERLARGETITLE_KEY];
}

- (BOOL) getPrefersLargeTitles {
    BOOL udata = [kUSERDEFAULTS boolForKey:THEME_PREFERLARGETITLE_KEY];
    if (!udata) {
        return NO;
    }
    return udata;
}



- (void)setFontSizeCoefficient:(NSInteger )coefficient{
    [kUSERDEFAULTS setInteger:coefficient forKey:THEME_FONT_COEFFICIENT_KEY];
}

- (NSInteger)getFontSizeCoefficient {
    
    NSInteger coefficient = [kUSERDEFAULTS integerForKey:THEME_FONT_COEFFICIENT_KEY];
    if (coefficient==0) {//返回默认2
        return 2;
    }
    return  coefficient;
}

- (float )getScaleCoefficient {
    //读取比例系数 (0.925~1.30)
    NSInteger coefficient = [self getFontSizeCoefficient]; 
    return 0.075*(coefficient-2)+1;
}


- (void)setNotiAt10:(BOOL )isOn{
    [kUSERDEFAULTS setBool:isOn forKey:THEME_NOTIAT10_KEY];
    
    if (isOn) {
        [[ZLNotificationManager sharedInstance] openLocalNotification];
    } else {
        [[ZLNotificationManager sharedInstance] closeLocalNotification:ZLNotificationTriggerInterval];
    }
}

- (BOOL)getNotiAt10 {
    BOOL ison = [kUSERDEFAULTS boolForKey:THEME_NOTIAT10_KEY];

    return ison;
}


- (void)setNotiAtPosition:(BOOL )isOn{
    [kUSERDEFAULTS setBool:isOn forKey:THEME_NOTIATPOSITION_KEY];
    
    if (isOn) {
        [[ZLNotificationManager sharedInstance] createNotificationType:ZLNotificationTriggerLocation];
    } else {
        [[ZLNotificationManager sharedInstance] closeLocalNotification:ZLNotificationTriggerLocation];
    }
}

- (BOOL)getNotiAtPosition {
    BOOL ison = [kUSERDEFAULTS boolForKey:THEME_NOTIATPOSITION_KEY];
    
    return ison;
}

















// 颜色 字符串转16进制
-(UIColor*)toUIColorByStr:(NSString*)colorStr{
    
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

// 颜色 转字符串（16进制）
-(NSString*)toStrByUIColor:(UIColor*)color{
    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    return [NSString stringWithFormat:@"%06x", rgb];
}

@end
