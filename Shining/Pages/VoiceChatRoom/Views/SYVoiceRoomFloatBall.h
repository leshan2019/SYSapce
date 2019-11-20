//
//  SYVoiceRoomFloatBall.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYVoiceRoomFloatBall;

@protocol SYVoiceRoomFloatBallDelegate <NSObject>

- (void)voiceRoomFloatBallDidClose;
- (void)voiceRoomFloatBallDidEnterRoomWithFloatBall:(SYVoiceRoomFloatBall *)floatBall;

@end

@interface SYVoiceRoomFloatBall : UIView

@property (nonatomic, weak) id <SYVoiceRoomFloatBallDelegate> delegate;

- (void)showWithRoomName:(NSString *)roomName
                roomIcon:(NSString *)roomIcon;

@end

NS_ASSUME_NONNULL_END
