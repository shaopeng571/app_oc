//
//  UIImage+ColorImage.h
//
//  Created by Jiaozl on 2016/11/28.
//  Copyright © 2016年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorImage)

+ (UIImage *)ImageFromColor:(UIColor *)color;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/**
 UIImage:去色功能的实现（图片灰色显示）
 @param sourceImage 图片
 */
- (UIImage *)grayImage:(UIImage *)sourceImage;


@end
