//
//  AboutItemView.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/8.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "AboutItemView.h"

@interface AboutItemView()

@property (strong, nonatomic)  UIImageView *iconView;
@property (strong, nonatomic)  UIImageView *arrowView;
@property (strong, nonatomic)  UILabel *rowNameLabel;
@property (strong, nonatomic)  UILabel *descLabel;
@property (strong, nonatomic)  UIView *lineView;
@property (nonatomic, assign) NSInteger typeID;


@end

@implementation AboutItemView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tapGR];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.iconView];
    [self addSubview:self.arrowView];
    [self addSubview:self.rowNameLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(5);
        make.width.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-5);
        make.width.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.rowNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(5);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowView.mas_left).offset(-5);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - actions

- (void)tapClick:(UITapGestureRecognizer *)tapGr {
    if (self.AboutitemClicked) {
        self.AboutitemClicked(self.typeID);
    }
}


- (void)setContent:(NSInteger)typeID image:(UIImage *)image title:(NSString *)title desc:(NSString *)desc type:(AboutItemViewType)type {
    self.typeID = typeID;
    self.iconView.image = image;
    self.rowNameLabel.text = title;
    if (type == AboutItemViewTypeDesc) {
        self.descLabel.hidden = NO;
        self.descLabel.text = desc;
    } else {
        self.descLabel.hidden = YES;
    }
}



#pragma mark - getters


- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_arrow_right"]];
    }
    return _arrowView;
}

- (UILabel *)rowNameLabel {
    if (!_rowNameLabel) {
        _rowNameLabel = [[UILabel alloc] init];
        _rowNameLabel.font = kGetThemeFont(12);
    }
    return _rowNameLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = kGetThemeFont(12);
        _descLabel.textColor = UIColor.lightGrayColor;
        _descLabel.textAlignment = NSTextAlignmentRight;
    }
    return _descLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UILabel alloc] init];
        _lineView.backgroundColor = kRGB(191, 191, 191);
    }
    return _lineView;
}

@end
