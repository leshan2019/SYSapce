//
//  SYVoiceTextMessageView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceTextMessageViewModel.h"
#import "SYVoiceTextMessageCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SYVoiceTextMessageListView;
@class SYVoiceTextMessageViewModel;

@protocol SYVoiceTextMessageListViewDataSource <NSObject>

- (NSInteger)numberOfItemsOfVoiceTextMessageListView:(SYVoiceTextMessageListView *)view;
- (SYVoiceTextMessageViewModel *)voiceTextMessageListView:(SYVoiceTextMessageListView *)view
                                  messageViewModelAtIndex:(NSInteger)index;

@end

@protocol SYVoiceTextMessageListViewDelegate <NSObject>

- (void)voiceTextMessageListViewDidSelectUserAtIndex:(NSInteger)index;
- (void)voiceTextMessageListViewDidSelectReceiverAtIndex:(NSInteger)index;

@end

@interface SYVoiceTextMessageListView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SYVoiceTextMessageCellDelegate>

@property (nonatomic, weak) id <SYVoiceTextMessageListViewDataSource> dataSource;
@property (nonatomic, weak) id <SYVoiceTextMessageListViewDelegate> delegate;

- (void)addGiftInfo:(SYVoiceTextMessageViewModel *)giftViewModel;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
