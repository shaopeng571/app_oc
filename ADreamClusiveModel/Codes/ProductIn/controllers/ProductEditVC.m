//
//  ProductEditVC.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/25.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ProductEditVC.h"
#import "UILabel+Alignment.h"
#import "ProductPicsTableViewCell.h"
#import "ProductItem.h"
#import "ZLHorizonTableView.h"
#import <AipOcrSdk/AipOcrSdk.h>



#define kEdgeLeftRight 16
#define kEdgeTopBottom 10

@interface ProductEditVC ()

@property (nonatomic, strong) UIScrollView *bgContentView;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UITextField *productNameTF;

@property (nonatomic, strong) UILabel *productPriceLabel;
@property (nonatomic, strong) UITextField *productPriceTF;

@property (nonatomic, strong) ZLHorizonTableView *picsView;

@property (nonatomic, strong) UILabel *productIntroLabel;
@property (nonatomic, strong) UIButton *ocrBtn;
@property (nonatomic, strong) UITextView *productIntroTV;

@property (nonatomic, strong) UIButton *scanQRBtn;


@property (nonatomic, strong) NSMutableArray *imagesArr;

@property (assign) BOOL isUpdate;
/*
 名称 ADreamClusive
 价格 ￥99999.99
 图册 最多六张   点击小图浏览大图【使用scrollview实现左右滚动】
 简介 实际中会穿插用到Html+Css+js前端知识、Python和Mac端以及Linux脚本知识，还有一些辅助工具的使用，都会在博客中体现，具体内容会尽可能详细的做好分类。
 */


@end

@implementation ProductEditVC {
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imagesArr = [[NSMutableArray alloc] initWithCapacity:0];
    
//    NSArray *imagepaths = [[ZLFileManager filenamesInPath:[ZLFileManager personalFilesPath] withExt:@"png" deep:YES] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
//        return [obj1 compare:obj2];
//    }];
//
//    for (NSString *imagepath in imagepaths) {
//        ProPicInfoItem *item = [[ProPicInfoItem alloc] init];
//        item.proimagepath = [imagepath lastPathComponent];
//        item.proinfo = [imagepath lastPathComponent];
////        [self.imagesArr addObject:item];
//        item = nil;
//    }
    
//    self.imagesArr = @[@"iamges1", @"images2", @"images3", @"images4", @"images5", @"images6"];
    
    [[AipOcrService shardService] authWithAK:@"skEWW6pgHmOpYS1tGDPcRx8e" andSK:@"Ne20r5buECf9VTRZUKcyucHUSOlmqNyf"];
    [self configCallback];
    
    [self setupUI];
 
    if (!self.item) {
        self.item = [[ProductItem alloc] init];
        self.isUpdate = NO;
        self.item.productPicInfoItems = self.imagesArr;
    } else {
        self.isUpdate = YES;
    }
    
    [self updateQR];
    [self setData];
}

- (void)setupUI {
    self.title = @"商品信息";
    [self.view addSubview:self.bgContentView];
    [self.bgContentView addSubview:self.productNameLabel];
    [self.bgContentView addSubview:self.productNameTF];
    [self.bgContentView addSubview:self.productPriceLabel];
    [self.bgContentView addSubview:self.productPriceTF];
    [self.bgContentView addSubview:self.picsView];
    [self.bgContentView addSubview:self.productIntroLabel];
    [self.bgContentView addSubview:self.ocrBtn];
    [self.bgContentView addSubview:self.productIntroTV];
    [self.bgContentView addSubview:self.scanQRBtn];
    self.bgContentView.contentSize = CGSizeMake(self.bgContentView.width, self.scanQRBtn.bottom+40);
    
    [self configNavBarButton];
}


- (void)setData {
    self.productNameTF.text = self.item.producName;
    self.productPriceTF.text = self.item.producPrice;
    self.picsView.datasource = self.item.productPicInfoItems;
    self.productIntroTV.text = self.item.producIntro;
}

- (void) updateQR {
    if (self.item.qrinfo) {
        [_scanQRBtn setTitle:@"点击更新二维码信息！" forState:UIControlStateNormal];
    } else {
        [_scanQRBtn setTitle:@"还没有上传二维码信息，点击上传！" forState:UIControlStateNormal];
    }
    [_scanQRBtn sizeToFit];
}

- (void)configNavBarButton {
    UIBarButtonItem *savebtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"保存", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    savebtnItem.tintColor = kRGB(255, 255, 255);
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:savebtnItem,nil]];
}

#pragma mark - actions
- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
            weakSelf.productIntroTV.text = message;
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}
- (void)saveAction:(id)sender {
    NSLog(@"保存");
    
    self.item.producName = [self.productNameTF.text isEqualToString:@""]?@"默认商品":self.productNameTF.text;
    self.item.producPrice = [self.productPriceTF.text isEqualToString:@""]?@"1314.0￥":self.productPriceTF.text;
    self.item.productPicInfoItems = self.picsView.datasource;
    self.item.producIntro = [self.productIntroTV.text isEqualToString:@""]?@"商品简介":self.productIntroTV.text;
    self.item.starscore = [NSString stringWithFormat:@"%.01f", ((arc4random_uniform(256))/255.0)];
    self.item.showimagestr = self.item.productPicInfoItems.count>0?[self.item.productPicInfoItems.firstObject proimagepath]:@"";
    
    
//    [ZLFileManager removeFilesAtPath:kDIRECTORY_DOCUMENTS];
    
    BOOL result = NO;
    if (self.isUpdate) {
        result = [[ZLFMDBHelper sharedFMDBHelper] updateToProducts:self.item];
    } else {
        result = [[ZLFMDBHelper sharedFMDBHelper] insertToProducts:self.item];
    }
    
    if(result) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
//    NSArray *allprod = [[ZLFMDBHelper sharedFMDBHelper] getAllFromProducts];
    
    
    
}

