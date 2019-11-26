//
//  ZLButtonFactory.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/23.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLButtonFactory.h"

@implementation ZLButtonFactory

+ (UIButton *)buttonWithTitle:(NSString *)title image:(UIImage *)image frame:(CGRect)frame target:(id)target selector:(SEL)sel {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0f;
    button.layer.borderColor = UIColor.lightGrayColor.CGColor;
    button.layer.borderWidth = 1.0f;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


+ (UIButton *)topImgBottomTextbuttonWithTitle:(NSString *)title image:(UIImage *)image frame:(CGRect)frame target:(id)target selector:(SEL)sel {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font = kFontOfSize(12);
//    button.layer.cornerRadius = 5.0f;
//    button.layer.borderColor = UIColor.greenColor.CGColor;
//    button.layer.borderWidth = 1.0f;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [self initButton:button];
    return button;
}

//将按钮设置为图片在上，文字在下（可以将此方法放在button的一个分类中，但可能会被其他重写了布局方法的分类覆盖）
+ (void)initButton:(UIButton*)btn {
    float spacing = 10;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}





@end
