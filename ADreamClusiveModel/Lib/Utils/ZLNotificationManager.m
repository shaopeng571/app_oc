//
//  ZLNotificationManager.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/27.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import "ZLNotificationManager.h"

#import <UserNotifications/UserNotifications.h>



@implementation ZLNotificationManager

+(id)sharedInstance
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[[self class] alloc] init];
    });
    return obj;
}
- (id)init{
    if (self = [super init]) {
        [self addNotificationAction];
        [self addNotificationAction2];
    }
    return self;
}

- (void)addNotificationAction {
    /*
     UNNotificationActionOptionAuthenticationRequired = (1 << 0),
     UNNotificationActionOptionDestructive = (1 << 1), 取消
     UNNotificationActionOptionForeground = (1 << 2), 启动程序
     */
    UNTextInputNotificationAction *textAction = [UNTextInputNotificationAction actionWithIdentifier:@"my_text" title:@"text_action" options:UNNotificationActionOptionForeground textInputButtonTitle:@"输入" textInputPlaceholder:@"默认文字"];
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"my_action" title:@"action" options:UNNotificationActionOptionDestructive];
    UNNotificationAction *action_1 = [UNNotificationAction actionWithIdentifier:@"my_action_1" title:@"action_1" options:UNNotificationActionOptionAuthenticationRequired];
    /*
     UNNotificationCategoryOptionNone = (0),
     UNNotificationCategoryOptionCustomDismissAction = (1 << 0),
     UNNotificationCategoryOptionAllowInCarPlay = (2 << 0),
     */
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"Jiao.X.time" actions:@[textAction,action,action_1] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    NSSet *setting = [NSSet setWithObjects:category, nil];
//    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:setting];
}
- (void)addNotificationAction2{
    // 创建 UNTextInputNotificationAction 比 UNNotificationAction 多了两个参数
    // * buttonTitle 输入框右边的按钮标题
    // * placeholder 输入框占位符
    UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"action.input" title:@"输入" options:UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"tell me loudly"];
    // 注册 category
    UNNotificationCategory *notificationCategory = [UNNotificationCategory categoryWithIdentifier:@"Jiao.X.time2" actions:@[inputAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:[NSSet setWithObject:notificationCategory]];
    
    
}
    
    
    
#pragma mark - iOS10

- (void)createNotificationType:(ZLNotificationTriggerType)triggertype {
    
    // 创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"时间提醒 - title";
    content.subtitle = [NSString stringWithFormat:@"装逼大会竞选时间提醒 - subtitle"];
    content.body = @"装逼大会总决赛时间到，欢迎你参加总决赛！希望你一统X界 - body";
    content.badge = @666;
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"key1":@"value1",@"key2":@"value2"};
    content.categoryIdentifier = @"Jiao.X.time2";
    
    // 通知附加内容
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"image_1" withExtension:@"jpeg"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"launchimg" withExtension:@"png"];
    UNNotificationAttachment *attch = [UNNotificationAttachment attachmentWithIdentifier:@"photo" URL:url options:nil error:nil];
    content.attachments = @[attch];
    
    // 创建通知标示
    NSString *requestIdentifier = @"Jiao.X.location";
    
    
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request;
    if (triggertype==ZLNotificationTriggerLocation) {
//        [self geocodeOf:@"北京市朝阳区迪阳大厦"];
        
        CLLocation *loc = [[LocationManager sharedInstance] getLatestLocation];
        CLLocationCoordinate2D center1 = CLLocationCoordinate2DMake(39.960102999999997, 116.460385);
        center1 = loc.coordinate;
        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center1 radius:500 identifier:@"经海五路"];
        region.notifyOnEntry = YES;
        region.notifyOnExit = YES;
        // region 位置信息 repeats 是否重复 （CLRegion 可以是地理位置信息）
        UNLocationNotificationTrigger *locationTrigger = [UNLocationNotificationTrigger triggerWithRegion:region repeats:YES];
        
        // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
        request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:locationTrigger];
    }
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 将通知请求 add 到 UNUserNotificationCenter
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"推送已添加成功 %@", requestIdentifier);
            //你自己的需求例如下面：
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            //此处省略一万行需求。。。。
        }
    }];
}



