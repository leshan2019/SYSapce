//
//  SYVoiceTextMessageCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVIPLevelView.h"
#import "SYBroadcasterLevelView.h"
#import "SYVoiceTextMessageViewModel.h"

@class SYVoiceTextMessageViewModel;

@protocol SYVoiceTextMessageCellDelegate <NSObject>

@optional
- (void)voiceTextMessageCellDidTapUsernameWithCell:(UICollectionViewCell *)cell;
- (void)voiceTextMessageCellDidTapReceiverNameWithCell:(UICollectionViewCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceTextMessageCell : UICollectionViewCell

@property (nonatomic, weak) id <SYVoiceTextMessageCellDelegate> delegate;

@property (nonatomic, strong) UIView *textShadow;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, assign) SYVoiceTextMessageType messageType;
@property (nonatomic, strong) SYVIPLevelView *vipView;
@property (nonatomic, strong) SYBroadcasterLevelView *broadcasterLevelView;

+ (CGSize)cellSizeWithViewModel:(SYVoiceTextMessageViewModel *)viewModel
                          width:(CGFloat)width;

- (void)showWithViewModel:(SYVoiceTextMessageViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
