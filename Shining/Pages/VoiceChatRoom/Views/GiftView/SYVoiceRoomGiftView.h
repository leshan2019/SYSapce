//
//  SYVoiceRoomGiftView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceChatUserViewModel.h"

@class SYVoiceRoomGiftView;

@protocol SYVoiceRoomGiftViewDataSource <NSObject>

//- (NSInteger)giftViewReceiverCountWithGiftView:(SYVoiceRoomGiftView *)giftView;
//- (NSString *)giftView:(SYVoiceRoomGiftView *)giftView
// receiverAvatarAtIndex:(NSInteger)index;
//- (NSString *)giftView:(SYVoiceRoomGiftView *)giftView
//    receiverUidAtIndex:(NSInteger)index;

- (NSArray <SYVoiceChatUserViewModel *>*)giftViewReceiversWithGiftView:(SYVoiceRoomGiftView *)giftView;

@end

@protocol SYVoiceRoomGiftViewDelegate <NSObject>

- (void)giftViewDidCloseWithGiftView:(SYVoiceRoomGiftView *)giftView;
- (void)giftView:(SYVoiceRoomGiftView *)giftView
didGoToCachierWithGiftViewWithCoin:(NSInteger)coin;

- (void)giftView:(SYVoiceRoomGiftView *)giftView
didSendGiftToUser:(SYVoiceChatUserViewModel *)user
          giftID:(NSInteger)giftID
    randomGiftId:(NSInteger)randomGiftId
            nums:(NSInteger)nums;

- (void)giftView:(SYVoiceRoomGiftView *)giftView
didSendRandomGiftWithGiftIDs:(NSArray *)giftIDs
          giftID:(NSInteger)giftID;

- (void)giftViewDidFinishSendGift;

- (BOOL)giftViewCanSendGiftWithGiftLevel:(NSInteger)giftLevel;

- (BOOL)giftViewShouldOperateUserRelatives; // 是否可以操作用户相关

- (BOOL)giftViewShouldOperateTeenager;

- (void)giftViewDidSendGiftToUpdateVIPLevel;

- (void)giftViewLackOfBalance;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomGiftView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                     isAllMic:(BOOL)isAllMic
                    channelID:(NSString *)channelID;

@property (nonatomic, assign, readonly) BOOL isAllMic; // 是否打赏全麦

@property (nonatomic, weak) id <SYVoiceRoomGiftViewDataSource> dataSource;
@property (nonatomic, weak) id <SYVoiceRoomGiftViewDelegate> delegate;

- (void)loadGifts;
- (void)loadBalance;
- (void)setHighlightedIndex:(NSInteger)index;
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
