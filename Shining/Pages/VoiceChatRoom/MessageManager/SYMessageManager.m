//
//  SYMessageManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMessageManager.h"
#import "SYSignalingManager.h"
#import "SYSocketEngine.h"
#import "SYVoiceChatEngine.h"
#import "SYSettingManager.h"
#import "YYModel.h"
#import "SYVoiceRoomMessage.h"
#import "SYVoiceRoomPKListModel.h"
#import "SYVoiceRoomKingModel.h"
#import "SYChatRoomModel.h"

#define Signaling_Action_JoinChannel @"userJoinChannel"
#define Signaling_Action_LeaveChannel @"userLeaveChannel"
#define Signaling_Action_ApplyMic @"requestMic"
#define Signaling_Action_CancelApplyMic @"downRequest"
#define Signaling_Action_ConfirmMic @"upMic"
#define Signaling_Action_KickMic @"downMic"
#define Signaling_Action_TurnOffMic @"closeMic"
#define Signaling_Action_TurnOnMic @"openMic"
#define Signaling_Action_Text @"sendMessage"
#define Signaling_Action_Gift @"sendGift"
#define Signaling_Action_ConfirmHost @"upDirector"
#define Signaling_Action_KickHost @"downDirector"
#define Signaling_Action_HostTurnOffMic @"closeDirectorMic"
#define Signaling_Action_HostTurnOnMic @"openDirectorMic"
#define Signaling_Action_ForbidChat @"userSilence"
#define Signaling_Action_CancelForbidChat @"userSilenceCancel"
#define Signaling_Action_ForbidEnter @"userGetOut"
#define Signaling_Action_CancelForbidEnter @"userGetOutCancel"
#define Signaling_Action_CloseChannel @"channelClosed"
#define Signaling_Action_OpenChannel @"channelOpen"
#define Signaling_Action_UpdateChannel @"channelUpdate"
#define Signaling_Action_AddAdminister @"adminAdd"
#define Signaling_Action_DeleteAdminister @"adminDelete"
#define Signaling_Action_GameStart @"startGame"
#define Signaling_Action_HostGameStart @"startDirectorGame"
#define Signaling_Action_GameWin @"sendWin"
#define Signaling_Action_BeeWin @"sendBeeWin" // 采蜜飘屏action
#define Signaling_Action_StartPK @"startPK"
#define Signaling_Action_StopPK @"stopPK"
#define Signaling_Action_SyncPK @"syncPK"
#define Signaling_Action_Clear @"clean"
#define Signaling_Action_Upgrade @"userLevelUpgrade"
#define Signaling_Action_BreakEgg @"breakEgg"
#define Signaling_Action_Emoji  @"sendEmoji"
#define Signaling_Action_HostEmoji  @"sendDirectorEmoji"
#define Signaling_Action_RoomKing  @"roomKing"
#define Signaling_Action_SyncRoomInfo  @"channelSync"
#define Signaling_Action_Follow  @"concern"
#define Signaling_Action_BeeHoney @"honeyCollect"
#define Signaling_Action_sendBoon @"sendBoon"
#define Signaling_Action_getBoon @"getBoon"
#define Signaling_Action_boonEmptied @"boonEmptied"
#define Signaling_Action_startStreaming @"startStreaming"

#define Signaling_ExtraType_PK 1
#define Signaling_ExtraType_RoomKing 2
#define Signaling_ExtraType_Boon 3
#define Signaling_ExtraType_SyncRoomInfo 4

@interface SYMessageManager () <SYVoiceChatEngineDelegate, SYSocketEngineDelegate, SYSignalingManagerDelegate, SYVoiceRoomEMManagerDelegate>

@property (nonatomic, strong) SYSignalingManager *signalingManager;
//@property (nonatomic, strong) SYSocketEngine *socketEngine;
@property (nonatomic, strong) SYVoiceChatEngine *voiceChatEngine;

@property (nonatomic, strong) NSString *channelID;
//@property (nonatomic, strong) UserProfileEntity *userModel;
@property (nonatomic, assign) SYChatRoomUserRole role;
@property (nonatomic, strong) NSString *sdkUserId;
@property (nonatomic, strong) NSString *signalingToken;
@property (nonatomic, strong) NSString *mediaToken;
@property (nonatomic, strong) NSString *emGroupId;
@property (nonatomic, strong) NSString *emUserId;

