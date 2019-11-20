//
//  SYLameTools.h
//  Shining
//
//  Created by letv_lzb on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "include/lame.h"
#import "SYSigleCase.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLameTools : NSObject
SYSingleCaseH(SYLameTools)

/**
 caf 转 mp3

 @param sourcePath 转 mp3 的caf 路径
 @param isDelete 是否删除原来的 caf 文件，YES：删除、NO：不删除
 @param success 成功的回调
 @param fail 失败的回调
 */
+(void)audioToMP3:(NSString *)sourcePath isDeleteSourchFile: (BOOL)isDelete withSuccessBack:(void(^)(NSString *resultPath))success withFailBack:(void(^)(NSString *error))fail;

/**
 caf 转 mp3 : 录音的同时转码

 @param sourcePath 转 mp3 的caf 路径
 @param isDelete 是否删除原来的 caf 文件，YES：删除、NO：不删除
 @param success 成功的回调
 @param fail 失败的回调
 */
-(void)audioRecodingToMP3:(NSString *)sourcePath isDeleteSourchFile: (BOOL)isDelete withSuccessBack:(void(^)(NSString *resultPath))success withFailBack:(void(^)(NSString *error))fail;

/**
 录音完成的调用
 */
- (void)sendEndRecord;
@end

NS_ASSUME_NONNULL_END