- (void)qrAction:(id)sender {
    ZLWeakSelf;
    QRViewController *qrVC = [QRViewController new];
    qrVC.qrUrlBlock = ^(NSString *url) {
        self->_item.qrinfo = url;
        [weakSelf updateQR];
    };
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)ocraction:(id)sender {
    [self generalOCR];
}

- (void)generalOCR{
    
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        // 在这个block里，image即为切好的图片，可自行选择如何处理
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextFromImage:image
                                              withOptions:options
                                           successHandler:_successHandler
                                              failHandler:_failHandler];
        
    }];
    [self presentViewController:vc animated:YES completion:nil];
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

- (UILabel *)productNameLabel {
    if (_productNameLabel==nil) {
        _productNameLabel = [self labelWithFrame:CGRectMake(kEdgeLeftRight, kEdgeTopBottom, 80, 30) text:@"商品名称:"];
    }
    return _productNameLabel;
}

- (UITextField *)productNameTF {
    if (_productNameTF==nil) {
        CGFloat x = _productNameLabel.right;
        CGFloat w = kSCREEN_WIDTH - x - kEdgeLeftRight;
        _productNameTF = [[UITextField alloc] initWithFrame:CGRectMake(x, _productNameLabel.top, w, _productNameLabel.height)];
        _productNameTF.font = kGetThemeFont(14);
        _productNameTF.borderStyle = UITextBorderStyleRoundedRect;
        _productNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _productNameTF.placeholder = @"请输入商品名称";
    }
    return _productNameTF;
}

- (UILabel *)productPriceLabel {
    if (_productPriceLabel==nil) {
        _productPriceLabel = [self labelWithFrame:CGRectMake(kEdgeLeftRight, kEdgeTopBottom+_productNameLabel.bottom, _productNameLabel.width, _productNameLabel.height) text:@"价格:"];
    }
    return _productPriceLabel;
}

- (UITextField *)productPriceTF {
    if (_productPriceTF==nil) {
        CGFloat x = _productPriceLabel.right;
        CGFloat w = kSCREEN_WIDTH - x - kEdgeLeftRight;
        _productPriceTF = [[UITextField alloc] initWithFrame:CGRectMake(x, _productPriceLabel.top, w, _productPriceLabel.height)];
        _productPriceTF.font = _productNameTF.font;
        _productPriceTF.borderStyle = UITextBorderStyleRoundedRect;
        _productPriceTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _productPriceTF.placeholder = @"请输入商品价格";
    }
    return _productPriceTF;
}

- (ZLHorizonTableView *)picsView {
    if (!_picsView) {
        _picsView = [[ZLHorizonTableView alloc] initWithFrame:CGRectMake(5, _productPriceLabel.bottom+kEdgeTopBottom, kSCREEN_WIDTH-10, 200) type:HorizonTableViewTypeEdit];
        
    }
    return _picsView;
}

- (UILabel *)productIntroLabel {
    if (_productIntroLabel==nil) {
        _productIntroLabel = [self labelWithFrame:CGRectMake(kEdgeLeftRight, kEdgeTopBottom+_picsView.bottom, _productNameLabel.width, _productNameLabel.height) text:@"简介:"];
    }
    return _productIntroLabel;
}

- (UIButton *)ocrBtn {
    if (!_ocrBtn) {
        _ocrBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.productIntroLabel.right+5, self.productIntroLabel.top, 200, self.productIntroLabel.height)];
        [_ocrBtn setTitle:@"拍照识别文字上传" forState:UIControlStateNormal];
        _ocrBtn.titleLabel.font = kGetThemeFont(15);
        [_ocrBtn setTitleColor:kGetThemeColor forState:UIControlStateNormal];
        [_ocrBtn addTarget:self action:@selector(ocraction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocrBtn;
}

- (UITextView *)productIntroTV {
    if (_productIntroTV==nil) {
        _productIntroTV = [[UITextView alloc] initWithFrame:CGRectMake(kEdgeLeftRight, _productIntroLabel.bottom+kEdgeTopBottom, kSCREEN_WIDTH-2*kEdgeLeftRight, 200)];
        _productIntroTV.font = _productNameTF.font;
        _productIntroTV.layer.borderWidth = 1.0;
        _productIntroTV.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _productIntroTV.layer.cornerRadius = 5.0;
    }
    return _productIntroTV;
}


- (UIButton *)scanQRBtn {
    if (!_scanQRBtn) {
        _scanQRBtn = [[UIButton alloc] initWithFrame:CGRectMake(kEdgeLeftRight, _productIntroTV.bottom+kEdgeTopBottom, 200, _productIntroLabel.height)];
        [_scanQRBtn setTitle:@"点击更新二维码信息！" forState:UIControlStateNormal];
        _scanQRBtn.titleLabel.font = kGetThemeFont(15);
        [_scanQRBtn setTitleColor:kGetThemeColor forState:UIControlStateNormal];
        [_scanQRBtn addTarget:self action:@selector(qrAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanQRBtn;
}

- (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text {
    UILabel *commLabel = [[UILabel alloc] initWithFrame:frame];
    commLabel.text = text;
    commLabel.font = kGetThemeFont(16);
    [commLabel changeAlignmentRightandLeft];
    return commLabel;
}




@end
