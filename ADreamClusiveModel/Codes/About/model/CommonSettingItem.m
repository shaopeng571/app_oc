//
//  CommonSettingItem.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/11/9.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "CommonSettingItem.h"

@implementation CommonSettingItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.groupdetail = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

// 模型中有一个数组内是另一模型
// groupdetail:本模型的属性名；RowItem:数组中存放的另一个模型对象
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"groupdetail":@"RowItem"};
}

@end

@implementation RowItem



@end
