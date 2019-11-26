//
//  ZLNetworkTools.m
//  SwiftExercises
//
//  Created by ADreamClusive on 16/11/2017.
//  Copyright © 2017 ADreamClusive. All rights reserved.
//

#import "ZLNetworkTools.h"
#import "ZLMd5Tools.h"

@implementation ZLNetworkTools

+ (void)monitorNetworkChanges:(void (^)(AFNetworkReachabilityStatus))networkStatus {
    //检测当前的网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 开始对网络检测
    
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态发生改变的时候调用这个block
        if (networkStatus) {
            networkStatus(status);
        }
    }];
    // 停止检测
    //    [manager stopMonitoring];
}

+ (AFHTTPSessionManager *)sessionManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30.0f;//    请求超时时长
    });
    
    return manager;
}




+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *signDict = [self signDictionary:parameters];
    
    [[ZLNetworkTools sessionManager] POST:URLString parameters:signDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSDictionary *success))success
    failure:(void (^)(NSError *error))failure{
    
    [[ZLNetworkTools sessionManager] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}

//+ (void)POST:(NSString *)URLString parameters:(NSDictionary *)parameters image:(UIImage *)image
//     success:(void (^)(NSDictionary *success))success failure:(void (^)(NSError *error))failure {
//    
//    [[ZLNetworkTools sessionManager] POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSString *imageName = [NSString stringWithFormat:@"%zd.jpg", [[NSDate date] timeIntervalSince1970]];
//        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"file" fileName:imageName mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if (success) {
//            success(result);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error) {
//            failure(error);
//        }
//    }];
//    
//}
//
///**
// *  多图上传
// */
//+(void)startMultiPartUploadTaskWithURL:(NSString *)url imagesArray:(NSArray *)images parameterOfimages:(NSString *)files parametersDict:(NSDictionary *)parameters compressionRatio:(float)ratio succeedBlock:(void (^)(NSDictionary *dict))succeedBlock failedBlock:(void (^)(NSError *error))failedBlock {
//    if (images.count == 0) {
//        NSLog(@"图片数组计数为零");
//        return;
//    }
//    for (int i = 0; i < images.count; i++) {
//        if (![images[i] isKindOfClass:[UIImage class]]) {
//            NSLog(@"images中第%d个元素不是UIImage对象",i+1);
//        }
//    }
//    
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    [[ZLNetworkTools sessionManager] POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        int i = 0;
//        //根据当前系统时间生成图片名称
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyyMMdd"];
//        NSString *dateString = [formatter stringFromDate:date];
//        
//        for (UIImage *image in images) {
//            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
//            NSData *imageData;
//            if (ratio > 0.0f && ratio < 1.0f) {
//                imageData = UIImageJPEGRepresentation(image, ratio);
//            }else{
//                imageData = UIImageJPEGRepresentation(image, 1.0f);
//            }
//            [formData appendPartWithFileData:imageData name:files fileName:fileName mimeType:@"image/jpg/png/jpeg"];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"common post json = %@", dict);
//        
//        succeedBlock(dict);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error) {
//            failedBlock(error);
//            NSLog(@"%@",error.localizedDescription);
//        }
//    }];
//}


/** 验签 */
+ (NSDictionary *)signDictionary:(NSDictionary *)parameters {
    if (!parameters && ![parameters isKindOfClass:[NSDictionary class]]) return @{};
    NSMutableDictionary *dic  = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

//    //  CT:客户端类型（ClientType:Android,IOS）
//    dic[@"CT"] = @"IOS";
//    //  CV:客户端版本（ClientVersion:1.0.1）
//    dic[@"CV"] = kAppVersion;
    //  TS:请求时间戳（TimeStamp:）
    dic[@"TS"] = [NSString stringWithFormat:@"%zd", (NSInteger)[[NSDate date] timeIntervalSince1970]];
//    //  CM:客户端型号 (ClientModel:iPhone6Plus)
//    dic[@"CM"] = [NSString deviceModelName];
//    //  SV:系统版本号 (SystemVersion:iOS 9.2.1)
//    dic[@"SV"] = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
    //  AK:请求应用表示（APPKey）
//    dic[@"AK"] = ZLAPPKEY;
    //    dic[@"schoolcode"] = @"AllSch";
//    // 登录后获得token值
//    if (kSeerToken) {
//        dic[@"SeerToken"] = kSeerToken;
//    }

    //  遍历字典去除空值
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //  所有key小写
        NSString *lowKey = [key lowercaseString];
        //  所有参数UTF8编码
        //        if ([obj isKindOfClass:[NSString class]])
        //            obj = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //  如果obj是字符串 或 obj存在 或 obj长度不为0 时将obj加入dict中
        if ([obj isKindOfClass:[NSString class]] && ([obj isKindOfClass:[NSNumber class]] || !obj || [obj length]))
            dict[lowKey] = obj;
        //  如果obj为数组 并且 obj个数不为0 将obj加入dict中
        else if ([obj isKindOfClass:[NSArray class]] && [obj count])
            dict[lowKey] = obj;
        //  如果obj为NSNumber类型则将obj转成NSString类型
        else if ([obj isKindOfClass:[NSNumber class]]) {
            dict[lowKey] = [NSString stringWithFormat:@"%@", obj];
        }
    }];
    //  加密密钥(如果为上述两个接口则使用默认密钥kAppSecretDefault)
    NSString *key = @"ADreamClusivetest";
    //  加密拼接字符串
    NSString *sign = @"";
    //  字典内所有key数组
    NSArray *allKeys = [dict allKeys];
    //  数组升序排序
    allKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
    //  遍历数组拼接加密字符串
    for (NSString *str in allKeys)
        sign = [NSString stringWithFormat:@"%@%@%@=%@", sign,sign.length?@"&":@"",str,dict[str]];
    //  在字符串最后拼接密钥
    sign = [sign stringByAppendingString:key];
    //  密钥MD5加密
    NSString *signMd5 = [ZLMd5Tools md5:sign];
    //  将密钥加入请求参数字典中
    dict[@"sign"] = signMd5;
    return dict;
}



@end
