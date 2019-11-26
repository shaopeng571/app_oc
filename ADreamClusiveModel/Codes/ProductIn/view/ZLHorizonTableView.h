//
//  ZLHorizonTableView.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/1.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HorizonTableViewTypeShow,
    HorizonTableViewTypeEdit,
} HorizonTableViewType;

NS_ASSUME_NONNULL_BEGIN

@interface ZLHorizonTableView : UIView

@property (nonatomic, strong) NSMutableArray *datasource;

- (instancetype)initWithFrame:(CGRect)frame type:(HorizonTableViewType)type;

@end

NS_ASSUME_NONNULL_END
