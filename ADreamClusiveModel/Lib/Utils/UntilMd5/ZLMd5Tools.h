//
//  ZLMd5Tools.h
//  ADreamClusive
//
//  Created by ADreamClusive on 16/11/22.
//  Copyright © 2016年 ADreamClusive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLMd5Tools : NSObject

/** 32位MD5加密 */
+ (NSString *) md5:(NSString *)str;
+ (NSString *) md5ForFileContent:(NSString *)file;
+ (NSString *) md5ForData:(NSData *)data;
/** 16位MD5加密 */
+ (NSString *) md5With16Rate:(NSString *)str;


+ (NSString *)sha1:(NSString *)str;

@end
