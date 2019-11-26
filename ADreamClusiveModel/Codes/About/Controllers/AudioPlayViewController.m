//
//  AudioPlayViewController.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/26.
//  Copyright © 2018 Jiaozl. All rights reserved.
//

#import "AudioPlayViewController.h"
#import "ZLButtonFactory.h"




//static AudioPlayViewController *cself = nil;

@interface AudioPlayViewController () <AVAudioPlayerDelegate>

/** 播放器 */
@property (nonatomic, strong) AVAudioPlayer *playera;
/** 播放进度条 */
@property (strong, nonatomic) UIProgressView *progress;
/** 改变播放进度滑块 */
@property (strong, nonatomic) UISlider *progressSlide;
/** 改变声音滑块 */
@property (strong, nonatomic) UISlider *volum;
/** 改变进度条滑块显示的定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;;

@end

@implementation AudioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [ZLButtonFactory buttonWithTitle:@"播放系统声音--5s" image:[UIImage imageNamed:@"about_audio"] frame:CGRectMake(0, 10, 200, 32) target:self selector:@selector(btnClick:)];
    button.tag = 100+1;
    [self.view addSubview:button];

    UIButton *button1 = [ZLButtonFactory buttonWithTitle:@"播放声音" image:[UIImage imageNamed:@"about_audio"] frame:CGRectMake(0, 10+button.bottom, 150, 32) target:self selector:@selector(btnClick:)];
    button1.tag = 100+2;
    [self.view addSubview:button1];

    UIButton *button2 = [ZLButtonFactory buttonWithTitle:@"播放在线音乐" image:[UIImage imageNamed:@"about_audio"] frame:CGRectMake(0, 10+button1.bottom, 200, 32) target:self selector:@selector(btnClick:)];
    button2.tag = 100+3;
    [self.view addSubview:button2];

//    cself = self;







    UIButton *playbtn = [ZLButtonFactory buttonWithTitle:@"播放" image:[UIImage imageNamed:@"about_audio"] frame:CGRectMake(button1.right+5, button1.top, 80, 32) target:self selector:@selector(playera:)];

    [self.view addSubview:playbtn];

    UIButton *playbtn2 = [ZLButtonFactory buttonWithTitle:@"暂停" image:[UIImage imageNamed:@"about_audio"] frame:CGRectMake(playbtn.right+5, playbtn.top, 80, 32) target:self selector:@selector(stop:)];

    [self.view addSubview:playbtn2];

    self.progress = [[UIProgressView alloc] initWithFrame:CGRectMake(10, button2.bottom+10, kSCREEN_WIDTH-2*10, 30)];
    self.progress.progress = 0;
    [self.view addSubview:self.progress];

    self.progressSlide = [[UISlider alloc] initWithFrame:CGRectMake(50, self.progress.bottom+10, kSCREEN_WIDTH-2*50, 30)];
    [self.progressSlide addTarget:self action:@selector(progressChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.progressSlide];
    self.progressSlide.value = 0;

    self.volum = [[UISlider alloc] initWithFrame:CGRectMake(50, self.progressSlide.bottom+10, kSCREEN_WIDTH-2*50, 30)];
    [self.volum addTarget:self action:@selector(volumChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.volum];
    self.volum.value = 0.1;

    NSError *err;
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"alarm1-b238" ofType:@"mp3"];
    //    NSURL *url = [NSURL URLWithString:filePath];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"alarm1-b238" withExtension:@"mp3"];
//     初始化播放器
    _playera = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    self.volum.value = 0.5;
    // 设置播放器声音
    _playera.volume = self.volum.value;
    // 设置代理
    _playera.delegate = self;
    // 设置播放速率
    _playera.rate = 1.0;
    // 设置播放次数 负数代表无限循环
    _playera.numberOfLoops = -1;
    // 准备播放
    [_playera prepareToPlay];
    self.progress.progress = 0;
    self.progressSlide.value = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(change) userInfo:nil repeats:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [_player pause];
    [_playera stop];
    [self removeObserver];
}

- (void)change {
    if (_playera.playing) {
        self.progress.progress = _playera.currentTime / _playera.duration;
        self.progressSlide.value = self.progress.progress;
    }
}
- (void)progressChange:(UISlider *)sender {
    if (_playera.playing) {
        // 改变当前的播放进度
        _playera.currentTime = sender.value * _playera.duration;
        self.progress.progress = sender.value;
    } else if(_player.status == AVPlayerStatusReadyToPlay) {
        [self changeProgress:sender];
    }
}
- (void)volumChange:(UISlider *)sender {
    
    // 改变声音大小
    _playera.volume = sender.value;
}
- (void)playera:(id)sender {
    
    // 开始播放
    [_playera play];
}
- (void)stop:(id)sender {
    // 暂停播放
    [_playera pause];
}

#pragma mark --AVAudioPlayerDelegate
/** 完成播放， 但是在打断播放和暂停、停止不会调用 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {

}
/** 播放过程中解码错误时会调用 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    
}
/** 播放过程被打断 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player NS_DEPRECATED_IOS(2_2, 8_0) {
    
}
/** 打断结束 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags NS_DEPRECATED_IOS(6_0, 8_0) {
    
}
/** 打断结束 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags NS_DEPRECATED_IOS(4_0, 6_0) {
    
}







- (void)btnClick:(UIButton *)sender {
    switch(sender.tag-100) {
        case 1:{ // 系统声音
            /*
             * 自定义音效
             **/
            [[ZLAudioPlayer sharedPlayer] playAudioWithName:@"8378" type:@"wav"];
            
            
            [[ZLAudioPlayer sharedPlayer] performSelector:@selector(stop) withObject:nil afterDelay:5];
           
        }
            break;
            
        case 2:{ // 普通声音
            // 开始播放
            [_playera play];
        }
            break;
            
        case 3:{ // 在线音乐
            [self player];
            [self play:nil];
        }
            break;
            
        default:{
            
        }
            break;
    }
}


