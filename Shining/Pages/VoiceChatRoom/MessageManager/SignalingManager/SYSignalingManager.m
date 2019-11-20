//
//  SYSignalingManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSignalingManager.h"
#import <AgoraSigKit/AgoraSigKit.h>
#import "SYChatEngineEnum.h"
#import <AgoraRtmKit/AgoraRtmKit.h>

#define MAX_RETRY_COUNT 3

@interface SYSignalingManager () <AgoraRtmDelegate, AgoraRtmChannelDelegate>

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) AgoraAPI *signalInstance;
@property (nonatomic, assign) NSInteger retryTimes;
@property (nonatomic, weak) id <SYSignalingManagerDelegate> delegate;

// rtm
@property (nonatomic, strong) AgoraRtmKit *rtmInstance;
@property (nonatomic, strong) AgoraRtmChannel *rtmChannel;
@property (nonatomic, assign) AgoraRtmConnectionState rtmConnectionState;

@end

@implementation SYSignalingManager

- (void)dealloc {
    
}

- (instancetype)initWithUserID:(NSString *)uid
                         token:(NSString *)token
                     channelID:(nonnull NSString *)channelID {
    self = [super init];
    if (self) {
        _retryTimes = 0;
        _uid = uid;
        _token = token;
        _channelID = channelID;
        _rtmConnectionState = 0;
    }
    return self;
}

- (void)startWithDelegate:(id<SYSignalingManagerDelegate>)delegate {
    self.delegate = delegate;
    if (self.uid.length == 0 || self.channelID.length == 0) {
        // process failed
        [self notifyFailed];
        return;
    }
//    self.signalInstance = [AgoraAPI getSigInstance:AGORA_APP_ID];
//    [self loginAndJoinChannelWithFinishBlock:nil needNotifyDelegate:YES];
    self.rtmInstance = [[AgoraRtmKit alloc] initWithAppId:AGORA_APP_ID
                                                 delegate:self];
    [self loginAndJoinChannelWithFinishBlock:nil needNotifyDelegate:YES];
}

- (void)loginAndJoinChannelWithFinishBlock:(void(^)(BOOL finish))block
                        needNotifyDelegate:(BOOL)needNotifyDelegate {
//    __weak typeof(self) weakSelf = self;
////    self.signalInstance.onError = ^(NSString *name, AgoraEcode ecode, NSString *desc) {
////        [weakSelf notifyFailed];
////    };
//    self.signalInstance.onLoginSuccess = ^(uint32_t uid, int fd) {
//        weakSelf.retryTimes = 0;
//        // login success
//        [weakSelf joinChannel];
//    };
//    self.signalInstance.onLoginFailed = ^(AgoraEcode ecode) {
//        // login failed
//        ++ weakSelf.retryTimes;
//        if (weakSelf.retryTimes >= 3) {
//            // throw delegate method
//            [weakSelf notifyFailed];
//            if (block) {
//                block(NO);
//            }
//        } else {
//            [weakSelf login];
//        }
//    };
//    self.signalInstance.onChannelJoined = ^(NSString *channelID) {
//        weakSelf.retryTimes = 0;
//        // join channel success
//        if (channelID && [weakSelf.channelID isEqualToString:channelID]) {
//            // throw delegate method
//            if (needNotifyDelegate) {
//                [weakSelf notifyJoinChannel];
//            }
//            if (block) {
//                block(YES);
//            }
//        }
//    };
//    self.signalInstance.onChannelJoinFailed = ^(NSString *channelID, AgoraEcode ecode) {
//        // join channel failed
//        ++ weakSelf.retryTimes;
//        if (weakSelf.retryTimes >= 3) {
//            // throw delegate method
//            [weakSelf notifyFailed];
//            if (block) {
//                block(NO);
//            }
//        } else {
//            [weakSelf joinChannel];
//        }
//    };
//    self.signalInstance.onMessageChannelReceive = ^(NSString *channelID, NSString *account, uint32_t uid, NSString *msg) {
//        if ([weakSelf.channelID isEqualToString:channelID]) {
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(signalingManagerDidReceiveMessage:)]) {
//                [weakSelf.delegate signalingManagerDidReceiveMessage:msg];
//            }
//        }
//    };
//    if ([self.signalInstance getStatus] == 2) {
//        // logined
//        [self joinChannel];
//    } else {
//        [self login];
//    }
    
    if (self.rtmConnectionState == AgoraRtmConnectionStateConnected) {
        [self joinChannelWithFinishBlock:block
                      needNotifyDelegate:needNotifyDelegate];
    } else {
        [self loginWithFinishBlock:block needNotifyDelegate:needNotifyDelegate];
    }
}

- (void)leaveChannel {
//    [self.signalInstance channelLeave:self.channelID];
//    [self.signalInstance destroy];
    [self.rtmChannel leaveWithCompletion:^(AgoraRtmLeaveChannelErrorCode errorCode) {
        
    }];
}

#pragma mark - private method

- (void)login {
//    [self.signalInstance login:AGORA_APP_ID account:self.uid token:self.token//@"_no_need_token"
//                           uid:0 deviceID:nil];
}

