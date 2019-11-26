//
//  UIView+ZL.m
//  Created by Jiaozl on 15/11/2017.
//  Copyright © 2017 Jiaozl. All rights reserved.
//

#import "UIView+ZL.h"

@implementation UIView (ZL)

-(UIViewController*)viewContainingController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder);
    
    return nil;
}

- (UIImage*) changeToUIImage {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:currnetContext];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return image;
    
}


- (void)setBorderColor:(UIColor *)borderColor width:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    self.layer.masksToBounds = YES;
    if (borderColor && 0 != borderWidth) {
        self.layer.borderColor = borderColor.CGColor;
        self.layer.borderWidth = borderWidth;
    }
    if (cornerRadius) {
        self.layer.cornerRadius = cornerRadius;
    }
}

- (void)addLineViewWithColor:(UIColor *)color top:(BOOL)isTopLine {
    color = color?color:[UIColor colorWithWhite:0.875 alpha:1];
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, isTopLine?0:(self.bounds.size.height-0.5), self.bounds.size.width, 0.5);
    lineView.backgroundColor = color;
    [self addSubview:lineView];
}

- (void)addStrikethroughWithColor:(UIColor *)color {
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
    shapeLayer.lineWidth = 1.0;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width, self.frame.size.height)];
    
    shapeLayer.path = path.CGPath;
    
    [self.layer addSublayer:shapeLayer];
}


@end
