//
//  ProductPicsTableViewCell.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/29.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductPicsTableViewCell : UITableViewCell

@property (nonatomic, copy) void(^deletePic)(NSIndexPath *indexpath);

@property (nonatomic, assign) BOOL showDeleteBtn;

- (void)setContentWithItem:(ProPicInfoItem *)item indexpath:(NSIndexPath *)indexpath;



@end

NS_ASSUME_NONNULL_END
