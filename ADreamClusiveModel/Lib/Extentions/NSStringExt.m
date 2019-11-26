//
//  NSStringExt.m
//  SwiftExercises
//
//  Created by ADreamClusive on 16/11/2017.
//  Copyright © 2017 ADreamClusive. All rights reserved.
//

#import "NSStringExt.h"


@implementation NSString (ZL)

#pragma mark - 字符串中空格处理
- (NSString *)clearEdgeSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)clearEdgeSpaceAndNewLine {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)clearAllSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)clearAllNewLine {
    return [self stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
}

- (NSString *)clearAllSpaceAndNewLine {
    return [[self clearAllSpace] clearAllNewLine];
}

- (NSString *)replaceString:(NSString *)oldStr withString:(NSString *)newStr {
    return [self stringByReplacingOccurrencesOfString:oldStr withString:newStr];
}

#pragma mark - 获取字符串中的电话号码
- (NSDictionary *)phoneNums {
    //获取字符串中的电话号码
    NSString *regulaStr = @"\\d{3,4}[- ]?\\d{7,8}";
    NSRange stringRange = NSMakeRange(0, self.length);
    //正则匹配
    NSError *error;
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:regulaStr options:0 error:&error];
    
    if (!error && regexps != nil) {
        __weak __typeof(self) weakSelf = self;
        [regexps enumerateMatchesInString:self options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            [resultDic setObject:[weakSelf substringWithRange:result.range] forKey:NSStringFromRange(result.range)];
        }];
    }
    return resultDic;
}


#pragma mark - 字符串size处理
+ (CGSize)sizeWithTextString:(NSString *)textString textFont:(UIFont *)textFont
{
    return [NSString sizeWithTextString:textString textFont:textFont maxWidth:MAXFLOAT];
}
+ (CGSize)sizeWithTextString:(NSString *)textString textFont:(UIFont *)textFont maxWidth:(CGFloat)maxWidth
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = textFont;
    CGSize size = CGSizeMake(maxWidth, MAXFLOAT);
    return [textString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
}



#pragma mark - 字符串中数字的处理
- (NSAttributedString *)changeNumberWithColor:(UIColor *)color {
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSString *pattern = @"\\d+";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult *result in results) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:result.range];
    }
    return attrStr;
}
- (NSAttributedString *)changeNumberColor:(UIColor *)color
                                 withFont:(CGFloat)font
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSString *pattern = @"\\d+";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult *result in results) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:result.range];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:result.range];
    }
    if ([self rangeOfString:@"."].location != NSNotFound) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:[self rangeOfString:@"."]];
    }
    return attrStr;
}

#pragma mark - 添加中划线和下划线
- (NSMutableAttributedString *)addStrikethroughWithColor:(UIColor *)color fontSize:(float)fontsize {
    NSDictionary *attribtDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontsize],
//                                 NSForegroundColorAttributeName:[UIColor redColor],
                                 NSUnderlineColorAttributeName:color,
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
    return attribtStr;
}

- (NSMutableAttributedString *)addUnderlineWithColor:(UIColor *)color fontSize:(float)fontsize {
    NSDictionary *attribtDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontsize],
//                                 NSForegroundColorAttributeName:[UIColor redColor],
                                 NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                                 NSUnderlineColorAttributeName:color,
                                 };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
    return attribtStr;
}




#pragma mark - 判断是否包含中文字符
- (BOOL)isIncludeChinese {
    for (int i=0; i<[self length]; i++) {
        int a = [self characterAtIndex:i];
        if(a>0x4e00 && a<0x9fff) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 获取n个随机数
+ (NSString *)randomStringLength:(NSInteger)len {
    NSMutableString *randomStr = [[NSMutableString alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < len; i++) {
        [randomStr appendString:[NSString stringWithFormat:@"%u", arc4random_uniform(10)]];
    }
    return [randomStr copy];
}

#pragma mark - 检查两个字符串的相似度

static inline int min(int a, int b) {
    return a < b ? a : b;
}

+ (float)likePercentByCompareOriginText:(NSString *)originText targetText:(NSString *)targetText{
    
    //length
    int n = (int)originText.length;
    int m = (int)targetText.length;
    if (n == 0 || m == 0) {
        return 0.0;
    }
    
    //Construct a matrix, need C99 support
    int N = n+1;
    int **matrix;
    matrix = (int **)malloc(sizeof(int *)*N);
    
    int M = m+1;
    for (int i = 0; i < N; i++) {
        matrix[i] = (int *)malloc(sizeof(int)*M);
    }
    
    for (int i = 0; i<N; i++) {
        for (int j=0; j<M; j++) {
            matrix[i][j]=0;
        }
    }
    
    for(int i=1; i<=n; i++) {
        matrix[i][0]=i;
    }
    for(int i=1; i<=m; i++) {
        matrix[0][i]=i;
    }
    for(int i=1;i<=n;i++)
    {
        unichar si = [originText characterAtIndex:i-1];
        for(int j=1;j<=m;j++)
        {
            unichar dj = [targetText characterAtIndex:j-1];
            int cost;
            if(si==dj){
                cost=0;
            }
            else{
                cost=1;
            }
            const int above = matrix[i-1][j]+1;
            const int left = matrix[i][j-1]+1;
            const int diag = matrix[i-1][j-1]+cost;
            matrix[i][j] = min(above, min(left,diag));
        }
    }
    return 100.0 - 100.0*matrix[n][m]/MAX(m,n);
}

@end