// 定时推送
- (void)createLocalizedUserNotification {
    
    // 设置触发条件 UNNotificationTrigger 至少60秒重复
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:60.0f repeats:YES];
    
    // 创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"时间提醒 - title";
    content.subtitle = [NSString stringWithFormat:@"装逼大会竞选时间提醒 - subtitle"];
    content.body = @"装逼大会总决赛时间到，欢迎你参加总决赛！希望你一统X界 - body";
    content.badge = @666;
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"key1":@"value1",@"key2":@"value2"};
    content.categoryIdentifier = @"Jiao.X.time2";
    
    // 通知附加内容
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"image_1" withExtension:@"jpeg"];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"launchimg" withExtension:@"png"];
    UNNotificationAttachment *attch = [UNNotificationAttachment attachmentWithIdentifier:@"photo" URL:url options:nil error:nil];
    content.attachments = @[attch];
    
    // 创建通知标示
    NSString *requestIdentifier = @"Jiao.X.time";
    
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:timeTrigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 将通知请求 add 到 UNUserNotificationCenter
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"推送已添加成功 %@", requestIdentifier);
            //你自己的需求例如下面：
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"本地通知" message:@"成功添加推送" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            //此处省略一万行需求。。。。
        }
    }];
    
}

#pragma mark - iOS10之前

- (void)pushLocalNotification {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"新的一天开始啦!快来%@签到吧!", kAPP_DISPLAY_NAME];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3]; // 设置通知的响应时间: 3秒钟后
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    // 锁屏时在推送消息的最下方显示设置的提示字符串
    localNotification.alertAction = @"签到啦";
    // 传递参数
    localNotification.userInfo = @{@"body": [NSString stringWithFormat:@"%@:签到啦", @"Jiaozl"]};
    //重复间隔：类似于定时器，每隔一段时间就发送通知
    localNotification.repeatInterval = NSCalendarUnitMinute;
    
    //--------------------可选属性------------------------------
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2) {
        localNotification.alertTitle = [NSString stringWithFormat:@"尊敬的%@：", kAPP_DISPLAY_NAME]; // iOS8.2
    }
    // 当点击推送通知消息时，首先显示启动图片，然后再打开App, 默认是直接打开App的
    localNotification.alertLaunchImage = @"LaunchImage.png";
    // 默认是没有任何声音的 UILocalNotificationDefaultSoundName：声音类似于震动的声音
    localNotification.soundName = @"8378";
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    localNotification.category = @"Jiao.X.time"; // 附加操作
    
    // 定时发送
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
//    NSInteger applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:applicationIconBadgeNumber];
    
    // 立即发送
    //    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

#pragma mark=============开启本地推送=======
-(void)openLocalNotification {
    [self createLocalizedUserNotification];
    return;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //获取当前时间
    NSDate *nowDate = [NSDate date];
    NSString *dateStr = [dateFormatter stringFromDate:nowDate];
    //获取今天10：00
    NSString * str_today_date10_00 = [NSString stringWithFormat:@"%@ 10:00:00",[dateStr substringToIndex:10]];
    NSDate * today_date10_00 = [dateFormatter dateFromString:str_today_date10_00];
    //获取明天10：00
    NSString *str_tomorrow_date10_00 =[NSString stringWithFormat:@"%@ 10:00:00",[[NSDate GetTomorrowDay:nowDate] substringToIndex:10]];
    NSDate * tomorrow_date10_00 = [dateFormatter dateFromString:str_tomorrow_date10_00];
    long sec;
    if([NSDate compareDate:dateStr withDate:str_today_date10_00]==1){
        // 还没到今天10:00
        sec =[NSDate getSubSecFromData:nowDate ToData:today_date10_00];
    }else{
        sec =[NSDate getSubSecFromData:nowDate ToData:tomorrow_date10_00];
    }
    
    
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:sec];
    notification.alertBody = @"新的一天开始啦!快来XX签到吧!";
    notification.alertAction = @"签到啦";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.userInfo = @{ @"body":@"XX:签到啦" };
    notification.repeatInterval = kCFCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


#pragma mark=============关闭本地推送==================
- (void)closeLocalNotification:(ZLNotificationTriggerType)type {
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    switch (type) {
        case ZLNotificationTriggerInterval:
            [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[@"Jiao.X.time"]];
            break;
        case ZLNotificationTriggerLocation:
            [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[@"Jiao.X.location"]];
            break;
        default:
            break;
    }
    
    // 获取队列和已失效队列通知请求
    [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        
    }];
    
    [[UNUserNotificationCenter currentNotificationCenter] getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        
    }];
    
}





@end
