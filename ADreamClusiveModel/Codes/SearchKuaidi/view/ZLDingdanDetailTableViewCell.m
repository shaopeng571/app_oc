//
//  ZLDingdanDetailTableViewCell.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/15.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLDingdanDetailTableViewCell.h"

@interface ZLDingdanDetailTableViewCell() <UITextViewDelegate>

@property (nonatomic, strong) ZLLabel *dingdanLabel;

@property (nonatomic, strong) UITextView *dingdanView;

@property (nonatomic, strong) DingdanInfoOneItem *item;

@end

@implementation ZLDingdanDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self addSubview:self.dingdanLabel];
        [self addSubview:self.dingdanView];
    }
    return self;
}

//cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", item.ftime, item.context];
- (void)setContentWithItem:(DingdanInfoOneItem *)item {
    self.item = item;
    
    NSMutableAttributedString *allStr = [NSMutableAttributedString new];
    
    NSAttributedString *aAttrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", item.ftime] attributes:@{NSForegroundColorAttributeName:kRGB(1, 106, 252) }];
    
    [allStr appendAttributedString:aAttrStr];
    
    NSMutableAttributedString *itemcontext = [[NSMutableAttributedString alloc] initWithString:item.context];
    NSDictionary *phoneNums = [item.context phoneNums];
    if (phoneNums && phoneNums.allKeys.count>0) {
        [phoneNums enumerateKeysAndObjectsUsingBlock:^(NSString *rangeStr, NSString *phonenum, BOOL * _Nonnull stop) {
            [itemcontext addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"tel:%@",phonenum] range:NSRangeFromString(rangeStr)];
        }];
    }
    
    [allStr appendAttributedString:itemcontext];
//    [allStr appendAttributedString:[self distinguishPhoneNums:item.context]];
    
    [allStr addAttribute:NSFontAttributeName value:kGetThemeFont(14) range:NSMakeRange(0, allStr.length)];
    
    
    
    self.dingdanView.attributedText = allStr;
    
}
-(NSAttributedString *)distinguishPhoneNums:(NSString *)labelStr{

    //获取字符串中的电话号码
    NSString *regulaStr = @"\\d{3,4}[- ]?\\d{7,8}";
    NSRange stringRange = NSMakeRange(0, labelStr.length);
    //正则匹配
    NSError *error;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:labelStr];
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];
    
    [str addAttribute:NSForegroundColorAttributeName value:UIColor.lightGrayColor range:stringRange];
    
    if (!error && regexps != nil) {
        [regexps enumerateMatchesInString:labelStr options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            NSRange phoneRange = result.range;
            [str addAttribute:NSLinkAttributeName
                        value:[NSString stringWithFormat:@"tel:%@", [[str attributedSubstringFromRange:phoneRange] string]]
                        range:phoneRange];
        }];
    }
    return str;
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSLog(@"%@", URL.absoluteString);
    
    return YES;
}

- (void)layoutSubviews {
    

    CGFloat height = [NSString sizeWithTextString:[NSString stringWithFormat:@"%@ %@", self.item.ftime, self.item.context].clearEdgeSpace textFont:kGetThemeFont(14) maxWidth:kSCREEN_WIDTH-20].height;
    
    self.dingdanView.frame = CGRectMake(10, 10, kSCREEN_WIDTH-20, height);
    
}

- (ZLLabel *)dingdanLabel {
    if (_dingdanLabel==nil) {
        _dingdanLabel = [[ZLLabel alloc] initWithFrame:CGRectZero edgeInsets:UIEdgeInsetsZero];
        _dingdanLabel.numberOfLines = 0;
        _dingdanLabel.textColor = kRGB(40, 40, 40);
        _dingdanLabel.font = kGetThemeFont(14);
        _dingdanLabel.backgroundColor = [UIColor greenColor];
    }
    return _dingdanLabel;
}
- (UITextView *)dingdanView {
    if (_dingdanView==nil) {
        _dingdanView = [[UITextView alloc] init];
        _dingdanView.textContainerInset = UIEdgeInsetsZero;
        _dingdanView.contentInset = UIEdgeInsetsZero;
        _dingdanView.textContainer.lineFragmentPadding = 0; // 单行左右边距为0
        _dingdanView.editable = NO;
        _dingdanView.scrollEnabled = NO;
        _dingdanView.font = kGetThemeFont(14);
        _dingdanView.textAlignment = NSTextAlignmentLeft;
//        _dingdanView.backgroundColor = UIColor.greenColor;
        //    设置点击时的样式
        NSDictionary *linkAttributes =@{NSForegroundColorAttributeName:kRGB(245, 129, 0),
                                        NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                        NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
        //    添加链接文字
        _dingdanView.linkTextAttributes = linkAttributes;
        /** 设置自动检测类型为链接网址. */
        _dingdanView.dataDetectorTypes = UIDataDetectorTypeLink;
        _dingdanView.delegate = self;
    }
    return _dingdanView;
}

@end