@end

@implementation SYMessageManager

- (void)dealloc {
    [[SYVoiceRoomEMManager sharedInstance] stop];
}

- (instancetype)initWithChannelID:(NSString *)channelID {
    self = [super init];
    if (self) {
        _channelID = channelID;
//        _userModel = [UserProfileEntity getUserProfileEntity];
//        _socketEngine = [[SYSocketEngine alloc] init];
        _voiceChatEngine = [SYVoiceChatEngine sharedEngine];
        _voiceChatEngine.delegate = self;
        [SYVoiceRoomEMManager sharedInstance].delegate = self;
    }
    return self;
}

- (void)setVoiceEngineEnabled:(BOOL)voiceEngineEnabled {
    _voiceEngineEnabled = voiceEngineEnabled;
    self.voiceChatEngine.voiceEngineEnabled = voiceEngineEnabled;
}

- (void)startProcessWithUserRole:(SYChatRoomUserRole)role
                          userId:(NSString *)userId
                  signalingToken:(NSString *)signalingToken
                      mediaToken:(NSString *)mediaToken
                         groupId:(NSString *)groupId
                        emUserId:(NSString *)emUserId {
    if (self.channelID) {
        self.sdkUserId = userId;
        self.emGroupId = groupId;
        self.emUserId = emUserId;
        self.signalingManager = [[SYSignalingManager alloc] initWithUserID:userId
                                                                     token:signalingToken
                                                                 channelID:self.channelID];
        [self.signalingManager startWithDelegate:self];
//        [self.socketEngine openWithRoomId:self.channelID
//                                 delegate:self];
        self.role = role;
        self.signalingToken = signalingToken;
        self.mediaToken = mediaToken;
        [[SYVoiceRoomEMManager sharedInstance] checkUnreadMessage];
    }
}

- (void)reJoinVoiceRoomWithUserId:(NSString *)userId
                       mediaToken:(NSString *)mediaToken {
    self.sdkUserId = userId;
    [self.voiceChatEngine joinChannelWithChannelID:self.channelID
                                               uid:userId
                                             token:mediaToken
                                              role:self.role];
}

- (void)changeUserRoleWithRole:(SYChatRoomUserRole)role {
    self.role = role;
    [self.voiceChatEngine changeUserRoleWithRole:role];
}

- (void)muteUserLocalAudioStream:(BOOL)muted {
    [self.voiceChatEngine setMuted:muted];
}

- (void)leaveChannelWithUser:(SYVoiceRoomUser *)user {
    [self sendLeaveChannelMessageWithUser:user];
}

- (void)leaveVoiceEngine {
    [self.voiceChatEngine leaveChannel];
}

- (void)leaveSignaling {
    [self.signalingManager leaveChannel];
}

- (void)leaveEM {
    [[SYVoiceRoomEMManager sharedInstance] leaveChatRoom:self.emGroupId];
    [[SYVoiceRoomEMManager sharedInstance] leaveChatRoom:[self overScreenVoiceRoomId]];
    [[SYVoiceRoomEMManager sharedInstance] leaveChatRoom:[self overScreenLiveRoomId]];
}

- (void)reJoinEMWithEMUserId:(NSString *)emUserId {
    if (self.needSendToEM) {
        self.emUserId = emUserId;
        [[SYVoiceRoomEMManager sharedInstance] start];
        __weak typeof(self) weakSelf = self;
        [[SYVoiceRoomEMManager sharedInstance] enterChatRoomWithChatRoomId:self.emGroupId success:^(BOOL success) {
            if (success) {
                if ([weakSelf.delegate respondsToSelector:@selector(messageManagerDidJoinEMChannel)]) {
                    [weakSelf.delegate messageManagerDidJoinEMChannel];
                }
            }
        }];
        [[SYVoiceRoomEMManager sharedInstance] enterChatRoomWithChatRoomId:[self overScreenVoiceRoomId] success:^(BOOL success) {
            
        }];
        
        [[SYVoiceRoomEMManager sharedInstance] enterChatRoomWithChatRoomId:[self overScreenLiveRoomId] success:^(BOOL success) {
            
        }];
    }
}

- (void)renewVoiceEngineToken:(NSString *)token {
    if (self.voiceChatEngine) {
        [self.voiceChatEngine renewToken:token];
    }
}

