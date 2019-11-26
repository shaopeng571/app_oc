//
//  CommonSettingItem.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonSettingItem : NSObject

@property (nonatomic, copy) NSString *groupname;

@property (nonatomic, strong) NSMutableArray *groupdetail;

@end

@interface RowItem : NSObject

@property (nonatomic, assign) NSInteger rowtype;

@property (nonatomic, copy) NSString *rowname;

@property (nonatomic, copy) NSString *rowvalue;

@end

NS_ASSUME_NONNULL_END

