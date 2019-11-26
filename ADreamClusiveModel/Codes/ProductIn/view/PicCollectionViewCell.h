//
//  PicCollectionViewCell.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/7.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicCollectionViewCell : UICollectionViewCell


@property(nonatomic, assign, readonly) BOOL PIC_selected;

- (void)setContentWithItem:(ProPicInfoItem *)item indexpath:(NSIndexPath *)indexpath;

- (void)setPIC_selected:(BOOL)PIC_selected;

@end

NS_ASSUME_NONNULL_END
