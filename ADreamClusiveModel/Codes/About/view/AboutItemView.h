//
//  AboutItemView.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/8.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AboutItemViewTypeDefault,
    AboutItemViewTypeDesc,
} AboutItemViewType;


NS_ASSUME_NONNULL_BEGIN

@interface AboutItemView : UIView

@property (nonatomic, copy) void(^AboutitemClicked)(NSInteger typeID);

- (void)setContent:(NSInteger)typeID image:(UIImage *)image title:(NSString *)title desc:(NSString *)desc type:(AboutItemViewType)type;

@end

NS_ASSUME_NONNULL_END
