//
//  ZLTabBarController.m
//  SwiftExercises
//
//  Created by seer on 15/11/2017.
//  Copyright © 2017 seer. All rights reserved.
//

#import "ZLTabBarController.h"

#import "ZLNavigationController.h"
#import "ZLViewController.h"

@interface ZLTabBarController ()

@end

@implementation ZLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ZLNavigationController *searchNVC = [self NVCFromVC:@"ViewController" TabTitle:@"查快递" tabItemImages:@[@"tab_search", @"tab_search"]];
    
//    ZLNavigationController *productNVC = [self NVCFromVC:@"ProductInViewController" TabTitle:@"商品信息" tabItemImages:@[@"tab_product", @"tab_product"]];
    
    ZLNavigationController *productNVC = [self NVCFromVC:@"ProductListViewController" TabTitle:@"商品信息" tabItemImages:@[@"tab_product", @"tab_product"]];
    
    
    ZLNavigationController *aboutNVC = [self NVCFromVC:@"AboutViewController" TabTitle:@"我的" tabItemImages:@[@"tab_about", @"tab_about"]];
    
    
    self.viewControllers = @[searchNVC, productNVC, aboutNVC];
    
    
    
    
    
    [self setAppearance];
    
    [self addNotifications];
}

- (void)setAppearance {
    
    //  设置tabBar背景色
//        [[UITabBar appearance] setBackgroundImage:[UIImage new]];
//        self.tabBar.backgroundColor = UIColor.whiteColor;
//        [[UITabBar appearance] setBackgroundColor:[UIColor redColor]];
    // 渲染Tabbar的颜色
    self.tabBar.barTintColor = UIColor.whiteColor;
    
    // 渲染Tabbar上元素的颜色，会将图标和文字同时渲染，也可以分开渲染
    self.tabBar.tintColor = kGetThemeColor;
    
    //  设置tabBar图标为原色
//    for (UINavigationController *nvc in self.viewControllers) {
//        nvc.tabBarItem.image = [nvc.tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        nvc.tabBarItem.selectedImage = [nvc.tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }
    
    // tabbar文字颜色
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kRGB(136, 115, 155),NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateNormal];

//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kGetThemeColor, NSFontAttributeName:[UIFont systemFontOfSize:11]} forState:UIControlStateSelected];
}

#pragma mark - actions

/** 初始化一个包裹着指定VC的NVC */
- (ZLNavigationController *)NVCFromVC:(NSString *)vcClassStr TabTitle:(NSString *)title tabItemImages:(NSArray *)imageNames{
    
    Class VCclazz =  NSClassFromString(vcClassStr);
    
    ZLViewController *vc = (ZLViewController *)[[VCclazz alloc] init];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageNames[0]];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:imageNames[1]];
    vc.title = title;
    
    ZLNavigationController *NVC = [[ZLNavigationController alloc] initWithRootViewController:vc];

    return NVC;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(changeColor)
     name:ThemeColorChangeNotification object:nil];
}
- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeColor {
    [self setAppearance];
}

- (void)dealloc {
    [self removeNotifications];
}


@end
