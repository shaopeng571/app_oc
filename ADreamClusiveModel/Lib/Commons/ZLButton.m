//
//  ZLButton.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/13.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLButton.h"

static CGFloat const bottomRadio = 0.4;

@interface ZLButton()

@property (nonatomic, copy) void(^handler)(ZLButton *button);

@end

@implementation ZLButton


+ (ZLButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)titleColor image:(UIImage *)image edgeInsets:(UIEdgeInsets)edgeInsets handler:(void(^)(ZLButton *button))handler {
    
    ZLButton *button = [[ZLButton alloc] initWithFrame:frame];
    
    button.contentEdgeInsets = edgeInsets;
    
//    button.layer.cornerRadius = 8.0;
//    
//    button.layer.borderWidth = 1.0;
//
//    button.layer.borderColor = UIColor.lightGrayColor.CGColor;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setImage:image forState:UIControlStateNormal];
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    button.titleLabel.font = font;
    
    button.handler = handler;
    
    [button addTarget:button action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.imageView.backgroundColor = UIColor.redColor;
//        self.titleLabel.backgroundColor = UIColor.greenColor;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        self.contentEdgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

// these return the rectangle for the background (assumes bounds), the content (image + title) and for the image and title separately. the content rect is calculated based
// on the title and image size and padding and then adjusted based on the control content alignment. there are no draw methods since the contents
// are rendered in separate subviews (UIImageView, UILabel)

//- (CGRect)contentRectForBounds:(CGRect)bounds {
//    return
//}





#pragma mark - actions

- (void)buttonClick:(ZLButton *)sender {
    if (self.handler) {
        self.handler(sender);
    }
}

#pragma mark - layout

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat x = CGRectGetMinX(contentRect),
            y = CGRectGetMinY(contentRect) + contentRect.size.height*(1-bottomRadio),
            w = contentRect.size.width,
            h = contentRect.size.height*bottomRadio;
    
    return CGRectMake(x, y, w, h);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat x = CGRectGetMinX(contentRect),
            y = CGRectGetMinY(contentRect),
            w = contentRect.size.width,
            h = contentRect.size.height*(1-bottomRadio);
    return CGRectMake(x, y, w, h);
}



@end
