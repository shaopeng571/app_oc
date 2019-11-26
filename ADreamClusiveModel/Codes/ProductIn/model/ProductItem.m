//
//  ProductItem.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/29.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ProductItem.h"

@interface ProductItem()

@end

@implementation ProductItem


- (instancetype)init {
    if (self=[super init]) {
        self.productID = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        self.productPicInfoItems = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)setShowimagestr:(NSString *)showimagestr {
    _showimagestr = showimagestr;
    
    if (showimagestr) {
        NSData *data = [NSData dataWithContentsOfFile:kWholePath(showimagestr)];
        
        [self setShowImage:[UIImage imageWithData:data]];
    }
}

- (UIImage *)showImage {
    if (!_showImage) {
//        if (_productPicInfoItems.count>0) {
//
//            //You code here...
//            NSString *imagename = ((ProPicInfoItem *)(_productPicInfoItems.firstObject)).proimagepath;
//
//            NSData *data = [NSData dataWithContentsOfFile:kWholePath(imagename)];
//
//            _showImage = [UIImage imageWithData:data];
//
//            //        [UIImage imageWithContentsOfFile:kWholePath(imagename)]?:kDefaultImage;
//        } else {
            _showImage = kDefaultImage;
//        }
    }
    return _showImage;
}


@end


