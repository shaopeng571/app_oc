//
//  FontSettingViewController.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "FontSettingViewController.h"
#import "FontsizeSliderView.h"
@interface FontSettingViewController ()

@property (nonatomic, strong) UILabel *sampleTextLabel;

@property(nonatomic,strong) FontsizeSliderView *fontSliderView;


@end

@implementation FontSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"字体大小";
    
    [self.view addSubview:self.sampleTextLabel];
    
    self.sampleTextLabel.text = @"一汽-大众高尔夫·嘉旅的外观与进口大众高尔夫Sportsvan车型基本一致，没有进行国产化的调整。扁平化的车头营造出宽体的视觉效果，车顶配备的铝合金行李架不仅美观，也为扩充装载能力提供了帮助。宽大的车尾搭配上短小的尾翼，使车尾更显灵动。\n车身尺寸方面，新车长宽高分别为4348mm/1807mm/1574mm，轴距2680mm。相比高尔夫车型，新车的轴距多出了43mm。\n空间方面无疑是高尔夫·嘉旅的最大优势，身高175cm的体验者坐在前排，可以获得一拳四指的头部空间，而保持前排座椅不动，体验者移至后排后，可以获得两拳左右的腿部空间以及一拳左右的头部空间。另外，值得一提的是，高尔夫·嘉旅的第二排座椅不仅支持靠背角度调节，且还支持前后调节。";
    
    [self setupAppearance];
    
    [self addNotifications];
    

    self.fontSliderView = [[FontsizeSliderView alloc] initWithFrame:CGRectMake(10, kSCREEN_HEIGHT-130-kNavigationBarHeight-40, kSCREEN_WIDTH-20, 130)];
    self.fontSliderView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.fontSliderView];
}


#pragma mark - actions
- (void)setupAppearance {
    self.sampleTextLabel.textColor = kGetThemeColor;
    
    self.sampleTextLabel.font = kGetThemeFont(14);
    
    CGSize textsize = [NSString sizeWithTextString:self.sampleTextLabel.text textFont:self.sampleTextLabel.font maxWidth:self.sampleTextLabel.width];
    
    self.sampleTextLabel.height = textsize.height;
}


#pragma mark - Notifications

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setupAppearance)
     name:ThemeFontChangeNotifocation object:nil];
}
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc {
    [self removeNotifications];
}



#pragma mark - getters
- (UILabel *)sampleTextLabel {
    if (!_sampleTextLabel) {
        _sampleTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, kNavigationBarHeight+8, kSCREEN_WIDTH-16, 10)];
        _sampleTextLabel.numberOfLines = 0;
//        _sampleTextLabel.backgroundColor = UIColor.whiteColor;
    }
    return _sampleTextLabel;
}





@end
