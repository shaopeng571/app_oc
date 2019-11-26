//
//  ZLActionSheetManager.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLActionSheetManager : NSObject

+ (void)showActionSheet:(NSString *)title message:(NSString *)msg actionTitles:(NSArray *)actionTitles inView:(UIView *)parentView handler:(void(^)(UIAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
