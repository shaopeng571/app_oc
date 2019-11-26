//
//  DingdanInfoItem.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/15.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DingdanInfoItem : NSObject

@property (nonatomic, copy) NSString *com;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger ischeck;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *nu;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger status;

@end

@interface DingdanInfoOneItem : NSObject

@property (nonatomic, copy) NSString *context;
@property (nonatomic, copy) NSString *ftime;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
