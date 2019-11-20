//
//  SYVoiceGiftMessageCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceTextMessageCell.h"

@class SYVoiceTextMessageViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceGiftMessageCell : UICollectionViewCell

@property (nonatomic, weak) id <SYVoiceTextMessageCellDelegate> delegate;

+ (CGSize)cellSizeWithViewModel:(SYVoiceTextMessageViewModel *)viewModel
                          width:(CGFloat)width;

- (void)showWithViewModel:(SYVoiceTextMessageViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