- (AVPlayerItem *)getItemWithIndex:(NSInteger)index {
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.158/alarm1-b238.mp3"];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    //KVO监听播放状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //KVO监听缓存大小
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //通知监听item播放完毕
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playOver:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    return item;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *item = object;
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"未知状态，不能播放");
            break;
            case AVPlayerStatusReadyToPlay:
            NSLog(@"准备完毕，可以播放");
            break;
            case AVPlayerStatusFailed:
            NSLog(@"加载失败, 网络相关问题");
            break; default: break;
        }
    }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *array = item.loadedTimeRanges;
        //本次缓存的时间
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        NSTimeInterval totalBufferTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //缓存的总长度
//        self.bufferProgress.progress = totalBufferTime / CMTimeGetSeconds(item.duration);
    }
}

- (AVPlayer *)player {
    if (!_player) {
        // 根据链接数组获取第一个播放的item， 用这个item来初始化AVPlayer
        AVPlayerItem *item = [self getItemWithIndex:0];
        /** 播放器 */
        // 初始化AVPlayer
        _player = [[AVPlayer alloc] initWithPlayerItem:item];
        __weak typeof(self)weakSelf = self;
        // 监听播放的进度的方法，addPeriodicTime: ObserverForInterval: usingBlock:
        /*
         DMTime 每到一定的时间会回调一次，包括开始和结束播放
         block回调，用来获取当前播放时长
         return 返回一个观察对象，当播放完毕时需要，移除这个观察
         */
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 10) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            if (current) {
                [weakSelf.progress setProgress:current / CMTimeGetSeconds(item.duration) animated:YES];
                weakSelf.progressSlide.value = current / CMTimeGetSeconds(item.duration);
            }
        }];
    }
    return _player;
}

//  播放
- (void)play:(id)sender {
    [self.player play];
}

//暂停
- (void)pause:(id)sender {
    [self.player pause];
}

- (void)playOver:(id)sender {
    [self next:sender];
}

- (void)next:(UIButton *)sender {
    [self removeObserver];
//    self.currentIndex ++;
//    if (self.currentIndex >= self.musicArray.count) {
//        self.currentIndex = 0;
//
//    }
    // 这个方法是用一个item取代当前的item
    [self.player replaceCurrentItemWithPlayerItem:[self getItemWithIndex:0]];
    [self.player play];

}
//- (IBAction)last:(UIButton *)sender {
//    [self removeObserver];
//    self.currentIndex --;
//    if (self.currentIndex < 0) {
//        self.currentIndex = 0;
//
//    }
//    // 这个方法是用一个item取代当前的item
//    [self.player replaceCurrentItemWithPlayerItem:[self getItemWithIndex:self.currentIndex]];
//    [self.player play];
//
//}
// 在播放另一个时，要移除当前item的观察者，还要移除item播放完成的通知
- (void)removeObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)changeProgress:(UISlider *)sender {
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        [self.player seekToTime:CMTimeMake(CMTimeGetSeconds(self.player.currentItem.duration) * sender.value, 1)];
    }
}


- (void)dealloc
{
    //
    NSLog(@"dealloc");
}


@end
