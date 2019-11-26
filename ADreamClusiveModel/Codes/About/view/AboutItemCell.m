//
//  AboutItemCell.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "AboutItemCell.h"

@interface AboutItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic, strong) NSIndexPath *indexpath;

@end

@implementation AboutItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(AboutItem *)item indexPath:(NSIndexPath *)indexPath {
    self.indexpath = indexPath;
    self.iconView.image = [UIImage imageNamed:item.image];
    self.nameLabel.text = item.title;
    if (item.type== AboutItemCellTypeDesc) {
        self.descLabel.hidden = NO;
        self.descLabel.text = item.desc;
    } else {
        self.descLabel.hidden = YES;
    }
}






@end
