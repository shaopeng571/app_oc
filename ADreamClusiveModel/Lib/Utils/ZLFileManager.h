//
//  ZLFileManager.h
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWholePath(imagename) [[ZLFileManager personalFilesPath] stringByAppendingPathComponent:(imagename)]


NS_ASSUME_NONNULL_BEGIN

@interface ZLFileManager : NSObject


/**
 获取个人文件路径

 @return 个人文件路径
 */
+ (NSString *)personalFilesPath;


/**
 创建一个目录

 @param path 目录路径
 @return 是否创建成功
 */
+ (BOOL)createDirectoryAtPath:(NSString *)path;


/**
 检查剩余可用空间
 */
+ (void)checkFreeDisk;

/** 获得文件夹（遍历）的大小 */
+ (float )folderSizeAtPath:(NSString*) folderPath;


/**
 删除目录下所有以ext为后缀的文件

 @param path 路径
 @param ext 后缀名
 @param deep 是否深度遍历
 */
+ (void)removeFilesAtPath:(NSString *)path withExt:(NSString *)ext deep:(BOOL)deep;

/**
 删除目录下所有文件及目录

 @param path 路径
 */
+ (void)removeFilesAtPath:(NSString *)path;


/**
 删除多个文件

 @param filepaths 文件目录集合
 */
+ (void)removeFiles:(NSArray *)filepaths;

/**
 得到所有以后缀ext结尾的文件路径

 @param path 父目录
 @param ext 后缀
 @param deep 是否深度遍历
 @return 所有ext文件路径
 */
+ (NSArray *)filenamesInPath:(NSString *)path withExt:(NSString *)ext deep:(BOOL)deep;



/**
 保存图片

 @param tempImage 图片
 @param imageName 名称
 @return 存储状态
 */
+ (BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
