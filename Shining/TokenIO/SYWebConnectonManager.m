//
//  SYWebConnectonManager.m
//  Shining
//
//  Created by letv_lzb on 2019/10/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYWebConnectonManager.h"
#import "TokenIO.h"
@interface SYWebConnectonManager () <TokenIODelegate>
@property (nonatomic, strong) TokenIO* tokenIO;
@end

@implementation SYWebConnectonManager

/**
 SYWebConnectonManager 单例

 @return 实例
 */
+ (instancetype)sharedManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SYWebConnectonManager alloc] init];
    });
    return instance;
}



- (TokenIO*) tokenIO {
    if (!_tokenIO) {
        TokenIO* io = [[TokenIO alloc] init];
        io.delegate = self;
        _tokenIO = io;
    }
    return _tokenIO;
}



/**
 建立连接
 */
- (void)startConnect {
    if ([self.tokenIO isConnected]) {
        [self userLeaveChannel:@""];
        [self.tokenIO disconnect];
    }
    if ([NSString sy_isBlankString:[SYSettingManager accessToken]]) {
        [self.tokenIO connectWithDeviceId:[SYSettingManager deviceUUID]];
    }else {
        [self.tokenIO connectWithAccessToken:[SYSettingManager accessToken]];
    }
}


/**
 断开连接
 */
- (void)stopConnect {
    [self.tokenIO disconnect];
}


- (void)sendCommand:(TokenCommand *)command {
    if (self.tokenIO && [self.tokenIO isConnected]) {
        [self.tokenIO sendCommand:command];
    }
}



/**
 加入房间

 @param channelId 房间id
 */
- (void)userJoinChannel:(NSString *)channelId {
    TokenJoinRoomCommand *command = [[TokenJoinRoomCommand alloc] initWithRoomId: channelId];
    [self sendCommand:command];
}

/**
 离开房间

 @param channelId 房间id
 */
- (void)userLeaveChannel:(NSString *)channelId {
    TokenLeaveRoomCommand *command = [[TokenLeaveRoomCommand alloc] init];
    [self sendCommand:command];
}


#pragma mark TokenIODelegate
- (NSString*) pcode {
    return SHANYIN_PCODE;
}

- (NSString*) version {
    return SHANYIN_VERSION;
}

- (NSString*)did {
    return [SYSettingManager smAntiDeviceId];
}

- (void) tokenIOConnected: (TokenIO*) io {
    NSLog(@"socket io connected");
}

- (void) tokenIODisconnected: (TokenIO*) io withError: (NSError * _Nullable) error {

    NSLog(@"socket io disconnected with error: %@", error);
}

- (void)tokenIO:(nonnull TokenIO *)io didReceiveTokenCommand:(nonnull TokenCommand *)command {
    if (command) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SYWebConnectionNotification object:command];
    }

    NSLog(@"socket io received command: %@", NSStringFromClass([command class]));
}


- (void)dealloc {
    if ([self.tokenIO isConnected]) {
        [self.tokenIO disconnect];
    }
}

@end
