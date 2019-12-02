//
//  SLTNullUtil.h
//  SLTDriver
//
//  Created by zl jiao on 2019/12/2.
//  Copyright © 2019 oyahaok. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NIL_STRING_RETURN(CONTENT, MESSAGE) \
if ([SLTNullUtil isBlankString:CONTENT]) { \
[MBProgressHUD showError:MESSAGE];                                    \
return;                                                               \
}
#define NIL_NIL_STRING_RETURN_NO(CONTENT, MESSAGE) \
if ([SLTNullUtil isBlankString:CONTENT]) { \
[MBProgressHUD showError:[NIL_STRING(MESSAGE) clearAllSpace]];                                    \
return NO;                                                               \
}


NS_ASSUME_NONNULL_BEGIN

@interface SLTNullUtil : NSObject

#pragma mark Null判断
+ (BOOL)isBlankString:(NSString *)aStr;

+ (BOOL)isBlankNumber:(NSNumber *)aNum;

+ (BOOL)isBlankArr:(NSArray *)arr;

+ (BOOL)isBlankDictionary:(NSDictionary *)dic;

#pragma mark Null转换
+ (NSString *)nullToString:(id)string;

+ (NSNumber *)nullToNumber:(id)num;

+ (NSArray *)nullToArray:(id)array;

+ (NSDictionary *)nullToDictionary:(id)dict;


@end

NS_ASSUME_NONNULL_END