- (void)sendTextMessage:(SYVoiceRoomText *)text
                   user:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_Text;
    message.msg = text;
//    SYVoiceRoomUser *user1 = [SYVoiceRoomUser new];
//    message.user = user1;
//    user1.uid = self.userModel.userid;
//    user1.username = self.userModel.username;
//    user1.icon = self.userModel.avatar_imgurl;
//    user1.level = self.userModel.level;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendDanmaku:(SYVoiceRoomText *)danmaku
          danmukuId:(NSInteger)danmakuId
               user:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_Text;
    message.msg = danmaku;
    message.msg.type = danmakuId + 10;
//    SYVoiceRoomUser *user1 = [SYVoiceRoomUser new];
//    message.user = user1;
//    user1.uid = self.userModel.userid;
//    user1.username = self.userModel.username;
//    user1.icon = self.userModel.avatar_imgurl;
//    user1.level = self.userModel.level;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendGiftMessage:(SYVoiceRoomGift *)gift
                 toUser:(SYVoiceRoomUser *)user
                 myself:(SYVoiceRoomUser *)myself {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_Gift;
    message.gift = gift;
    message.receiver = user;
    message.user = myself;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendRandomGiftMessage:(SYVoiceRoomGift *)gift
                       myself:(SYVoiceRoomUser *)myself {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_Gift;
    message.gift = gift;
    message.user = myself;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendEnterChannelMessageWithUser:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_JoinChannel;
//    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    message.user = user;
//    user.uid = self.userModel.userid;
//    user.username = self.userModel.username;
//    user.icon = self.userModel.avatar_imgurl;
//    user.vehicle = self.userModel.vehicle;
//    user.level = self.userModel.level;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
    [[SYWebConnectonManager sharedManager] userJoinChannel:self.channelID];
}

- (void)sendLeaveChannelMessageWithUser:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_LeaveChannel;
//    SYVoiceRoomUser *user = [SYVoiceRoomUser new];
    message.user = user;
//    user.uid = self.userModel.userid;
//    user.username = self.userModel.username;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
    [[SYWebConnectonManager sharedManager] userLeaveChannel:self.channelID];
}

