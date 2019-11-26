//
//  ProductItem.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/29.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProPicInfoItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProductItem : NSObject


/**
 id
 */
@property (nonatomic, copy) NSString *productID;
/**
 名称
 */
@property (nonatomic, copy) NSString *producName;

/**
 价格
 */
@property (nonatomic, copy) NSString *producPrice;

/**
 简介
 */
@property (nonatomic, copy) NSString *producIntro;

/**
 图片信息
 */
@property (nonatomic, strong) NSMutableArray *productPicInfoItems;


@property (nonatomic, copy) NSString *showimagestr;

// 要显示的image
@property (nonatomic, strong) UIImage *showImage;

/**
 二维码信息
 */
@property (nonatomic, copy) NSString *qrinfo;
/**
 评分
 */
@property (nonatomic, copy) NSString *starscore;





@end

NS_ASSUME_NONNULL_END
