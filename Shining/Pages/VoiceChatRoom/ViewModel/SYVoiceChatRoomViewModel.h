//
//  SYVoiceChatRoomViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceChatUserViewModel.h"
#import "SYVoiceTextMessageViewModel.h"
#import "SYVoiceChatRoomInfoViewModel.h"
#import "SYVoiceRoomInfoChangeProtocol.h"
#import "SYVoiceRoomPlayerProtocol.h"
#import "SYVoiceRoomAudioEffectProtocol.h"
#import "SYVoiceRoomOperationViewModel.h"
#import "SYVoiceRoomBossViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SYVoiceChatRoomErrorUnknown = 0,
    SYVoiceChatRoomErrorForbiddenEnter,
    SYVoiceChatRoomErrorForbiddenChat,
    SYVoiceChatRoomErrorAuthority,
    SYVoiceChatRoomErrorNetwork,
    SYVoiceChatRoomErrorSignaling,
    SYVoiceChatRoomErrorJoinChannelFailed,
    SYVoiceChatRoomErrorRoomClosed,
    SYVoiceChatRoomErrorRoomLocked,
    SYVoiceChatRoomErrorDownloadOtherApp,
} SYVoiceChatRoomError;

@protocol SYVoiceChatRoomViewModelDelegate <NSObject>
@optional
- (void)voiceChatRoomDidGetMyRole:(SYChatRoomUserRole)role;
- (void)voiceChatRoomInfoDataReady; // 聊天室信息准备好，需要刷新房间信息
- (void)voiceChatRoomDataPrepared; // 聊天室数据准备好，需要刷新UI
- (void)voiceChatRoomUpdateToolBar; // 需要更新toolbar
- (void)voiceChatRoomDataError:(SYVoiceChatRoomError)error; // 聊天室数据失败
- (void)voiceChatRoomUserInMicChangedWithUser:(nullable SYVoiceChatUserViewModel *)user
                                     position:(NSInteger)position
                                      isUpMic:(BOOL)isUpMic;
- (void)voiceChatRoomUserInMicMuteStateChangedWithState:(BOOL)isMuted
                                               position:(NSInteger)position;
- (void)voiceChatRoomUsersInMicDidChanged; // 整个麦位需要刷新
- (void)voiceChatRoomUserInApplyMicListChanged;
- (void)voiceChatRoomDidReceivePublicScreenMessage;
- (void)voiceChatRoomUserIsForbiddenChatWithUid:(NSString *)uid;
- (void)voiceChatRoomUserCancelForbiddenChatWithUid:(NSString *)uid;
- (void)voiceChatRoomUserIsForbiddenEnterChannelWithUid:(NSString *)uid;
- (void)voiceChatRoomUserCancelForbiddenEnterChannelWithUid:(NSString *)uid;
- (void)voiceChatRoomDidCloseChannel;
- (void)voiceChatRoomDidIndicateSpeakersInMicPositions:(NSArray <NSNumber *>*)positions isMyself:(BOOL)isMyself;

- (void)voiceChatRoomDidReceiveGiftWithGiftID:(NSInteger)giftID
                                randomGiftIDs:(nonnull NSArray *)randomGiftIDs
                                   withSender:(nonnull SYVoiceRoomUser *)sender
                                 withReciever:(nonnull SYVoiceRoomUser *)reciever;
- (void)voiceChatRoomDidStartGameWithMicPosition:(NSInteger)position
                                            game:(SYVoiceRoomGameType)game
                                  gameImageNames:(NSArray *)gameImageNames
                                 resultImageName:(NSString *)resultImageName;
- (void)voiceChatRoomOperationDataReady; // 运营位数据准备好
- (void)voiceChatRoomRedpacketDataReady; // 聊天室红包数据准备OK
- (void)voiceChatRoomRefreshGroupRedPacketData; // 聊天室群红包数据更新完毕
- (void)voiceChatRoomShowUserProp:(nonnull SYVoiceRoomUser *)user;
- (void)voiceChatRoomDidReceiveOverScreenMessage:(SYVoiceTextMessageViewModel *)message;
- (void)voiceChatRoomOnlineUserNumberDidChangedWithNumber:(NSInteger)number
                                                   myself:(BOOL)isMyself;
