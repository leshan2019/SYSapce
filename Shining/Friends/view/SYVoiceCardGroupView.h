//
//  SYVoiceCardGroupView.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceCardView.h"

NS_ASSUME_NONNULL_BEGIN

@class SYVoiceCardGroupView, SYVoiceCardView;
@protocol SYVoiceCardGroupViewDelegate <NSObject>
@optional
- (void)cardView:(SYVoiceCardGroupView *)cardView didClickItemAtIndex:(NSInteger)index;
- (void)attentionUser:(SYVoiceCardView *)cardItemView;
- (void)contact:(SYVoiceCardView *)cardItemView;
- (void)gotoUserinfo:(SYVoiceCardView *)cardItemView;
@end

@protocol SYVoiceCardGroupViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemViewsInCardView:(SYVoiceCardGroupView *)cardView;
- (SYVoiceCardView *)cardView:(SYVoiceCardGroupView *)cardView itemViewAtIndex:(NSInteger)index;
- (void)cardViewNeedMoreData:(SYVoiceCardGroupView *)cardView;
@optional
// default is equal to cardView's bounds
- (CGSize)cardView:(SYVoiceCardGroupView *)cardView sizeForItemViewAtIndex:(NSInteger)index;

- (void)showCurrentCardItem:(SYVoiceCardView *)cardItemView index:(NSInteger)index;

@end

@interface SYVoiceCardGroupView : UIView
@property (nonatomic, weak) id <SYVoiceCardGroupViewDataSource> dataSource;
@property (nonatomic, weak) id <SYVoiceCardGroupViewDelegate> delegate;

- (void)deleteTheTopItemViewWithLeft:(BOOL)left;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
