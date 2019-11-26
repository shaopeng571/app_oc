//
//  LocationManager.h
//  ADreamClusiveModel
//
//  Created by 西禾口语 2018 on 2018/11/28.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject

+ (id)sharedInstance;

- (void)getLocation;

- (void)setLatestLocation:(CLLocation *)location;

- (CLLocation *)getLatestLocation;

- (NSDictionary *)addressDic;


@end

NS_ASSUME_NONNULL_END
