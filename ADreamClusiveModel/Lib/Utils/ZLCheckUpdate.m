//
//  ZLCheckUpdate.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLCheckUpdate.h"

@implementation ZLCheckUpdate


#pragma mark - 检查更新

/// 检查版本更新
+ (void)checkVersion {
    NSString *url = @"http://itunes.apple.com/lookup?id=1195492376";
    [[AFHTTPSessionManager manager] POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"版本更新检查成功");
        NSArray *results = responseObject[@"results"];
        if (results && results.count > 0) {
            NSDictionary *response = results.firstObject;
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]; // 软件的当前版本
            NSString *lastestVersion = response[@"version"]; // AppStore 上软件的最新版本
            if (currentVersion && lastestVersion && ![self isLastestVersion:currentVersion compare:lastestVersion]) {
                // 给出提示是否前往 AppStore 更新
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"检测到有版本更新，是否前往 AppStore 更新版本。" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *trackViewUrl = response[@"trackViewUrl"]; // AppStore 上软件的地址
                    if (trackViewUrl) {
                        NSURL *appStoreURL = [NSURL URLWithString:trackViewUrl];
                        if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                            [[UIApplication sharedApplication] openURL:appStoreURL];
                        }
                    }
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleCancel handler:nil]];
                
                [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"版本更新检查失败");
    }];
}

/// 判断是否最新版本号（大于或等于为最新）
+ (BOOL)isLastestVersion:(NSString *)currentVersion compare:(NSString *)lastestVersion {
    if (currentVersion && lastestVersion) {
        // 拆分成数组
        NSMutableArray *currentItems = [[currentVersion componentsSeparatedByString:@"."] mutableCopy];
        NSMutableArray *lastestItems = [[lastestVersion componentsSeparatedByString:@"."] mutableCopy];
        // 如果数量不一样补0
        NSInteger currentCount = currentItems.count;
        NSInteger lastestCount = lastestItems.count;
        if (currentCount != lastestCount) {
            NSInteger count = labs(currentCount - lastestCount); // 取绝对值
            for (int i = 0; i < count; ++i) {
                if (currentCount > lastestCount) {
                    [lastestItems addObject:@"0"];
                } else {
                    [currentItems addObject:@"0"];
                }
            }
        }
        // 依次比较
        BOOL isLastest = YES;
        for (int i = 0; i < currentItems.count; ++i) {
            NSString *currentItem = currentItems[i];
            NSString *lastestItem = lastestItems[i];
            if (currentItem.integerValue != lastestItem.integerValue) {
                isLastest = currentItem.integerValue > lastestItem.integerValue;
                break;
            }
        }
        return isLastest;
    }
    return NO;
}

@end
