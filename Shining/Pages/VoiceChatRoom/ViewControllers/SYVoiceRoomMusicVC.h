//
//  SYVoiceRoomMusicVC.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceRoomPlayerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

//@protocol SYVoiceRoomMusicVCDelegate <NSObject>
//
//- (void)voiceRoomMusicVCDidPlayMusicWithFilePath:(NSString *)filePath;
//- (void)voiceRoomMusicVCDidPauseMusic;
//- (void)voiceRoomMusicVCDidResumeMusic;
//
//@end

@interface SYVoiceRoomMusicVC : UIViewController <SYVoiceRoomPlayerObserverProtocol>

//@property (nonatomic, weak) id <SYVoiceRoomMusicVCDelegate> delegate;
@property (nonatomic, weak) id <SYVoiceRoomPlayerControlProtocol> playControlDelegate;

+ (instancetype)sharedVC;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
