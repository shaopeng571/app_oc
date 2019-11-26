//
//  FirstViewController.m
//  ADreamClusive
//
//  Created by ADreamClusive on 17/1/14.
//  Copyright © 2017年 ADreamClusive. All rights reserved.
//

#import "CommonSettingViewController.h"
#import "CommonSettingItem.h"
#import "SectionHeaderView.h"
#import "CommonSettingCell.h"
@interface CommonSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *wTableView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) AutoScrollLabel *autoscrollTitle;

@end

@implementation CommonSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.data = [NSMutableArray arrayWithObjects:@"红", @"黄", @"蓝" ,@"默认", @"随机一个颜色", nil];
    [[LocationManager sharedInstance] getLocation];
    
    
    [self.data addObjectsFromArray:[CommonSettingItem mj_objectArrayWithFilename:@"CommonSettings.plist"]];

    
    self.wTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
    self.wTableView.delegate = self;
    self.wTableView.dataSource = self;
    self.wTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, CGFLOAT_MIN)];
    self.wTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, CGFLOAT_MIN)];
    
    [self.view addSubview:self.wTableView];
    
    
    [self configNavBarButton];
}

- (void)configNavBarButton {
    
    self.autoscrollTitle = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH*0.6, 44)];
    NSDictionary *adressdic = [[LocationManager sharedInstance] addressDic];
    if (adressdic.allKeys.count>0) {
        self.autoscrollTitle.text = [NSString stringWithFormat:@"当前位置💧:%@ %@ %@", adressdic[@"City"], adressdic[@"SubLocality"], adressdic[@"Name"]];
    } else {
        self.autoscrollTitle.text = @"设置";
    }
    self.navigationItem.titleView = self.autoscrollTitle;
}



#pragma mark - actions

- (void)changeThemeColor:(NSIndexPath *)indexPath {
    NSString *rowValue = [[self.data[indexPath.section] groupdetail][indexPath.row] rowvalue];
    
    UIColor *color;
    
    if([rowValue isEqualToString:@"kRANDOM_COLOR"]){
        color = kRANDOM_COLOR;
    } else if([rowValue isEqualToString:@"kDefaultThemeColor"]) {
        color = kDefaultThemeColor;
    } else {
        color = [UIColor colorwithHexString:rowValue];
    }
    
    kSetThemeColor(color);
    
    //发送一个通知
    kPOST_NOTIFICATION(ThemeColorChangeNotification);
    [self.wTableView reloadData];
}


#pragma mark - delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeaderView *view = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, 100, 44) title:[self.data[section] groupname]];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, CGFLOAT_MIN)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((CommonSettingItem *)self.data[section]).groupdetail.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"CommonSettingCell";
    CommonSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        cell = [[NSBundle mainBundle] loadNibNamed:@"CommonSettingCell" owner:self options:nil].lastObject;
    }
    [cell setContent:[self.data[indexPath.section] groupdetail][indexPath.row] indexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RowItem *item = [self.data[indexPath.section] groupdetail][indexPath.row];
    
    NSInteger rowtype = [item rowtype];
    
    if (rowtype == CommonSettingCellTypeDefault) {
        [self changeThemeColor:indexPath];
        
    } else if (rowtype == CommonSettingCellTypeSkip) {
        Class clazz = NSClassFromString(item.rowvalue);
        [self.navigationController pushViewController:[[clazz alloc] init] animated:YES];
    }
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)data {
    if (!_data) {
        _data = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _data;
}

@end
