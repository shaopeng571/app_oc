//
//  IrregularShapeVC.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/15.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "IrregularShapeVC.h"
#import "OBShapedButton.h"
@interface IrregularShapeVC ()

@end

@implementation IrregularShapeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *bgmapiv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavigationBarHeight)];
    bgmapiv.image = [UIImage imageNamed:@"map"];
    [self.view addSubview:bgmapiv];
    
    
    OBShapedButton *obbutton = [[OBShapedButton alloc] initWithFrame:bgmapiv.bounds];
    [obbutton setImage:[UIImage imageNamed:@"SanMing"] forState:UIControlStateNormal];
    [self.view addSubview:obbutton];
    [obbutton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click:(id)sender {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"测试"
                                                                       message:@"你选中了三明市"
                                                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:nil];
    [alertView addAction:okAction];
    [self presentViewController:alertView
                       animated:YES
                     completion:nil];
}

@end
