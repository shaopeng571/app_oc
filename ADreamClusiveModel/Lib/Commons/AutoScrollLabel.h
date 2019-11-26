//
//  AutoScrollLabel.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/14.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutoScrollLabel : UIScrollView

/// 每秒移动多少像素
@property(nonatomic) float scrollSpeed;

/// 滚动到结束时,暂停多长时间
@property(nonatomic) NSTimeInterval pauseInterval;

/// 文本
@property(nonatomic, copy) NSString *text;



@end

NS_ASSUME_NONNULL_END