- (void)voiceChatRoomPKStatusChanged;
- (void)voiceChatRoomBossStatusChanged;

- (void)voiceChatRoomDidCheckUnreadMessage:(BOOL)hasUnread;

- (void)voiceChatRoomDidReceiveExpressionWithPosition:(NSInteger)position
                                     expressionImages:(NSArray <UIImage *>*)expressionImages;

// 视频
- (void)liveRoomHostDidJoinRoomWithRoomOpenState:(BOOL)isOpen
                                          hostID:(NSString *)hostID
                                            role:(SYChatRoomUserRole)role;
// 主播重新推流消息
- (void)liveRoomDidReceiveStartStreamingMessage;

// 是否需要语音SDK
- (BOOL)voiceChatRoomNeedVoiceSDK;

// 获取到房间热度
- (void)voiceChatRoomDidFetchRoomHotScore:(NSInteger)score;

@end

// 整个语音聊天室的dataSource提供给UI层。并掌控所有内部流程。

@interface SYVoiceChatRoomViewModel : NSObject <SYVoiceRoomInfoChangeProtocol>

@property (nonatomic, weak) id <SYVoiceChatRoomViewModelDelegate> delegate;
@property (nonatomic, assign, readonly) SYChatRoomUserRole initialRole; // 初始角色

- (instancetype)initWithChannelID:(NSString *)channelID
                         password:(NSString *)password;

- (BOOL)isMyselfLogin;

// ======================== data source ==================

- (SYVoiceChatRoomInfoViewModel *)roomInfo;

- (SYVoiceChatUserViewModel *)liveRoomHost;
- (SYVoiceChatUserViewModel *)usersInMicAtPosition:(NSInteger)position;
- (NSInteger)userMicPositionInMicListWithUid:(NSString *)uid;

- (void)changeUserInfoAtPosition:(NSInteger)position
                       isFromMic:(BOOL)isFromMic
                             uid:(NSString *)uid
                        username:(NSString *)username
                          avatar:(NSString *)avatar
                       avatarBox:(NSInteger)avatarBox
                broadcasterLevel:(NSInteger)broadcasterLevel
                   isBroadcaster:(NSInteger)isBroadcaster
                    isSuperAdmin:(NSInteger)isSuperAdmin;

- (NSInteger)usersCountInApplyMicList;

- (SYVoiceChatUserViewModel *)usersInApplyMicListAtIndex:(NSInteger)position;

- (SYVoiceChatUserViewModel *)roomOwner;

- (SYVoiceChatUserViewModel *)myself;

- (UserProfileEntity *)currentUser;

- (BOOL)isMyselfContainsInApplyMicList;

- (NSInteger)myselfIndexInApplyMicList;

- (BOOL)isMyselfAtMicPosition:(NSInteger)micPosition;

- (NSInteger)textMessageListCount;

- (SYVoiceTextMessageViewModel *)textMessageViewModelAtIndex:(NSInteger)index;

- (BOOL)isMyselfForbiddenChat; // 自己是否被禁言

- (NSArray *)operationViewModels;

- (BOOL)isPKing;

#pragma mark - **红包相关逻辑**

// 可领取红包列表 （可领取+未到领取时间）
- (NSArray *)redPacketCanGetListData;

// 获取可领取红包最近的时间
- (NSInteger)redPacketCanGetTime;

// 从拿到红包列表数据开始计时的时间
- (NSInteger)getHasPassedTimeAfterGetRedPacketListData;

// 刷新群红包列表
- (void)refreshRoomGroupRedpacketList;

// 领取群红包
- (void)requestGetRoomGroupRedpacket:(NSString *)redPacketId
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;

// 领取群红包信令
- (void)sendGetRoomGroupRedpacketSignalling:(NSString *)userId
                                   userName:(NSString *)userName
                          redPacketSenderId:(NSString *)senderId
                        redPacketSenderName:(NSString *)senderName
                               getCoinCount:(NSInteger)coinCount;

// 发送群红包信令
- (void)sendRoomGroupRedpacketSignalling;

// 群红包达到一定额度后，全服飘屏
- (void)sendOverScreenGroupRedpacketSignalling;

