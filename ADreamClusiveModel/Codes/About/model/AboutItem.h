//
//  AboutItem.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutItem : NSObject

/*
 eventid
 2：打开一个页面，通过desc传递要打开的类名；
 3：打开一个网页，通过desc传递网页地址；
 
*/
@property (nonatomic, assign) NSInteger eventid;
@property (nonatomic, assign) NSInteger subeventid;

// 右侧说明文字  或  打开网页的连接
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

// 显示类型， type为0：不显示右侧说明文字；type为1：显示右侧说明文字；
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
