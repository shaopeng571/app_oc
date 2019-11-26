#import "ChineseToPinyin.h"

@implementation ChineseToPinyin

+ (NSString *)pinyinFromChineseString:(NSString *)chinese{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
//    NSLog(@"%@", pinyin);
    
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
//    NSLog(@"%@", pinyin);
    
    //返回最近结果
    return pinyin;
    
}

@end
