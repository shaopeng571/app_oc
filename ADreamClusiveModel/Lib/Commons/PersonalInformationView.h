//
//  PersonalInformationView.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const PIV_BgImage;
extern NSString *const PIV_Image;
extern NSString *const PIV_Nickname;
extern NSString *const PIV_Name;

@interface PersonalInformationView : UIView

@property (nonatomic, copy) void(^didSelect)(void);

- (void)setContent:(NSDictionary *)personInfoDic;

@end

NS_ASSUME_NONNULL_END
