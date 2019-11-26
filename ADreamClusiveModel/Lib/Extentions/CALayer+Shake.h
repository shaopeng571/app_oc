//
//  CALayer+Shake.h
//  ADreamClusive
//
//  Created by ADreamClusive on 2016/11/28.
//  Copyright © 2016年 boole. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Shake)
/*
 *  X轴方向颤动
 */
-(void)shakeX;
/*
 *  Y轴方向颤动
 */
-(void)shakeY;

@end
