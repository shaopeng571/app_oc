//
//  CreateQRManager.h
//  ADreamClusiveDemo
//
//  Created by ADreamClusive on 2017/6/17.
//  Copyright © 2017年 ADreamClusive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QRManager : NSObject

/**
 *  展示二维码
 *  @param imageViewWidth 展示二维码的imageView的宽度
 *  @param dataStr   二维码的文字
 */
+ (UIImage *)showQRCodeWithImageWidth:(CGFloat)imageViewWidth andDataStr:(NSString *)dataStr;
/**
 *  展示带logo 的二维码
 *
 *  @param logoImageName logo 的名称
 *  @param dataStr   二维码的文字
 *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+  (UIImage *)showQRCodeWithDataStr:(NSString *)dataStr andLogo:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView;

/**
 *  生成一张彩色的二维码
 *
 *  @param data_Str    传入你要生成二维码的数据
 *  @param backgroundColor    背景色
 *  @param mainColor    主颜色
 */
+ (UIImage *)showQRWithColorQRCodeData:(NSString *)data_Str backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;


/**
 获取二维码中的信息

 @param image 二维码图片
 @return 二维码中隐含的信息
 */
+ (NSString *)touchQRImageGetStringWithImage:(UIImage *)image;


#pragma mark - 生成条形码 //Avilable in iOS 8.0 and later
+ (UIImage *)barcodeImageWithContent:(NSString *)content codeImageSize:(CGSize)size red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;






/**
 *  二维码生成(Erica Sadun 原生代码生成)
 *
 *  @param string   内容字符串
 *  @param size 二维码大小
 *  @param color 二维码颜色 默认黑色
 *  @param backGroundColor 背景颜色 默认白色
 *
 *  @return 返回一张图片
 */
+ (UIImage *)qrImageWithString:(NSString *)string
                          size:(CGSize)size
                         color:(UIColor *)color
               backGroundColor:(UIColor *)backGroundColor;
/**
 *  条形码生成(Third party)
 *
 *  @param code   内容字符串
 *  @param size  条形码大小
 *  @param color 条形码颜色 默认黑色
 *  @param backGroundColor 背景颜色 默认白色
 *
 *  @return 返回一张图片
 */
+ (UIImage *)generateBarCode:(NSString *)code
                        size:(CGSize)size
                       color:(UIColor *)color
             backGroundColor:(UIColor *)backGroundColor;
@end
