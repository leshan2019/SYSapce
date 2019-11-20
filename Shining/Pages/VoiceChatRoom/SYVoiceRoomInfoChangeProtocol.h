//
//  SYVoiceRoomInfoChangeProtocol.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#ifndef SYVoiceRoomInfoChangeProtocol_h
#define SYVoiceRoomInfoChangeProtocol_h

@protocol SYVoiceRoomInfoChangeProtocol <NSObject>

@optional

- (void)voiceRoomInfoDidChange;
- (void)voiceRoomInfoDidAddAdminister:(NSString *)uid;
- (void)voiceRoomInfoDidDeleteAdminister:(NSString *)uid;
- (void)voiceRoomInfoDidRemoveForbiddenChatUser:(NSString *)uid;
- (void)voiceRoomInfoDidRemoveForbiddenEnterUser:(NSString *)uid;
- (void)voiceRoomInfoDidChangeRoomBackgroundImage:(NSInteger)imageNum;

@end


#endif /* SYVoiceRoomInfoChangeProtocol_h */
