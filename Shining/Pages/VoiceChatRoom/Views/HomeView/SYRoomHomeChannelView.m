//
//  SYVideoRoomHomeChannelView.m
//  Shining
//
//  Created by leeco on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYRoomHomeChannelView.h"
#import "SYVideoRoomHomeRoomCell.h"
#import "SYRoomHomePageViewModel.h"
#import "SYVoiceChatRoomManager.h"
#import "SYVoiceChatRoomVC.h"
#import "SYNoNetworkView.h"
@interface SYRoomHomeChannelView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SYPasswordInputViewDelegate, SYNoNetworkViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UICollectionView *pageCollectionView;
@property (nonatomic, strong) SYRoomHomePageViewModel *viewModel;
@property (nonatomic, strong) SYNoNetworkView *noNetworkView;
@property (nonatomic, strong) SYDataEmptyView *emptyDataView;
@property (nonatomic, assign) CGFloat moreHeight;
@end
@implementation SYRoomHomeChannelView
- (instancetype)initWithFrame:(CGRect)frame
                   categoryId:(NSInteger)categoryId
                   moreHeight:(CGFloat)moreHeight{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DEFAULT_THEME_BG_COLOR;
        self.moreHeight = moreHeight;
        self.viewModel = [[SYRoomHomePageViewModel alloc] initWithCategoryId:categoryId];
        [self addSubview:self.pageCollectionView];
        __weak typeof(self) weakSelf = self;
        self.pageCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestVideoChannelData];
        }];
    }
    return self;
}

- (void)requestVideoChannelData {
    if (![SYNetworkReachability isNetworkReachable]) {
        if ([self.viewModel roomListCount] == 0) {
            [self addNoNetworkView];
        }
        return;
    }
    [self removeEmptyDataView];
    [self removeNoNetworkView];
    [self.viewModel requestPageType:FirstCategoryType_default andRoomListWithBlock:^(BOOL success) {
        if (success) {
            [self.pageCollectionView reloadData];
            if ([self.viewModel roomListCount] == 0) {
                [self addEmptyDataView];
            }
        } else {
            if ([self.viewModel roomListCount] == 0) {
                [self addNoNetworkView];
            } else {
                [SYToastView showToast:@"数据更新失败"];
            }
        }
        [self.pageCollectionView.mj_header endRefreshing];
        if ([self.delegate respondsToSelector:@selector(roomHomeChannelViewDataIsRefreshed:)]) {
            [self.delegate roomHomeChannelViewDataIsRefreshed:self.pageCollectionView];
        }
    }];
}

- (void)addNoNetworkView {
    [self removeNoNetworkView];
    
    CGPoint point = [self convertPoint:CGPointMake(0, self.sy_top) toView:nil];
    self.noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:CGRectMake(0, 0, self.sy_width, self.sy_height - point.y)
                                                                  withDelegate:self];
    [self addSubview:self.noNetworkView];
}

- (void)removeNoNetworkView {
    if (self.noNetworkView) {
        [self.noNetworkView removeFromSuperview];
    }
    self.noNetworkView = nil;
}

- (void)addEmptyDataView {
    [self removeEmptyDataView];
    CGPoint point = [self convertPoint:CGPointMake(0, self.sy_top) toView:nil];
    self.emptyDataView = [[SYDataEmptyView alloc] initWithFrame:CGRectMake(0, point.y/4.f, self.sy_width, self.sy_height - point.y)
                                                   withTipImage:@"myWalletEmpty"
                                                     withTipStr:@"当前暂无房间哦～"];
    self.emptyDataView.backgroundColor = DEFAULT_THEME_BG_COLOR;
    [self addSubview:self.emptyDataView];
}

- (void)removeEmptyDataView {
    if (self.emptyDataView) {
        [self.emptyDataView removeFromSuperview];
    }
    self.emptyDataView = nil;
}

- (UICollectionView *)pageCollectionView {
    if (!_pageCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _pageCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                             collectionViewLayout:layout];
        _pageCollectionView.delegate = self;
        _pageCollectionView.dataSource = self;
        _pageCollectionView.backgroundColor = [UIColor clearColor];
        [_pageCollectionView registerClass:[SYVideoRoomHomeRoomCell class]
            forCellWithReuseIdentifier:@"cell"];
        
        if (@available(iOS 11.0, *)) {
            _pageCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _pageCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _pageCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel roomListCount];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVideoRoomHomeRoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                              forIndexPath:indexPath];
    [cell showWithTitle:[self.viewModel roomNameAtIndex:indexPath.item]
              avatarURL:[self.viewModel roomIconAtIndex:indexPath.item]
                  score:[self.viewModel roomScoreAtIndex:indexPath.item]
               roomType:[self.viewModel roomTypeAtIndex:indexPath.item]
           roomTypeIcon:[self.viewModel roomCategoryIconAtIndex:indexPath.item]
               isLocked:[self.viewModel roomIsLockedAtIndex:indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络连接中断，请检查网络"];
        return;
    }
    NSString *channelID = [self.viewModel roomIdAtIndex:indexPath.item];
//    [[SYVoiceChatRoomManager sharedManager] tryToEnterVideoChatRoomWithRoomId:channelID from:SYChatRoomFromTagList_video];
    NSArray *channelIDList = [self.viewModel roomIDList];
    [[SYVoiceChatRoomManager sharedManager] tryToEnterLiveRoomWithRoomId:channelID
                                                          liveRoomIDList:channelIDList
                                                              categoryID:self.viewModel.categoryId];
    
    NSString *title = [self.viewModel roomNameAtIndex:indexPath.item];
//    [MobClick event:@"listClick" attributes:@{@"position": @(indexPath.item+1), @"category": @(self.viewModel.categoryId), @"name":title?:@""}];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [SYVideoRoomHomeRoomCell cellSizeWithWidth:collectionView.sy_width];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    CGFloat bottom = iPhoneX ? (49.f + 34.f)+self.moreHeight : 49.f+self.moreHeight;
    return UIEdgeInsetsMake(10.f, 7.f, bottom, 7.f);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if ([self.delegate respondsToSelector:@selector(roomHomeChannelViewScrollViewDidScrollroomHomeChannelViewScrollViewDidScroll:)]) {
//        [self.delegate roomHomeChannelViewScrollViewDidScroll:scrollView];
//    }
    self.scrollCallback(scrollView);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    if ([self.delegate respondsToSelector:@selector(video_homeChannelViewScrollVIewWillScroll:)]) {
    //        [self.delegate video_homeChannelViewScrollVIewWillScroll:scrollView];
    //    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + scrollView.sy_height+self.moreHeight >= scrollView.contentSize.height) {
        if (![SYNetworkReachability isNetworkReachable]) {
            return;
        }
        [MBProgressHUD showHUDAddedTo:self animated:NO];
        [self.viewModel requestPageType:FirstCategoryType_default andLoadMoreRoomListWithBlock:^(BOOL success) {
            if (success) {
                [self.pageCollectionView reloadData];
            }
            [MBProgressHUD hideHUDForView:self animated:NO];
        }];
    }
}

- (void)SYNoNetworkViewClickRefreshBtn {
    [self requestVideoChannelData];
}
#pragma mark -
- (UIScrollView *)pagerView_listScrollView{
    return self.pageCollectionView;
}
- (void)pagerView_listViewDidScrollCallback:(void (^)(UIScrollView *))callback{
    self.scrollCallback = callback;
}
- (UIView *)pagerView_listView{
    return  self;
}
@end
