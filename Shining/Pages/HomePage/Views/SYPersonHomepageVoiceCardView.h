//
//  SYPersonHomepageVoiceCardView.h
//  Shining
//
//  Created by yangxuan on 2019/10/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FirstRecord)(void);
typedef void(^AgainRecord)(void);

NS_ASSUME_NONNULL_BEGIN

/**
    声音卡片
 */
@interface SYPersonHomepageVoiceCardView : UIView

- (instancetype)initVoiceCardViewWithFrame:(CGRect)frame
                               recordVoice:(FirstRecord)recordBlock
                             tapArrowBlock:(AgainRecord)tapArrowBLock;

// 更新声音和url
- (void)updateVoiceControl:(NSString *)voiceUrl voiceDuration:(NSInteger)duration;

// 停止播放录音
- (void)stopPlayVoice;

// 更新卡片标题
- (void)updateTitle:(NSString *)title;

// 是否展示右侧arrow按钮
- (void)hideArrowBtn;

// 是否展示底部分割线
- (void)showBottomLine:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
