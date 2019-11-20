//
//  SYAudioPlayer.h
//  Shining
//
//  Created by letv_lzb on 2019/3/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    SYAudioPlayStatusPrepare,
    SYAudioPlayStatusPlaying,
    SYAudioPlayStatusPause,
    SYAudioPlayStatusFinish,
    SYAudioPlayStatusError,
} SYAudioPlayStatus;


typedef void(^SYAudioPlayerCallBack)(SYAudioPlayStatus status,NSTimeInterval playTime,NSTimeInterval playDutation,NSString *error);

@interface SYAudioPlayer : NSObject

/**
 * 是否自动联播
 */
@property (nonatomic, assign) BOOL isAutomaticPlayNext;

- (id)initWithUrls:(NSArray *)urls seekDuration:(NSTimeInterval)seekTime duration:(NSTimeInterval)duration;

- (id)initWithUrls:(NSArray *)urls seekDuration:(NSTimeInterval)seekTime duration:(NSTimeInterval)duration playerCallBack:(SYAudioPlayerCallBack)callBack;

- (void)setPlayerCallBack:(SYAudioPlayerCallBack)callBack;

- (void)play;
// 重播
- (void)rePLay;
- (void)pause;
- (void)stop;
- (void)seek:(NSTimeInterval)time;
- (BOOL)next;
- (BOOL)previous;

@end

NS_ASSUME_NONNULL_END
