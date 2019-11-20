//
//  SYVoiceGameMessageCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/5/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceTextMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceGameMessageCell : UICollectionViewCell

@property (nonatomic, weak) id <SYVoiceTextMessageCellDelegate> delegate;

- (void)showWithViewModel:(SYVoiceTextMessageViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
