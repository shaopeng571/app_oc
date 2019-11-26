//
//  CommonSettingCell.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonSettingItem.h"


typedef enum : NSUInteger {
    CommonSettingCellTypeDefault, // 只有一个标题， 点击直接响应
    CommonSettingCellTypeSwitch, // 带Switch的
    CommonSettingCellTypeSkip, // 带箭头的，直接跳转到其他页面
} CommonSettingCellType;

NS_ASSUME_NONNULL_BEGIN


@interface CommonSettingCell : UITableViewCell

- (void)setContent:(RowItem *)item indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
