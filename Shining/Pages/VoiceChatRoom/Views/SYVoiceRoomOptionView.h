//
//  SYVoiceRoomOptionView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomOptionViewDelegate <NSObject>

- (void)voiceRoomOptionViewDidSelectConfirmMicAtIndex:(NSInteger)index;
- (void)voiceRoomOptionViewDidSelectMuteMicAtIndex:(NSInteger)index;
- (void)voiceRoomOptionViewDidCancel;

@end

@interface SYVoiceRoomOptionView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  showAtPoint:(CGPoint)point
                     micIndex:(NSInteger)micIndex;

@property (nonatomic, weak) id <SYVoiceRoomOptionViewDelegate> delegate;

- (void)setMutedState:(BOOL)isMuted;

@end

NS_ASSUME_NONNULL_END
