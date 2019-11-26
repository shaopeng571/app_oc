//
//  ProductListViewController.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/31.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductListTableViewCell.h"
#import "ProductInViewController.h"
#import "ProductDetailVC.h"
#import "QRViewController.h"
#import "ProductSearchViewController.h"
#import "ProductEditVC.h"


static NSString *const COUNT_PERPAGE = @"10";

@interface ProductListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *productListTableView;

@property (nonatomic, strong) NSMutableArray *products;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
    // Do any additional setup after loading the view.
    [self setupUI];
    

    
    self.productListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.products removeAllObjects];
        self.currentIndex = 0;
        [self.products addObjectsFromArray:[self fetchRequest]];
        [self.productListTableView reloadData];
        [self.productListTableView.mj_header endRefreshing];
    }];
    
    self.productListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self.products addObjectsFromArray:[self fetchRequest]];
        [self.productListTableView reloadData];
        [self.productListTableView.mj_footer endRefreshing];
    }];
    
    
//    [self.products addObjectsFromArray:[[ZLFMDBHelper sharedFMDBHelper] getAllFromProducts]];
//    for (ProductItem *item in self.products) {
//
//        if(item.productPicInfoItems.count>0)
//        item.showimagestr = [item.productPicInfoItems.firstObject proimagepath];
//
//        [[ZLFMDBHelper sharedFMDBHelper] updateToProducts:item];
//    }
    
    [self.productListTableView.mj_header beginRefreshing];
    [self.productListTableView reloadData];
}

- (NSArray *)fetchRequest {
    NSArray *datas = [[ZLFMDBHelper sharedFMDBHelper] getProductsFrom:[NSString stringWithFormat:@"%ld", (long)self.currentIndex] count:COUNT_PERPAGE];
    self.currentIndex += datas.count;
    return datas;
}

- (void)setupUI {
    self.title = @"商品列表";
    [self.view addSubview:self.productListTableView];
    
    [self configNavBarButton];
}

- (void)configNavBarButton {
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn sizeToFit];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    
    self.navigationItem.rightBarButtonItems = @[addItem];
    
    
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"🔍", nil) style:UIBarButtonItemStylePlain target:self action:@selector(searchAction:)];
    self.navigationItem.leftBarButtonItem = leftitem;
}

#pragma mark - actions
- (void)addAction:(id)sender {
    ProductEditVC *productDetailVC = [[ProductEditVC alloc] init];
    
    [self.navigationController pushViewController:productDetailVC animated:YES];
}


- (void)searchAction:(id)sender {
    
//    QRViewController *qrVC = [QRViewController new];
//    qrVC.qrUrlBlock = ^(NSString *url) {
//        [self.products removeAllObjects];
//        [self.products addObjectsFromArray:[[ZLFMDBHelper sharedFMDBHelper] queryProductsWithSearchStr:url]];
//        [self.productListTableView reloadData];
//    };
//    [self.navigationController pushViewController:qrVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索商品" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
//        [self.products removeAllObjects];
//        [self.products addObjectsFromArray:[[ZLFMDBHelper sharedFMDBHelper] queryProductsWithSearchStr:searchText]];
//        [self.productListTableView reloadData];
        
        ProductSearchViewController *proVc = [[ProductSearchViewController alloc] init];
        [proVc.products addObjectsFromArray:[[ZLFMDBHelper sharedFMDBHelper] queryProductsWithSearchStr:searchText]];
        
        [weakSelf.navigationController pushViewController:proVc animated:YES];
        
    }];
    
    searchViewController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    [self.navigationController pushViewController:searchViewController animated:YES];
    
    
//    Class clazz = NSClassFromString(@"ProductSearchViewController");
//    [self.navigationController pushViewController:(ZLViewController *)[[clazz alloc] init] animated:NO];
    
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
        _productListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavigationBarHeight-kTabBarHeight) style:UITableViewStylePlain];
        _productListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
       
        _productListTableView.estimatedRowHeight = 0;
        _productListTableView.estimatedSectionHeaderHeight = 0;
        _productListTableView.estimatedSectionFooterHeight = 0;
        
        _productListTableView.tableHeaderView = [UIView new];
        _productListTableView.tableFooterView = [UIView new];

//        _productListTableView.showsVerticalScrollIndicator = NO;
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
