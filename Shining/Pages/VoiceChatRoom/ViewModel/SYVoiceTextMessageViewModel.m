//
//  SYVoiceTextMessageViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceTextMessageViewModel.h"
#import "SYVoiceRoomMessage.h"
#import "SYGiftInfoManager.h"

@interface SYVoiceTextMessageViewModel ()

@end

@implementation SYVoiceTextMessageViewModel

- (instancetype)initWithMessage:(SYVoiceRoomMessage *)message {
    self = [super init];
    if (self) {
        _userUid = message.user.uid;
        _avatarURL = message.user.icon;
        _username = message.user.username;
        _message = message.msg.msg;
        _receiverUsername = message.receiver.username;
        _receiverAvatarURL = message.receiver.icon;
        _receiverUid = message.receiver.uid;
        _giftName = message.gift.name;
        _giftURL = message.gift.icon;
        _giftPrice = message.gift.price;
        _giftId = message.gift.giftid;
        _randomGiftId = message.gift.randomGiftId;
        if (_randomGiftId > 0) {
            SYGiftModel *gift = [[SYGiftInfoManager sharedManager] giftWithGiftID:_randomGiftId];
            if (gift) {
                _randomGiftName = gift.name;
            }
        }
        _giftNums = message.gift.nums;
        _userLevel = message.user.level;
        _broadcasterLevel = message.user.streamer_level;
        _isBroadcaster = message.user.is_streamer;
        _isSuperAdmin = message.user.is_super_admin;
//        _broadcasterLevel = 2;
        _receiverLevel = message.receiver.level;
        if (message.gift && message.msg.type != 10 && message.msg.type != 30) {
            _messageType = SYVoiceTextMessageTypeGift;
        } else if (message.game) {
            _messageType = SYVoiceTextMessageTypeGame;
            _gameType = (SYVoiceRoomGameType)message.game.type;
            _gameValue = message.game.value;
        } else if (message.emoji) {
            _messageType = SYVoiceTextMessageTypeExpression;
            _expressionIcon = message.emoji.icon;
        } else if (message.msg.type >= 2) {
            _messageType = (SYVoiceTextMessageType)message.msg.type;
        } else {
            _messageType = SYVoiceTextMessageTypeDefault;
        }
        if (_messageType == SYVoiceTextMessageTypeGetRedpacket) {
            _coinCount = [message.extra.data integerValue];
        }
        _from = message.from;
        _channel = message.channel;
        _gameName = message.gameName;
    }
    return self;
}

@end
