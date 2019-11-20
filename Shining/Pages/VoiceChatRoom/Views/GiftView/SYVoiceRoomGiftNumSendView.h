//
//  SYVoiceRoomGiftNumSendView.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

// 带有发送礼物数量和发送按钮的view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomGiftNumSendViewDelegate <NSObject>

- (void)voiceRoomGiftNumSendViewTouchWhenDisable;
- (void)voiceRoomGiftNumSendViewDidSendGiftWithNum:(NSInteger)num;

@end

@interface SYVoiceRoomGiftNumSendView : UIView

@property (nonatomic, weak) id <SYVoiceRoomGiftNumSendViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger giftNum; // 礼物数量

- (void)setEnabled:(BOOL)enabled;
- (void)resetGiftNum;
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
