//
//  PicListViewController.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/7.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLViewController.h"

typedef enum : NSUInteger {
    PicListViewTypeShow,
    PicListViewTypeSelect,
} PicListViewType;

NS_ASSUME_NONNULL_BEGIN

@interface PicListViewController : ZLViewController

@property (nonatomic, assign) PicListViewType type;

@property (nonatomic, copy) void(^didFinishPickingImages)(NSArray<ProPicInfoItem *>*items);

@end

NS_ASSUME_NONNULL_END
