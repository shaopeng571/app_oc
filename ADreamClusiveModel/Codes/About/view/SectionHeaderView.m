//
//  SectionHeaderView.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "SectionHeaderView.h"

@interface SectionHeaderView()

@property (strong, nonatomic)  UILabel *titleLabel;

@end

@implementation SectionHeaderView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
    self = [self initWithFrame:frame];
    self.titleLabel.text = title;
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(5);
        make.right.mas_equalTo(self).mas_offset(-5);
        make.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
}

#pragma mark - getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kGetThemeFont(14);
    }
    return _titleLabel;
}

@end
