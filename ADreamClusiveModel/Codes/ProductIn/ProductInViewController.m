//
//  ProductInViewController.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/23.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ProductInViewController.h"
#import "QRViewController.h"
#import "PicListViewController.h"
#import "ZLButton.h"

@interface ProductInViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *bgContentView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIImageView *qrImageView;
@property (nonatomic, strong) UIButton *scanQRBtn;
@property (nonatomic, strong) ZLButton *rejectBtn;

@end

@implementation ProductInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}

- (void)setupUI {
    [self.view addSubview:self.bgContentView];
    [self.bgContentView addSubview:self.messageLabel];
    [self.bgContentView addSubview:self.qrImageView];
    [self.bgContentView addSubview:self.scanQRBtn];
    self.bgContentView.contentSize = CGSizeMake(self.bgContentView.width, self.scanQRBtn.bottom+40);
    
    //    self.messageLabel.text = [NSString stringWithFormat:@"%@", [ChineseToPinyin pinyinFromChineseString:@"你好"]];
    
    
    //    self.qrimageView.image = [QRManager barcodeImageWithContent:@"6543234567890-09876543" codeImageSize:self.qrimageView.size red:0.2 green:0.4 blue:0.6];
    
    self.qrImageView.image = [QRManager showQRCodeWithDataStr:@"http://wwww.baidu.com" andLogo:@"AppIcon" logoScaleToSuperView:0.2];
    
    [self configNavBarButton];
    
    
    ZLButton *rejBtn = [ZLButton buttonWithFrame:CGRectMake(80, self.scanQRBtn.bottom+20, 80, 80) title:@"检测图片" titleFont:kGetThemeFont(13) titleColor:kGetThemeColor image:[UIImage imageNamed:@"nav_camera"] edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10) handler:^(ZLButton * _Nonnull button) {
        
    }];
    [self.bgContentView addSubview:rejBtn];

    ZLWeakSelf;
    self.rejectBtn = [ZLButton buttonWithFrame:CGRectMake(rejBtn.right+20, self.scanQRBtn.bottom+20, 80, 80) title:@"检测图片" titleFont:kGetThemeFont(10) titleColor:UIColor.blackColor image:[UIImage imageNamed:@"check"] edgeInsets:UIEdgeInsetsMake(4, 4, 4, 4) handler:^(ZLButton * _Nonnull button) {
        [weakSelf getPersonalSize:button];
    }];
    
    [self.bgContentView addSubview:self.rejectBtn];
    
    
    self.bgContentView.contentSize = CGSizeMake(self.bgContentView.width, rejBtn.bottom+40);

}

- (void)configNavBarButton {
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"检测个人文件夹大小", nil) style:UIBarButtonItemStylePlain target:self action:@selector(getPersonalSize:)];
//    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: anotherButton,nil]];
    
//    self.rejectBtn = [ZLButtonFactory topImgBottomTextbuttonWithTitle:NSLocalizedString(@"检测图片", nil) image:[UIImage imageNamed:@"nav_camera"] frame:CGRectMake(0, 0, 40, 40) target:self selector:@selector(getPersonalSize:)];
    
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setImage:[UIImage imageNamed:@"nav_camera"] forState:UIControlStateNormal];
    [cameraBtn sizeToFit];
    UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
    
    [self.navigationItem setRightBarButtonItems:@[informationCardItem]];
}

#pragma mark - Actions

- (void)longTouchAction:(UIGestureRecognizer *)sender {
    NSString *resultOfQR = [QRManager touchQRImageGetStringWithImage:self.qrImageView.image];
    NSLog(@"识别二维码的内容为：%@",resultOfQR);
    self.messageLabel.text = [NSString stringWithFormat:@"二维码信息：%@", resultOfQR];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resultOfQR]];
}


- (void)scanQR:(id)sender {
    
    QRViewController *qrVC = [QRViewController new];
    qrVC.qrUrlBlock = ^(NSString *urlstr) {
        self->_messageLabel.text = urlstr;
        //创建一个url，这个url就是WXApp的url，记得加上：//
        NSURL *url = [NSURL URLWithString:urlstr];
        //先判断是否能打开该url
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            //打开url
            [[UIApplication sharedApplication] openURL:url];
        }
        
    };
    [self.navigationController pushViewController:qrVC animated:YES];

}

