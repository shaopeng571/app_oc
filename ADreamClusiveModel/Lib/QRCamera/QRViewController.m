//
//  QRViewController.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "QRView.h"
//#import "CompurterLoginViewController.h"
@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate,QRViewDelegate>

@property (strong, nonatomic) AVCaptureDevice * device;
@property (strong, nonatomic) AVCaptureDeviceInput * input;
@property (strong, nonatomic) AVCaptureMetadataOutput * output;
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * preview;

@end

@implementation QRViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
    [_session startRunning];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"二维码/条码";
    [self setCapSession];
    [self drawView];
}

- (void)drawView {
    //---------------------------至此，基本的扫描需求已经满足-------------------------------------------------
    QRView *qrRectView = [[QRView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT-kNavigationBarHeight)];
    qrRectView.transparentArea = CGSizeMake(200, 200);
    qrRectView.backgroundColor = [UIColor clearColor];
//    qrRectView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    qrRectView.delegate = self;
    [self.view addSubview:qrRectView];
    
    //修正扫描区域
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat screenWidth = self.view.frame.size.width;
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,
                                 (screenHeight - qrRectView.transparentArea.height) / 2,
                                 qrRectView.transparentArea.width,
                                 qrRectView.transparentArea.height);

    [_output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];

    // 添加文字提示
    UILabel *warnnigLabel = [[UILabel alloc] initWithFrame :CGRectMake(0,self.view.frame.size.height/2-200,self.view.frame.size.width,90)];
    warnnigLabel.numberOfLines = 3;
    warnnigLabel.text = @"将二维码/条形码放入框内，即可自动扫描";
    warnnigLabel.textColor = [UIColor whiteColor];
    warnnigLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:warnnigLabel];

    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([_device hasTorch]) {
        UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [lightButton setTitle:@"打开照明灯" forState:0];
        [lightButton setTitle:@"关闭照明灯" forState:UIControlStateSelected];
        lightButton.frame = CGRectMake(0,self.view.frame.size.height/2+200,self.view.frame.size.width,30);
        [lightButton addTarget:self action:@selector(openLightAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:lightButton];
    }
}

- (void)setCapSession {
    // 1.实例化拍摄装备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2.设置输入设备
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // 3.设置元数据输出
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 4.添加拍摄会话
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];     // 添加会话输入
    }
    
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];   // 添加会话输出
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    //    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    //增加条形码扫描  // 设置输出数据类型（需要将元数据输出添加到会话后才能制定元数据类型，否则会报错）
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                    //以下为条形码，如果项目只需要扫描二维码，下面都不要写
                                    AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeUPCECode,
                                    AVMetadataObjectTypeCode39Code,
                                    AVMetadataObjectTypeCode39Mod43Code,
                                    AVMetadataObjectTypeCode93Code,
                                    AVMetadataObjectTypeCode128Code,
                                    AVMetadataObjectTypePDF417Code];
    
    // 5.视频预览图层
    // 传递session是为了告诉图层将来显示什么内容
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    // 显示方式
    // 设置videoGravity,顾名思义就是视频播放时的拉伸方式,默认是AVLayerVideoGravityResizeAspect
    // AVLayerVideoGravityResizeAspect 保持视频的宽高比并使播放内容自动适应播放窗口的大小。
    // AVLayerVideoGravityResizeAspectFill 和前者类似，但它是以播放内容填充而不是适应播放窗口的大小。最后一个值会拉伸播放内容以适应播放窗口.
    // 因为考虑到全屏显示以及设备自适应,这里我们采用fill填充
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame = self.view.layer.bounds;
    // 将图层插入当前图层
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    
    // 6.启动会话
    [_session startRunning];
}

#pragma mark - 打开照明灯
- (void)openLightAction: (UIButton *)sender {
    
    if (sender.selected) {
        [self turnOnlight:NO];
    } else {
        [self turnOnlight:YES];
    }
    
    sender.selected = !sender.selected;

}

- (void)turnOnlight:(BOOL)on {
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([_device hasTorch]) {
        [_device lockForConfiguration:nil];
        if (on) {
            [_device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [_device setTorchMode:AVCaptureTorchModeOff];
        }
    }
}

#pragma mark - 返回按钮
- (void)pop:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark QRViewDelegate
-(void)scanTypeConfig:(QRItem *)item {
    
    if (item.type == QRItemTypeQRCode) {
        _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
        
    } else if (item.type == QRItemTypeOther) {
        
        _output.metadataObjectTypes = @[//以下为条形码，如果项目只需要扫描二维码，下面都不要写
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeUPCECode,
                                        AVMetadataObjectTypeCode39Code,
                                        AVMetadataObjectTypeCode39Mod43Code,
                                        AVMetadataObjectTypeCode93Code,
                                        AVMetadataObjectTypeCode128Code,
                                        AVMetadataObjectTypePDF417Code
                                        ];
    }
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
/**
 扫描结果处理
 
 @param captureOutput 输出数据源
 @param metadataObjects 扫描结果数组
 @param connection 用于协调输入与输出之间的数据流
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    // 1.判断扫描结果的数据是否存在
    if ([metadataObjects count] >0) {
         // 2.如果存在数据，则停止会话
        [_session stopRunning];
        
        // AVMetadataMachineReadableCodeObject 是AVMetadataObject的具体子类定义的特性检测一维或二维条形码。
        // AVMetadataMachineReadableCodeObject代表一个单一的照片中发现机器可读的代码。这是一个不可变对象描述条码的特性和载荷。
        // 在支持的平台上,AVCaptureMetadataOutput输出检测机器可读的代码对象的数组
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    NSLog(@" %@",stringValue);
    
    //---------------------------到这里就获取到了扫描结果数据---------
    
    // 播放音效
    [self SG_playSoundEffect:@"QRSource.bundle/sound.caf"];
    
    if (self.qrUrlBlock) {
        self.qrUrlBlock(stringValue);
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
//    // 拿到uid 跳转到pc 登录确认界面
//    CompurterLoginViewController *computerLoginVC = [CompurterLoginViewController new];
//
//    computerLoginVC.uid = stringValue;
//
//    [self presentViewController:computerLoginVC animated:YES completion:^{
//
//    }];
//
//    computerLoginVC.dismissBlock = ^{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    };
}

/** 播放音效文件 */
- (void)SG_playSoundEffect:(NSString *)name {
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
/** 播放完成回调函数 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    //SGQRCodeLog(@"播放完成...");
}

-(void)getQRStringValue:(QRUrlBlock)_block{
    if (_block) {
         self.qrUrlBlock = _block;
    }
}



@end
