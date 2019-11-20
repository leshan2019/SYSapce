//
//  SYMessageManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYChatEngineEnum.h"
#import "SYVoiceRoomPlayerProtocol.h"
#import "SYVoiceRoomAudioEffectProtocol.h"
#import "SYVoiceRoomBoonModel.h"

@class SYVoiceRoomGift;
@class SYVoiceRoomUser;
@class SYVoiceRoomText;
@class SYVoiceRoomGame;
@class SYVoiceRoomMessage;
@class SYVoiceRoomPKListModel;
@class SYVoiceRoomExpression;
@class SYVoiceRoomKingModel;
@class SYChatRoomModel;

NS_ASSUME_NONNULL_BEGIN

@protocol SYMessageManagerDelegate <NSObject>

// ======================== 信令 ==========================

- (void)messageManagerDidJoinChannel;
- (void)messageManagerDidJoinEMChannel;
- (void)messageManagerDidError;
- (void)messageManagerVoiceEngineTokenWillExpireWithEngineUserId:(NSInteger)userId;

- (void)messageManagerDidReceiveUserJoinInChannelWithUser:(SYVoiceRoomUser *)user;
- (void)messageManagerDidReceiveUserLeaveChannelWithUser:(SYVoiceRoomUser *)user;
- (void)messageManagerDidReceiveUserApplyMicWithUser:(SYVoiceRoomUser *)user;
- (void)messageManagerDidReceiveUserCancelApplyMicWithUser:(SYVoiceRoomUser *)user;
- (void)messageManagerDidReceiveConfirmMicWithUser:(SYVoiceRoomUser *)user
                                        micPostion:(NSInteger)micPostion;
- (void)messageManagerDidReceiveKickMicWithUser:(SYVoiceRoomUser *)user
                                     micPostion:(NSInteger)micPostion;
- (void)messageManagerDidReceiveConfirmHostMicWithUser:(SYVoiceRoomUser *)user
                                            micPostion:(NSInteger)micPostion;
- (void)messageManagerDidReceiveKickHostMicWithUser:(SYVoiceRoomUser *)user
                                         micPostion:(NSInteger)micPostion;
- (void)messageManagerDidReceiveMuteMicWithUser:(SYVoiceRoomUser *)user
                                     micPostion:(NSInteger)micPostion;
- (void)messageManagerDidReceiveCancelMuteMicWithUser:(SYVoiceRoomUser *)user
                                           micPostion:(NSInteger)micPostion;
- (void)messageManagerDidReceiveHostMuteMicWithUser:(SYVoiceRoomUser *)user
                                         micPostion:(NSInteger)micPostion;
- (void)messageManagerDidReceiveHostCancelMuteMicWithUser:(SYVoiceRoomUser *)user
                                               micPostion:(NSInteger)micPostion;
- (void)messageManagerDidReceiveTextMessage:(SYVoiceRoomText *)text
                                     sender:(SYVoiceRoomUser *)sender;
- (void)messageManagerDidReceiveGiftMessage:(SYVoiceRoomGift *)gift
                                     sender:(SYVoiceRoomUser *)sender
                                   receiver:(SYVoiceRoomUser *)receiver;
- (void)messageManagerDidReceiveForbidChatWithUser:(SYVoiceRoomUser *)user; // 禁言
- (void)messageManagerDidReceiveCancelForbidChatWithUser:(SYVoiceRoomUser *)user; // 取消禁言
- (void)messageManagerDidReceiveForbidEnterWithUser:(SYVoiceRoomUser *)user; // 禁入
- (void)messageManagerDidReceiveCancelForbidEnterWithUser:(SYVoiceRoomUser *)user;
- (void)messageManagerDidReceiveFollowMessageWithFollower:(SYVoiceRoomUser *)follower
                                                 followee:(SYVoiceRoomUser *)followee;
- (void)messageManagerDidReceiveCloseChannel;
- (void)messageManagerDidReceiveOpenChannel;
- (void)messageManagerDidReceiveUpdateChannel;
- (void)messageManagerDidReceiveAdminStatusChangedWithUser:(SYVoiceRoomUser *)user; // 添加管理员
- (void)messageManagerDidReceiveStartGame:(SYVoiceRoomGame *)game
                                     user:(SYVoiceRoomUser *)user;
- (void)messageManagerDidReceiveOverScreenMessage:(SYVoiceRoomMessage *)message;

