//
//  ZLPlayAudio.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/26.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import "ZLAudioPlayer.h"

@interface ZLAudioPlayer() {
    //组装并播放音效
    SystemSoundID soundID;
}



@end

@implementation ZLAudioPlayer

static id __sharedPlayer;
+ (instancetype)sharedPlayer {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        __sharedPlayer = [[ZLAudioPlayer alloc] init];
    });
    return __sharedPlayer;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)playAudioWithName:(NSString *)filename type:(NSString *)type {
    [self stopAudio];
    
    //音效文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, zlsoundCompleteCallback, NULL);
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(soundID);//播放音效
    //AudioServicesPlayAlertSound(soundID);//播放音效并震动
    
}

void zlsoundCompleteCallback(SystemSoundID soundid, void *clientData) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); //震动
    AudioServicesPlaySystemSound(soundid); // 播放系统声音 这里的sound是我自定义的，不要 copy 哈，没有的

    // 移除完成后执行的函数
    //    AudioServicesRemoveSystemSoundCompletion(soundid);
    //    // 根据ID释放自定义系统声音(如果确定不再使用，可以释放声音)
    //    AudioServicesDisposeSystemSoundID(soundid);
}

- (void)stopAudio {
    // 移除完成后执行的函数
    AudioServicesRemoveSystemSoundCompletion(soundID);
    // 根据ID释放自定义系统声音(如果确定不再使用，可以释放声音)
    AudioServicesDisposeSystemSoundID(soundID);
}



@end
