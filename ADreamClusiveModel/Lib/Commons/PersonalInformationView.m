//
//  PersonalInformationView.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "PersonalInformationView.h"

NSString *const PIV_BgImage = @"PIV_BgImage";
NSString *const PIV_Image = @"PIV_Image";
NSString *const PIV_Nickname = @"PIV_Nickname";
NSString *const PIV_Name = @"PIV_Name";


@interface PersonalInformationView()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIImageView *avatarImgView;

@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *rightArrowImgView;

@property (nonatomic, strong) UIImageView *qrImgView;



@end

@implementation PersonalInformationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.bgImgView];
    [self addSubview:self.avatarImgView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.qrImgView];
    [self addSubview:self.rightArrowImgView];
    
}

- (void)layoutSubviews {
    ZLWeakSelf;
    CGFloat kEdgeX = 13, kEdgeY = 12;
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakSelf.frame.size);
        make.center.mas_equalTo(weakSelf);
    }];
    
    
    [self.avatarImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(weakSelf.frame.size.height-2*kEdgeY);
        make.centerY.mas_equalTo(weakSelf);
        make.left.mas_equalTo(kEdgeX);
    }];
    
    [self.rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.rightArrowImgView.image.size.width);
        make.height.mas_equalTo(weakSelf.rightArrowImgView.image.size.height);
        make.right.mas_equalTo(weakSelf).mas_offset(-kEdgeX);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
    [self.qrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(weakSelf.frame.size.height*0.2);
        make.right.mas_equalTo(weakSelf.rightArrowImgView.mas_left);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
    
    CGSize nickLabelSize = [NSString sizeWithTextString:self.nickNameLabel.text textFont:self.nickNameLabel.font];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avatarImgView.mas_right).mas_offset(kEdgeX);
        make.right.mas_equalTo(weakSelf.qrImgView.mas_left).mas_offset(-kEdgeX);
        make.top.mas_equalTo(weakSelf.avatarImgView.mas_top).mas_offset(kEdgeY);
        make.height.mas_equalTo(nickLabelSize.height);
    }];
    
    
    CGSize nameLabelSize = [NSString sizeWithTextString:self.nameLabel.text textFont:self.nameLabel.font];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.avatarImgView.mas_right).mas_offset(kEdgeX);
        make.right.mas_equalTo(weakSelf.qrImgView.mas_left).mas_offset(-kEdgeX);
        make.height.mas_equalTo(nameLabelSize.height);
        make.bottom.mas_equalTo(weakSelf.avatarImgView.mas_bottom).mas_offset(-kEdgeY);
    }];
}

#pragma mark - actions

- (void)tapClick:(UITapGestureRecognizer *)tapgr {
    if (self.didSelect) {
        self.didSelect();
    }
}

- (void)setContent:(NSDictionary *)personInfoDic {
    if (personInfoDic[PIV_BgImage]) {
        self.bgImgView.image = personInfoDic[PIV_BgImage];
    }
    
    self.avatarImgView.image = personInfoDic[PIV_Image];
    self.nickNameLabel.text = personInfoDic[PIV_Nickname];
    self.nameLabel.text = [NSString stringWithFormat:@"%@:%@",  kAPP_DISPLAY_NAME, personInfoDic[PIV_Name]];
}

#pragma mark - getters
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        
    }
    return _bgImgView;
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.backgroundColor = [UIColor greenColor];
        _avatarImgView.clipsToBounds = YES;
//        _avatarImgView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImgView.layer.cornerRadius = 8.0;
        _avatarImgView.layer.borderColor = kRGB(236, 236, 236).CGColor;
        _avatarImgView.layer.borderWidth = 2.0;
    }
    return _avatarImgView;
}
- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = kGetThemeFont(17);
    }
    return _nickNameLabel;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kGetThemeFont(13);
    }
    return _nameLabel;
}
- (UIImageView *)rightArrowImgView {
    if (!_rightArrowImgView) {
        _rightArrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_arrow_right"]];
    }
    return _rightArrowImgView;
}
- (UIImageView *)qrImgView {
    if (!_qrImgView) {
        _qrImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qrimg"]];
    }
    return _qrImgView;
}



@end
