//
//  NotificationService.m
//  ZLNotiService
//
//  Created by ADreamClusive 2018 on 2018/11/28.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import "NotificationService.h"
#import <UIKit/UIKit.h>
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    NSString * attchUrl = [self.bestAttemptContent.userInfo[@"aps"][@"image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    NSString * attchUrl = [self.bestAttemptContent.userInfo[@"attachments"][0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //下载图片,放到本地
    UIImage * imageFromUrl = [self getImageFromURL:attchUrl];
    
    //获取documents目录
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectoryPath = [paths firstObject];
    
    NSString * localPath = [self saveImage:imageFromUrl withFileName:@"MyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    if (localPath && ![localPath isEqualToString:@""]) {
        UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:@"photo" URL:[NSURL fileURLWithPath:localPath] options:nil error:nil];
        if (attachment) {
            self.bestAttemptContent.attachments = @[attachment];
        }
    }
    self.contentHandler(self.bestAttemptContent);
    
    
//    //1. 下载
//    NSString *urlString = [self.bestAttemptContent.userInfo[@"attachments"][0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (!error) {
//
//            //2. 保存数据
//            NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject
//                              stringByAppendingPathComponent:@"image.jpg"];
//            UIImage *image = [UIImage imageWithData:data];
//            NSError *err = nil;
//            BOOL result = [UIImageJPEGRepresentation(image, 1) writeToFile:path options:NSAtomicWrite error:&err];
//
//            //3. 添加附件
//            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"remote-atta1" URL:[NSURL fileURLWithPath:path] options:nil error:&err];
//            if (attachment) {
//                self.bestAttemptContent.attachments = @[attachment];
//            }
//        }
//
//        //4. 返回新的通知内容
//        self.contentHandler(self.bestAttemptContent);
//    }];
//
//    [task resume];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}







- (UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    //dataWithContentsOfURL方法需要https连接
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

//将所下载的图片保存到本地
- (NSString *) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    NSString *urlStr = @"";
    if ([[extension lowercaseString] isEqualToString:@"png"]){
        urlStr = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]];
        [UIImagePNGRepresentation(image) writeToFile:urlStr options:NSAtomicWrite error:nil];
        
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] ||
               [[extension lowercaseString] isEqualToString:@"jpeg"]){
        urlStr = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]];
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:urlStr options:NSAtomicWrite error:nil];
        
    } else{
        NSLog(@"extension error");
    }
    return urlStr;
}



@end
