//
//  SYVoiceRoomMusicPanel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SYVoiceRoomMusicPlayModeLoop = 0, // 全部循环
    SYVoiceRoomMusicPlayModeSingleLoop, // 单曲循环
    SYVoiceRoomMusicPlayModeRandom, // 随机
} SYVoiceRoomMusicPlayMode;

@protocol SYVoiceRoomMusicPanelDelegate <NSObject>

- (void)voiceRoomMusicPanelDidPlay;
- (void)voiceRoomMusicPanelDidPause;
- (void)voiceRoomMusicPanelDidPlayNext;
- (void)voiceRoomMusicPanelDidSeekToTime:(NSTimeInterval)time;
- (void)voiceRoomMusicPanelDidSelectVolumeButton;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomMusicPanel : UIView

@property (nonatomic, weak) id <SYVoiceRoomMusicPanelDelegate> delegate;
@property (nonatomic, assign, readonly) SYVoiceRoomMusicPlayMode currentPlayMode;

- (void)playWithSongTitle:(NSString *)title
                     size:(long long)size;
- (void)stopPlay;

- (void)changeCurrentPlaybackTime:(NSInteger)time;
- (void)changeDuration:(NSInteger)duration;


@end

NS_ASSUME_NONNULL_END
