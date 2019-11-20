//
//  Header.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#ifndef SYChatEngineEnum_h
#define SYChatEngineEnum_h
// 21ca11f0f11e4399abead882b374e48d
#define AGORA_APP_ID @"21ca11f0f11e4399abead882b374e48d" //@"fcd1b3f31207419b80a3dbb2977950cf"

typedef enum : NSUInteger {
    SYChatRoomUserRoleAudience = 0, // 听众
    SYChatRoomUserRoleCommunity, // 工会成员
    SYChatRoomUserRoleBroadcaster, // 麦上的人
    SYChatRoomUserRoleHost, // 主持人
    SYChatRoomUserRoleAdminister, // 管理员
    SYChatRoomUserRoleHomeOwner, // 房主
} SYChatRoomUserRole;

typedef enum : NSUInteger {
    SYVoiceRoomGameUnknown = 0,
    SYVoiceRoomGameTouzi, // 骰子
    SYVoiceRoomGameCaiquan, // 猜拳
    SYVoiceRoomGameNumber, // 摇数字
    SYVoiceRoomGameBaodeng = 101, // 爆灯
} SYVoiceRoomGameType;


#endif /* SYChatEngineEnum_h */
