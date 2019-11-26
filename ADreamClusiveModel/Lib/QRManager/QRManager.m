//
//  QRManager.m
//  ADreamClusiveDemo
//
//  Created by ADreamClusive on 2017/6/17.
//  Copyright © 2017年 ADreamClusive. All rights reserved.
//

#import "QRManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
@implementation QRManager


/**
 生成一个基础二维码

 @param dataStr 二维码中的文字
 @return 二维码图片
 */
+ (CIImage *)createCIQRImageWithDataStr:(NSString *)dataStr {
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性（因为滤镜可能保存上一次的属性)
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    // 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKeyPath:@"inputMessage"];
//    [filter setValue:data forKey:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}
/**
 *  展示二维码
 *  @param imageViewWidth 展示二维码的imageView的宽度
 *  @param dataStr   二维码的文字
 */
+ (UIImage *)showQRCodeWithImageWidth:(CGFloat)imageViewWidth andDataStr:(NSString *)dataStr{
    // 借助UIImageView 来显示二维码
    
    CIImage *outputImage = [QRManager createCIQRImageWithDataStr:dataStr];
    // 5.将CIImage转换成UIImage，并放大显示
    // 因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    return [QRManager createNonInterpolatedUIImageFromCIImage:outputImage withSize:imageViewWidth];
}
/**
 *  展示带logo 的二维码
 *
 *  @param logoImageName logo 的名称
 *  @param dataStr   二维码的文字
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+  (UIImage *)showQRCodeWithDataStr:(NSString *)dataStr andLogo:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView {
 
    // 4. 获取输出的二维码
    CIImage *outputImage = [QRManager createCIQRImageWithDataStr:dataStr];
    // 5. 图片小于（27，27），我们需要放大他
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
   // 6.将CIImage 类型转成UIImage 类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    
    // ===============  添加中间小图标 ===============
    // 7.开启绘图，获取图形上下文，上下文就是二维码大小
    UIGraphicsBeginImageContext(start_image.size);
    // 8.把二维码画上去（这里以图片上下文，左上角（0，0）点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    // 9. 把小图片绘制上去
    // 再把小图片画上去
    NSString *icon_imageName = logoImageName;
    UIImage *icon_image = [UIImage imageNamed:icon_imageName];
    CGFloat icon_imageW = start_image.size.width * logoScaleToSuperView;
    CGFloat icon_imageH = start_image.size.height * logoScaleToSuperView;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    
    [icon_image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    
    return final_image;
    
}

/**
 *  生成一张彩色的二维码
 *
 *  @param data_Str    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)showQRWithColorQRCodeData:(NSString *)data_Str backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor {
    // 4. 获取输出的二维码
    CIImage *outputImage = [QRManager createCIQRImageWithDataStr:data_Str];
    
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    
    // 4、创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    
    // 设置默认值
    [color_filter setDefaults];
    
    // 5、KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    
    // 6、需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    
    return [UIImage imageWithCIImage:colorImage];
}
/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


/**
 获取二维码中的信息
 
 @param image 二维码图片
 @return 二维码中隐含的信息
 */
+ (NSString *)touchQRImageGetStringWithImage:(UIImage *)image {
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    NSString *scannedResult;
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        scannedResult = feature.messageString;
        NSLog(@"scannedResult - - %@", scannedResult);
        // 在此发通知，告诉子类二维码数据
//        [SGQRCodeNotificationCenter postNotificationName:SGQRCodeInformationFromeAibum object:scannedResult];
    }
    return scannedResult;
}

#pragma mark - 生成条形码
+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    UIImage *image = [self barcodeImageWithContent:content codeImageSize:size];
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpaceRef, kCGBitmapByteOrder32Little|kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    //遍历像素, 改变像素点颜色
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    for (int i = 0; i<pixelNum; i++, pCurPtr++) {
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900) {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red*255;
            ptr[2] = green*255;
            ptr[1] = blue*255;
            
        } else {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
            
        }
        
    }
    //取出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpaceRef, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef]; CGImageRelease(imageRef);
    CGContextRelease(context); CGColorSpaceRelease(colorSpaceRef); return resultImage;
}
//改变条形码尺寸大小
+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size{
    CIImage *image = [self barcodeImageWithContent:content];
    CGRect integralRect = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(integralRect), size.height/CGRectGetHeight(integralRect));
    size_t width = CGRectGetWidth(integralRect)*scale;
    size_t height = CGRectGetHeight(integralRect)*scale;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:integralRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, integralRect, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
//生成最原始的条形码
+ (CIImage *)barcodeImageWithContent:(NSString *)content{
    CIFilter *qrFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:contentData forKey:@"inputMessage"];
    [qrFilter setValue:@(0.00) forKey:@"inputQuietSpace"];
    CIImage *image = qrFilter.outputImage;
    return image;
}
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}












//二维码生成
+ (UIImage *)qrImageWithString:(NSString *)string size:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor
{
    color = color ? color : [UIColor blackColor];
    backGroundColor = backGroundColor ? backGroundColor : [UIColor whiteColor];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    if (!qrFilter)
    {
        NSLog(@"Error: Could not load filter");
        return nil;
    }
    
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    CIFilter * colorQRFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorQRFilter setValue:qrFilter.outputImage forKey:@"inputImage"];
    //二维码颜色
    if (color == nil) {
        color = [UIColor blackColor];
    }
    if (backGroundColor == nil) {
        backGroundColor = [UIColor whiteColor];
    }
    [colorQRFilter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
    //背景颜色
    [colorQRFilter setValue:[CIColor colorWithCGColor:backGroundColor.CGColor] forKey:@"inputColor1"];
    
    
    CIImage *outputImage = [colorQRFilter valueForKey:@"outputImage"];
    
    UIImage *smallImage = [self imageWithCIImage:outputImage orientation: UIImageOrientationUp];
    
    return [self resizeImageWithoutInterpolation:smallImage size:size];
}


#pragma mark - CIImage转UIImage

+ (UIImage *)imageWithCIImage:(CIImage *)aCIImage orientation: (UIImageOrientation)anOrientation
{
    if (!aCIImage) return nil;
    
    CGImageRef imageRef = [[CIContext contextWithOptions:nil] createCGImage:aCIImage fromRect:aCIImage.extent];
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:anOrientation];
    CFRelease(imageRef);
    
    return image;
}
+ (UIImage *)resizeImageWithoutInterpolation:(UIImage *)sourceImage size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    [sourceImage drawInRect:(CGRect){.size = size}];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

//条形码生成
+ (UIImage *)generateBarCode:(NSString *)code size:(CGSize)size color:(UIColor *)color backGroundColor:(UIColor *)backGroundColor {
    color = color ? color : [UIColor blackColor];
    backGroundColor = backGroundColor ? backGroundColor : [UIColor whiteColor];
    // 生成条形码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    //设置条形码颜色和背景颜色
    CIFilter * colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setValue:filter.outputImage forKey:@"inputImage"];
    //条形码颜色
    if (color == nil) {
        color = [UIColor blackColor];
    }
    if (backGroundColor == nil) {
        backGroundColor = [UIColor whiteColor];
    }
    [colorFilter setValue:[CIColor colorWithCGColor:color.CGColor] forKey:@"inputColor0"];
    //背景颜色
    [colorFilter setValue:[CIColor colorWithCGColor:backGroundColor.CGColor] forKey:@"inputColor1"];
    
    barcodeImage = [colorFilter outputImage];
    
    // 消除模糊
    CGFloat scaleX = size.width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = size.height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}


@end
