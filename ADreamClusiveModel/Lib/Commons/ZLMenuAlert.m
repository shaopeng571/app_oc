//
//  ZLMenuAlert.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/15.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLMenuAlert.h"

@interface ZLMenuAlert ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView * tableView;
@end

@implementation ZLMenuAlert

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(void)setTabColor:(UIColor *)tabColor{
    _tabColor = tabColor;
    self.tableView.backgroundColor = tabColor;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initUI];
    }
    return self;
}


-(void)initUI{
    
    self.userInteractionEnabled = YES;
    
    UITableView * tableView = [UITableView new];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.frame = self.bounds;
    [self addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    tableView.rowHeight = 30;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fmenualert"];
}

-(void)setArrMDataSource:(NSMutableArray *)arrMDataSource{
    _arrMDataSource = arrMDataSource;
    [_tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectedCallback) {
        self.didSelectedCallback(indexPath.row, _arrMDataSource[indexPath.row]);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrMDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fmenualert" forIndexPath:indexPath];
    cell.textLabel.text = _arrMDataSource[indexPath.row];
    cell.textLabel.textColor = _txtColor ? _txtColor : [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.contentView.backgroundColor = self.tabColor;
    cell.textLabel.backgroundColor = self.tabColor;
    cell.textLabel.font = _cusFont ? _cusFont : kGetThemeFont(15);
    return cell;
}

// 以下适配iOS11+
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

@end
