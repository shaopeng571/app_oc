//
//  AppDelegate+UMApiService.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/19.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import "AppDelegate+UMApiService.h"

#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 统计组件
#import <UMShare/UMShare.h>    // 分享组件
#import <UMPush/UMessage.h>             // Push组件
#import <UserNotifications/UserNotifications.h>  // Push组件必须的系统库
/* 开发者可根据功能需要引入相应组件头文件，并导入相应组件库*/


static NSString *const UM_APPKEY = @"5bf2695af1f556bae400024a";

static NSString *const WEIXIN_APPKEY = @"wx2520e3b1d7f61085";
static NSString *const WEIXIN_APPSECRET = @"0948b49fecdac591feefc2729bd5e153";

static NSString *const QQ_APPKEY = @"1107981296"; // 腾讯开放平台 APP ID

static NSString *const SINAWEIBO_APPKEY = @"1743243388";
static NSString *const SINAWEIBO_APPSECRET = @"d0f203e87f971f2da5581e7192e2b9a9";

static NSString *const REDIRECT_URL = @"http://www.baidu.com";

@interface AppDelegate () <UNUserNotificationCenterDelegate>



@end


@implementation AppDelegate (UMApiService)

- (void)initWithUMAPIServiceWithOptions:(NSDictionary *)launchOptions {
    
    // 配置友盟SDK产品并并统一初始化
    [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO.
    [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
    [UMConfigure initWithAppkey:UM_APPKEY channel:@"App Store"];
    /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
    
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    // [MobClick setScenarioType:E_UM_GAME];  // optional: 游戏场景设置
    
    // Push组件基本功能配置
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    } else {
        // Fallback on earlier versions
    }
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标等
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert|UMessageAuthorizationOptionSound;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 用户选择了接收Push消息
            NSLog("===granted=YES===");
        }else{
            // 用户拒绝接收Push消息
            NSLog("===granted==NO==");
        }
    }];
    
    [self replyPushNotificationAuthorization:[UIApplication sharedApplication]];
    [ZLNotificationManager sharedInstance];
    
    // 请参考「Share详细介绍-初始化第三方平台」
    // 分享组件配置，因为share模块配置可选三方平台较多，代码基本跟原版一样，也可下载demo查看
    [self configUSharePlatforms];   // required: setting platforms on demand
    [self confitUShareSettings];
}





- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WEIXIN_APPKEY appSecret:WEIXIN_APPSECRET redirectURL:REDIRECT_URL];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:WEIXIN_APPKEY appSecret:WEIXIN_APPSECRET redirectURL:REDIRECT_URL];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatFavorite appKey:WEIXIN_APPKEY appSecret:WEIXIN_APPSECRET redirectURL:REDIRECT_URL];
    /*
     * 移除相应平台的分享，如微信收藏
     */
//    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APPKEY/*设置QQ平台的appID*/  appSecret:nil redirectURL:REDIRECT_URL];

    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SINAWEIBO_APPKEY appSecret:SINAWEIBO_APPSECRET redirectURL:REDIRECT_URL];
    //
    //        /* 钉钉的appKey */
    //        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DingDing appKey:@"dingoalmlnohc0wggfedpk" appSecret:nil redirectURL:nil];
    //
    //        /* 支付宝的appKey */
    //        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //
    //
    //        /* 设置易信的appKey */
    //        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_YixinSession appKey:@"yx35664bdff4db42c2b7be1e29390c1a06" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //
    //        /* 设置点点虫（原来往）的appKey和appSecret */
    //        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_LaiWangSession appKey:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" redirectURL:@"http://mobile.umeng.com/social"];
    //
    //        /* 设置领英的appKey和appSecret */
    //        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Linkedin appKey:@"81t5eiem37d2sc"  appSecret:@"7dgUXPLH8kA8WHMV" redirectURL:@"https://api.linkedin.com/v1/people"];
    //
    //        /* 设置Twitter的appKey和appSecret */
    //        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:@"fB5tvRpna1CKK97xZUslbxiet"  appSecret:@"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K" redirectURL:nil];
    //
    //        /* 设置Facebook的appKey和UrlString */
    //        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:@"506027402887373"  appSecret:nil redirectURL:@"http://www.umeng.com/social"];
    //
    //        /* 设置Pinterest的appKey */
    //        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Pinterest appKey:@"4864546872699668063"  appSecret:nil redirectURL:nil];
    //
    //        /* dropbox的appKey */
    //        [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_DropBox appKey:@"k4pn9gdwygpy4av" appSecret:@"td28zkbyb9p49xu" redirectURL:@"https://mobile.umeng.com/social"];
    //
    //        /* vk的appkey */
    //        [[UMSocialManager defaultManager]  setPlaform:UMSocialPlatformType_VKontakte appKey:@"5786123" appSecret:nil redirectURL:nil];
    
}

    
// 支持所有iOS系统

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}



