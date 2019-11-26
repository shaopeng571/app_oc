//
//  ProductPicsTableViewCell.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/29.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ProductPicsTableViewCell.h"

@interface ProductPicsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *namelabel;

@property (weak, nonatomic) IBOutlet UIImageView *propic;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, strong) NSIndexPath *indexpath;

@end

@implementation ProductPicsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.propic.layer.borderWidth = 1.0;
//    self.propic.layer.borderColor = UIColor.yellowColor.CGColor;
//    self.propic.layer.cornerRadius = 5.0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setShowDeleteBtn:(BOOL)showDeleteBtn {
    _showDeleteBtn = showDeleteBtn;
    
    self.deleteBtn.hidden = !_showDeleteBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentWithItem:(ProPicInfoItem *)item indexpath:(nonnull NSIndexPath *)indexpath {
    
    self.indexpath = indexpath;
    self.propic.image = [UIImage imageNamed:@"iPhoneX-Port"];
    if (item.proimagepath) {
        self.propic.image = [UIImage imageWithContentsOfFile:kWholePath(item.proimagepath)]?:kDefaultImage;
    }
    
    self.namelabel.text =   [NSDate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[item.proinfo floatValue]] format:@"yyyy-MM-dd HH:mm:ss"];
}

- (IBAction)deleteAction:(id)sender {
    if (self.deletePic) {
        self.deletePic(self.indexpath);
    }
}


@end
