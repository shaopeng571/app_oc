//
//  ZLMenuAlert.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/15.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLMenuAlert : UIView

// 显示字体设置
@property(nonatomic,assign)UIFont * cusFont;

/**
 点击回调,返回所点的角标以及点击的内容
 */
@property(nonatomic, copy) void(^didSelectedCallback)(NSInteger index, NSString * content);
/// 数据源 数据, 下拉列表的内容数组.
@property(nonatomic, strong) NSArray * arrMDataSource;
// tableview以及cell的背景色, 如果不设置默认白色
@property(nonatomic, strong) UIColor * tabColor;
// 文字的颜色, 默认黑色
@property(nonatomic, strong) UIColor * txtColor;


@end

NS_ASSUME_NONNULL_END
