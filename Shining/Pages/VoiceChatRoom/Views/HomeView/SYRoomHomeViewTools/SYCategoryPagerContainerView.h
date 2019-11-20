//
//  MyPagerContainerView.h
//  MyCollectionView
//
//  Created by leeco on 2019/10/21.
//  Copyright © 2019 letv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCategoryPageCollectionView.h"

//@class MyPageCollectionView;
@class SYCategoryBgTableView;
@class SYCategoryPagerContainerView;
@protocol SYCategoryPageContainerViewDelegate <NSObject>

- (NSInteger)pageContainer_numberOfRowsInListContainerView:(SYCategoryPagerContainerView *)listContainerView;

- (UIView *)pageContainer_listContainerView:(SYCategoryPagerContainerView *)listContainerView listViewInRow:(NSInteger)row;

- (void)pageContainer_listContainerView:(SYCategoryPagerContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row;

- (void)pageContainer_listContainerView:(SYCategoryPagerContainerView *)listContainerView didEndDisplayingCellAtRow:(NSInteger)row;

@end
@interface SYCategoryPagerContainerView : UIView

@property (nonatomic, strong, readonly) SYCategoryPageCollectionView *collectionView;
@property (nonatomic, weak) id<SYCategoryPageContainerViewDelegate> delegate;
@property (nonatomic, weak) SYCategoryBgTableView *mainTableView;

- (instancetype)initWithDelegate:(id<SYCategoryPageContainerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reloadData;

@end

