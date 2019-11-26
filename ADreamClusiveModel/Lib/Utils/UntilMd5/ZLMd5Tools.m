//
//  ZLMd5Tools.m
//  ADreamClusive
//
//  Created by ADreamClusive on 16/11/22.
//  Copyright © 2016年 ADreamClusive. All rights reserved.
//

#import "ZLMd5Tools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ZLMd5Tools

#pragma mark - 32位MD5加密
//md5 加密字符串
+ (NSString *) md5:(NSString *)str {
    
    if (str == nil) {
        return nil;
    }
    const char *cstr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), digest);
    
    NSMutableString *MD5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [MD5Str appendFormat:@"%02x", digest[i]];
    
    return MD5Str;
}

//md5 加密文件内容
+ (NSString *) md5ForFileContent:(NSString *)file {
    
    if( nil == file ){
        return nil;
    }
    
    NSData * data = [NSData dataWithContentsOfFile:file];
    
    return [self md5ForData:data];
}

//md5 加密data
+ (NSString *) md5ForData:(NSData *)data{
    
    if( !data || ![data length] ) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    
    NSMutableString *MD5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [MD5Str appendFormat:@"%02X", digest[i]];
    
    return MD5Str;
}

#pragma mark - 16位MD5加密
+(NSString *) md5With16Rate:(NSString *)str{
    NSString *md5Str = [self md5:str];
    if (!md5Str) {
        return nil;
    }
    NSString *string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    return string;
}

#pragma mark -
+ (NSString *)sha1:(NSString *)str {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([data bytes], (CC_LONG)[data length], digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

@end
