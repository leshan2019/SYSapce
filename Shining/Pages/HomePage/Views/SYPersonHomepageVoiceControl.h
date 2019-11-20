//
//  SYPersonHomepageVoiceView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  录音播放控件
 */
@interface SYPersonHomepageVoiceControl : UIButton

// 更新录音URL+时长
- (void)updateVoiceControl:(NSString *)voiceUrl voiceDuration:(NSInteger)duration;

// 暴露给外界控制播放的方法
- (void)clickSYPersonHomepageVoiceControl;

// 开始播放
- (void)startPlay;
// 暂停播放
- (void)pausePlay;
// 继续播放
- (void)continuePlay;
// 停止播放
- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
