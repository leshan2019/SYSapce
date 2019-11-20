//
//  SYAudioFileTools.h
//  Shining
//
//  Created by letv_lzb on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYAudioFileTools : NSObject
/**
 判断文件或文件夹是否存在
@param filePathName 文件夹或文件名
@return YES:存在 NO:不存在
*/
+(BOOL)audioFileOrFolderExists:(NSString *)filePathName;

/**
 判断文件是否存在
 @param filePath 文件路径
 @return YES:存在 NO:不存在
 */
+(BOOL)audioFileExists:(NSString *)filePath;

/**
 类方法创建文件夹目录
 @param folderName 文件夹的名字
 @return 返回一个路径
 */
+(NSString *)audioCreateFolder:(NSString *)folderName;

@end

NS_ASSUME_NONNULL_END