- (void)getPersonalSize:(id)sender {
    NSString *personalPath  = [ZLFileManager personalFilesPath];
//
    float size = [ZLFileManager folderSizeAtPath:personalPath];
    
//    [self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"%gMB", size]];
    [self.rejectBtn setTitle:[NSString stringWithFormat:@"%gMB", size] forState:UIControlStateNormal];
    
    [ZLButtonFactory initButton:self.rejectBtn];
    
//    [ZLFileManager removeFilesAtPath:kDIRECTORY_DOCUMENTS];
    
//    BOOL suc = [[NSFileManager defaultManager] createDirectoryAtPath:personalPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
//    PicListViewController *picsvc = [[PicListViewController alloc] init];
//    [self.navigationController pushViewController:picsvc animated:YES];
    
    
}

- (void)cameraAction:(id)sender {
    NSLog(@"调用相机");
    
    if ([ZLDeviceUtils isSimulator]) {
        [self.view makeToast:@"此功能不支持模拟器" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    // 创建UIImagePickerController实例
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePickerController.delegate = self;
    // 是否显示裁剪框编辑（默认为NO），等于YES的时候，照片拍摄完成可以进行裁剪
//    imagePickerController.allowsEditing = YES;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 设置照片来源为相机
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 设置进入相机时使用前置或后置摄像头
    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    // iOS8以后拍照的页面跳转会卡顿几秒中，加入这个属性，卡顿消失
//    imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    // 展示选取照片控制器
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - Delegates

#pragma mark - UIImagePickerControllerDelegate
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage; // 原始图片
     * UIImagePickerControllerEditedImage; // 裁剪后图片
     * UIImagePickerControllerCropRect; // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL; // 媒体的URL
     * UIImagePickerControllerReferenceURL // 原件的URL
     * UIImagePickerControllerMediaMetadata // 当数据来源是相机时，此值才有效
     */
    
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // 最多0.5MB
//    image = [UIImage compressImage:image toByte:10000];
    NSData *oriData = UIImageJPEGRepresentation(image, 1);
    
    image = [UIImage compressImage:image toMaxEdgeLength:1280 toByte:100000];
    
    NSData *newData = UIImageJPEGRepresentation(image, 1);
    
    self.qrImageView.image = image;
    // // 创建保存图像时需要传入的选择器对象（回调方法格式固定）
    // SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
    // // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
    // UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    BOOL result = [ZLFileManager saveImage:image WithName:[NSString stringWithFormat:@"%f.png", timeStamp]];
    
}
// 取消选取调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (UILabel *)messageLabel {
    if (_messageLabel==nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, self.bgContentView.width-32, 100)];
        _messageLabel.numberOfLines = 0;
//        _messageLabel.backgroundColor = UIColor.lightGrayColor;
        _messageLabel.text = @"二维码信息：";
    }
    return _messageLabel;
}
- (UIImageView *)qrImageView {
    if (_qrImageView==nil) {
        CGFloat edgeLength = self.bgContentView.width-32;
        _qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, self.messageLabel.bottom+10, edgeLength, edgeLength)];
        _qrImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouchAction:)];
        _qrImageView.userInteractionEnabled = YES;
        [_qrImageView addGestureRecognizer:longGesture];
    }
    return _qrImageView;
}

- (UIButton *)scanQRBtn {
    if (_scanQRBtn == nil) {
        _scanQRBtn = [ZLButtonFactory buttonWithTitle:@"扫一扫" image:[UIImage imageNamed:@"qrimg"] frame:CGRectMake(0, self.qrImageView.bottom+10, 180, 70) target:self selector:@selector(scanQR:)];
        
        
        
//        _scanQRBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.qrImageView.bottom+10, 80, 30)];
//        [_scanQRBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
//        [_scanQRBtn setTitleColor:kRGB(251, 213, 0) forState:UIControlStateNormal];
//        [_scanQRBtn addTarget:self action:@selector(scanQR:) forControlEvents:UIControlEventTouchUpInside];
        _scanQRBtn.centerX = self.bgContentView.centerX;
    }
    return _scanQRBtn;
}


@end