//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//    {
//        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//        if (!result) {
//            // 其他如支付等SDK的回调
//        }
//        return result;
//    }
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}

//获取测试的token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog("===didRegisterForRemoteNotificationsWithDeviceToken===");
    
    NSLog(@"TOKEN：%@",[[[[deviceToken description ] stringByReplacingOccurrencesOfString: @"<" withString:@"" ]
                  
                  stringByReplacingOccurrencesOfString: @">" withString:@""]
                 
                 stringByReplacingOccurrencesOfString:@" " withString:@" "
                 
                 ]);
    
    
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
//    [UMessage registerDeviceToken:deviceToken];
    
    //NSLog(@"locError:%s};", NSUserDefaults.kUMessageUserDefaultKeyForParams);
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSDictionary *)userInfo {
    

}

#pragma mark - 收到通知iOS10以前兼容处理
// 收到友盟的消息推送
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog("===didReceiveRemoteNotification===");
    // 注意：当应用处在前台的时候，是不会弹出通知的，这个时候就需要自己进行处理弹出一个通知的UI
    
    if (application.applicationState == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"] message:[[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"]
                              
                                                       delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        return;
    } else if (application.applicationState == UIApplicationStateInactive){ //如果是在后台挂起，用户点击进入是UIApplicationStateInactive这个状态
        
        //......
        
    }
    
    // 这个是友盟自带的前台弹出框
    [UMessage setAutoAlert:NO];
    
    //    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
    //
    //        [UMessage didReceiveRemoteNotification:userInfo];
    //
    //
    //
    //        completionHandler(UIBackgroundFetchResultNewData);
    //
    //    }
    
    [UMessage didReceiveRemoteNotification:userInfo];
}


#pragma mark - 申请通知权限
// 申请通知权限
- (void)replyPushNotificationAuthorization:(UIApplication *)application{
    
    if (kCURRENT_SYSTEM_VERSION.floatValue >= 10.0) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册成功");
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        // 之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }else if (kCURRENT_SYSTEM_VERSION.floatValue >= 8.0){
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        //iOS 8.0系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
}

#pragma mark - iOS10新增处理通知事件

/*
 * iOS10新增：处理前台收到通知的代理方法
 * 只会是app处于前台状态 前台状态 and 前台状态下才会走，后台模式下是不会走这里的
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
   
    NSLog("===willPresentNotification1===");
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) { //应用处于前台时的远程推送接受

        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        
    }else{ //应用处于前台时的本地推送接受
        
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
        
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionAlert);
}

/**
 iOS10新增：处理后台点击通知的代理方法
 只会是用户点击消息才会触发，如果使用户长按（3DTouch）、弹出Action页面等并不会触发。
 点击Action的时候会触发！
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    

    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) { //应用处于后台时的远程推送接受
        
#ifdef UM_Swift
        [UMessageSwiftInterface didReceiveRemoteNotificationWithUserInfo:userInfo];
#else
        //必须加这句代码
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        //此处省略一万行需求代码。。。。。。
        [UMessage didReceiveRemoteNotification:userInfo];
#endif
        
    } else { //应用处于后台时的本地推送接受
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
        
    }
    //2016-09-27 14:42:16.353978 UserNotificationsDemo[1765:800117] Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler(); // 系统要求执行这个方法
}

    
@end
