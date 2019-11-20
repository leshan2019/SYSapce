//
//  SYVoiceCardView.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceMatchUserModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SYVoiceCardView;
@protocol SYVoiceCardViewDelegate <NSObject>
- (void)cardItemViewDidRemoveFromSuperView:(SYVoiceCardView *)cardItemView;
- (void)attentionUser:(SYVoiceCardView *)cardItemView;
- (void)contact:(SYVoiceCardView *)cardItemView;
- (void)gotoUserinfo:(SYVoiceCardView *)cardItemView;
@optional
- (void)cardItemViewPanGestureStateChanged:(SYVoiceCardView *)cardItemView withMoveWidth:(CGFloat)moveWidth;
- (void)cardItemViewPanGestureStateEnd:(SYVoiceCardView *)cardItemView;
@end

@interface SYVoiceCardView : UIView

@property (nonatomic, weak) id <SYVoiceCardViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)updateUIByUser:(SYVoiceMatchUserModel *)userInfo;
- (void)removeWithLeft:(BOOL)left;
- (void)showAnimationPlayer;
@end

NS_ASSUME_NONNULL_END
