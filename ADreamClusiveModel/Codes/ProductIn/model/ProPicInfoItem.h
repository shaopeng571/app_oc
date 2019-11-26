//
//  ProPicInfoItem.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/29.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProPicInfoItem : NSObject 

// 图片，图片列表显示中使用
@property (nonatomic, strong) UIImage *proimage;

@property (nonatomic, copy) NSString *proimagepath;

@property (nonatomic, copy) NSString *proinfo;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
