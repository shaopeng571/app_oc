//
//  ZLCrashHandler.m
//
//  Created by Jiaozl on 2016/11/2.
//  Copyright © 2016年 Jiaozl. All rights reserved.
//

#import "ZLCrashHandler.h"
#import "ZLUncaughtExceptionModel.h"

@implementation ZLCrashHandler

+ (void)uploadCrashLog {
    
    [ZLCrashHandler uploadCrashLogAtPath:ZLUncaughtExceptionFilePath];
    [ZLCrashHandler uploadCrashLogAtPath:ZLSignalExceptionFilePath];
}

+ (void)uploadCrashLogAtPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", path, ZLExceptionFileName]];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (str) {
        
        // 00 打印崩溃日志（debug 时可以用）
        NSLog(@"str --- %@", str);
        
        // 01 存在崩溃日志则上传到服务器（常用做法，方便发布状态下的崩溃信息收集）
        // 这里写你服务器的上传接口
        
        [fileManager removeItemAtPath:filePath error:nil]; // 上传成功后记得删除沙盒中保存的上一次的崩溃日志信息（这句话写在上传接口回调里面）
        
        
        // 02 存在崩溃日志发送到邮箱
        //        NSString *mailUrl = [NSString stringWithFormat:@"mailto:CoderZYWang@yeah.net?subject=程序异常崩溃,请配合处理。&body=%@", str];
        // 打开地址
        //        NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
        
    }
}

+ (void)uploadCrashLog2 {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"Exception.txt"];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (str) {
        
        // 00 打印崩溃日志（debug 时可以用）
        NSLog(@"str --- %@", str);
        
        // 01 存在崩溃日志则上传到服务器（常用做法，方便发布状态下的崩溃信息收集）
        // 这里写你服务器的上传接口

        [fileManager removeItemAtPath:filePath error:nil]; // 上传成功后记得删除沙盒中保存的上一次的崩溃日志信息（这句话写在上传接口回调里面）
        
        
        // 02 存在崩溃日志发送到邮箱
//        NSString *mailUrl = [NSString stringWithFormat:@"mailto:CoderZYWang@yeah.net?subject=程序异常崩溃,请配合处理。&body=%@", str];
        // 打开地址
//        NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
        
    }
}



//{
//    // 发送崩溃日志
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *dataPath = [path stringByAppendingPathComponent:@"error.log"];
//    NSData *data = [NSData dataWithContentsOfFile:dataPath];
//    if (data != nil) {
//        [self sendExceptionLogWithData:data path:path];
//    }
//
//}


//#pragma mark -- 发送崩溃文件
//- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path {
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 5.0f;
//    //告诉AFN，支持接受 text/xml 的数据
//    [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    NSString *urlString = @"http://192.168.1.156/xxxx";
//
//    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:data name:@"file" fileName:@"Exception.txt" mimeType:@"txt"];
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        // 删除文件
//        NSFileManager *fileManger = [NSFileManager defaultManager];
//        [fileManger removeItemAtPath:path error:nil];
//
//    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
//
//
//    }];
//}
//#pragma mark - 通过post 或者 get 方式来将异常信息发送到服务器
//- (void)sendCrashLog:(NSString *)crashLog {
//    dispatch_semaphore_t semophore = dispatch_semaphore_create(0);
//    // 创建信号量
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:nil];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.156/xxxx"]];
//    [request setHTTPMethod:@"POST"];
//    request.HTTPBody = [[NSString stringWithFormat:@"crash=%@",crashLog] dataUsingEncoding:NSUTF8StringEncoding];
//    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"response%@",response);
//        dispatch_semaphore_signal(semophore);
//        // 发送信号
//
//    }] resume];
//    dispatch_semaphore_wait(semophore, DISPATCH_TIME_FOREVER); // 等待
//}

@end




