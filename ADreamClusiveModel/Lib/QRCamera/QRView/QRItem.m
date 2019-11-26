//
//  QRItem.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/30.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRItem.h"
#import <objc/runtime.h>

@implementation QRItem

- (instancetype)initWithFrame:(CGRect)frame
                       titile:(NSString *)titile{
    
    self =  [QRItem buttonWithType:UIButtonTypeSystem];
    if (self) {
        [self setTitle:titile forState:UIControlStateNormal];
        self.frame = frame;
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self setTitleColor:kRGB(200, 180, 130) forState:UIControlStateSelected];
    }
    return self;
}
@end
