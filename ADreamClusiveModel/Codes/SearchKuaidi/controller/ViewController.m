//
//  ViewController.m
//  ADreamClusiveModel
//
//  Created by Jiaozl 2018 on 2018/10/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ViewController.h"
#import "DingdanInfoItem.h"
#import "ZLMenuAlert.h"
#import "ZLDingdanDetailVC.h"
@interface ViewController () <UITextFieldDelegate>

@property (strong, nonatomic) DingdanInfoItem *dingdanInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBgView;
@property (weak, nonatomic) IBOutlet UITextField *copanyTF;
@property (weak, nonatomic) IBOutlet UITextField *dingdanTF;
@property (weak, nonatomic) IBOutlet UIButton *searchDingdanBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) ZLMenuAlert * alert;

@property (strong, nonatomic) NSDictionary *copanyDic;
@property (strong, nonatomic) NSMutableArray *alertSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // scrollview中设置约束，label长度超过scrollview后，会使scrollview的size受到影响
    self.messageLabel.frame = CGRectMake(16, self.searchDingdanBtn.bottom+10, kSCREEN_WIDTH-32, 100);
    
    
    self.copanyTF.delegate = self;
    
    self.copanyDic = [self readPlistWithName:@"CopanysModel"];
    
    NSLog(@"go to ViewController")
    
    self.scrollBgView.contentSize = CGSizeMake(kSCREEN_WIDTH, self.messageLabel.bottom + 40);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.copanyTF) {
        [self showAlertMenu];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.copanyTF) {
        if (self.alert) {
            [self.alert removeFromSuperview];
        }
    }
    return YES;
}

- (id)readPlistWithName:(NSString *)pname {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:pname ofType:@"plist"];

    return [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
}

- (void)showAlertMenu {
    __weak typeof(self) weakSelf = self;
    if (self.alert) {
        [self.alert removeFromSuperview];
    } else {
        self.alert =  [[ZLMenuAlert alloc] initWithFrame:CGRectMake(self.copanyTF.left, self.copanyTF.bottom + 3.0, self.copanyTF.width, 120)];
        self.alert.tabColor = kRGB(208, 210, 217);
        
        self.alert.arrMDataSource = self.copanyDic.allKeys;
        [self.alert setDidSelectedCallback:^(NSInteger index, NSString *content) {
            //回调中要实现的功能.
            weakSelf.copanyTF.text = content;
            
            [weakSelf.alert removeFromSuperview];
            
            [weakSelf resignFirstResponder];
            
            weakSelf.alert = nil;
        }];
    }
    
    [self.view addSubview:self.alert];
    
    
    
}

- (IBAction)searchDingdan:(id)sender {
//    int list[2]={1,2};
//    int *p = list;
//    free(p);//导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
//    p[1] = 5;
//    
//    
//    NSArray *array = @[@(1), @(2), @(3)];
//
//
//    self.copanyTF.text = array[3];
    
    
//    NSInteger timestamp = [NSDate timestampFromDateString:@"2018-12-18 12:00:00" format:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *datestr = [NSDate stringFromTimestamp:timestamp withDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    
//    NSString *datestr2 = [NSDate stringFromDate:[NSDate date] format:@"YYYY-MM-dd HH:mm:ss"];
//    
//    NSDate *date = [NSDate dateFromString:datestr2 format:@"YYYY-MM-dd HH:mm:ss"];
//    
//    NSString *weekstr = [NSDate weekdayStringFromDate:date];
//    
//    self.messageLabel.text = [NSString stringWithFormat:@"%ld  %@\n%@ %@\n%@", timestamp, datestr, datestr2, date, weekstr];
    
    
    NSString *copanystr = [ZLCheckNullUtils replaceNullValue:self.copanyTF.text].clearEdgeSpace;
    NSString *dingdanNum = [ZLCheckNullUtils replaceNullValue:self.dingdanTF.text].clearEdgeSpace;
    
//    dingdanNum = @"801942121705668823";
    
    dingdanNum = [dingdanNum isEqualToString:@""]?@"75100657843281":dingdanNum;
    
    if([copanystr isEqualToString:@""]) {
        [self.view makeToast:@"快递公司不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    if ([dingdanNum isEqualToString:@""]) {
        [self.view makeToast:@"快递单号不能为空" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    
    
    
    [self getKuaidiInfo:@{@"type":self.copanyDic[copanystr]?:[ChineseToPinyin pinyinFromChineseString:copanystr],
                          @"postid":dingdanNum
                          }];
}

- (void)getKuaidiInfo:(NSDictionary *)parameters {
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.kuaidi100.com/query?type=%@&postid=%@", parameters[@"type"], parameters[@"postid"]];
    
    [ZLNetworkTools POST:urlStr parameters:@{} success:^(NSDictionary *success) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        weakSelf.dingdanInfo = [DingdanInfoItem mj_objectWithKeyValues:success];
        
        [weakSelf updateUI];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}




- (void)updateUI {
    NSString *appendStr = @"";
    switch (self.dingdanInfo.status) {
        case 200: // 成功
            self.messageLabel.textColor = UIColor.greenColor;
            break;
        case 201: // 异常
            self.messageLabel.textColor = UIColor.redColor;
            break;
            
        case 400: // 异常
            self.messageLabel.textColor = UIColor.redColor;
            appendStr = @"您输入的信息不存在";
            break;
            
        default:
            break;
    }
    
    self.messageLabel.text = [NSString stringWithFormat:@"查询状态：%@", [appendStr isEqualToString:@""]?self.dingdanInfo.message:appendStr];
    
    if (self.dingdanInfo.status == 200) {
        ZLDingdanDetailVC *dingdanDetailVC = [[ZLDingdanDetailVC alloc] init];
        dingdanDetailVC.dingdanInfos = self.dingdanInfo.data;
        [self.navigationController pushViewController:dingdanDetailVC animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self resignFirstResponder];
}




@end
