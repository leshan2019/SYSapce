//
//  SYVoiceRoomInputView.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYVoiceRoomInputViewDelegate <NSObject>

- (void)voiceRoomInputViewDidSendText:(NSString *)text;
- (void)voiceRoomInputViewDidSendDanmaku:(NSString *)danmuku
                                 danmuId:(NSInteger)danmuId;
- (BOOL)voiceRoomInputViewCanVipDanmakuBeSendWithDanmakuLevel:(NSInteger)level;
- (BOOL)voiceRoomInputViewShouldSend;
- (BOOL)voiceRoomInputViewNeedChildProtect;
- (void)voiceRoomInputViewLackOfBalance;
- (BOOL)voiceRoomInputViewCanSendDanmaku; // 是否为禁言

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomInputView : UIView

@property (nonatomic, weak) id <SYVoiceRoomInputViewDelegate> delegate;

- (void)setRoomID:(NSString *)roomID
           userID:(NSString *)userID;
- (void)becomeFirstResponder;

@end

NS_ASSUME_NONNULL_END
