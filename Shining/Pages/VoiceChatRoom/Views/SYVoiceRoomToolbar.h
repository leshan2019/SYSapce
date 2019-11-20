//
//  SYVoiceRoomToolbar.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYChatEngineEnum.h"

@protocol SYVoiceRoomToolbarDelegate <NSObject>

- (void)voiceRoomToolbarTouchInputButton;
- (void)voiceRoomToolbarTouchSeatButton;
- (void)voiceRoomToolbarTouchMicButton;
- (void)voiceRoomToolbarTouchGiftButton;
- (void)voiceRoomToolbarTouchExpressionButton;
- (void)voiceRoomToolbarTouchPKButton;
- (void)voiceRoomToolbarTouchPrivateMessageButton;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomToolbar : UIView

@property (nonatomic, weak) id <SYVoiceRoomToolbarDelegate> delegate;

- (void)changeUserRole:(SYChatRoomUserRole)role;
- (void)changeMicState:(BOOL)isMuted;
- (void)changeApplyMicState:(BOOL)micState;
- (void)hideApplyMicButton;
- (void)setPKFuncEnable:(BOOL)enable; // pk 功能是否可用
- (void)setHasUnreadMessage:(BOOL)hasUnread;
//- (void)changeInputAvailability:(BOOL)isAvailable;

@end

NS_ASSUME_NONNULL_END
