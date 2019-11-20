//
//  TokenIO.h
//  SocketBed
//
//  Created by Zhang Qigang on 2019/9/27.
//  Copyright © 2019 Zhang Qigang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TokenCommandType) {
    TokenCommandTypeJoinRoom,                // 加入房间
    TokenCommandTypeLeaveRoom,               // 离开房间
    TokenCommandTypeUserMessage,             // 用户消息
    TokenCommandTypeRoomBroadcast,           // 房间广播
    TokenCommandTypeAllRoomBroadcast,        // 所有房间广播
    TokenCommandTypeAllUserBroadcast,        // 所有用户广播
};

typedef NS_ENUM(NSInteger, TokenMType) {
    TokenMTypeSystemMsg = 1,                // 系统反馈的消息
    TokenMTypeNormalMsg = 2,                // 普通发送的消息
};

typedef NS_ENUM(NSInteger, TokenStatus) {
    TokenStatusSuccess = 200,                // 成功
    TokenStatusFailed = 400,                 // 失败
};

@class TokenIO;

@interface TokenCommand : NSObject
@property (nonatomic, assign, readonly) TokenCommandType type;
@property (nonatomic, assign) TokenMType mt;
@property (nonatomic, assign) TokenStatus code;
- (instancetype) init NS_UNAVAILABLE;
@end

@interface TokenJoinRoomCommand : TokenCommand
@property (nonatomic, copy, readonly) NSString* roomId;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithRoomId: (NSString*) roomId;
@end

@interface TokenLeaveRoomCommand : TokenCommand
- (instancetype) init;
@end

@interface TokenUserCommand : TokenCommand
@property (nonatomic, copy, readonly) NSString* userId;
@property (nonatomic, copy, readonly) NSString* message;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithUserId: (NSString*) userId message: (NSString*) message;
@end

@interface TokenRoomBroadcastCommand : TokenCommand
@property (nonatomic, copy, readonly) NSString* roomId;
@property (nonatomic, copy, readonly) NSString* message;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithRoomId: (NSString*) roomId message: (NSString*) message;
@end

@interface TokenAllRoomBroadcastCommand : TokenCommand
@property (nonatomic, copy, readonly) NSString* message;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithMessage: (NSString*) message;
@end

@interface TokenAllUserBroadcastCommand : TokenCommand
@property (nonatomic, copy, readonly) NSString* message;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithMessage: (NSString*) message;
@end

@protocol TokenIODelegate <NSObject>
- (NSString*) pcode;
- (NSString*) version;
- (NSString*) did;

- (void) tokenIOConnected: (TokenIO*) io;
- (void) tokenIODisconnected: (TokenIO*) io withError: (NSError * _Nullable) error;
- (void) tokenIO: (TokenIO*) io didReceiveTokenCommand: (TokenCommand*) command;
@end

@interface TokenIO : NSObject
@property (nonatomic, weak) id<TokenIODelegate> delegate;
- (instancetype) init;

- (void) connectWithAccessToken: (NSString*) accessToken;
- (void) connectWithDeviceId: (NSString*) deviceId;
- (void) disconnect;
- (BOOL) isConnected;
- (void) sendCommand: (TokenCommand*) command;
@end

NS_ASSUME_NONNULL_END
