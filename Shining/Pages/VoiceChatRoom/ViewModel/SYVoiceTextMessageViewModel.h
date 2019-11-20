//
//  SYVoiceTextMessageViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYChatEngineEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class SYVoiceRoomMessage;

typedef enum : NSUInteger {
    SYVoiceTextMessageTypeDefault = 0, // 普通文字消息，包含：头像，昵称，文字消息等
    SYVoiceTextMessageTypeGift, // 礼物文字消息。
    SYVoiceTextMessageTypeJoinChannel, // 进入频道消息 type=2
    SYVoiceTextMessageTypeGreeting, // 公告、欢迎语等 type=3
    SYVoiceTextMessageTypeSystem, // 系统消息 type=4
    SYVoiceTextMessageTypeInfo, // 信息消息（上麦等）type=5
    SYVoiceTextMessageTypePost, // 公告 type = 6
    SYVoiceTextMessageTypeGame, // 游戏 type = 7
    SYVoiceTextMessageTypeExpression, // 表情 type = 8
    SYVoiceTextMessageTypeVipUpgrade, // 升级 type = 9
    SYVoiceTextMessageTypeBreakEgg, // 砸蛋 type = 10
    SYVoiceTextMessageTypeDanmaku = 11, // 普通弹幕 type = 11
    SYVoiceTextMessageTypeSuperDanmaku, // 高级弹幕 type = 12
    SYVoiceTextMessageTypeVipDanmaku, // Vip弹幕 type = 13
    SYVoiceTextMessageTypeBeeHoney = 30, // 采蜜 type = 30
    SYVoiceTextMessageTypeFollow, // 关注消息  type = 31
    SYVoiceTextMessageTypeSendRedpacket, // 发送群红包消息 type = 32
    SYVoiceTextMessageTypeGetRedpacket,  // 领取群红包消息 type = 33
} SYVoiceTextMessageType;

@interface SYVoiceTextMessageViewModel : NSObject

@property (nonatomic, assign, readonly) SYVoiceTextMessageType messageType;
@property (nonatomic, strong, readonly) NSString *userUid;
@property (nonatomic, strong, readonly) NSString *avatarURL;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, assign, readonly) NSInteger userLevel;
@property (nonatomic, assign, readonly) NSInteger broadcasterLevel;
@property (nonatomic, assign, readonly) NSInteger isBroadcaster;        // 是否是主播：1-是 0-否
@property (nonatomic, assign, readonly) NSInteger isSuperAdmin;

@property (nonatomic, strong, readonly) NSString *receiverUid;
@property (nonatomic, strong, readonly) NSString *receiverAvatarURL;
@property (nonatomic, strong, readonly) NSString *receiverUsername;
@property (nonatomic, assign, readonly) NSInteger receiverLevel;
@property (nonatomic, assign, readonly) NSInteger giftId;
@property (nonatomic, assign, readonly) NSInteger randomGiftId;
@property (nonatomic, strong, readonly) NSString *giftName;
@property (nonatomic, strong, readonly) NSString *giftURL;
@property (nonatomic, assign, readonly) NSInteger giftPrice;
@property (nonatomic, assign, readonly) NSString *randomGiftName;
@property (nonatomic, assign, readonly) NSInteger giftNums;

@property (nonatomic, assign, readonly) SYVoiceRoomGameType gameType;
@property (nonatomic, assign, readonly) NSInteger gameValue;

@property (nonatomic, strong, readonly) NSString *expressionIcon;

@property (nonatomic, strong, readonly) NSString *from;
@property (nonatomic, strong, readonly) NSString *channel;
@property (nonatomic, strong, readonly) NSString *gameName;

@property (nonatomic, assign, readonly) NSInteger coinCount;    // 领取群红包蜜豆数

- (instancetype)initWithMessage:(SYVoiceRoomMessage *)message;

@end

NS_ASSUME_NONNULL_END
