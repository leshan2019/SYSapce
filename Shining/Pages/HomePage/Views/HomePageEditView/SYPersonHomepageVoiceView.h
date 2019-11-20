//
//  SYPersonHomepageVoiceView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYPersonHomepageVoiceViewDelegate <NSObject>

// 删除server端录音文件
- (void)SYPersonHomepageVoiceViewDeleteServerVoice;

// 删除本地录音文件
- (void)SYPersonHomepageVoiceViewDeleteLocalVoice:(NSString *)localVoiceUrl;

// 保存本地录音文件
- (void)SYPersonHomepageVoiceViewSaveLocalVoice:(NSString *)localVoiceUrl voiceDuration:(NSInteger)duration;

- (void)SYPersonHomepageVoiceViewLeadUserToOpenRecordPermission;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  个人主页编辑 - 声音view
 */
@interface SYPersonHomepageVoiceView : UIView

@property (nonatomic, weak) id <SYPersonHomepageVoiceViewDelegate> delegate;

- (void)updateVoiceViewWithVoiceUrl:(NSString *)voiceUrl voiceDuration:(NSInteger)duration;

// 进入录音准备状态
- (void)setVoiceViewToRecordState;

// 停止播放
- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
