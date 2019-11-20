//
//  SYVoiceRoomWaitMicListView.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYChatEngineEnum.h"

@class SYVoiceChatUserViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceRoomApplyMicListViewDataSource <NSObject>

- (NSInteger)voiceRoomApplyMicListViewItemCount;
- (SYVoiceChatUserViewModel *)voiceRoomApplyMicListViewItemModelAtIndex:(NSInteger)index;
- (BOOL)voiceRoomApplyMicListViewNeedConfirmButtonAtIndex:(NSInteger)index;
- (BOOL)voiceRoomApplyMicListViewIsMyselfInApplyList;
- (NSInteger)voiceRoomApplyMicListViewMyselfIndex;
- (BOOL)voiceRoomApplyMicListViewIsNeedApplyButton;

@end

@protocol SYVoiceRoomApplyMicListViewDelegate <NSObject>

- (void)voiceRoomApplyMicListViewDidSelectConfirmButtonAtIndex:(NSInteger)index;
- (void)voiceRoomApplyMicListViewDidSelectRowAtIndex:(NSInteger)index;
- (void)voiceRoomApplyMicListViewDidSelectApplyButton;
- (void)voiceRoomApplyMicListViewDidDisappeared; // 消失

@end

@interface SYVoiceRoomApplyMicListView : UIView

@property (nonatomic, weak) id <SYVoiceRoomApplyMicListViewDataSource> dataSource;
@property (nonatomic, weak) id <SYVoiceRoomApplyMicListViewDelegate> delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
