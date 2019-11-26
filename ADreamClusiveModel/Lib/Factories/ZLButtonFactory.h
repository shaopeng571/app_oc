//
//  ZLButtonFactory.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/23.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLButtonFactory : NSObject


/**
 快速创建一个带边框的Button


 
 @param title 标题
 @param image 图片
 @param frame Frame
 @param target target
 @param sel 方法
 @return 创建好的按钮
 */
+ (UIButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image frame:(CGRect)frame target:(id)target selector:(SEL)sel;

/**
 快速创建一个上图下文字的Button
 
 
 
 @param title 标题
 @param image 图片
 @param frame Frame
 @param target target
 @param sel 方法
 @return 创建好的按钮
 */
+ (UIButton *)topImgBottomTextbuttonWithTitle:(NSString *)title image:(UIImage *)image frame:(CGRect)frame target:(id)target selector:(SEL)sel;

+ (void)initButton:(UIButton*)btn;


@end

NS_ASSUME_NONNULL_END
