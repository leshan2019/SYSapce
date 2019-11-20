//
//  SYVoiceRoomGiftGroupView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GiftPageControlHeight 27

@class SYVoiceChatRoomGiftViewModel;
@class SYVoiceRoomGiftGroupView;

@protocol SYVoiceRoomGiftGroupViewDelegate <NSObject>

- (void)voiceRoomGiftGroupViewDidChangeGiftSelectIndexWithGroupView:(SYVoiceRoomGiftGroupView *)groupView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomGiftGroupView : UIView

@property (nonatomic, weak) id <SYVoiceRoomGiftGroupViewDelegate> delegate;
@property (nonatomic, assign, readonly) NSInteger selectedGiftIndex;
@property (nonatomic, assign) BOOL isGiftBag; // 礼物背包

- (void)showGiftListWithGroup:(NSInteger)group
                    viewModel:(SYVoiceChatRoomGiftViewModel *)viewModel;


/**
 重新loadData
 */
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