- (void)messageManagerDidReceiveStartPKWithPKList:(SYVoiceRoomPKListModel *)pkListModel;
- (void)messageManagerDidReceiveStopPKWithPKList:(SYVoiceRoomPKListModel *)pkListModel;
- (void)messageManagerDidReceiveSyncPKList:(SYVoiceRoomPKListModel *)pkListModel;

- (void)messageManagerDidCheckUnreadMessage:(BOOL)hasUnread;
- (void)messageManagerDidReceiveClearPublicScreen;
- (void)messageManagerDidReceiveUserUpgradeMessageWithUser:(SYVoiceRoomUser *)user;
- (void)messageManagerDidReceiveBreakEggMessage:(SYVoiceRoomGift *)gift
                                         sender:(SYVoiceRoomUser *)sender
                                       gameName:(NSString *)gameName;
- (void)messageManagerDidReceiveBeeHoneyMessage:(SYVoiceRoomGift *)gift
                                         sender:(SYVoiceRoomUser *)sender
                                       gameName:(NSString *)gameName;
- (void)messageManagerDidReceiveExpression:(SYVoiceRoomExpression *)expression
                                      user:(SYVoiceRoomUser *)user
                               micPosition:(NSInteger)micPosition;
- (void)messageManagerDidReceiveHostExpression:(SYVoiceRoomExpression *)expression
                                          user:(SYVoiceRoomUser *)user;
- (void)messageManagerDidReceiveBossInfo:(SYVoiceRoomKingModel *)bossInfo;

- (void)messageManagerDidReceiveSendGroupRedPacketMessage:(SYVoiceRoomUser *)sender;

- (void)messageManagerDidReceiveGetGroupRedPacketMessage:(SYVoiceRoomUser *)sender
                                           fromUserModel:(SYVoiceRoomBoonModel *)fromUserModel;

- (void)messageManagerDidReceiveGetGroupRedPacketEmptyMessage:(SYVoiceRoomBoomEmptyModel *)emptyModel;

// ======================= 媒体 =========================

- (void)messageManagerDidIndicateSpeakersWithUids:(NSArray <NSNumber *>*)uids;

// ========================视频直播 ======================
- (void)messageManagerDidReceiveStartStreamingWithUser:(SYVoiceRoomUser *)user; // 直播推流

- (void)messageManagerDidReceiveRoomInfoSyncWithRoomInfo:(SYChatRoomModel *)roomInfo;

@end

@interface SYMessageManager : NSObject

@property (nonatomic, weak) id <SYMessageManagerDelegate> delegate;

@property (nonatomic, assign) BOOL needSendToEM; // 需要发送信令给环信

@property (nonatomic, strong, readonly) NSString *sdkUserId;

// 是否需要语音SDK
@property (nonatomic, assign) BOOL voiceEngineEnabled;

// ================ initializer ================
- (instancetype)initWithChannelID:(NSString *)channelID;

// ================ function ====================
- (void)startProcessWithUserRole:(SYChatRoomUserRole)role
                          userId:(NSString *)userId
                  signalingToken:(NSString *)signalingToken
                      mediaToken:(NSString *)mediaToken
                         groupId:(NSString *)groupId
                        emUserId:(NSString *)emUserId;

- (void)reJoinVoiceRoomWithUserId:(NSString *)userId
                       mediaToken:(NSString *)mediaToken;

- (void)changeUserRoleWithRole:(SYChatRoomUserRole)role;

- (void)muteUserLocalAudioStream:(BOOL)muted;

- (void)leaveChannelWithUser:(SYVoiceRoomUser *)user;
- (void)leaveVoiceEngine;
- (void)leaveSignaling;
- (void)leaveEM;

- (void)reJoinEMWithEMUserId:(NSString *)emUserId;

- (void)renewVoiceEngineToken:(NSString *)token;

// ================= bgm ======================

- (id <SYVoiceRoomPlayerControlProtocol>)playControlInstance;
- (id <SYVoiceRoomAudioEffectProtocol>)audioEffectPlayer;

// ================= action =======================
- (void)sendTextMessage:(SYVoiceRoomText *)message
                   user:(SYVoiceRoomUser *)user;

- (void)sendDanmaku:(SYVoiceRoomText *)danmaku
          danmukuId:(NSInteger)danmakuId
               user:(SYVoiceRoomUser *)user;

- (void)sendGiftMessage:(SYVoiceRoomGift *)gift
                 toUser:(SYVoiceRoomUser *)user
                 myself:(SYVoiceRoomUser *)myself;

- (void)sendRandomGiftMessage:(SYVoiceRoomGift *)gift
                       myself:(SYVoiceRoomUser *)myself;

