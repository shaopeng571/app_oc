//
//  UILabel+Alignment.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/26.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "UILabel+Alignment.h"
#import <CoreText/CoreText.h>

@implementation UILabel (Alignment)





- (void)changeAlignmentRightandLeft {
    CGRect textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil];
    CGFloat margin = (self.frame.size.width - textSize.size.width) / (self.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributeString addAttribute:(id)kCTKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1)];
    self.attributedText = attributeString;
}

@end
