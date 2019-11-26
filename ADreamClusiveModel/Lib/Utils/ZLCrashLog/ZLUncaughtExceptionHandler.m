//
//  ZLUncaughtExceptionHandler.m
//  UncaughtExceptionDemo
//
//  Created by ADreamClusive 2018 on 2018/10/19.
//  Copyright © 2018年  ADreamClusive. All rights reserved.
//

#import "ZLUncaughtExceptionHandler.h"
#import "ZLDeviceUtils.h"
#import "ZLUncaughtExceptionModel.h"
#import <UIKit/UIKit.h>

@implementation ZLUncaughtExceptionHandler

static BOOL dismissed;
- (void)raiseException {
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"程序出现问题啦" message:@"崩溃信息" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alertView show];
    alertView = nil;
    
    //当接收到异常处理消息时，让程序开始runloop，防止程序死亡
    while (!dismissed) {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    //当点击弹出视图的Cancel按钮哦,isDimissed ＝ YES,上边的循环跳出
    CFRelease(allModes);
    
    // 保存完异常信息后杀死应用程序或抛出异常
    //    NSDictionary *userInfo=[exception userInfo];
    //    [self saveCreash:exception file:[userInfo objectForKey:UncaughtExceptionHandlerFileKey]];
    //
    //    NSSetUncaughtExceptionHandler(NULL);
    //    signal(SIGABRT, SIG_DFL);
    //    signal(SIGILL, SIG_DFL);
    //    signal(SIGSEGV, SIG_DFL);
    //    signal(SIGFPE, SIG_DFL);
    //    signal(SIGBUS, SIG_DFL);
    //    signal(SIGPIPE, SIG_DFL);
    //    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
    //    {
    //        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    //    }
    //    else
    //    {
    //        [exception raise];
    //    }
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    //因为这个弹出视图只有一个Cancel按钮，所以直接进行修改isDimsmissed这个变量了
    dismissed = YES;
}


+ (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - 保存异常信息到文件
+ (void)saveCrash:(NSString *)exceptionInfo toFile:(NSString *)fileName atPath:(NSString *)path {
    
    // 当AppDelegate中发生崩溃时，程序log不能正常记录
//    [[[ZLUncaughtExceptionHandler alloc] init] raiseException];
    
    NSString * _libPath  = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:path];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_libPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * savePath = [_libPath stringByAppendingFormat:@"/%@",fileName];
    
    BOOL success = [[ZLUncaughtExceptionHandler demonstrateExceptionInfo:exceptionInfo withPath:savePath] writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"YES sucess:%d",success);
}

+ (NSString *)demonstrateExceptionInfo:(NSString *)exceptionInfo withPath:(NSString *)path {
    
    NSMutableString *baseMessage = [NSMutableString stringWithFormat:@"\n - UUID:   %@\n - OS Version:   %@\n - Hardware Model :   %@\n - App Version:   %@", IDENTIFIER_NUMBER, PHONE_VERSION, PHONE_TYPE, APP_VERSION]; // 设备基本的一些信息
    
    [baseMessage appendString:[NSString stringWithFormat:@"\n - PATH:   %@", path]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSSS xxxx"];

    //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    [baseMessage appendString:[NSString stringWithFormat:@"\n - Date/Time:   %@", dateStr]];
    
    [baseMessage appendString:@"\n\n"];
    
    return [NSString stringWithFormat:@"%@\n%@", baseMessage, exceptionInfo];
}


//+ (void)saveCrash:(NSString *)exceptionInfo {
//    
//    NSString * _libPath  = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"OCCrash"];
//    if (![[NSFileManager defaultManager] fileExistsAtPath:_libPath]){
//        [[NSFileManager defaultManager] createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970];
//    NSString *timeString = [NSString stringWithFormat:@"%f", a];
//    
//    NSString * savePath = [_libPath stringByAppendingFormat:@"/error%@.log",timeString];
//    
//    BOOL sucess = [exceptionInfo writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    
//    NSLog(@"YES sucess:%d",sucess);
//}

#pragma mark - 设置默认异常处理方法

+ (void)setDefaultHandler
{
    InstallUncaughtExceptionHandler();
    InstallSignalHandler();
}

#pragma mark UnException
void HandleException(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    
    NSLog(@"%@", exceptionInfo);
    
    [ZLUncaughtExceptionHandler saveCrash:exceptionInfo toFile:ZLExceptionFileName atPath:ZLUncaughtExceptionFilePath];
}


void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
}

#pragma mark SignalException

void SignalExceptionHandler(int signal)
{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:[NSString stringWithFormat:@"Exception reason: signalException \nException name: exception with signal %d\n", signal]];
    [mstr appendString:@"Exception stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    
    [ZLUncaughtExceptionHandler saveCrash:mstr toFile:ZLExceptionFileName atPath:ZLSignalExceptionFilePath];
}

void InstallSignalHandler(void)
{
    signal(SIGHUP, SignalExceptionHandler);
    signal(SIGINT, SignalExceptionHandler);
    signal(SIGQUIT, SignalExceptionHandler);
    
    //注册程序由于abort()函数调用发生的程序中止信号
    signal(SIGABRT, SignalExceptionHandler);
    //注册程序由于非法指令产生的程序中止信号
    signal(SIGILL, SignalExceptionHandler);
    //注册程序由于无效内存的引用导致的程序中止信号
    signal(SIGSEGV, SignalExceptionHandler);
    //注册程序由于浮点数异常导致的程序中止信号
    signal(SIGFPE, SignalExceptionHandler);
    //注册程序由于内存地址未对齐导致的程序中止信号
    signal(SIGBUS, SignalExceptionHandler);
    //程序通过端口发送消息失败导致的程序中止信号
    signal(SIGPIPE, SignalExceptionHandler);
}


@end