- (void)sendEnterChannelMessageWithUser:(SYVoiceRoomUser *)user;

- (void)sendLeaveChannelMessageWithUser:(SYVoiceRoomUser *)user;

- (void)sendRequestMicMessage:(SYVoiceRoomUser *)user;

- (void)sendCancelRequestMicMessage:(SYVoiceRoomUser *)user;

- (void)sendUpMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position isMute:(BOOL)isMute;

- (void)sendDownMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position;

- (void)sendHostUpMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position;

- (void)sendHostDownMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position;

- (void)sendTurnOnMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position;

- (void)sendTurnOffMic:(SYVoiceRoomUser *)user position:(NSInteger)position;

- (void)sendHostTurnOnMicMessage:(SYVoiceRoomUser *)user position:(NSInteger)position;

- (void)sendHostTurnOffMic:(SYVoiceRoomUser *)user position:(NSInteger)position;

- (void)sendForbidUserChat:(SYVoiceRoomUser *)user;

- (void)sendCancelForbidUserChat:(SYVoiceRoomUser *)user;

- (void)sendForbidUserEnter:(SYVoiceRoomUser *)user;

- (void)sendCancelForbidUserEnter:(SYVoiceRoomUser *)user;

- (void)sendFollowUserWithUser:(SYVoiceRoomUser *)user
                      followee:(SYVoiceRoomUser *)followee;

- (void)sendCloseChannel;

- (void)sendOpenChannel;

- (void)sendUpdateChannel;

- (void)sendAddAdminister:(SYVoiceRoomUser *)user;

- (void)sendDeleteAdminister:(SYVoiceRoomUser *)user;

- (void)sendStartPK:(SYVoiceRoomPKListModel *)pkListModel;

- (void)sendStopPK:(SYVoiceRoomPKListModel *)pkListModel;

- (void)sendSyncPK:(SYVoiceRoomPKListModel *)pkListModel;

- (void)clearPublicScreen;

- (void)sendUserUpgrade:(SYVoiceRoomUser *)user;

- (void)sendBreakEggWithGift:(SYVoiceRoomGift *)gift
                        user:(SYVoiceRoomUser *)user
                    gameName:(NSString *)gameName;

- (void)sendBeeHoneyWithGift:(SYVoiceRoomGift *)gift
                        user:(SYVoiceRoomUser *)user
                    gameName:(NSString *)gameName;

- (void)sendExpression:(SYVoiceRoomExpression *)expression
                  user:(SYVoiceRoomUser *)user
              position:(NSInteger)position;

- (void)sendHostExpression:(SYVoiceRoomExpression *)expression
                      user:(SYVoiceRoomUser *)user;

- (void)sendSyncRoomKing:(SYVoiceRoomKingModel *)roomKing;

// 发送群红包
- (void)sendGroupRedPacketKing:(SYVoiceRoomUser *)user;

// 领取群红包
- (void)sendGetGroupRedPacketKing:(SYVoiceRoomUser *)user
                    fromUserModel:(SYVoiceRoomBoonModel *)fromModel;

// 红包领完信令
- (void)sendGetGroupRedpacketEmptyKing:(SYVoiceRoomBoomEmptyModel *)emptyModel;

// ============================== game =============================

- (void)sendGameMessageWithGame:(SYVoiceRoomGame *)game
                           user:(SYVoiceRoomUser *)user
                       position:(NSInteger)position
                         isHost:(BOOL)isHost;

// ============================== overscreen ======================

- (void)sendOverScreenGiftMessage:(SYVoiceRoomGift *)gift
                           toUser:(SYVoiceRoomUser *)user
                           myself:(SYVoiceRoomUser *)myself
                           roomId:(NSString *)roomId;

- (void)sendOverScreenGameMessage:(SYVoiceRoomGift *)gift
                           myself:(SYVoiceRoomUser *)myself
                           roomId:(NSString *)roomId
                         gameName:(NSString *)gameName;

- (void)sendOverScreenBeeGameMessage:(SYVoiceRoomGift *)gift
                              myself:(SYVoiceRoomUser *)myself
                              roomId:(NSString *)roomId
                            gameName:(NSString *)gameName;

// 发送群红包，飘屏api
- (void)sendOverScreenGroupRedPacketMessage:(SYVoiceRoomUser *)myself
                                     roomid:(NSString *)roomid;
//直播推流
- (void)sendStartStreamingMessageWithUser:(SYVoiceRoomUser *)user;

- (void)sendSyncRoomInfoMessage:(SYChatRoomModel *)roomInfo;

@end

NS_ASSUME_NONNULL_END
