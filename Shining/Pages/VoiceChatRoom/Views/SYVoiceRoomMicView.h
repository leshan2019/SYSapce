//
//  SYVoiceRoomMicView.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYVoiceChatUserViewModel;

typedef enum : NSUInteger {
    SYVoiceRoomMicViewStyleOrdinary, // 普通麦位
    SYVoiceRoomMicViewStyleHost, // 主持
    SYVoiceRoomMicViewStyleSingleHost, // 单独只有一个主持人
} SYVoiceRoomMicViewStyle;

@class SYVoiceRoomMicView;

@protocol SYVoiceRoomMicViewDelegate <NSObject>

- (void)voiceRoomMicViewDidSelectMic:(SYVoiceRoomMicView *)micView
                             atIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomMicView : UIView

@property (nonatomic, weak) id <SYVoiceRoomMicViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                        style:(SYVoiceRoomMicViewStyle)style
                      position:(NSInteger)position;

- (void)drawWithUserViewModel:(SYVoiceChatUserViewModel *)userViewModel;

- (void)changeMuteState:(BOOL)isMuted; // 改变静音状态

- (BOOL)isOccupied;

- (void)drawSpeakerAudioWave;
- (void)removeSpeakerAudioWave;

- (void)showGameImages:(NSArray *)images repeatTime:(NSInteger)repeat result:(NSString *)result;
- (void)showExpressionImages:(NSArray <UIImage *>*)images;

- (void)showGiftAnimationWithImageUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
