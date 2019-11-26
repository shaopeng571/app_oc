//
//  UIView+Shape.m
//  irregularHit
//
//  Created by ADreamClusive 2018 on 2018/11/15.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "UIView+Shape.h"

@implementation UIView (Shape)

- (void)setShape:(UIBezierPath *)shape {
    if (shape==nil) {
        self.layer.mask = nil;
    }
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = shape.CGPath;
    self.layer.mask = maskLayer;
}

@end
