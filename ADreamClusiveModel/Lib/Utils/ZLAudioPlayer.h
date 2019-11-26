//
//  ZLPlayAudio.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/26.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLAudioPlayer : NSObject

+ (instancetype)sharedPlayer;

- (void)playAudioWithName:(NSString *)filename type:(NSString *)type;

- (void)stopAudio;


@end

NS_ASSUME_NONNULL_END
