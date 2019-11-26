//
//  PointInsideButton.m
//  irregularHit
//
//  Created by ADreamClusive 2018 on 2018/11/15.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "PointInsideButton.h"

@interface PointInsideButton()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation PointInsideButton


- (void)setShape:(UIBezierPath *)shape {
    [super setShape:shape];

    self.path = shape;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGPathIsEmpty(self.path.CGPath)) {
        return YES;
    }
    
    if (CGPathContainsPoint(self.path.CGPath, nil, point, nil)) {
        return YES;
    }
    
    return NO;
}

@end
