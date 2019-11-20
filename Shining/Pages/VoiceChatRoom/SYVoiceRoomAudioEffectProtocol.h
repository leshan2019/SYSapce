//
//  SYVoiceRoomAudioEffectProtocol.h
//  Shining
//
//  Created by mengxiangjian on 2019/5/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#ifndef SYVoiceRoomAudioEffectProtocol_h
#define SYVoiceRoomAudioEffectProtocol_h

@protocol SYVoiceRoomAudioEffectProtocol <NSObject>

- (void)voiceRoomAudioPlayAudioEffectWithFilePath:(NSString *)filePath;
- (void)voiceRoomAudioPlayAudioStopEffect;

@end

#endif /* SYVoiceRoomAudioEffectProtocol_h */