// 当某一个红包被抢光后，发送一条信令，让所有用户移除该条红包数据
- (void)sendRoomGroupRedpacketHasGetedEmpty:(NSString *)redPacketId
                                     roomid:(NSString *)roomId
                                    ownerId:(NSString *)ownerId;

- (SYVoiceRoomBossViewModel *)bossViewModel;

// ========================= start process =================

- (void)startProcess;

// 进入视频直播间
- (void)joinLiveRoom;

// ========================== update =======================

- (void)updateMyselfUserInfo;

- (void)updateRoomInfo;

- (void)requestMyselfInfo;

- (void)requestFollowStateWithBlock:(void(^)(BOOL isFollowed))block;

- (void)updateOnlineNumber:(NSInteger)onlineNumber;

// =========================== bgm =============================

- (id <SYVoiceRoomPlayerControlProtocol>)playControlInstance;
- (id <SYVoiceRoomAudioEffectProtocol>)audioEffectPlayer;

// =========================== action ==========================

- (void)applyMic;

- (void)cancelApplyMic;

- (void)confirmMyselfHost;

- (void)changeMyselfFromOtherToHost;

- (void)kickHost;

- (void)confirmMicAtIndex:(NSInteger)index
               micPostion:(NSInteger)micPosition;

- (void)kickMicAtMicPostion:(NSInteger)micPostion;

- (void)muteMyself;

- (void)cancelMuteMyself;

- (void)muteMicAtMicPostion:(NSInteger)micPostion;

- (void)cancelMuteMicAtMicPosition:(NSInteger)micPostion;

- (void)muteHostMicAtMicPostion:(NSInteger)micPostion;

- (void)cancelMuteHostMicAtMicPosition:(NSInteger)micPostion;

- (void)sendTextMessage:(NSString *)text;

- (void)sendDanmaku:(NSString *)danmaku danmukuId:(NSInteger)danmakuId;

- (void)sendGiftMessageWithReceiver:(SYVoiceChatUserViewModel *)receiver
                             giftID:(NSInteger)giftID
                       randomGiftID:(NSInteger)randomGiftID
                               nums:(NSInteger)nums;

- (void)sendRandomGiftMessageWithGiftIDs:(NSArray *)giftIDs
                                  giftID:(NSInteger)giftID;

- (void)leaveChannel;

- (void)forbidUserChatWithUser:(SYVoiceChatUserViewModel *)user;

- (void)cancelForbidUserChatWithUser:(SYVoiceChatUserViewModel *)user;

- (void)forbidUserEnterWithUser:(SYVoiceChatUserViewModel *)user;

- (void)cancelForbidUserEnterWithUser:(SYVoiceChatUserViewModel *)user;

- (void)sendFollowUserMessageWithUser:(SYVoiceChatUserViewModel *)user;
- (void)sendFollowUserMessageWithUserId:(NSString *)uid
                               username:(NSString *)username;

- (void)closeChannel;

- (void)openChannel;

- (void)startPK;

- (void)stopPK;

- (void)refreshPKInfo;

- (void)clearPublicScreen;

- (void)refreshBossInfo;

// ============================= game ===========================

- (void)sendGameMessageWithGame:(SYVoiceRoomGameType)game
                         isHost:(BOOL)isHost;

- (void)sendExpressionWithExpressionID:(NSInteger)expressionID;

- (void)sendBeeHoneyMessageWithGiftName:(NSString *)giftName
                                  price:(NSInteger)price
                                 giftId:(NSInteger)giftId
                               giftIcon:(NSString *)giftIcon
                               gameName:(NSString *)gameName;

// ============================= share ==========================

/**
 分享小程序
 */
- (void)shareRoomToWeixin;

/**
 分享到朋友圈
 */
- (void)shareRoomToWeixinTimeLine;
/**
 分享到会话
 */
-  (void)shareRoomToWeixinSession;

// =========================== unread message ===================

- (BOOL)hasUnreadMessage;

// =========================== live =============================

- (void)liveStreamStarted;
- (void)liveStreamInterrupted;

//
- (void)startLiveStreaming:(NSString *)userId userName:(NSString *)userName;

- (void)disableUpdateRolesList; // 取消定时取麦位列表的逻辑，目前只有在视频直播需要

@end

NS_ASSUME_NONNULL_END
