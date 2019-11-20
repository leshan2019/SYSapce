//
//  SYVoiceRoomApplyListCell.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYVoiceChatUserViewModel;
@class SYVoiceRoomApplyMicCell;

@protocol SYVoiceRoomApplyMicCellDelegate <NSObject>

- (void)voiceRoomApplyMicCellDidSelectConfirmButtonWithCell:(SYVoiceRoomApplyMicCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomApplyMicCell : UICollectionViewCell

@property (nonatomic, weak) id <SYVoiceRoomApplyMicCellDelegate> delegate;

- (void)drawWithUserViewModel:(SYVoiceChatUserViewModel *)userViewModel
                        index:(NSInteger)index
            needConfirmButton:(BOOL)needConfirmButton;

@end

NS_ASSUME_NONNULL_END
