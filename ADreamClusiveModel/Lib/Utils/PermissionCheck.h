//
//  PermissionCheck.h
//  SeerEnglish
//
//  Created by ADreamClusive 2018 on 2018/4/5.
//  Copyright © 2018年 SeerEducation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionCheck : NSObject


/**
 检查是否允许联网
 */
+ (void)openEventServiceWithBolck:(void(^)(BOOL shouldOn))returnBolck;
/**
 通知权限
 */
+(void)checkNotificationAuthorizationGrand:(void (^)(void))permissionGranted
                          withNoPermission:(void (^)(void))noPermission;
/**
 通讯录权限
 */
+(void)checkAddressBookAuthorizationGrand:(void(^)(void))permissionGranted
                         withNoPermission:(void (^)(void))noPermission;

/**定位权限*/
+ (void)checkLocationServiceAuthorization:(void(^)(BOOL authorizationAllow, CLAuthorizationStatus status))checkFinishBack;

/**麦克风权限*/
+ (void)checkAudioAuthorizationGrand:(void (^)(void))permissionGranted
                    withNoPermission:(void (^)(void))noPermission;

/**相册权限*/
+ (void)checkPhotoAlbumAuthorizationGrand:(void (^)(void))permissionGranted
                         withNoPermission:(void (^)(void))noPermission;

/**相机权限*/
+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted
                     withNoPermission:(void (^)(void))noPermission;

@end
