//
//  SYAudioFileManager.h
//  Shining
//
//  Created by letv_lzb on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYAudioFileManager : NSObject

/**
 音频的拼接

 @param fromPath 前段音频路径
 @param toPath 后段音频路径
 @param outputPath 拼接后的音频路径
 */
+(void)syAddAudio:(NSString *)fromPath toAudio:(NSString *)toPath outputPath:(NSString *)outputPath;

/**
 音频的剪切

 @param audioPath 要剪切的音频路径
 @param fromTime 开始剪切的时间
 @param toTime 结束剪切的时间
 @param outputPath 剪切成功后的音频路径
 */
+(void)syCutAudio:(NSString *)audioPath fromTime:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime outputPath:(NSString *)outputPath;

/**
 把.m4a转为.caf格式
 @param originalUrlStr .m4a文件路径
 @param destUrlStr .caf文件路径
 @param completed 转化完成的block
 */
+ (void)syConvetM4aToWav:(NSString *)originalUrlStr
               destUrl:(NSString *)destUrlStr
             completed:(void (^)(NSError *error)) completed;

/**
 把.caf转为.m4a格式
 @param cafUrlStr .m4a文件路径
 @param m4aUrlStr .caf文件路径
 @param completed 转化完成的block
 */
+ (void)syConvetCafToM4a:(NSString *)cafUrlStr
               destUrl:(NSString *)m4aUrlStr
             completed:(void (^)(NSError *error)) completed;

@end

NS_ASSUME_NONNULL_END
