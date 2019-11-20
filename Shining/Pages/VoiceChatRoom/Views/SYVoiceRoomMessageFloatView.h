//
//  SYVoiceRoomMessageFloatView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceTextMessageViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomMessageFloatViewDelegate <NSObject>

- (void)voiceRoomMessageFloatViewOpenRoomWithRoomId:(NSString *)roomId;

@end

@interface SYVoiceRoomMessageFloatView : UIView

@property (nonatomic, weak) id <SYVoiceRoomMessageFloatViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isAnimate;

- (void)addMessage:(SYVoiceTextMessageViewModel *)msgViewModel;

- (void)destory;

@end

NS_ASSUME_NONNULL_END
