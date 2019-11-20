//
//  MyProtocol.h
//  MyCollectionView
//
//  Created by leeco on 2019/10/21.
//  Copyright © 2019 letv. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol SYCategoryPagerViewListViewDelegate <NSObject>

- (UIView *)pagerView_listView;

- (UIScrollView *)pagerView_listScrollView;

- (void)pagerView_listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback;

@optional

- (void)pagerView_listScrollViewWillResetContentOffset;

- (void)pagerView_listDidAppear;

- (void)pagerView_listDidDisappear;

@end

@protocol SYCategoryPageViewDelegate <NSObject>

- (NSUInteger)pagerView_tableHeaderViewHeightInPagerView:(UIView *)pagerView;

- (UIView *)pagerView_tableHeaderViewInPagerView:(UIView *)pagerView;

- (NSUInteger)pagerView_heightForPinSectionHeaderInPagerView:(UIView *)pagerView;

- (UIView *)pagerView_viewForPinSectionHeaderInPagerView:(UIView *)pagerView;

- (NSInteger)pagerView_numberOfListsInPagerView:(UIView *)pagerView;

- (id<SYCategoryPagerViewListViewDelegate>)pagerView:(UIView *)pagerView initListAtIndex:(NSInteger)index;

@optional
- (void)pagerView_mainTableViewDidScroll:(UIScrollView *)scrollView;
@end

