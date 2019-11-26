//
//  ZLNavigationController.m
//  SwiftExercises
//
//  Created by seer on 15/11/2017.
//  Copyright © 2017 seer. All rights reserved.
//

#import "ZLNavigationController.h"

@interface ZLNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation ZLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupAppearance];
    
    [self addNotifications];
    
    [self addFullScreenBackGesture];
}

- (void)addFullScreenBackGesture {
    //  这句很核心 稍后讲解
    id target = self.interactivePopGestureRecognizer.delegate;
    //  这句很核心 稍后讲解
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;

    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer *fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];

    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    //解决与左滑手势冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    // 过滤执行过渡动画时的手势处理
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    return self.childViewControllers.count == 1 ? NO : YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
//    // 修改tabBra的frame
//    CGRect frame = self.tabBarController.tabBar.frame;
//
//    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
//
//    self.tabBarController.tabBar.frame = frame;
}

- (void)setupAppearance {
    //    self.navigationBar.backgroundColor = kRGB(255, 0, 0);  // 只是设置的背景色，并不能很好的显示
    self.navigationBar.barTintColor = kGetThemeColor;
    
    if (@available(iOS 11.0, *)) {
        //导航大标题, 上滑到顶部时动态切换大小标题样式 (导航栏高度UINavigationBar = 44/96)
        self.navigationBar.prefersLargeTitles = kGetThemeLargeTitle;
        
        //        // 设置大标题颜色等属性
        //        [self.navigationBar setLargeTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        //        // 设置标题属性
        //        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
    } else {
        // Fallback on earlier versions
    }
}


- (void)addNotifications {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setupAppearance)
     name:ThemeColorChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(setupAppearance)
     name:ThemeLargeTitleChangeNotifocation object:nil];
}
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self removeNotifications];
}


@end
