//
//  AutoScrollLabel.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/14.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "AutoScrollLabel.h"

@interface AutoScrollLabel()

@property (nonatomic,strong) UILabel *textLabel ;

@end



@implementation AutoScrollLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonInit];
    }
    return self;
    
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self commonInit];
    }
    return self;
}


- (void)commonInit {
    
    self.scrollSpeed = 80;
    self.pauseInterval = 3;
    
    self.scrollEnabled = NO ;
    
    
    
    [self addSubview:self.textLabel];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
    // 设置完textLabel.text调用是否滚动
    [self startScrollIfNeed];
}

- (void)startScrollIfNeed {
    [self.textLabel sizeToFit];
    self.textLabel.width = MAX(self.textLabel.width, self.width);
    self.textLabel.height = self.height;
    self.contentSize = self.textLabel.bounds.size;
    
    // 需要滚动
    if (self.textLabel.bounds.size.width>self.bounds.size.width) {
        [self animationScroll];
    }
    
    
}
- (void)animationScroll {
    
    self.contentOffset = CGPointMake(-self.bounds.size.width, 0);
    
    [UIView animateWithDuration:self.textLabel.frame.size.width/self.scrollSpeed delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.contentOffset = CGPointMake(self.textLabel.frame.size.width - self.bounds.size.width, 0);
        
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(animationScroll) withObject:nil afterDelay:self.pauseInterval];
    }];
}


#pragma mark - getters
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}



@end
