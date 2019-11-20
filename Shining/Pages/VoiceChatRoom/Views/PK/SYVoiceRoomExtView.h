//
//  SYVoiceRoomPKView.h
//  Shining
//
//  Created by mengxiangjian on 2019/7/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceChatRoomViewModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SYLiveRoomUserActionType) {
    SYLiveRoomUserActionType_PK,
    SYLiveRoomUserActionType_privateMsg,
    SYLiveRoomUserActionType_closeAnimation,
    SYLiveRoomUserActionType_redpackage,
    SYLiveRoomUserActionType_clear,
    SYLiveRoomUserActionType_hide  //榜单隐身
};


@protocol SYVoiceRoomExtViewDelegate <NSObject>

- (void)voiceRoomExtViewDidStartPK;
- (void)voiceRoomExtViewDidStopPK;
- (void)voiceRoomExtViewDidClearPublicScreen;
- (void)voiceRoomExtViewDidRedPct;
- (void)animationSwitchAction:(BOOL)isOff;
- (void)voiceRoomExtViewDidPrivateMsg;
- (void)voiceRoomExtViewDidChartHideAction:(BOOL)isHide;
@end

@interface SYVoiceRoomExtView : UIView

@property (nonatomic, weak) id <SYVoiceRoomExtViewDelegate> delegate;
- (void)setVoiceViewModel:(SYVoiceChatRoomViewModel *)voiceViewModel;
- (void)setVoiceViewModel:(SYVoiceChatRoomViewModel *)voiceViewModel roomType:(BOOL)isLive;
- (void)setHasUnreadMessage:(BOOL)hasUnread;

@end

NS_ASSUME_NONNULL_END
