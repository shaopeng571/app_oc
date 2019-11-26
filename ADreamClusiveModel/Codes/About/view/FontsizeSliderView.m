//
//  FontsizeSliderView.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "FontsizeSliderView.h"

@interface FontsizeSliderView()<UIGestureRecognizerDelegate>

@property(nonatomic,strong) UISlider * slider;
@property(nonatomic,strong) UITapGestureRecognizer*tapGesture;

@end

@implementation FontsizeSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    
    //背景图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.slider.width-30, 8)];
    imageView.center = self.slider.center;
    UIImage *img = [UIImage imageNamed:@"woxin_setFontSize_line"];
    imageView.image = img;
    
    [self addSubview:imageView];
    [self addSubview:self.slider];
    
    UILabel * leftLabel = [[UILabel alloc] init];
    leftLabel .font = [UIFont systemFontOfSize:13];
    leftLabel .text = @"A";
    
    CGSize sSize = [NSString sizeWithTextString:leftLabel.text textFont:leftLabel.font];
    leftLabel.size = sSize;
    leftLabel.center = CGPointMake(imageView.left, self.height*0.5-25);
    
    
    [self addSubview:leftLabel];
    
    UILabel * standardLabel = [[UILabel alloc] init];
    standardLabel.font = [UIFont systemFontOfSize:15.5];
    standardLabel.text = @"标准";
    standardLabel.textColor = [UIColor grayColor];
    CGSize tSize = [NSString sizeWithTextString:standardLabel.text textFont:standardLabel.font];
    standardLabel.size = tSize;
    standardLabel.center = CGPointMake(imageView.left+(imageView.width*0.2), leftLabel.centerY);
    [self addSubview:standardLabel];
    
    UILabel * rightLabel = [[UILabel alloc] init];
    rightLabel .font = [UIFont systemFontOfSize:24];
    rightLabel .text = @"A";
    CGSize lSize = [NSString sizeWithTextString:rightLabel.text textFont:rightLabel.font];
    rightLabel.size = lSize;
    rightLabel.center = CGPointMake(imageView.right, leftLabel.centerY);
    [self addSubview:rightLabel];
}

#pragma mark - actions

- (void)valueChanged:(UISlider *)sender
{
    //只取整数值，固定间距
    NSString *tempStr = [self numberFormat:sender.value];
    if (tempStr.floatValue ==sender.value) {
        return;
    }
    [sender setValue:tempStr.floatValue];
    [self setFontCoefficient:tempStr.integerValue];
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    //取得点击点
    CGPoint p = [sender locationInView:sender.view];
    //计算处于背景图的几分之几，并将之转换为滑块的值（1~6）
    float tempFloat = (p.x-15 ) / (_slider.frame.size.width-30) * 5 + 1;
    NSString *tempStr = [self numberFormat:tempFloat];
    //    NSLog(@"%f,%f,%@", p.x, tempFloat, tempStr);
    
    [_slider setValue:tempStr.floatValue];
    [self setFontCoefficient:tempStr.integerValue];
}

- (void)sliderTouchDown:(UISlider *)sender {
    _tapGesture.enabled = NO;
}

- (void)sliderTouchUp:(UISlider *)sender {
    _tapGesture.enabled = YES;
}
/**
 *  四舍五入
 *
 *  @param num 待转换数字
 *
 *  @return 转换后的数字
 */
- (NSString *)numberFormat:(float)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0"];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:num]];
}


-(void)setFontCoefficient:(NSInteger )coefficient{
    kSetThemeFontSizeCoeff(coefficient);
    kPOST_NOTIFICATION(ThemeFontChangeNotifocation);
}



#pragma mark - getters

- (UISlider *)slider {
    if (!_slider) {
        //滑块设置
        CGFloat height = 25;
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH-70, height)];
        _slider.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height+height)*0.5);
        
        _slider.minimumValue = 1;
        _slider.maximumValue = 6;
        _slider.minimumTrackTintColor = [UIColor clearColor];
        _slider.maximumTrackTintColor = [UIColor clearColor];
        _slider.multipleTouchEnabled = NO;
        [_slider setValue:kGetThemeFontSizeCoeff];
        
        
        //添加点击手势和滑块滑动事件响应
        [_slider addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self
                    action:@selector(sliderTouchDown:)
          forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self
                    action:@selector(sliderTouchUp:)
          forControlEvents:UIControlEventTouchUpInside];
        
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tapGesture.delegate = self;
        [_slider addGestureRecognizer:_tapGesture];
    }
    return _slider;
}




@end
