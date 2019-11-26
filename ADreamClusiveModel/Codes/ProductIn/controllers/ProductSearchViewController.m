//
//  ProductSearchViewController.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/6.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ProductSearchViewController.h"

#import "ProductListTableViewCell.h"

#import "ProductDetailVC.h"


@interface ProductSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *productListTableView;

@end

@implementation ProductSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.productListTableView];
    
    [self.productListTableView reloadData];
    
    self.title = @"搜索商品";
}

- (void)configNavBarButton {
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    anotherButton.tintColor = kGetThemeColor;
    self.navigationItem.rightBarButtonItem = anotherButton;
}


#pragma mark - actions

- (void)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)deleteItemAtindexPath:(NSIndexPath *)indexPath {
    ProductItem *item = self.products[indexPath.row];
    BOOL result = NO;
    if([[ZLFMDBHelper sharedFMDBHelper] deleteProduct:item]) {
        
        [self.products removeObject:item];
        result = YES;
    }
    return result;
}

#pragma mark - delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ProductListTableViewCell";
    ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        //        cell = [[ProductPicsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell = [[NSBundle mainBundle] loadNibNamed:@"ProductListTableViewCell" owner:self options:nil].lastObject;
    }
    
    [cell setContentWithItem:self.products[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductDetailVC *prodetailVC = [[ProductDetailVC alloc] init];
    prodetailVC.item = self.products[indexPath.row];
    [self.navigationController pushViewController:prodetailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){//title可自已定义
        
        NSLog(@"点击删除");
        if ([self deleteItemAtindexPath:indexPath]) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    deleteRoWAction.backgroundColor = kGetThemeColor;
    
    return @[deleteRoWAction];
}

#pragma mark - getters

- (UITableView *)productListTableView {
    if (_productListTableView==nil) {
        _productListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavigationBarHeight) style:UITableViewStylePlain];
        _productListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _productListTableView.tableHeaderView = [UIView new];
        _productListTableView.tableFooterView = [UIView new];
        //        _productPicsTableView.estimatedRowHeight = 0;
        //        _productPicsTableView.estimatedSectionHeaderHeight = 0;
        //        _productPicsTableView.estimatedSectionFooterHeight = 0;
        _productListTableView.showsVerticalScrollIndicator = NO;
        //        _productListTableView.allowsSelection = NO;
        _productListTableView.delegate = self;
        _productListTableView.dataSource = self;
    }
    return _productListTableView;
}
- (NSMutableArray *)products {
    if (!_products) {
        _products = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _products;
}



@end
