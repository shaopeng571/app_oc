//
//  ZLButton.h
//  ADreamClusiveModel
//
//  上图、下文字按钮
//  Created by ADreamClusive 2018 on 2018/11/13.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLButton : UIButton

+ (ZLButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)titleColor image:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets handler:(void(^)(ZLButton *button))handler;

@end

NS_ASSUME_NONNULL_END
