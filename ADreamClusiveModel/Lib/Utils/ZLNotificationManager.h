//
//  ZLNotificationManager.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/27.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZLNotificationTriggerInterval,
    ZLNotificationTriggerLocation,
} ZLNotificationTriggerType;

@interface ZLNotificationManager : NSObject


+ (id)sharedInstance;

- (void)openLocalNotification;

- (void)closeLocalNotification:(ZLNotificationTriggerType)type;

- (void)createNotificationType:(ZLNotificationTriggerType)triggertype;

@end

NS_ASSUME_NONNULL_END
