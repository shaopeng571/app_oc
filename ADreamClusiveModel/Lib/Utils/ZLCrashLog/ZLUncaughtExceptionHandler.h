//
//  ZLUncaughtExceptionHandler.h
//  UncaughtExceptionDemo
//
//  Created by ADreamClusive 2018 on 2018/10/19.
//  Copyright © 2018年  ADreamClusive. All rights reserved.
//

#import <Foundation/Foundation.h>

//#include <libkern/OSAtomic.h>
#include <execinfo.h>


NS_ASSUME_NONNULL_BEGIN

@interface ZLUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;

@end

NS_ASSUME_NONNULL_END
