//
//  PicCollectionViewCell.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/7.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "PicCollectionViewCell.h"

@interface PicCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImgView;
@property (weak, nonatomic) IBOutlet UILabel *picTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;

@property (nonatomic, strong) NSIndexPath *indexpath;

@end

@implementation PicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = UIColor.lightGrayColor;
    
    self.picTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    
}

- (void)setContentWithItem:(ProPicInfoItem *)item indexpath:(NSIndexPath *)indexpath {
    self.indexpath = indexpath;
    
    self.indexpath = indexpath;
    
    self.picImgView.image = item.proimage;
    
    self.picTitleLabel.text = [NSDate stringFromTimestamp:item.proinfo.integerValue withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.selectImgView.hidden = !item.selected;
}

- (void)setPIC_selected:(BOOL)isSelected {
    self.selectImgView.hidden = !isSelected;
}



@end
