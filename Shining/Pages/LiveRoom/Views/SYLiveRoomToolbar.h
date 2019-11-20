//
//  SYLiveRoomToolbar.h
//  Shining
//
//  Created by mengxiangjian on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYLiveRoomToolbarDelegate <NSObject>

- (void)liveRoomToolbarDidSelectClose;
- (void)liveRoomToolbarTouchGiftButton;
- (void)liveRoomToolbarTouchInputButton;
- (void)liveRoomToolbarTouchExpressionButton;
- (void)liveRoomToolbarTouchPrivateMessageButton;
- (void)liveRoomToolbarTouchShareButton;
- (void)liveRoomToolbarTouchMoreButton;

@end

@interface SYLiveRoomToolbar : UIView

@property (nonatomic, weak) id <SYLiveRoomToolbarDelegate> delegate;

- (void)setUserRoleWithIsHost:(BOOL)isHost;
- (void)setHasUnreadMessage:(BOOL)hasUnread;

@end

NS_ASSUME_NONNULL_END
