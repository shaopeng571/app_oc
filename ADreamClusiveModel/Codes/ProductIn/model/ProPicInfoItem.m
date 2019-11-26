//
//  ProPicInfoItem.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/29.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ProPicInfoItem.h"

@interface ProPicInfoItem() <NSCoding>

@end

@implementation ProPicInfoItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selected = NO;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.proimagepath forKey:@"proimagepath"];
    [aCoder encodeObject:self.proinfo forKey:@"proinfo"];
    [aCoder encodeBool:self.selected forKey:@"selected"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.proimagepath = [aDecoder decodeObjectForKey:@"proimagepath"];
        self.proinfo = [aDecoder decodeObjectForKey:@"proinfo"];
        self.selected = [aDecoder decodeBoolForKey:@"selected"];
    }
    return self;
}

- (void)setProimagepath:(NSString *)proimagepath {
    _proimagepath = proimagepath;
    if(proimagepath) {
        NSData *data = [NSData dataWithContentsOfFile:kWholePath(proimagepath)];
        
        [self setProimage:[UIImage imageWithData:data]];
    }
    
    
}

- (UIImage *)proimage {
    if (!_proimage) {
        _proimage = [UIImage imageNamed:@"iPhoneX-Port"];
    }
    return _proimage;
}

@end
