//
//  ZLDingdanDetailVC.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/15.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLDingdanDetailVC.h"
#import "ZLDingdanDetailTableViewCell.h"
@interface ZLDingdanDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZLDingdanDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单状态详细信息";
    
    
    
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
//
//    [arr addObjectsFromArray:self.dingdanInfos];
//
//    [arr addObjectsFromArray:self.dingdanInfos];
//
//    [arr addObjectsFromArray:self.dingdanInfos];
//
//    [arr addObjectsFromArray:self.dingdanInfos];
//
//    self.dingdanInfos = arr;
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dingdanInfos.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DingdanInfoOneItem *item = self.dingdanInfos[indexPath.row];
    
    CGFloat height = [NSString sizeWithTextString:[NSString stringWithFormat:@"%@ %@", item.ftime, item.context].clearEdgeSpace textFont:kGetThemeFont(14) maxWidth:kSCREEN_WIDTH-20].height;
    
    return height+20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"dingdan";
    ZLDingdanDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[ZLDingdanDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    DingdanInfoOneItem *item = self.dingdanInfos[indexPath.row];
    
    [cell setContentWithItem:item];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (UITableView *)tableView {
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
//        _tableView.backgroundColor = UIColor.redColor;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
