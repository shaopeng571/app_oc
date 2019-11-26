//
//  ZLNetworkTools.h
//  SwiftExercises
//
//  Created by ADreamClusive on 16/11/2017.
//  Copyright © 2017 ADreamClusive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface ZLNetworkTools : NSObject

/**
 *  监测网络变化
 *
 *  @param networkStatus  网络状态改变
 *  AFNetworkReachabilityStatusReachableViaWiFi WIFI网络
 *  AFNetworkReachabilityStatusReachableViaWWAN 蜂窝网络
 *  AFNetworkReachabilityStatusUnknown          未知网络
 *  AFNetworkReachabilityStatusNotReachable     没有网络
 */
+ (void)monitorNetworkChanges:(void (^)(AFNetworkReachabilityStatus status))networkStatus;

/**
 *  POST请求
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功返回参数
 *  @param failure    请求失败返回参数
 */
+ (void)POST:(NSString *)URLString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSDictionary *success))success
     failure:(void (^)(NSError *error))failure;


/**
 *  GET请求
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功返回参数
 *  @param failure    请求失败返回参数
 */
+ (void)GET:(NSString *)URLString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSDictionary *success))success
    failure:(void (^)(NSError *error))failure;

/**
 *  带图片post请求
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param image      附带图片
 *  @param success    请求成功
 *  @param failure    请求失败
 */

//+ (void)POST:(NSString *)URLString
//  parameters:(NSDictionary *)parameters
//       image:(NSImage *)image
//     success:(void (^)(NSDictionary *success))success
//     failure:(void (^)(NSError *error))failure;
//
+ (AFHTTPSessionManager *)sessionManager;
//
///**
// *  上传带图片的内容，允许多张图片上传（URL）POST
// *
// *  @param url          传url
// *  @param images       要上传的图片数组（注意数组内容需是图片）
// *  @param files    图片数组对应的参数 可以为nil
// *  @param parameters   其他参数字典 可以为nil
// *  @param ratio        图片的压缩比例（0.0~1.0之间）
// *  @param succeedBlock 成功的回调
// *  @param failedBlock  失败的回调
// */
//+ (void)startMultiPartUploadTaskWithURL:(NSString *)url
//                            imagesArray:(NSArray *)images
//                      parameterOfimages:(NSString *)files
//                         parametersDict:(NSDictionary *)parameters
//                       compressionRatio:(float)ratio
//                           succeedBlock:(void (^)(NSDictionary *dict))succeedBlock
//                            failedBlock:(void (^)(NSError *error))failedBlock;
//
//





@end
