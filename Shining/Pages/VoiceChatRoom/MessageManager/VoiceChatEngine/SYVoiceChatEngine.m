//
//  SYChatEngine.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatEngine.h"
#import <AgoraAudioKit/AgoraRtcEngineKit.h>

@interface SYVoiceChatEngine () <AgoraRtcEngineDelegate>

@property (nonatomic, strong) AgoraRtcEngineKit *engine;
@property (nonatomic, assign) NSUInteger engineUid;
@property (nonatomic, assign) NSInteger retryTimes;
@property (nonatomic, weak) id <SYVoiceRoomPlayerObserverProtocol> playObserver;

@end

@implementation SYVoiceChatEngine

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedEngine {
    static SYVoiceChatEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[SYVoiceChatEngine alloc] init];
    });
    return engine;
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(audioRouteChangeListenerCallback:)
//         name:AVAudioSessionRouteChangeNotification
//         object:nil];
        _voiceEngineEnabled = YES;
    }
    return self;
}

- (void)audioRouteChangeListenerCallback:(NSNotification *)notification {
//    NSDictionary *interuptionDict = notification.userInfo;
//    NSInteger routeChangeReason   = [[interuptionDict
//                                      valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
//    switch (routeChangeReason) {
//        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
//            //插入耳机
//        {
//            if (self.engine) {
//                [self.engine setParameters:@"{\"che.audio.bypass.apm\":true}"];
//            }
//        }
//            break;
//        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
//            //拔出耳机
//        {
//            if (self.engine) {
//                [self.engine setParameters:@"{\"che.audio.bypass.apm\":false}"];
//            }
//        }
//            break;
//        case AVAudioSessionRouteChangeReasonCategoryChange:
//            // called at start - also when other audio wants to play
//            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
//            break;
//    }
}

- (BOOL)hasHeadset {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    AVAudioSessionRouteDescription *currentRoute = [audioSession currentRoute];
    
    for (AVAudioSessionPortDescription *output in currentRoute.outputs) {
        if ([[output portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
    }
    return NO;
}

- (void)joinChannelWithChannelID:(NSString *)channelID
                             uid:(NSString *)uid
                           token:(NSString *)token
                            role:(SYChatRoomUserRole)role {
    if (!self.voiceEngineEnabled) {
        return;
    }
    if (!channelID || channelID.length < 0) {
        return;
    }
    NSLog(@"agora version: %@", [AgoraRtcEngineKit getSdkVersion]);
    _retryTimes = 0;
    self.engine = [AgoraRtcEngineKit sharedEngineWithAppId:AGORA_APP_ID
                                              delegate:self];
    [self.engine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        
    }];
    [self.engine setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.engine setClientRole:[self clientRoleWithUserRole:role]];
    [self.engine setAudioProfile:AgoraAudioProfileMusicHighQualityStereo
                        scenario:AgoraAudioScenarioDefault];
    [self.engine enableAudioVolumeIndication:1000 smooth:3];
    [self.engine adjustAudioMixingVolume:([SYSettingManager voiceRoomMixingAudioVolume] * 100)];
//    if ([self hasHeadset]) {
//        [self.engine setParameters:@"{\"che.audio.bypass.apm\":true}"];
//    } else {
//        [self.engine setParameters:@"{\"che.audio.bypass.apm\":false}"];
//    }
//    if (![SYSettingManager voiceRoomMicDenoiseFlag]) {
//        [self.engine setParameters:@"{\"che.audio.enable.aec\":false}"];
//        [self.engine setParameters:@"{\"che.audio.enable.ns\":false}"];
//    }
    __weak typeof(self) weakSelf = self;
    while (YES) {
        NSInteger success = [self.engine joinChannelByToken:token
                                                  channelId:channelID
                                                       info:nil
                                                        uid:[uid integerValue]
                                                joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
                                                    weakSelf.engineUid = uid;
                                                }];
        if (success == 0) {
            // success
            NSLog(@"进入房间");
            if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatEngineDidJoinChannel)]) {
                [self.delegate voiceChatEngineDidJoinChannel];
            }
            self.retryTimes = 0;
            break;
        } else {
            // fail
            NSLog(@"进入房间失败");
            self.retryTimes ++;
            if (self.retryTimes >= 3) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatEngineDidError)]) {
                    [self.delegate voiceChatEngineDidError];
                }
                break;
            }
        }
    }
}

- (void)changeUserRoleWithRole:(SYChatRoomUserRole)role {
    if (!self.voiceEngineEnabled) {
        return;
    }
    [self.engine setClientRole:[self clientRoleWithUserRole:role]];
    if (role != SYChatRoomUserRoleHost) {
        [self.engine stopAudioMixing];
    }
} 

