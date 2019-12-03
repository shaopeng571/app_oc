//
//  PermissionCheck.m
//  SeerEnglish
//
//  Created by ADreamClusive 2018 on 2018/4/5.
//  Copyright © 2018年 SeerEducation. All rights reserved.
//

#import "PermissionCheck.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreTelephony/CTCellularData.h>


@implementation PermissionCheck

/**
 检查是否允许联网
 */
+ (void)openEventServiceWithBolck:(void(^)(BOOL shouldOn))returnBolck
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
        if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
            if (returnBolck) {
                returnBolck(NO);
            }
        } else {
            if (returnBolck) {
                returnBolck(YES);
            }
        }
    };
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataRestrictedStateUnknown || state == kCTCellularDataNotRestricted) {
        if (returnBolck) {
            returnBolck(NO);
        }
    } else {
        if (returnBolck) {
            returnBolck(YES);
        }
    }
#endif
}

/**通知权限*/
+(void)checkNotificationAuthorizationGrand:(void (^)(void))permissionGranted
                          withNoPermission:(void (^)(void))noPermission {
    BOOL isAvalible = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone) {
            isAvalible = YES;
            
        } else {
            isAvalible = NO;
        }
        
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
            isAvalible = NO;
        } else {
            isAvalible = YES;
        }
    }
    
    //用户拒绝授权
    if (isAvalible == NO) {
        //提示用户开启通知权限
        if (noPermission) {
            noPermission();
        }
    } else {
        if (permissionGranted) {
            permissionGranted();
        }
    }
}

/**相机权限*/
+ (void)checkCameraAuthorizationGrand:(void (^)(void))permissionGranted
                     withNoPermission:(void (^)(void))noPermission
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (videoAuthStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                granted ? (permissionGranted?permissionGranted():nil): (noPermission?noPermission():nil);
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            if (permissionGranted) {
                permissionGranted();
            }
            break;
        }
        case AVAuthorizationStatusRestricted:
            NSLog(@"不能完成授权，可能开启了访问限制");
            if (noPermission) {
                noPermission();
            }
        case AVAuthorizationStatusDenied:{
            NSLog(@"请到设置授权访问相机");
            if (noPermission) {
                noPermission();
            }
        }
            break;
        default:
            break;
    }
}

/**相册权限*/
+ (void)checkPhotoAlbumAuthorizationGrand:(void (^)(void))permissionGranted
                         withNoPermission:(void (^)(void))noPermission
{
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthStatus) {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                (status == PHAuthorizationStatusAuthorized) ? (permissionGranted?permissionGranted():nil): (noPermission?noPermission():nil);
            }];
            break;
        }
        case PHAuthorizationStatusAuthorized:
        {
            if (permissionGranted) {
                permissionGranted();
            }
            break;
        }
        case PHAuthorizationStatusRestricted:
            NSLog(@"不能完成授权，可能开启了访问限制");
            if (noPermission) {
                noPermission();
            }
        case PHAuthorizationStatusDenied:{
            NSLog(@"请到设置授权访问相册");
            if (noPermission) {
                noPermission();
            }
            break;
        }
        default:
            break;
            
    }
}

/**麦克风权限*/
+ (void)checkAudioAuthorizationGrand:(void (^)(void))permissionGranted
                    withNoPermission:(void (^)(void))noPermission
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (videoAuthStatus) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                granted ? (permissionGranted?permissionGranted():nil): (noPermission?noPermission():nil);
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:
        {
            if (permissionGranted) {
                permissionGranted();
            }
            break;
        }
        case AVAuthorizationStatusRestricted:
            NSLog(@"不能完成授权，可能开启了访问限制");
            if (noPermission) {
                noPermission();
            }
        case AVAuthorizationStatusDenied:{
            NSLog(@"请到设置授权访问麦克风");
            if (noPermission) {
                noPermission();
            }
        }
            break;
        default:
            break;
    }
}

/**定位权限*/
+ (void)checkLocationServiceAuthorization:(void(^)(BOOL authorizationAllow, CLAuthorizationStatus status))checkFinishBack
{
    if ([CLLocationManager locationServicesEnabled])
    {
        //隐私->定位 开启
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
                if (checkFinishBack) {
                    checkFinishBack(NO, status);
                }
                break;
            case kCLAuthorizationStatusRestricted:
                if (checkFinishBack) {
                    checkFinishBack(NO, status);
                }
                break;
            case kCLAuthorizationStatusDenied:
                NSLog(@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)");
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                if (checkFinishBack) {
                    checkFinishBack(YES, status);
                }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                if (checkFinishBack) {
                    checkFinishBack(YES, status);
                }
                break;
            default:
                break;
        }
    }else
    {
        NSLog(@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)");
    }
    
}


/**通讯录检测*/

+(void)checkAddressBookAuthorizationGrand:(void(^)(void))permissionGranted

                         withNoPermission:(void (^)(void))noPermission

{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,NULL);
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusNotDetermined:{
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                granted ? (permissionGranted?permissionGranted():nil): (noPermission?noPermission():nil);
            });
        }break;
        case kABAuthorizationStatusRestricted:
            if (noPermission) {
                noPermission();
            }
            break;
        case kABAuthorizationStatusDenied:
            if (noPermission) {
                noPermission();
            }
            break;
        case kABAuthorizationStatusAuthorized:
            if (permissionGranted) {
                permissionGranted();
            }
            break;
        default:
            break;
    }
}

@end
