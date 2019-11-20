//
//  SYChatEngine.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomPlayerProtocol.h"
#import "SYVoiceRoomAudioEffectProtocol.h"
#import "SYChatEngineEnum.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceChatEngineDelegate <NSObject>

- (void)voiceChatEngineDidIndicateUserSpeakWithUids:(NSArray *)uids;
- (void)voiceChatEngineDidJoinChannel;
- (void)voiceChatEngineDidError;
- (void)voiceChatEngineTokenWillExpireWithEngineUserId:(NSInteger)userId;

@end

@interface SYVoiceChatEngine : NSObject <SYVoiceRoomPlayerControlProtocol, SYVoiceRoomAudioEffectProtocol>

@property (nonatomic, weak) id <SYVoiceChatEngineDelegate> delegate;
@property (nonatomic, assign) BOOL voiceEngineEnabled;

+ (instancetype)sharedEngine;

- (void)joinChannelWithChannelID:(NSString *)channelID
                             uid:(NSString *)uid
                           token:(NSString *)token
                            role:(SYChatRoomUserRole)role;

- (void)changeUserRoleWithRole:(SYChatRoomUserRole)role;

- (void)setMuted:(BOOL)muted;

- (void)leaveChannel;

- (void)renewToken:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
