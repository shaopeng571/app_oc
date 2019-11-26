//
//  ZLViewController.m
//  SwiftExercises
//
//  Created by seer on 15/11/2017.
//  Copyright © 2017 seer. All rights reserved.
//

#import "ZLViewController.h"

@interface ZLViewController ()

@end

@implementation ZLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    NSLog(@"%f:%f", kSCREEN_WIDTH, kSCREEN_HEIGHT);
    
    if(__IPHONE_7_0) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    self.view.backgroundColor = kRGB(239, 239, 244);

    // 设置返回文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.tintColor = UIColor.whiteColor;
    self.navigationItem.backBarButtonItem = item;

    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        // 设置每个导航的第一个页面显示大标题
        ((UIViewController *)self.navigationController.viewControllers.firstObject).navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - actions

#pragma mark - 设置tabbar


@end
