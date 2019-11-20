//
//  SYAudioFileTools.m
//  Shining
//
//  Created by letv_lzb on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYAudioFileTools.h"

@implementation SYAudioFileTools

+ (BOOL)audioFileExists:(NSString *)filePath
{
    // 长度等于0，直接返回不存在
    if (filePath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@",filePath];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (existed == YES) {
        return YES;
    }else{
        // 不存在
        return NO;
    }
}

+ (NSString *)audioCreateFolder:(NSString *)folderName
{
    NSString *filePath = [NSString stringWithFormat:@"%@",folderName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (!(isDir == YES && existed == YES)) {
        // 不存在的路径才会创建
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

+ (BOOL)audioFileOrFolderExists:(NSString *)filePathName
{
    // 长度等于0，直接返回不存在
    if (filePathName.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@",filePathName];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (!(isDir == YES && existed == YES)) {
        // 不存在的路径才会创建
        return NO;
    }else{
        return YES;
    }
}

@end
