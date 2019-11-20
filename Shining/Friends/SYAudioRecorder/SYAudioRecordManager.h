//
//  SYAudioManager.h
//  Shining
//
//  Created by letv_lzb on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SYSigleCase.h"

NS_ASSUME_NONNULL_BEGIN

// 录音存放的文件夹 /Library/Caches/JKRecorder
#define cachesRecorderFolderPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Caches/SYRecorder"]

typedef void(^SYAudioSuccess)(BOOL ret,NSString *resultPath,NSTimeInterval recordTime,NSTimeInterval duration);
typedef void(^SYLongTimeHander)(BOOL ret,NSTimeInterval recordTime);
typedef void(^SYRecordTimeHander)(NSTimeInterval currentTime,NSTimeInterval duration);

@interface SYAudioRecordManager : NSObject
SYSingleCaseH(SYAudioRecordManager)

/** 录音文件路径 */
@property (nonatomic, copy, readonly) NSString *recordPath;
/** 录音文件路径*/
@property (nonatomic, copy, readonly) NSString *recordResultPath;

/** 当前录音的时间 */
@property(nonatomic,assign) NSTimeInterval audioCurrentTime;

/**
 开始录音
 @param recordName 录音的名字
 */

/**
 开始录音

 @param recordName 录音的文件名字
 @param type 文件后缀 caf
 @param isConventToMp3 是否自动转为mp3
 @param duration 录制时长： 小于0 时 不限定时长
 */
- (void)beginRecordWithRecordName:(NSString *)recordName withRecordType:(NSString *)type withAutoConventToMp3:(BOOL)isConventToMp3 duration:(CGFloat) duration;

/** 结束录音 */
- (void)endRecord;

/** 暂停录音 */
- (void)pauseRecord;

/** 删除录音 */
- (void)deleteRecord;

/** 重新录音 */
- (void)reRecord;

/**
 更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息
 @property(getter=isMeteringEnabled) BOOL meteringEnabled：是否启用音频测量，默认为NO，一旦启用音频测量可以通过updateMeters方法更新测量值
 */
- (void)updateMeters;

/**
 获得指定声道的分贝峰值
 获得指定声道的分贝峰值，注意如果要获得分贝峰值必须在此之前调用updateMeters方法
 @return 指定频道的值
 */
- (float)peakPowerForChannel0;


/**
 <#Description#>

 @param successBlock <#successBlock description#>
 */
- (void)setSuccessBlock:(SYAudioSuccess)successBlock;


/**
 <#Description#>

 @param longTimerHander <#longTimerHander description#>
 */
- (void)setLongTimerHander:(SYLongTimeHander)longTimerHander;

/**
 <#Description#>

 @param recordTimerHander <#recordTimerHander description#>
 */
- (void)setRecordTimerHander:(SYRecordTimeHander)recordTimerHander;

@end

NS_ASSUME_NONNULL_END