- (void)setMuted:(BOOL)muted {
    if (!self.voiceEngineEnabled) {
        return;
    }
    [self.engine muteLocalAudioStream:muted];
}

- (void)leaveChannel {
    [self.engine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        NSLog(@"离开房间");
    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [AgoraRtcEngineKit destroy];
//    });
}

- (void)renewToken:(NSString *)token {
    if (!self.voiceEngineEnabled) {
        return;
    }
    if (self.engine) {
        [self.engine renewToken:token];
    }
}

#pragma mark - AgoraRtcEngineDelegate

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine
    didOccurError:(AgoraErrorCode)errorCode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatEngineDidError)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate voiceChatEngineDidError];
        });
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine
reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo *> *)speakers
totalVolume:(NSInteger)totalVolume {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatEngineDidIndicateUserSpeakWithUids:)]) {
        NSMutableArray *uids = [NSMutableArray new];
        for (AgoraRtcAudioVolumeInfo *info in speakers) {
            [uids addObject:@(info.uid)];
        }
        if (totalVolume <= 30) {
            [self.delegate voiceChatEngineDidIndicateUserSpeakWithUids:@[]];
        } else {
            [self.delegate voiceChatEngineDidIndicateUserSpeakWithUids:uids];
        }
    }
}

- (void)rtcEngineLocalAudioMixingDidFinish:(AgoraRtcEngineKit * _Nonnull)engine {
    if ([self.playObserver respondsToSelector:@selector(voiceRoomPlayerDidFinishPlay)]) {
        [self.playObserver voiceRoomPlayerDidFinishPlay];
    }
}

- (void)rtcEngineRemoteAudioMixingDidStart:(AgoraRtcEngineKit *)engine {
//    if ([self.playObserver respondsToSelector:@selector(voiceRoomPlayerDidStartPlay)]) {
//        [self.playObserver voiceRoomPlayerDidStartPlay];
//    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine tokenPrivilegeWillExpire:(NSString *_Nonnull)token {
    // token过期
    if ([self.delegate respondsToSelector:@selector(voiceChatEngineTokenWillExpireWithEngineUserId:)]) {
        [self.delegate voiceChatEngineTokenWillExpireWithEngineUserId:self.engineUid];
    }
}

- (void)rtcEngineRequestToken:(AgoraRtcEngineKit *)engine {
    if ([self.delegate respondsToSelector:@selector(voiceChatEngineTokenWillExpireWithEngineUserId:)]) {
        [self.delegate voiceChatEngineTokenWillExpireWithEngineUserId:self.engineUid];
    }
}

#pragma mark - private

- (AgoraClientRole)clientRoleWithUserRole:(SYChatRoomUserRole)role {
    AgoraClientRole clientRole = AgoraClientRoleAudience;
    switch (role) {
        case SYChatRoomUserRoleHost:
        case SYChatRoomUserRoleBroadcaster:
        {
            clientRole = AgoraClientRoleBroadcaster;
        }
            break;
            
        default:
            break;
    }
    return clientRole;
}

#pragma mark - mixing player protocol

- (void)voiceRoomPlayerControlDidPlayWithFilePath:(NSString *)filePath {
    [self.engine startAudioMixing:filePath
                         loopback:NO
                          replace:NO
                            cycle:1];
    [self.engine adjustAudioMixingVolume:([SYSettingManager voiceRoomMixingAudioVolume] * 100)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
}

- (void)voiceRoomPlayerControlDidResume {
    [self.engine resumeAudioMixing];
}

- (void)voiceRoomPlayerControlDidPause {
    [self.engine pauseAudioMixing];
}

- (void)voiceRoomPlayerControlDidChangeVolumeWithProgress:(float)progress {
    [self.engine adjustAudioMixingVolume:progress*100];
}

- (void)voiceRoomPlayerControlDidChangePlaybackTime:(NSTimeInterval)time {
    [self.engine setAudioMixingPosition:time];
}

- (NSTimeInterval)voiceRoomPlayerControlDidGetCurrentPlaybackTime {
    return [self.engine getAudioMixingCurrentPosition];
}

- (NSTimeInterval)voiceRoomPlayerControlDidGetDuration {
    return [self.engine getAudioMixingDuration];
}

- (void)voiceRoomPlayerSetObserver:(id <SYVoiceRoomPlayerObserverProtocol>)observer {
    self.playObserver = observer;
}

#pragma mark -

- (void)voiceRoomAudioPlayAudioEffectWithFilePath:(NSString *)filePath {
    [self.engine playEffect:0
                   filePath:filePath
                  loopCount:0
                      pitch:1.0
                        pan:0
                       gain:100
                    publish:NO];
}

- (void)voiceRoomAudioPlayAudioStopEffect {
    [self.engine stopEffect:0];
}

@end
