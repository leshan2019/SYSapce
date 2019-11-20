//
//  SYVoiceRoomUserInfoView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceChatUserViewModel.h"
#import "SYVoiceTextMessageViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SYVoiceChatUserViewModel;

@protocol SYVoiceRoomUserInfoViewDataSource <NSObject>

- (BOOL)voiceRoomUserInfoViewUserIsMutedWithUid:(NSString *)uid
                                  atMicPosition:(NSInteger)micPosition;

@end

@protocol SYVoiceRoomUserInfoViewDelegate <NSObject>

- (void)voiceRoomUserInfoViewDidFetchUserInfoWithUid:(NSString *)uid
                                           isFromMic:(BOOL)isFromMic
                                       atMicPosition:(NSInteger)micPosition
                                            username:(NSString *)username
                                              avatar:(NSString *)avatar
                                           avatarBox:(NSInteger)avatarBox
                                    broadcasterLevel:(NSInteger)broadcasterLevel
                                       isBroadcaster:(NSInteger)isBroadcaster
                                        isSuperAdmin:(NSUInteger)isSuperAdmin;
- (void)voiceRoomUserInfoViewDidKickUserFromMicWithUid:(NSString *)uid
                                         atMicPosition:(NSInteger)micPosition;
- (void)voiceRoomUserInfoViewDidChangeMuteStateWithUid:(NSString *)uid
                                         atMicPosition:(NSInteger)micPosition;
- (void)voiceRoomUserInfoViewDidSelectGiftButtonWithUser:(SYVoiceChatUserViewModel *)user;
- (void)voiceRoomUserInfoViewDidForbidUserChatWithUser:(SYVoiceChatUserViewModel *)user;
- (void)voiceRoomUserInfoViewDidCancelForbidUserChatWithUser:(SYVoiceChatUserViewModel *)user;
- (void)voiceRoomUserInfoViewDidForbidUserEnterWithUser:(SYVoiceChatUserViewModel *)user;
- (void)voiceRoomUserInfoViewDidCancelForbidUserEnterWithUser:(SYVoiceChatUserViewModel *)user;

- (void)voiceRoomUserInfoViewDidClose;
- (void)voiceRoomUserInfoViewGoToUserHomePageWithUid:(NSString *)uid;
- (void)voiceRoomUserInfoViewGoToPrivateMessageWithUserId:(NSString *)userId
                                                 username:(NSString *)username
                                                   avatar:(NSString *)avatar
                                              em_username:(NSString *)em_username;

- (BOOL)voiceRoomUserInfoViewShouldFollowUser;  // 是否可以关注用户
- (void)voiceRoomUserInfoViewClickReport:(NSString *)reporterId;       // 举报
- (void)voiceRoomUserInfoViewDidFollowUserWithUser:(SYVoiceChatUserViewModel *)user;
- (void)voiceRoomUserInfoViewDidCancelFollowUserWithUser:(SYVoiceChatUserViewModel *)user;

@end

@interface SYVoiceRoomUserInfoView : UIView

@property (nonatomic, weak) id <SYVoiceRoomUserInfoViewDataSource> dataSource;
@property (nonatomic, weak) id <SYVoiceRoomUserInfoViewDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isFromMic;

- (void)showWithChannelID:(NSString *)channelID
                  UserUid:(NSString *)uid
                 isMyself:(BOOL)isMyself
                isFromMic:(BOOL)isFromMic
              micPosition:(NSInteger)micPosition
                  isAdmin:(BOOL)isAdmin;

- (void)reloadMuteState;
- (void)reloadForbidChatState:(BOOL)isForbidden
                          uid:(NSString *)uid;
- (void)reloadForbidEnterState:(BOOL)isForbidden
                           uid:(NSString *)uid;
- (void)reloadIskickedFromMicWithUid:(NSString *)uid;

@end

NS_ASSUME_NONNULL_END
