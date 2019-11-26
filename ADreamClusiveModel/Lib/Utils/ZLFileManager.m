//
//  ZLFileManager.m
//  ADreamClusiveModel
//
//  Created by ADreamClusive 2018 on 2018/10/12.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ZLFileManager.h"

#define DEFAULT_FILEMANAGER [NSFileManager defaultManager]

@implementation ZLFileManager

+ (NSString *)personalFilesPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *personalPath  = [paths.firstObject stringByAppendingPathComponent:@"images"];
    
    // 不存在则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:personalPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:personalPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return personalPath;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path {
    NSString *absolutePath = [self absolutePath:path]; // 如果已经存在会直接返回YES
    return [DEFAULT_FILEMANAGER createDirectoryAtPath:absolutePath withIntermediateDirectories:YES attributes:nil error:nil];
}


+ (void)removeFilesAtPath:(NSString *)path {
    [self removeFile:path];
}

+ (void)removeFilesAtPath:(NSString *)path withExt:(NSString *)ext deep:(BOOL)deep {
    NSArray *filepaths = [self filenamesInPath:path withExt:ext deep:deep];
    
    for (NSString *filepath in filepaths) {
        [self removeFile:filepath];
    }
}

+ (void)removeFiles:(NSArray *)filepaths {
    for (NSString *filename in filepaths) {
        [self removeFile:filename];
    }
}

+ (BOOL)removeFile:(NSString *)filepath {
    return [DEFAULT_FILEMANAGER removeItemAtPath:[self absolutePath:filepath] error:nil];
}


+ (NSArray *)filenamesInPath:(NSString *)path withExt:(NSString *)ext deep:(BOOL)deep {
    NSArray *filenamespaths = [self filenamesInPath:path deep:deep];
    
    NSMutableArray *fileextpaths = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *subpath in filenamespaths) {
        if ([[subpath pathExtension] isEqualToString:ext]) {
            [fileextpaths addObject:subpath];
        }
    }
    return fileextpaths;
}

+ (NSArray *)filenamesInPath:(NSString *)path deep:(BOOL)deep {
    
    if (![DEFAULT_FILEMANAGER fileExistsAtPath:path]) {
        return @[];
    }
    
    NSString *absolutePath = [self absolutePath:path];
    
    if (![self isDirectory:path]) {
        return @[absolutePath];
    }
    
    // 相对路径数组 如果path是目录，则返回一个数组@[]
    NSArray *relativeSubpaths = deep?
                        [DEFAULT_FILEMANAGER subpathsOfDirectoryAtPath:path error:nil]: // 若path不是目录，则返回@[]
                        [DEFAULT_FILEMANAGER contentsOfDirectoryAtPath:path error:nil]; // 若path不是目录，则返回nil
    
    // 绝对路径数组
    NSMutableArray *absoluteSubpaths = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *relativeSubpath in relativeSubpaths) {
        NSString *absoluteSubpath = [absolutePath stringByAppendingPathComponent:relativeSubpath];
        [absoluteSubpaths addObject:absoluteSubpath];
    }

    return absoluteSubpaths;
}

+(NSString *)absolutePath:(NSString *)path
{
    [self assertPath:path];
    
    return path;
}

+(void)assertPath:(NSString *)path
{
    NSAssert(path != nil, @"Invalid path. Path cannot be nil.");
    NSAssert(![path isEqualToString:@""], @"Invalid path. Path cannot be empty string.");
}



// 获取可用空间大小

+ (void)checkFreeDisk
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSString *free = [NSString stringWithFormat:@"可用空间：%.2fG",([freeSpace doubleValue])/(pow(10, 9))];
    NSLog(@"free === \n%@",free);
}


//遍历文件夹获得文件夹大小，返回字节
+ (long long) folderSizeAtPath2:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSString* fileName = [folderPath copy];
    long long folderSize = 0;
    BOOL isdir;
    [manager fileExistsAtPath:fileName isDirectory:&isdir];
    if (isdir != YES) {
        return [self fileSizeAtPath:fileName];
        
    } else {
        NSArray * items = [manager contentsOfDirectoryAtPath:fileName error:nil];
        for (int i =0; i<items.count; i++) {
            BOOL subisdir; NSString* fileAbsolutePath = [fileName stringByAppendingPathComponent:items[i]];
            [manager fileExistsAtPath:fileAbsolutePath isDirectory:&subisdir];
            if (subisdir==YES) {
                folderSize += [self folderSizeAtPath2:fileAbsolutePath]; //文件夹就递归计算
                
            } else {
                folderSize += [self fileSizeAtPath:fileAbsolutePath];//文件直接计算
            }
        }
    }
    return folderSize;  //folderSize/(1024*1024)递归时候会运算两次出错，所以返回字节。在外面再计算
}

// 获得文件夹（遍历）的大小
+ (float )folderSizeAtPath:(NSString*) folderPath{
    long long Siz = [self folderSizeAtPath2:folderPath];
    return (CGFloat)Siz / (pow(10, 6));
//    NSFileManager* manager = [NSFileManager defaultManager];
//    if (![manager fileExistsAtPath:folderPath]) return 0;
//    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
//    NSString* fileName;
//    long long folderSize = 0;
//    while ((fileName = [childFilesEnumerator nextObject]) != nil){
//        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
//        folderSize += [self fileSizeAtPath:fileAbsolutePath];
//    }
    
//    return (CGFloat)folderSize/(pow(10, 6));  // MB
}
// 单个文件的大小
+ (long long) fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        /**
         {
         NSFileCreationDate = "2018-10-12 08:27:03 +0000";
         NSFileExtensionHidden = 0;
         NSFileGroupOwnerAccountID = 501;
         NSFileGroupOwnerAccountName = mobile;
         NSFileModificationDate = "2018-10-12 08:29:45 +0000";
         NSFileOwnerAccountID = 501;
         NSFileOwnerAccountName = mobile;
         NSFilePosixPermissions = 420;
         NSFileProtectionKey = NSFileProtectionCompleteUntilFirstUserAuthentication;
         NSFileReferenceCount = 1;
         NSFileSize = 65536;
         NSFileSystemFileNumber = 3334322;
         NSFileSystemNumber = 16777219;
         NSFileType = NSFileTypeRegular;
         }
         */
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
    } else {
        NSLog(@"计算文件大小：文件不存在");
    }
    return 0;
}



+ (BOOL)isDirectory:(NSString *)filePath
{
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    return isDirectory;
}


+ (BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    
    NSString *filePath = [[ZLFileManager personalFilesPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    
    // 保存文件的名称
    BOOL result = NO;
    if ([imageName.pathExtension isEqualToString:@"png"]) {
        result = [UIImagePNGRepresentation(tempImage) writeToFile:filePath atomically:YES];
    } else {
        result = [UIImageJPEGRepresentation(tempImage, 1) writeToFile:filePath atomically:YES];
    }
    
    return result;
}



@end