- (void)sendRequestMicMessage:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_ApplyMic;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendCancelRequestMicMessage:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_CancelApplyMic;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendUpMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position isMute:(BOOL)isMute {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_ConfirmMic;
    message.user = user;
    message.position = position;
    message.status = isMute;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendDownMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_KickMic;
    message.user = user;
    message.position = position;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendHostUpMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_ConfirmHost;
    message.user = user;
    message.position = position;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendHostDownMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_KickHost;
    message.user = user;
    message.position = position;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendTurnOnMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_TurnOnMic;
    message.user = user;
    message.position = position;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendTurnOffMic:(SYVoiceRoomUser *)user position:(NSInteger)position {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_TurnOffMic;
    message.user = user;
    message.position = position;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendHostTurnOnMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_HostTurnOnMic;
    message.user = user;
    message.position = position;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendHostTurnOffMic:(SYVoiceRoomUser *)user position:(NSInteger)position {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_HostTurnOffMic;
    message.user = user;
    message.position = position;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendForbidUserChat:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_ForbidChat;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendCancelForbidUserChat:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_CancelForbidChat;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendForbidUserEnter:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_ForbidEnter;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendCancelForbidUserEnter:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_CancelForbidEnter;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendFollowUserWithUser:(SYVoiceRoomUser *)user
                      followee:(SYVoiceRoomUser *)followee {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_Follow;
    message.user = user;
    message.receiver = followee;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendCloseChannel {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_CloseChannel;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendOpenChannel {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_OpenChannel;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendUpdateChannel {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_UpdateChannel;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendAddAdminister:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_AddAdminister;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendDeleteAdminister:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_DeleteAdminister;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendStartPK:(SYVoiceRoomPKListModel *)pkListModel; {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_StartPK;
    message.extra = [SYVoiceRoomExtra new];
    message.extra.type = Signaling_ExtraType_PK;
    message.extra.data = [pkListModel yy_modelToJSONString];
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendStopPK:(SYVoiceRoomPKListModel *)pkListModel {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_StopPK;
    message.extra = [SYVoiceRoomExtra new];
    message.extra.type = Signaling_ExtraType_PK;
    message.extra.data = [pkListModel yy_modelToJSONString];
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendSyncPK:(SYVoiceRoomPKListModel *)pkListModel {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_SyncPK;
    message.extra = [SYVoiceRoomExtra new];
    message.extra.type = Signaling_ExtraType_PK;
    message.extra.data = [pkListModel yy_modelToJSONString];
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)clearPublicScreen {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_Clear;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendGroupRedPacketKing:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_sendBoon;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
}

- (void)sendGetGroupRedPacketKing:(SYVoiceRoomUser *)user fromUserModel:(SYVoiceRoomBoonModel *)fromModel {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_getBoon;
    message.user = user;
    message.extra = [SYVoiceRoomExtra new];
    message.extra.type = Signaling_ExtraType_Boon;
    message.extra.data = [fromModel yy_modelToJSONString];
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
}

- (void)sendGetGroupRedpacketEmptyKing:(SYVoiceRoomBoomEmptyModel *)emptyModel {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_boonEmptied;
    message.extra = [SYVoiceRoomExtra new];
    message.extra.type = Signaling_ExtraType_Boon;
    message.extra.data = [emptyModel yy_modelToJSONString];
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
}

- (void)sendUserUpgrade:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_Upgrade;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendBreakEggWithGift:(SYVoiceRoomGift *)gift
                        user:(SYVoiceRoomUser *)user
                    gameName:(NSString *)gameName {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_BreakEgg;
    message.user = user;
    message.gift = gift;
    message.gameName = gameName;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendBeeHoneyWithGift:(SYVoiceRoomGift *)gift
                        user:(SYVoiceRoomUser *)user
                    gameName:(NSString *)gameName {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_BeeHoney;
    message.user = user;
    message.gift = gift;
    message.gameName = gameName;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendExpression:(SYVoiceRoomExpression *)expression
                  user:(SYVoiceRoomUser *)user
              position:(NSInteger)position {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_Emoji;
    message.user = user;
    message.emoji = expression;
    message.position = position;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendHostExpression:(SYVoiceRoomExpression *)expression
                      user:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_HostEmoji;
    message.user = user;
    message.emoji = expression;
    message.position = 0;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendSyncRoomKing:(SYVoiceRoomKingModel *)roomKing {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_RoomKing;
    SYVoiceRoomExtra *extra = [SYVoiceRoomExtra new];
    extra.type = Signaling_ExtraType_RoomKing;
    extra.data = [roomKing yy_modelToJSONString];
    message.extra = extra;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendGameMessageWithGame:(SYVoiceRoomGame *)game
                           user:(SYVoiceRoomUser *)user
                       position:(NSInteger)position
                         isHost:(BOOL)isHost {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.position = position;
    message.action = isHost ? Signaling_Action_HostGameStart : Signaling_Action_GameStart;
//    SYVoiceRoomUser *user1 = [SYVoiceRoomUser new];
    message.user = user;
//    user1.uid = self.userModel.userid;
//    user1.username = self.userModel.username;
//    user1.icon = self.userModel.avatar_imgurl;
//    user1.level = self.userModel.level;
    message.game = game;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendOverScreenGiftMessage:(SYVoiceRoomGift *)gift
                           toUser:(SYVoiceRoomUser *)user
                           myself:(SYVoiceRoomUser *)myself
                           roomId:(NSString *)roomId {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_Gift;
    message.gift = gift;
    message.receiver = user;
    message.user = myself;
    message.channel = roomId;
    NSString *json = [message yy_modelToJSONString];
    [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                  type:SYVoiceRoomEMMessageTypeChatRoom
                                                fromId:self.emUserId
                                                  toId:[self overScreenSendMessageRoomId]];
}

- (void)sendOverScreenGameMessage:(SYVoiceRoomGift *)gift
                           myself:(SYVoiceRoomUser *)myself
                           roomId:(NSString *)roomId
                         gameName:(NSString *)gameName {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.gameName = gameName;
    message.action = Signaling_Action_GameWin;
    message.gift = gift;
    message.user = myself;
    message.channel = roomId;
    NSString *json = [message yy_modelToJSONString];
    [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                  type:SYVoiceRoomEMMessageTypeChatRoom
                                                fromId:self.emUserId
                                                  toId:[self overScreenSendMessageRoomId]];
}

- (void)sendOverScreenBeeGameMessage:(SYVoiceRoomGift *)gift
                              myself:(SYVoiceRoomUser *)myself
                              roomId:(NSString *)roomId
                            gameName:(NSString *)gameName {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.gameName = gameName;
    message.action = Signaling_Action_BeeWin;
    message.gift = gift;
    message.user = myself;
    message.channel = roomId;
    NSString *json = [message yy_modelToJSONString];
    [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                  type:SYVoiceRoomEMMessageTypeChatRoom
                                                fromId:self.emUserId
                                                  toId:[self overScreenSendMessageRoomId]];
}

- (void)sendOverScreenGroupRedPacketMessage:(SYVoiceRoomUser *)myself roomid:(NSString *)roomid {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_sendBoon;
    message.user = myself;
    message.channel = roomid;
    message.msg = [SYVoiceRoomText new];
    message.msg.type = 32;
    NSString *json = [message yy_modelToJSONString];
    [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                  type:SYVoiceRoomEMMessageTypeChatRoom
                                                fromId:self.emUserId
                                                  toId:[self overScreenSendMessageRoomId]];
}


- (void)sendStartStreamingMessageWithUser:(SYVoiceRoomUser *)user {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_startStreaming;
    message.user = user;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

- (void)sendSyncRoomInfoMessage:(SYChatRoomModel *)roomInfo {
    SYVoiceRoomMessage *message = [SYVoiceRoomMessage new];
    message.action = Signaling_Action_SyncRoomInfo;
    SYVoiceRoomExtra *extra = [SYVoiceRoomExtra new];
    extra.type = Signaling_ExtraType_SyncRoomInfo;
    extra.data = [roomInfo yy_modelToJSONString];
    message.extra = extra;
    NSString *json = [message yy_modelToJSONString];
    [self.signalingManager sendMessage:json];
    if (self.needSendToEM) {
        [[SYVoiceRoomEMManager sharedInstance] sendMessage:json
                                                      type:SYVoiceRoomEMMessageTypeChatRoom
                                                    fromId:self.emUserId
                                                      toId:self.emGroupId];
    }
}

#pragma mark - bgm

- (id <SYVoiceRoomPlayerControlProtocol>)playControlInstance {
    return self.voiceChatEngine;
}

- (id <SYVoiceRoomAudioEffectProtocol>)audioEffectPlayer {
    return self.voiceChatEngine;
}

#pragma mark - SYSignalingManagerDelegate

- (void)signalingManagerDidJoinChannel {
    if (self.needSendToEM) {
        [self reJoinEMWithEMUserId:self.emUserId];
    }
    [self.voiceChatEngine joinChannelWithChannelID:self.channelID
                                               uid:self.sdkUserId
                                             token:self.mediaToken
                                              role:self.role];
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidJoinChannel)]) {
        [self.delegate messageManagerDidJoinChannel];
    }
}

- (void)signalingManagerDidFailed {
    if ([self.delegate respondsToSelector:@selector(messageManagerDidError)]) {
        [self.delegate messageManagerDidError];
    }
}

- (void)signalingManagerDidReceiveMessage:(nonnull NSString *)message {
    void (^block)(void(^)(void)) = ^(void(^e)(void)) {
        dispatch_async(dispatch_get_main_queue(), e);
    };
    SYVoiceRoomMessage *m = [SYVoiceRoomMessage yy_modelWithJSON:message];
    if ([m.action isEqualToString:Signaling_Action_JoinChannel]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveUserJoinInChannelWithUser:)]) {
                [self.delegate messageManagerDidReceiveUserJoinInChannelWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_ApplyMic]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveUserApplyMicWithUser:)]) {
                [self.delegate messageManagerDidReceiveUserApplyMicWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_CancelApplyMic]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveUserCancelApplyMicWithUser:)]) {
                [self.delegate messageManagerDidReceiveUserCancelApplyMicWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_ConfirmMic]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveConfirmMicWithUser:micPostion:)]) {
                [self.delegate messageManagerDidReceiveConfirmMicWithUser:m.user micPostion:m.position];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_KickMic]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveKickMicWithUser:micPostion:)]) {
                [self.delegate messageManagerDidReceiveKickMicWithUser:m.user micPostion:m.position];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_ConfirmHost]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveConfirmHostMicWithUser:micPostion:)]) {
                // 位置写死为0，将来多麦位，必须给位置
//                [self.delegate messageManagerDidReceiveConfirmHostMicWithUser:m.user micPostion:m.position];
                [self.delegate messageManagerDidReceiveConfirmHostMicWithUser:m.user micPostion:0];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_KickHost]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveKickHostMicWithUser:micPostion:)]) {
                // 位置写死为0，将来多麦位，必须给位置
//                [self.delegate messageManagerDidReceiveKickHostMicWithUser:m.user micPostion:m.position];
                [self.delegate messageManagerDidReceiveKickHostMicWithUser:m.user micPostion:0];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_TurnOffMic]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveMuteMicWithUser:micPostion:)]) {
                [self.delegate messageManagerDidReceiveMuteMicWithUser:m.user micPostion:m.position];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_TurnOnMic]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveCancelMuteMicWithUser:micPostion:)]) {
                [self.delegate messageManagerDidReceiveCancelMuteMicWithUser:m.user micPostion:m.position];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_HostTurnOnMic]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveHostCancelMuteMicWithUser:micPostion:)]) {
                [self.delegate messageManagerDidReceiveHostCancelMuteMicWithUser:m.user micPostion:m.position];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_HostTurnOffMic]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveHostMuteMicWithUser:micPostion:)]) {
                [self.delegate messageManagerDidReceiveHostMuteMicWithUser:m.user micPostion:m.position];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_Text]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveTextMessage:sender:)]) {
                [self.delegate messageManagerDidReceiveTextMessage:m.msg sender:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_Gift]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveGiftMessage:sender:receiver:)]) {
                [self.delegate messageManagerDidReceiveGiftMessage:m.gift
                                                            sender:m.user
                                                          receiver:m.receiver];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_LeaveChannel]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveUserLeaveChannelWithUser:)]) {
                [self.delegate messageManagerDidReceiveUserLeaveChannelWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_ForbidChat]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveForbidChatWithUser:)]) {
                [self.delegate messageManagerDidReceiveForbidChatWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_ForbidEnter]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveForbidEnterWithUser:)]) {
                [self.delegate messageManagerDidReceiveForbidEnterWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_CloseChannel]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveCloseChannel)]) {
                [self.delegate messageManagerDidReceiveCloseChannel];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_OpenChannel]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveOpenChannel)]) {
                [self.delegate messageManagerDidReceiveOpenChannel];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_CancelForbidChat]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveCancelForbidChatWithUser:)]) {
                [self.delegate messageManagerDidReceiveCancelForbidChatWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_CancelForbidEnter]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveCancelForbidEnterWithUser:)]) {
                [self.delegate messageManagerDidReceiveCancelForbidEnterWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_UpdateChannel]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveUpdateChannel)]) {
                [self.delegate messageManagerDidReceiveUpdateChannel];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_AddAdminister] ||
               [m.action isEqualToString:Signaling_Action_DeleteAdminister]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveAdminStatusChangedWithUser:)]) {
                [self.delegate messageManagerDidReceiveAdminStatusChangedWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_GameStart] ||
               [m.action isEqualToString:Signaling_Action_HostGameStart]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveStartGame:user:)]) {
                [self.delegate messageManagerDidReceiveStartGame:m.game user:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_StartPK]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveStartPKWithPKList:)]) {
                SYVoiceRoomPKListModel *model = [SYVoiceRoomPKListModel yy_modelWithJSON:m.extra.data];
                [self.delegate messageManagerDidReceiveStartPKWithPKList:model];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_StopPK]) {
        block(^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveStopPKWithPKList:)]) {
                SYVoiceRoomPKListModel *model = [SYVoiceRoomPKListModel yy_modelWithJSON:m.extra.data];
                [self.delegate messageManagerDidReceiveStopPKWithPKList:model];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_SyncPK]) {
        block(^{
            if (m.extra.type == Signaling_ExtraType_PK) {
                SYVoiceRoomPKListModel *model = [SYVoiceRoomPKListModel yy_modelWithJSON:m.extra.data];
                if (model) {
                    if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveSyncPKList:)]) {
                        [self.delegate messageManagerDidReceiveSyncPKList:model];
                    }
                }
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_Clear]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveClearPublicScreen)]) {
                [self.delegate messageManagerDidReceiveClearPublicScreen];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_Upgrade]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveUserUpgradeMessageWithUser:)]) {
                [self.delegate messageManagerDidReceiveUserUpgradeMessageWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_BreakEgg]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveBreakEggMessage:sender:gameName:)]) {
                [self.delegate messageManagerDidReceiveBreakEggMessage:m.gift
                                                                sender:m.user
                                                              gameName:m.gameName];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_Emoji]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveExpression:user:micPosition:)]) {
                [self.delegate messageManagerDidReceiveExpression:m.emoji
                                                             user:m.user
                                                      micPosition:m.position];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_HostEmoji]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveHostExpression:user:)]) {
                [self.delegate messageManagerDidReceiveHostExpression:m.emoji
                                                                 user:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_RoomKing]) {
        block(^{
            if (m.extra.type == Signaling_ExtraType_RoomKing) {
                SYVoiceRoomKingModel *model = [SYVoiceRoomKingModel yy_modelWithJSON:m.extra.data];
                if (model) {
                    if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveBossInfo:)]) {
                        [self.delegate messageManagerDidReceiveBossInfo:model];
                    }
                }
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_Follow]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveFollowMessageWithFollower:followee:)]) {
                [self.delegate messageManagerDidReceiveFollowMessageWithFollower:m.user
                                                                        followee:m.receiver];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_BeeHoney]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveBeeHoneyMessage:sender:gameName:)]) {
                [self.delegate messageManagerDidReceiveBeeHoneyMessage:m.gift
                                                                sender:m.user
                                                              gameName:m.gameName];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_sendBoon]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveSendGroupRedPacketMessage:)]) {
                [self.delegate messageManagerDidReceiveSendGroupRedPacketMessage:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_getBoon]) {
        block(^{
            if (m.extra.type == Signaling_ExtraType_Boon) {
                SYVoiceRoomBoonModel *model = [SYVoiceRoomBoonModel yy_modelWithJSON:m.extra.data];
                if (model && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveGetGroupRedPacketMessage:fromUserModel:)]) {
                    [self.delegate messageManagerDidReceiveGetGroupRedPacketMessage:m.user fromUserModel:model];
                }
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_boonEmptied]) {
        block(^{
            if (m.extra.type == Signaling_ExtraType_Boon) {
                SYVoiceRoomBoomEmptyModel *model = [SYVoiceRoomBoomEmptyModel yy_modelWithJSON:m.extra.data];
                if (model && [self.delegate respondsToSelector:@selector(messageManagerDidReceiveGetGroupRedPacketEmptyMessage:)]) {
                    [self.delegate messageManagerDidReceiveGetGroupRedPacketEmptyMessage:model];
                }
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_startStreaming]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveStartStreamingWithUser:)]) {
                [self.delegate messageManagerDidReceiveStartStreamingWithUser:m.user];
            }
        });
    } else if ([m.action isEqualToString:Signaling_Action_SyncRoomInfo]) {
        block(^{
            if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveRoomInfoSyncWithRoomInfo:)]) {
                SYChatRoomModel *model = [SYChatRoomModel yy_modelWithJSON:m.extra.data];
                [self.delegate messageManagerDidReceiveRoomInfoSyncWithRoomInfo:model];
            }
        });
    }
}

