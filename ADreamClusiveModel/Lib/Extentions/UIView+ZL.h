//
//  UIView+ZL.h
//  Created by Jiaozl on 15/11/2017.
//  Copyright © 2017 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZL)

/**
 Returns the UIViewController object that manages the receiver.
 */
-(UIViewController*)viewContainingController;

/// 把UIView转成UIImage
- (UIImage*) changeToUIImage;

/**
 * Set view's layer bound color
 */
- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadiuscornerRadius;

/**
 *  为视图添加线条
 *
 *  @param color     线条颜色
 *  @param isTopLine 是否为顶部的线条
 */
- (void)addLineViewWithColor:(UIColor *)color top:(BOOL)isTopLine;

/// 添加删除线
- (void)addStrikethroughWithColor:(UIColor *)color;

@end
