//
//  AboutItemCell.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutItem.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    AboutItemCellTypeDefault,
    AboutItemCellTypeDesc,
} AboutItemCellType;

@interface AboutItemCell : UITableViewCell

- (void)setContent:(AboutItem *)item indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