#pragma mark - SYVoiceChatEngineDelegate

- (void)voiceChatEngineDidJoinChannel {
    
}

- (void)voiceChatEngineDidError {
    
}

- (void)voiceChatEngineDidIndicateUserSpeakWithUids:(NSArray *)uids {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageManagerDidIndicateSpeakersWithUids:)]) {
        [self.delegate messageManagerDidIndicateSpeakersWithUids:uids];
    }
}

- (void)voiceChatEngineTokenWillExpireWithEngineUserId:(NSInteger)userId {
    if ([self.delegate respondsToSelector:@selector(messageManagerVoiceEngineTokenWillExpireWithEngineUserId:)]) {
        [self.delegate messageManagerVoiceEngineTokenWillExpireWithEngineUserId:userId];
    }
}

#pragma mark -

- (void)voiceRoomEMManagerDidReceiveMessage:(NSString *)message
                                       type:(SYVoiceRoomEMMessageType)type
                                  channelId:(NSString *)channelId {
    if ([channelId isEqualToString:self.emGroupId] && type == SYVoiceRoomEMMessageTypeChatRoom) {
        // 只处理本房间的消息
        SYVoiceRoomMessage *m = [SYVoiceRoomMessage yy_modelWithJSON:message];
        if ([m.from isEqualToString:@"mp"]) {
            [self signalingManagerDidReceiveMessage:message];
        }
    } else if (type == SYVoiceRoomEMMessageTypeChatRoom && ([channelId isEqualToString:[self overScreenVoiceRoomId]] || [channelId isEqualToString:[self overScreenLiveRoomId]])) {
        // 飘屏
        if ([self.delegate respondsToSelector:@selector(messageManagerDidReceiveOverScreenMessage:)]) {
            SYVoiceRoomMessage *m = [SYVoiceRoomMessage yy_modelWithJSON:message];
            if ([m.action isEqualToString:Signaling_Action_GameWin]) {
                m.from = @"OverScreenGameWin";
                NSInteger internalTrigger = [SYSettingManager gameInternalFloatScreenTrigger];
                if (internalTrigger == 0) {
                    internalTrigger = 1000;
                }
                NSInteger trigger = [SYSettingManager gameFloatScreenTrigger];
                if (trigger == 0) {
                    trigger = 5000;
                }
                SYVoiceRoomGift *gift = m.gift;
                if (gift.price >= internalTrigger && gift.price < trigger) {
                    if ([NSString sy_isBlankString:m.channel] ||
                        ![m.channel isEqualToString:self.channelID]) {
                        return;
                    }
                } else if (gift.price >= trigger){
                } else {
                    return;
                }
                [self.delegate messageManagerDidReceiveOverScreenMessage:m];
            } else if ([m.action isEqualToString:Signaling_Action_BeeWin]) {
                m.from = @"OverScreenBeeGameWin";
                NSInteger internalTrigger = [SYSettingManager beeGameInternalFloatScreenTrigger];
                if (internalTrigger == 0) {
                    internalTrigger = 1000;
                }
                NSInteger trigger = [SYSettingManager beeGameFloatScreenTrigger];
                if (trigger == 0) {
                    trigger = 5000;
                }
                SYVoiceRoomGift *gift = m.gift;
                if (gift.extraPrice >= internalTrigger && gift.extraPrice < trigger) {
                    if ([NSString sy_isBlankString:m.channel] ||
                        ![m.channel isEqualToString:self.channelID]) {
                        return;
                    }
                } else if (gift.extraPrice >= trigger){
                } else {
                    return;
                }
                [self.delegate messageManagerDidReceiveOverScreenMessage:m];
            } else if ([m.action isEqualToString:Signaling_Action_Gift]) {
                NSInteger internalTrigger = [SYSettingManager internalFloatScreenTrigger];
                if (internalTrigger == 0) {
                    internalTrigger = 500;
                }
                NSInteger trigger = [SYSettingManager floatScreenTrigger];
                if (trigger == 0) {
                    trigger = 1880;
                }
                SYVoiceRoomGift *gift = m.gift;
                if (gift.price >= internalTrigger && gift.price < trigger) {
                    if ([NSString sy_isBlankString:m.channel] ||
                        ![m.channel isEqualToString:self.channelID]) {
                        return;
                    }
                    m.from = @"OverScreenInternal";
                } else if (gift.price >= trigger){
                    m.from = @"OverScreen";
                } else {
                    return;
                }
                [self.delegate messageManagerDidReceiveOverScreenMessage:m];
            } else if ([m.action isEqualToString:Signaling_Action_sendBoon]) {
                m.from = @"OverScreenSendGroupRedPacket";
                [self.delegate messageManagerDidReceiveOverScreenMessage:m];
            }
        }
    }
}

- (void)voiceRoomEMManagerDidCheckUnreadMessage:(BOOL)hasUnread {
    if ([self.delegate respondsToSelector:@selector(messageManagerDidCheckUnreadMessage:)]) {
        [self.delegate messageManagerDidCheckUnreadMessage:hasUnread];
    }
}

- (NSString *)overScreenSendMessageRoomId {
    if (self.voiceEngineEnabled) {
        return [self overScreenVoiceRoomId];
    }
    return [self overScreenLiveRoomId];
}

- (NSString *)overScreenVoiceRoomId {
    if ([SYSettingManager syIsTestApi]) {
        return @"79766202941441";
    } else {
        return @"84959954010113";
    }
}

- (NSString *)overScreenLiveRoomId {
    if ([SYSettingManager syIsTestApi]) {
        return @"95827432374273";
    } else {
        return @"95827192250369";
    }
}

@end
