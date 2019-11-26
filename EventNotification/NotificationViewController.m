//
//  NotificationViewController.m
//  EventNotification
//
//  Created by ADreamClusive 2018 on 2018/11/27.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *aclabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    
    CGSize viewsize = self.view.bounds.size;
    
    self.preferredContentSize = CGSizeMake(viewsize.width, 100);

}

- (void)didReceiveNotification:(UNNotification *)notification {
    
    
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
    
    self.aclabel.text = body;
    self.label.text = title;
    
    
//    self.imgView.image = [UIImage imageNamed:@"launchimg"];

    if (content.attachments.firstObject.URL.startAccessingSecurityScopedResource) {
        self.imgView.image = [UIImage imageWithContentsOfFile:content.attachments.firstObject.URL.path];
    }
//    这句暂时不能加，加了就加载不了图片了
//    [content.attachments.firstObject.URL stopAccessingSecurityScopedResource];
}

@end
