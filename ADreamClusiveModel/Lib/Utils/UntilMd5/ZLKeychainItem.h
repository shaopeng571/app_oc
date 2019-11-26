//
//  ZLKeyChain.h
//  ADreamClusive
//
//  Created by ADreamClusive on 2017/5/9.
//  Copyright © 2017年 ADreamClusive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLKeychainItem : NSObject

+ (id)readForKey:(NSString *)key;

+ (void)deleteWithService:(NSString *)service;

+ (void)addKeychainData:(id)data forKey:(NSString *)key;

@end
