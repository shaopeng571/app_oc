//
//  ProductListTableViewCell.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/31.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ProductListTableViewCell.h"
#import "CWStarRateView.h"

@interface ProductListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *propicimgView;
@property (weak, nonatomic) IBOutlet UILabel *proNameLebel;
@property (weak, nonatomic) IBOutlet UILabel *proPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *qrinfosupportlabel;
@property (weak, nonatomic) IBOutlet CWStarRateView *starView;


@end

@implementation ProductListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.propicimgView.layer.borderWidth = 1.0;
    self.propicimgView.layer.borderColor = UIColor.yellowColor.CGColor;
    self.propicimgView.layer.cornerRadius = 5.0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.qrinfosupportlabel.text = @"该商品暂未上传二维码信息";
    self.starView.scorePercent = 0.8;
    
    self.proNameLebel.height = [self fitHeight:self.proNameLebel];
    self.proPriceLabel.height = [self fitHeight:self.proPriceLabel];
    self.qrinfosupportlabel.height = [self fitHeight:self.qrinfosupportlabel];
}

//- (void)layoutSubviews {
//    self.proNameLebel.height = [self fitHeight:self.proNameLebel];
//    self.proPriceLabel.height = [self fitHeight:self.proPriceLabel];
//    self.qrinfosupportlabel.height = [self fitHeight:self.qrinfosupportlabel];
//}

- (CGFloat)fitHeight:(UILabel *)label {
    return [NSString sizeWithTextString:label.text textFont:label.font maxWidth:label.width].height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithItem:(ProductItem *)item {
    self.proNameLebel.text = [NSString stringWithFormat:@"商品名称：%@", item.producName];
    self.proPriceLabel.text = [NSString stringWithFormat:@"商品价格：%@", item.producPrice];
    if(!item.qrinfo) {
        self.qrinfosupportlabel.hidden = NO;
    } else {
        self.qrinfosupportlabel.hidden = YES;
    }
    
    
    NSDate* tmpStartData = [NSDate date];
    
    self.propicimgView.image = item.showImage;
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@">>>>>>>>>>cost time = %f ms", deltaTime*1000);
    
    
//    if (item.productPicInfoItems.count>0) {
//
//
//        NSDate* tmpStartData = [NSDate date];
//
//        //You code here...
//        NSString *imagename = ((ProPicInfoItem *)(item.productPicInfoItems.firstObject)).proimagepath;
//
//        NSData *data = [NSData dataWithContentsOfFile:kWholePath(imagename)];
//
//        self.propicimgView.image = [UIImage imageWithData:data];
//
//
//        double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
//        NSLog(@">>>>>>>>>>cost time = %f ms", deltaTime*1000);
//
//
//
////        [UIImage imageWithContentsOfFile:kWholePath(imagename)]?:kDefaultImage;
//    } else {
//        self.propicimgView.image = kDefaultImage;
//    }
    
    self.starView.scorePercent = [item.starscore floatValue];
}

///var/mobile/Containers/Data/Application/A4A3873C-A353-41FE-9BB7-BE70B436A5F2/Documents/images/1540964774.501379.png

///var/mobile/Containers/Data/Application/9199B47A-242E-455E-97EE-6AB1ADF5C117/Documents/images/1540964774.501379.png

///var/mobile/Containers/Data/Application/06A1CDE2-7563-4DD4-B9B4-19BBA351F563/Documents/images/1540980009.964124.png
///var/mobile/Containers/Data/Application/06A1CDE2-7563-4DD4-B9B4-19BBA351F563/Documents/images/1540980009.964124.png


@end
