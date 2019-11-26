//
//  CALayer+Shake.m
//  ADreamClusive
//
//  Created by ADreamClusive on 2016/11/28.
//  Copyright © 2016年 boole. All rights reserved.
//

#import "CALayer+Shake.h"

@implementation CALayer (Shake)

/*
 *  X轴方向颤动
 */
-(void)shakeX
{
    [self shakeWithAxle:@"x"];
}

/*
 *  Y轴方向颤动
 */
-(void)shakeY
{
    [self shakeWithAxle:@"y"];
}

/*
 *  颤动
 */
-(void)shakeWithAxle:(NSString *)direction
{
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:[NSString stringWithFormat:@"transform.translation.%@", [direction lowercaseString]]];
    
    CGFloat s = 8;
    
    kfa.values = @[@(-s),@(0),@(s),@(0),@(-s),@(0),@(s),@(0)];
    
    //时长
    kfa.duration = .13f;
    
    //重复
    kfa.repeatCount = 2;
    
    //移除
    kfa.removedOnCompletion = YES;
    
    [self addAnimation:kfa forKey:@"shake"];
}

@end
