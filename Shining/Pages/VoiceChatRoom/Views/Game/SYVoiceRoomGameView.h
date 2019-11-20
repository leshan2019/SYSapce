//
//  SYVoiceRoomGameView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYChatEngineEnum.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomGameViewDelegate <NSObject>

- (void)voiceRoomGameViewDidSelectGame:(SYVoiceRoomGameType)game;

@end

@interface SYVoiceRoomGameView : UIView

@property (nonatomic, weak) id <SYVoiceRoomGameViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
