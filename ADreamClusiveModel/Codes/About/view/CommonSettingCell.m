//
//  CommonSettingCell.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "CommonSettingCell.h"

@interface CommonSettingCell()

@property (weak, nonatomic) IBOutlet UILabel *rowTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;

@property (nonatomic, strong) RowItem *item;
@property (nonatomic, strong) NSIndexPath *indexpath;

@end

@implementation CommonSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.switchBtn.transform = CGAffineTransformMakeScale(0.75, 0.75);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(RowItem *)item indexPath:(NSIndexPath *)indexPath {
    
    self.indexpath = indexPath;
    self.item = item;
    
    self.switchBtn.hidden = YES;
    self.arrowImgView.hidden = YES;
    
    
    if (item.rowtype == CommonSettingCellTypeDefault) {
        
    } else if (item.rowtype == CommonSettingCellTypeSwitch) {
        self.switchBtn.hidden = NO;
        switch(item.rowvalue.integerValue) {
            case 1:{
                self.switchBtn.on = kGetThemeLargeTitle;
            }
                break;
            case 2: {
                
                self.switchBtn.on = kGetThemeNotiAt10;
            }
                break;
            case 3:{
                
                self.switchBtn.on = kGetThemeNotiAtPosition;
            }
                break;
            
            default:
                break;
        }
        
    } else if (item.rowtype == CommonSettingCellTypeSkip) {
        self.arrowImgView.hidden = NO;
    }
    
    self.rowTitleLabel.text = item.rowname;
    
}

- (IBAction)switchClick:(UISwitch *)sender {
    switch(self.item.rowvalue.integerValue) {
        case 1:{
            kSetThemeLargeTitle(sender.isOn);
            kPOST_NOTIFICATION(ThemeLargeTitleChangeNotifocation);
        }
            break;
        case 2:{
            
            kSetThemeNotiAt10(sender.isOn);
        }
            break;
            
        case 3:{
            
            kSetThemeNotiAtPosition(sender.isOn);
        }
            break;
        default:
            break;
    }
}



@end
