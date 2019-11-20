//
//  SYVoiceRoomPlayerProtocol.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#ifndef SYVoiceRoomPlayerProtocol_h
#define SYVoiceRoomPlayerProtocol_h

@protocol SYVoiceRoomPlayerObserverProtocol <NSObject>

- (void)voiceRoomPlayerDidStartPlay;
- (void)voiceRoomPlayerDidFinishPlay;
- (void)voiceRoomPlayerDidErrorPlay;

@end

@protocol SYVoiceRoomPlayerControlProtocol <NSObject>

- (void)voiceRoomPlayerControlDidPlayWithFilePath:(NSString *)filePath;
- (void)voiceRoomPlayerControlDidResume;
- (void)voiceRoomPlayerControlDidPause;
- (void)voiceRoomPlayerControlDidChangeVolumeWithProgress:(float)progress;
- (void)voiceRoomPlayerControlDidChangePlaybackTime:(NSTimeInterval)time;
- (NSTimeInterval)voiceRoomPlayerControlDidGetCurrentPlaybackTime;
- (NSTimeInterval)voiceRoomPlayerControlDidGetDuration;
- (void)voiceRoomPlayerSetObserver:(id <SYVoiceRoomPlayerObserverProtocol>)observer;

@end


#endif /* SYVoiceRoomPlayerProtocol_h */