- (void)loginWithFinishBlock:(void(^)(BOOL))block
          needNotifyDelegate:(BOOL)needNotifyDelegate {
    __weak typeof(self) weakSelf = self;
    void (^loginSuccessBlock)(void) = ^ {
        weakSelf.retryTimes = 0;
        // login success
        [weakSelf joinChannelWithFinishBlock:block
                          needNotifyDelegate:needNotifyDelegate];
    };
    
    void (^loginFailedBlock)(void) = ^ {
        // login failed
        ++ weakSelf.retryTimes;
        if (weakSelf.retryTimes >= 3) {
            // throw delegate method
            [weakSelf notifyFailed];
            if (block) {
                block(NO);
            }
        } else {
            [weakSelf loginWithFinishBlock:block needNotifyDelegate:needNotifyDelegate];
        }
    };
    [self.rtmInstance loginByToken:self.token
                              user:self.uid
                        completion:^(AgoraRtmLoginErrorCode errorCode) {
        if (errorCode == AgoraRtmLoginErrorOk) {
            loginSuccessBlock();
        } else {
            loginFailedBlock();
        }
    }];
}

- (void)joinChannel {
//    [self.signalInstance channelJoin:self.channelID];
}

- (void)joinChannelWithFinishBlock:(void(^)(BOOL))block
                needNotifyDelegate:(BOOL)needNotifyDelegate {
    __weak typeof(self) weakSelf = self;
    void (^joinSuccessBlock)(void) = ^() {
        weakSelf.retryTimes = 0;
        // join channel success
        // throw delegate method
        if (needNotifyDelegate) {
            [weakSelf notifyJoinChannel];
        }
        if (block) {
            block(YES);
        }
    };
    void (^joinFailedBlock)(void) = ^() {
        // join channel failed
        ++ weakSelf.retryTimes;
        if (weakSelf.retryTimes >= 3) {
            // throw delegate method
            [weakSelf notifyFailed];
            if (block) {
                block(NO);
            }
        } else {
            [weakSelf joinChannelWithFinishBlock:block
                              needNotifyDelegate:needNotifyDelegate];
        }
    };
    if (!self.rtmChannel) {
        self.rtmChannel = [self.rtmInstance createChannelWithId:self.channelID
                                                       delegate:self];
    }
    [self.rtmChannel joinWithCompletion:^(AgoraRtmJoinChannelErrorCode errorCode) {
        if (errorCode == AgoraRtmJoinChannelErrorOk) {
            joinSuccessBlock();
        } else {
            joinFailedBlock();
        }
    }];
}

- (void)notifyJoinChannel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(signalingManagerDidJoinChannel)]) {
            [self.delegate signalingManagerDidJoinChannel];
        }
    });
}

- (void)notifyFailed {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(signalingManagerDidFailed)]) {
            [self.delegate signalingManagerDidFailed];
        }
    });
}

- (void)sendMessage:(NSString *)message {
    __weak typeof(self) weakSelf = self;
//    void (^block)(void) = ^{
//        [weakSelf.signalInstance messageChannelSend:self.channelID
//                                                msg:message
//                                              msgID:@""];
//    };
//    if ([self.signalInstance getStatus] == 2) {
//        block();
//    } else {
//        [self loginAndJoinChannelWithFinishBlock:^(BOOL finish) {
//            if (finish) {
//                block();
//            }
//        } needNotifyDelegate:NO];
//    }
    void (^block)(void) = ^{
//        [weakSelf.signalInstance messageChannelSend:self.channelID
//                                                msg:message
//                                              msgID:@""];
        AgoraRtmMessage *msg = [[AgoraRtmMessage alloc] initWithText:message];
        [weakSelf.rtmChannel sendMessage:msg
                              completion:^(AgoraRtmSendChannelMessageErrorCode errorCode) {
            if (errorCode == AgoraRtmSendChannelMessageErrorOk) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(signalingManagerDidReceiveMessage:)]) {
                    [weakSelf.delegate signalingManagerDidReceiveMessage:msg.text];
                }
            }
        }];
    };
    if (self.rtmConnectionState == AgoraRtmConnectionStateConnected) {
        block();
    } else {
        [self loginAndJoinChannelWithFinishBlock:^(BOOL finish) {
            if (finish) {
                block();
            }
        } needNotifyDelegate:NO];
    }
    
}

#pragma mark - rtm delegate

/**
 Occurs when the connection state between the SDK and the Agora RTM system changes.

 @param kit An [AgoraRtmKit](AgoraRtmKit) instance.
 @param state The new connection state. See AgoraRtmConnectionState.
 @param reason The reason for the connection state change. See AgoraRtmConnectionChangeReason.

 */
- (void)rtmKit:(AgoraRtmKit * _Nonnull)kit connectionStateChanged:(AgoraRtmConnectionState)state reason:(AgoraRtmConnectionChangeReason)reason {
    self.rtmConnectionState = state;
}

/**
 Occurs when the current RTM Token exceeds the 24-hour validity period.
 
 This callback occurs when the current RTM Token exceeds the 24-hour validity period and reminds the user to renew it. When receiving this callback, generate a new RTM Token on the server and call the [renewToken]([AgoraRtmKit renewToken:completion:]) method to pass the new Token on to the server.

 @param kit An AgoraRtmKit instance.
 */
- (void)rtmKitTokenDidExpire:(AgoraRtmKit * _Nonnull)kit {
    
}

// 收到频道消息
- (void)channel:(AgoraRtmChannel * _Nonnull)channel messageReceived:(AgoraRtmMessage * _Nonnull)message fromMember:(AgoraRtmMember * _Nonnull)member {
    if (self.delegate && [self.delegate respondsToSelector:@selector(signalingManagerDidReceiveMessage:)]) {
        [self.delegate signalingManagerDidReceiveMessage:message.text];
    }
}

@end
