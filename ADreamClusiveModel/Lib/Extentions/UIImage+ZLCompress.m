//
//  UIImage+ZLCompress.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/25.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "UIImage+ZLCompress.h"

@implementation UIImage (ZLCompress)


+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

#warning 这样写得到的图片和上面是不同的，将data转为image后，再转回data会变大，导致最终结果image会更加模糊
+ (UIImage *)compressImage1:(UIImage *)image toByte:(NSUInteger)maxLength {
    UIImage *resultImage = [UIImage compressImageQuality:image toByte:maxLength];
    NSData *imgData = UIImageJPEGRepresentation(resultImage, 1);
    if (imgData.length <= maxLength) {
        return resultImage;
    }
    
    return [UIImage compressImageSize:resultImage toByte:maxLength];
}

+ (UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength)
        return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            // 当data大小位于0.9maxLength和maxLength之间时结束
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}


+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength {
    UIImage *resultImage = image;
    NSData *data = UIImageJPEGRepresentation(resultImage, 1);
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        // Use image to draw (drawInRect:), image is larger but more compression time
        // Use result image to draw, image is smaller but less compression time
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    return resultImage;
}


+ (UIImage *)compressImage:(UIImage *)sourceImage toMaxEdgeLength:(CGFloat)maxEdgeLength toByte:(NSUInteger)maxLength {
    UIImage *resizedImg = [UIImage resizeImage:sourceImage maxEdgeLength:maxEdgeLength];
    
    return [UIImage compressImageQuality:resizedImg toByte:maxLength];
}


+ (UIImage *)resizeImage:(UIImage *)sourceImage maxEdgeLength:(CGFloat)maxEdgeLength {
//    CGFloat maxEdgeLength = 1280;
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width; //图片宽度
    CGFloat height = imageSize.height; //图片高度
    
    if (width>maxEdgeLength||height>maxEdgeLength) { //1.宽高大于maxEdgeLength(宽高比不按照2来算，按照1来算)
        if (width>height) {
            CGFloat scale = height/width;
            width = maxEdgeLength;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = maxEdgeLength;
            width = height*scale;
        }
        
    } else if(width>maxEdgeLength||height<maxEdgeLength){ //2.宽大于maxEdgeLength高小于maxEdgeLength
        CGFloat scale = height/width;
        width = maxEdgeLength;
        height = width*scale;
        
    }else if(width<maxEdgeLength||height>maxEdgeLength){ //3.宽小于maxEdgeLength高大于maxEdgeLength
        CGFloat scale = width/height;
        height = maxEdgeLength;
        width = height*scale;
    }else{ //4.宽高都小于maxEdgeLength
        
    }
    //进行尺寸重绘
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)compressImageQuality:(UIImage *)sourceImage {
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(sourceImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(sourceImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(sourceImage, 0.8);
        }else if (data.length>200*1024) { //0.25M-0.5M
            data=UIImageJPEGRepresentation(sourceImage, 0.9);
        }
    }
    return [UIImage imageWithData:data];
}




@end
