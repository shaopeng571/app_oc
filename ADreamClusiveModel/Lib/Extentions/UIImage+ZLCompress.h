//
//  UIImage+ZLCompress.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/25.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZLCompress)

/**
 压缩图片到占用空间不大于maxLength
 
 为了兼顾清晰度：先压缩质量，在压缩尺寸
 
 @param sourceImage 原图片
 @param maxLength 最大大小
 @return 压缩后的图片
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage toByte:(NSUInteger)maxLength;
/**
 压缩图片质量到占用空间不大于maxLength

 @param sourceImage 原图片
 @param maxLength 最大大小
 @return 压缩后的图片
 */
+ (UIImage *)compressImageQuality:(UIImage *)sourceImage toByte:(NSInteger)maxLength;

/**
 压缩图片尺寸到占用空间不大于maxLength
 
 @param sourceImage 原图片
 @param maxLength 最大大小
 @return 压缩后的图片
 */
+ (UIImage *)compressImageSize:(UIImage *)sourceImage toByte:(NSUInteger)maxLength;

/**
 压缩图片到指定尺寸，在压缩到指定大小

 @param sourceImage 原图片
 @param maxEdgeLength 最大尺寸
 @param maxLength 最大大小
 @return 新图片
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage toMaxEdgeLength:(CGFloat)maxEdgeLength toByte:(NSUInteger)maxLength;
/**
 改变SourceImage的size，最大边长不超过maxEdgeLength

 @param sourceImage 原图片
 @param maxEdgeLength 最大边长
 @return 新图片
 */
+ (UIImage *)resizeImage:(UIImage *)sourceImage maxEdgeLength:(CGFloat)maxEdgeLength;

/**
 按照既定的质量系数压缩图片

 @param sourceImage 原图片
 @return 新图片
 */
+(UIImage *)compressImageQuality:(UIImage *)sourceImage;

@end

NS_ASSUME_NONNULL_END
