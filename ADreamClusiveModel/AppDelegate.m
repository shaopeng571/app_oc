//
//  AppDelegate.m
//  ADreamClusiveModel
//
//  Created by Jiaozl 2018 on 2018/10/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+UMApiService.h"
#import <Bugly/Bugly.h>

#import "ZLUncaughtExceptionHandler.h"
#import "ZLCrashHandler.h"
#import "ZLTabBarController.h"

#define mApplication        [UIApplication sharedApplication]
#define mNotificationCenter [NSNotificationCenter defaultCenter]

@interface AppDelegate () <BuglyDelegate, CLLocationManagerDelegate>

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer       *pollTimer;
@property (nonatomic, assign) NSInteger     pollCountTimer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LocationManager sharedInstance];
    
    [self setIQKeyBoardManager];
    
    //    [[UINavigationBar appearance] setBarTintColor:kRGB(37*0.5, 23*0.5, 21*0.5)];
    
    self.window= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[ZLTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    [ZLFMDBHelper sharedFMDBHelper];
    
    [[ZLFMDBHelper sharedFMDBHelper] createProductsTableWithItem:[ProductItem class]];
    
    
    // 初始化UM相关服务
    [self initWithUMAPIServiceWithOptions:launchOptions];
    
    //    [self p_configureForBugly];
    
    [self redirectNSLogToDocumentFolder];
    
    // 可能会和其他第三方框架中崩溃日志收集冲突
    [ZLUncaughtExceptionHandler setDefaultHandler];
    
    [ZLCrashHandler uploadCrashLog];
    
    //    @throw [NSException exceptionWithName:@"newException" reason:@"主动抛出异常" userInfo:@{}];
    [mNotificationCenter addObserver:self selector:@selector(handleBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [mNotificationCenter addObserver:self selector:@selector(handleEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    return YES;
}

- (void)handleBecomeActive:(NSNotification *)notification {
    
    //    [mApplication endBackgroundTask:self.backgroundTaskIdentifier];
    //    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
}

- (void)handleEnterBackground:(NSNotification *)notification {
    
    self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void) {
        [mApplication endBackgroundTask:self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    NSLog(@"remaining back ground time %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
    [self startPoll];
}

- (void)startPoll {
    
    [self stopPoll];
    
    _pollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollAction:) userInfo:nil repeats:YES];
}

- (void)stopPoll {
    
    if (_pollTimer && [_pollTimer isValid]) {
        [_pollTimer invalidate];
        _pollTimer = nil;
    }
    self.pollCountTimer = 0;
}

- (void)pollAction:(NSTimer *)timer {
    
    self.pollCountTimer += 1;
    NSLog(@"后台任务进行中......%ld", self.pollCountTimer);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
}

#pragma mark - Private
- (void)p_configureForBugly {
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.channel = @"App Store";
    config.blockMonitorEnable = YES;
    // 卡顿监控开关，默认关闭
    config.blockMonitorTimeout = 5;
    config.unexpectedTerminatingDetectionEnable = YES;
    // 非正常退出事件记录开关，默认关闭
    config.delegate = self;
#ifdef DEBUG
    config.debugMode = YES; // debug 模式下，开启调试模式
    config.reportLogLevel = BuglyLogLevelVerbose; // 设置打印日志级别
#else
    config.debugMode = NO; // release 模式下，关闭调试模式
    config.reportLogLevel = BuglyLogLevelWarn; // 设置自定义日志上报的级别，默认不上报自定义日志
#endif
    [Bugly startWithAppId:@"a9893a6902" config:config];
}



#pragma mark - Bugly代理 - 捕获异常,回调(@return 返回需上报记录，随 异常上报一起上报)
//- (NSString *)attachmentForException:(NSException *)exception {
//
//    NSLog(@"ni");
////#ifdef DEBUG
//    // 调试
//    return [NSString stringWithFormat:@"我是携带信息:%@",[self redirectNSLogToDocumentFolder]];
////#endif
////    return nil;
//}

#pragma mark - 保存日志文件
- (NSString *)redirectNSLogToDocumentFolder {
    //如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return nil;
    }
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){
        //在模拟器不保存到文件中
        return nil;
    }
    //获取Document目录下的Log文件夹，若没有则新建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",dateStr];
    // freopen 重定向输出输出流，将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    return [[NSString alloc] initWithContentsOfFile:logFilePath encoding:NSUTF8StringEncoding error:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setIQKeyBoardManager {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    //  工具条 下一个/上一个 完成
    manager.enableAutoToolbar = YES;
    manager.shouldResignOnTouchOutside = YES;
}

@end
