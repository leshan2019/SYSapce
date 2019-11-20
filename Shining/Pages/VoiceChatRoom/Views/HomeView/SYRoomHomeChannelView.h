//
//  SYVideoRoomHomeChannelView.h
//  Shining
//
//  Created by leeco on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCategoryProtocol.h"

@protocol SYVideoRoomHomeChannelViewDelegate <NSObject>

- (void)roomHomeChannelViewScrollViewDidScroll:(UIScrollView*)scr;
- (void)roomHomeChannelViewDataIsRefreshed:(UIScrollView*)scr;
//- (void)video_homeChannelViewScrollVIewWillScroll:(UIScrollView*)scr;
@end
@interface SYRoomHomeChannelView : UIView <SYCategoryPagerViewListViewDelegate>
@property (nonatomic, weak) id <SYVideoRoomHomeChannelViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                   categoryId:(NSInteger)categoryId
                   moreHeight:(CGFloat)moreHeight;

- (void)requestVideoChannelData;

@property (nonatomic, strong, readonly) UICollectionView *pageCollectionView;

@end

