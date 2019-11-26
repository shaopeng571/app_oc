//
//  ProductDetailVC.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/1.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ProductDetailVC.h"
#import "ZLHorizonTableView.h"
#import "ProductEditVC.h"

@interface ProductDetailVC ()

@property (nonatomic, strong) UIScrollView *bgContentView;

@property (nonatomic, strong) UILabel *productPriceLabel;

@property (nonatomic, strong) ZLHorizonTableView *picsView;

@property (nonatomic, strong) UILabel *productIntroLabel;

@property (nonatomic, strong) NSMutableArray *imagesArr;

@end

@implementation ProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [self setData];
}

- (void)setupUI {
    self.title = self.item.producName;
    [self.view addSubview:self.bgContentView];
    [self.bgContentView addSubview:self.productPriceLabel];
    [self.bgContentView addSubview:self.picsView];
    [self.bgContentView addSubview:self.productIntroLabel];
    
    [self configNavBarButton];
}


- (void)configNavBarButton {
    UIBarButtonItem *savebtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"编辑", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    savebtnItem.tintColor = kRGB(255, 255, 255);
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: savebtnItem,nil]];
}

- (void)setData {
    self.productPriceLabel.text = self.item.producPrice;
    self.productIntroLabel.text = self.item.producIntro;
    self.picsView.datasource = self.item.productPicInfoItems;
}

- (void)viewDidLayoutSubviews {
    self.productIntroLabel.height = [NSString sizeWithTextString:self.item.producIntro textFont:self.productIntroLabel.font maxWidth:self.productIntroLabel.width].height;
    self.bgContentView.contentSize = CGSizeMake(self.bgContentView.width, self.productIntroLabel.bottom+40);
}

#pragma mark - actions
- (void)editAction:(id)sender {
    ProductEditVC *productDetailVC = [[ProductEditVC alloc] init];
    productDetailVC.item = self.item;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}


#pragma mark - getters

- (UIScrollView *)bgContentView {
    if (_bgContentView==nil) {
        _bgContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavigationBarHeight)];
//        _bgContentView.backgroundColor = UIColor.greenColor;
        _bgContentView.alwaysBounceVertical = YES;
    }
    return _bgContentView;
}

- (UILabel *)productPriceLabel {
    if (_productPriceLabel==nil) {
        _productPriceLabel =[[UILabel alloc] initWithFrame:CGRectMake(16, 10, kSCREEN_WIDTH-32, 30)];
        _productIntroLabel.font = kGetThemeFont(16);
    }
    return _productPriceLabel;
}

- (ZLHorizonTableView *)picsView {
    if (!_picsView) {
        _picsView = [[ZLHorizonTableView alloc] initWithFrame:CGRectMake(5, _productPriceLabel.bottom+10, kSCREEN_WIDTH-10, 200)];
    }
    return _picsView;
}

- (UILabel *)productIntroLabel {
    if (_productIntroLabel==nil) {
        _productIntroLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, _picsView.bottom+10, kSCREEN_WIDTH-32, 100)];
        _productIntroLabel.font = kGetThemeFont(14);
        _productIntroLabel.numberOfLines = 0;
    }
    return _productIntroLabel;
}


@end
