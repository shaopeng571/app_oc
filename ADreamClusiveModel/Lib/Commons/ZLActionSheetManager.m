//
//  ZLActionSheetManager.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLActionSheetManager.h"
#import <UIKit/UIKit.h>

@implementation ZLActionSheetManager

+ (void)showActionSheet:(NSString *)title message:(NSString *)msg actionTitles:(NSArray *)actionTitles inView:(UIView *)parentView handler:(void(^)(UIAlertAction *action))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSAssert(actionTitles, @"actionTitles不能为空");
    
    for (NSString *actionTitle in actionTitles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了按钮1，进入按钮1的事件");
            handler(action);
        }];
        //把action添加到actionSheet里
        [alertController addAction:action];
    }
    
    
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        handler(action);
    }];
    
    [alertController addAction:actionCancel];
    
    
    // 兼容iPad
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = parentView;
        popover.sourceRect = parentView.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    
    
    
    
    //相当于之前的[actionSheet show];
//    [self presentViewController:alertController animated:YES completion:nil];
    [[parentView parentContainerViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
