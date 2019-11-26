//
//  QRViewController.h
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "ZLViewController.h"

typedef void(^QRUrlBlock)(NSString *url);


@interface QRViewController :ZLViewController

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

-(void)getQRStringValue:(QRUrlBlock)_block;


@end
