//
//  SYVoiceRoomMessage.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomGift.h"
#import "SYVoiceRoomUser.h"
#import "SYVoiceRoomText.h"
#import "SYVoiceRoomGame.h"
#import "SYVoiceRoomExtra.h"
#import "SYVoiceRoomExpression.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomMessage : NSObject

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) SYVoiceRoomUser *user;
@property (nonatomic, strong) SYVoiceRoomUser *receiver;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger status; // 0-不静音 1-静音
@property (nonatomic, strong) SYVoiceRoomText *msg;
@property (nonatomic, strong) SYVoiceRoomGift *gift;
@property (nonatomic, strong) SYVoiceRoomExpression *emoji;
@property (nonatomic, strong) SYVoiceRoomGame *game;
@property (nonatomic, strong) NSString *channel; // 飘屏可能的跳转房间的房间id
@property (nonatomic, strong) NSString *from; // 来源，有值就是非Bee语音，目前只有小程序
@property (nonatomic, strong) NSString *gameName; // 游戏名称
@property (nonatomic, strong) SYVoiceRoomExtra *extra; // 扩展字段

@end

NS_ASSUME_NONNULL_END
