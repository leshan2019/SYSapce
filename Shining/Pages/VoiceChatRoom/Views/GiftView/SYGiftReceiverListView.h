//
//  SYGiftReceiverListView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYGiftReceiverListViewDelegate <NSObject>

- (void)giftReceiverListViewSelectIndexesChanged;

@end

@interface SYGiftReceiverListView : UIView

@property (nonatomic, weak) id <SYGiftReceiverListViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray <NSNumber *>*selectIndexArray;

- (void)setUserAvatarURLArray:(NSArray *)urls highlightedIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
