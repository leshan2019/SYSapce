//
//  SYVideoRoomHomeView.m
//  Shining
//
//  Created by leeco on 2019/9/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYRoomHomeView.h"
#import "SYRoomHomeFocusView.h"
#import "SYVideoRoomHomeTabCell.h"
#import "SYRoomHomeChannelView.h"
#import "SYRoomHomePageViewModel.h"
#import "SYWebViewController.h"
#import "SYRoomCategoryViewModel.h"
#import "SYCategoryBgTableView.h"
#import "SYCategoryPagerContainerView.h"
#define kPageChannelViewTag 49543
#define kPageTabViewTag 49544
@interface SYRoomHomeView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,SYVoiceRoomHomeFocusViewDelegate,SYVideoRoomHomeChannelViewDelegate,UITableViewDataSource, UITableViewDelegate,SYCategoryPageContainerViewDelegate>
///////
@property (nonatomic, strong) SYCategoryBgTableView *mainTableView;
@property (nonatomic, strong) SYCategoryPagerContainerView *listContainerView;
@property (nonatomic, strong) UIScrollView *currentScrollingListView;
@property (nonatomic, strong) id<SYCategoryPagerViewListViewDelegate> currentList;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, id<SYCategoryPagerViewListViewDelegate>> *validListDict;
@property (nonatomic, assign) UIDeviceOrientation currentDeviceOrientation;
///////

@property (nonatomic, assign) FirstCategoryType categoryType;
@property (nonatomic, strong) SYRoomHomeFocusView *focusView;
@property (nonatomic, strong) UICollectionView*tabCollectionView;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) BOOL focusDataReady;
@property (nonatomic, assign) BOOL categoryDataReady;

@property (nonatomic, strong) NSMutableArray *statPostedArray;

@property (nonatomic, strong) SYRoomHomePageViewModel *viewModel;

@end
@implementation SYRoomHomeView
- (instancetype)initWithFrame:(CGRect)frame andCategoryType:(FirstCategoryType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.categoryType = type;
        
        _validListDict = [NSMutableDictionary dictionary];
        [self initializeViews];
        [self setupSubViews];
    }
    return self;
}
- (void)initializeViews {
    [self addSubview:self.mainTableView];

}

- (SYCategoryBgTableView *)mainTableView{
    if (!_mainTableView) {
        SYCategoryBgTableView*tableView = [[SYCategoryBgTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollsToTop = NO;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableHeaderView = self.focusView;
        tableView.backgroundColor = DEFAULT_THEME_BG_COLOR;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _mainTableView = tableView;
    }
    return _mainTableView;
}
- (SYCategoryPagerContainerView *)listContainerView{
    if (!_listContainerView) {
        SYCategoryPagerContainerView * myListContainerView = [[SYCategoryPagerContainerView alloc] initWithDelegate:self];
        myListContainerView.mainTableView = self.mainTableView;
        myListContainerView.collectionView.scrollEnabled = NO;
        myListContainerView.backgroundColor = DEFAULT_THEME_BG_COLOR;
        _listContainerView = myListContainerView;
    }
    return _listContainerView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainTableView.frame = self.bounds;
}
- (void)reloadData {
    self.currentList = nil;
    self.currentScrollingListView = nil;

    for (id<SYCategoryPagerViewListViewDelegate> list in self.validListDict.allValues) {
        [list.pagerView_listView removeFromSuperview];
    }
    [_validListDict removeAllObjects];

    self.mainTableView.tableHeaderView = self.focusView;
    [self.mainTableView reloadData];
    [self.listContainerView reloadData];
}

- (void)preferredProcessListViewDidScroll:(UIScrollView *)scrollView {
    CGFloat ratio = 349.f / 105.f;
    CGFloat height = (self.sy_width - 26.f) / ratio;
    NSInteger heig = height;
    NSInteger offset = self.mainTableView.contentOffset.y;
    if (offset < heig) {
        //mainTableView的header还没有消失，让listScrollView一直为0
        if (self.currentList && [self.currentList respondsToSelector:@selector(pagerView_listScrollViewWillResetContentOffset)]) {
            [self.currentList pagerView_listScrollViewWillResetContentOffset];
        }
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    }else {
        //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
        self.mainTableView.contentOffset = CGPointMake(0, height);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (void)preferredProcessMainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat ratio = 349.f / 105.f;
    CGFloat height = (self.sy_width - 26.f) / ratio;
    if (self.currentScrollingListView != nil && self.currentScrollingListView.contentOffset.y > 0) {
        //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
        self.mainTableView.contentOffset = CGPointMake(0, height);
    }
    NSInteger heig = height;
    NSInteger offset = scrollView.contentOffset.y;
    if (offset< heig) {
        //mainTableView已经显示了header，listView的contentOffset需要重置
        for (id<SYCategoryPagerViewListViewDelegate> list in self.validListDict.allValues) {
            if ([list respondsToSelector:@selector(pagerView_listScrollViewWillResetContentOffset)]) {
                [list pagerView_listScrollViewWillResetContentOffset];
            }
            [list pagerView_listScrollView].contentOffset = CGPointZero;
        }
    }

    if (scrollView.contentOffset.y > height && self.currentScrollingListView.contentOffset.y == 0) {
        //当往上滚动mainTableView的headerView时，滚动到底时，修复listView往上小幅度滚动
        self.mainTableView.contentOffset = CGPointMake(0, height);
    }
}
#pragma mark - Private
- (void)setMainTableViewScrollEnable:(BOOL)canScroll{
    self.mainTableView.scrollEnabled = canScroll;
}
- (void)listViewDidScroll:(UIScrollView *)scrollView {
    self.currentScrollingListView = scrollView;

    [self preferredProcessListViewDidScroll:scrollView];
}

- (void)listDidAppear:(NSInteger)index {
    NSUInteger count = [self.categoryViewModel categoryCountWithType:self.categoryType];
    if (count <= 0 || index >= count) {
        return;
    }
    self.currentPage = index;
    
    id<SYCategoryPagerViewListViewDelegate> list = _validListDict[@(index)];
    if (list && [list respondsToSelector:@selector(pagerView_listDidAppear)]) {
        [list pagerView_listDidAppear];
    }
}

- (void)listDidDisappear:(NSInteger)index {
    NSUInteger count = [self.categoryViewModel categoryCountWithType:self.categoryType];
    if (count <= 0 || index >= count) {
        return;
    }
    id<SYCategoryPagerViewListViewDelegate> list = _validListDict[@(index)];
    if (list && [list respondsToSelector:@selector(pagerView_listDidDisappear)]) {
        [list pagerView_listDidDisappear];
    }
}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger tabCount = [self.categoryViewModel categoryCountWithType:self.categoryType];
    CGFloat tabHeight = 35.f*dp;
    if (tabCount < 2) {
        tabHeight = 0;
    }
    CGFloat height = self.bounds.size.height - tabHeight;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellind = @"cellind";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.backgroundColor = [UIColor purpleColor];
    self.listContainerView.frame = CGRectMake(0, 0, self.mainTableView.frame.size.width, self.bounds.size.height);//cell.bounds;
    [cell addSubview:self.listContainerView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger tabCount = [self.categoryViewModel categoryCountWithType:self.categoryType];
    CGFloat tabHeight = 46.f*dp;
    if (tabCount < 2) {
        tabHeight = 0;
    }
    return tabHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.mainTableView.sy_width, 46*dp)];//
    view.backgroundColor = DEFAULT_THEME_BG_COLOR;
    [view addSubview:self.tabCollectionView];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isTracking ) {
        self.listContainerView.collectionView.scrollEnabled = NO;
    }
    [self preferredProcessMainTableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
   
}
#pragma mark - MyPagerContainerViewDelegate

- (NSInteger)pageContainer_numberOfRowsInListContainerView:(SYCategoryPagerContainerView *)listContainerView {
    NSInteger count = [self.categoryViewModel categoryCountWithType:self.categoryType];
    return count;
}

- (UIView *)pageContainer_listContainerView:(SYCategoryPagerContainerView *)listContainerView listViewInRow:(NSInteger)row {
    id<SYCategoryPagerViewListViewDelegate> list = self.validListDict[@(row)];
    if (list == nil) {
        NSInteger tabCount = [self.categoryViewModel categoryCountWithType:self.categoryType];
        CGFloat tabHeight = 46.f*dp;
        if (tabCount < 2) {
            tabHeight = 0;
        }
        NSInteger categoryId = [self.categoryViewModel categoryIdAtIndex:row categoryType:self.categoryType];
        SYRoomHomeChannelView *channelView  = [[SYRoomHomeChannelView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, self.sy_height) categoryId:categoryId moreHeight:tabHeight];
//        if (row == 0) {
        channelView.delegate = self;
            [channelView requestVideoChannelData];
//        }
        list = channelView;
        __weak typeof(self)weakSelf = self;
        __weak typeof(id<SYCategoryPagerViewListViewDelegate>) weakList = list;
        [list pagerView_listViewDidScrollCallback:^(UIScrollView *scrollView) {
            weakSelf.currentList = weakList;
            [weakSelf listViewDidScroll:scrollView];
        }];
        _validListDict[@(row)] = list;
    }
    for (id<SYCategoryPagerViewListViewDelegate> listItem in self.validListDict.allValues) {
        if (listItem == list) {
            [listItem pagerView_listScrollView].scrollsToTop = YES;
        }else {
            [listItem pagerView_listScrollView].scrollsToTop = NO;
        }
    }

    return [list pagerView_listView];
}

- (void)pageContainer_listContainerView:(SYCategoryPagerContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row {
    [self listDidAppear:row];
    self.currentScrollingListView = [self.validListDict[@(row)] pagerView_listScrollView];
}

- (void)pageContainer_listContainerView:(SYCategoryPagerContainerView *)listContainerView didEndDisplayingCellAtRow:(NSInteger)row {
    [self listDidDisappear:row];
}
/////////////////
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    self.backgroundColor = DEFAULT_THEME_BG_COLOR;
    self.viewModel = [[SYRoomHomePageViewModel alloc] init];
    self.categoryViewModel = [[SYRoomCategoryViewModel alloc] init];
    

    __weak typeof(self) weakSelf = self;
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf willAppear];
    }];
    if ([self.mainTableView.mj_header isKindOfClass:[MJRefreshNormalHeader class]]) {
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.mainTableView.mj_header;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
    }
    self.mainTableView.mj_header.ignoredScrollViewContentInsetTop = - self.focusView.sy_top;
}
- (SYRoomHomeFocusView *)focusView {
    if (!_focusView) {
        CGFloat top = 0;
        CGFloat height = 0;
        _focusView = [[SYRoomHomeFocusView alloc] initWithFrame:CGRectMake(0, top, self.sy_width, height)];
        [_focusView resetSpec:8.f];
        _focusView.delegate = self;
    }
    return _focusView;
}


- (UICollectionView *)tabCollectionView {
    if (!_tabCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 30;
        layout.minimumInteritemSpacing = 30;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        layout.sectionInset = UIEdgeInsetsMake(4, 25, 0, 0);
        _tabCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.focusView.sy_bottom, self.sy_width, 35.f*dp)
                                                collectionViewLayout:layout];
        _tabCollectionView.delegate = self;
        _tabCollectionView.dataSource = self;
        [_tabCollectionView registerClass:[SYVideoRoomHomeTabCell class]
               forCellWithReuseIdentifier:@"tab"];
        _tabCollectionView.backgroundColor = DEFAULT_THEME_BG_COLOR;
        _tabCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _tabCollectionView;
}


- (void)resetSubViewsFrame{
    
    [self.focusView setFrame:CGRectMake(0, 0, self.sy_width, 0)];
    NSInteger tabCount = [self.categoryViewModel categoryCountWithType:self.categoryType];
    CGFloat tabHeight = 35.f*dp;
    if (tabCount < 2) {
        tabHeight = 0;
    }
    [self.tabCollectionView setFrame:CGRectMake(0, 10*dp, self.sy_width,tabHeight )];

    [self.mainTableView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.categoryViewModel categoryCountWithType:self.categoryType];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tabCollectionView) {
        SYVideoRoomHomeTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tab"
                                                                                 forIndexPath:indexPath];
        [cell showWithIconURL:[self.categoryViewModel categoryIconAtIndex:indexPath.item categoryType:self.categoryType]
            highlighteIconURL:[self.categoryViewModel categoryHighlightedIconAtIndex:indexPath.item categoryType:self.categoryType]
                        title:@""];
        cell.selected = (indexPath.item == self.currentPage);
        cell.backgroundColor = DEFAULT_THEME_BG_COLOR;
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tabCollectionView) {
        CGFloat x = indexPath.item * self.listContainerView.sy_width;
        [self.listContainerView.collectionView setContentOffset:CGPointMake(x, 0) animated:YES];
        [self changeTabCollectionCellSelectedStateWithOldIndex:self.currentPage
                                                      newIndex:-1
                                         needHighlightNewIndex:NO];
        
       
        self.currentPage = indexPath.item;
        [self.listContainerView.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.item inSection:0]]];
        [self willAppear];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.tabCollectionView) {
        CGSize size = [self.categoryViewModel getCategoryTabSize:26.f andIndex:indexPath.item categoryType:self.categoryType];
        return size;
    }
    return collectionView.sy_size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.tabCollectionView) {
        return UIEdgeInsetsMake(0.f, 15.f, 0, 15.f);
    }
    return UIEdgeInsetsMake(0.f, 0.f, 0, 0.f);
}

#pragma mark - private

- (void)changeTabCollectionCellSelectedStateWithOldIndex:(NSInteger)oldIndex
                                                newIndex:(NSInteger)newIndex
                                   needHighlightNewIndex:(BOOL)needHighlightNewIndex {
    SYVideoRoomHomeTabCell *cell = (SYVideoRoomHomeTabCell *)[self.tabCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:oldIndex inSection:0]];
    cell.selected = NO;
    if (needHighlightNewIndex) {
        cell = (SYVideoRoomHomeTabCell *)[self.tabCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:newIndex inSection:0]];
        cell.selected = YES;
    }
}

#pragma mark -

- (void)roomHomeChannelViewScrollViewDidScroll:(UIScrollView *)scr {
    
}

- (void)roomHomeChannelViewDataIsRefreshed:(UIScrollView *)scr {
    [self.mainTableView.mj_header endRefreshing];
}

#pragma mark - data request
- (void)requestVideoHomeData{
    if (!self.focusDataReady) {
        self.hasRequestedData = YES;
        [MBProgressHUD showHUDAddedTo:self animated:NO];
        [self.viewModel requestPageType:self.categoryType andFocusListWithBlock:^(BOOL success) {
            [MBProgressHUD hideHUDForView:self animated:NO];
            self.focusDataReady = success;
            if (success && [self.viewModel focusListCount] > 0) {
                [self.focusView reloadData];
            }
            [self requestVideoCategoryList];
            
            if (!success) {
            }
        }];
    }
}
-(void)requestVideoCategoryList{
    if (self.categoryDataReady) {
        return;
    }
    [self.tabCollectionView reloadData];
    [self reloadData];
    [self willAppear];
}

- (void)willAppear {
    SYRoomHomeChannelView *channelView = self.validListDict[@(self.currentPage)];
    if (channelView) {
        [channelView requestVideoChannelData];
    }
}
#pragma mark - focus delegate
- (void)homeFocusResetFrame{
    CGFloat top = 0;
    CGFloat ratio = 349.f / 105.f;
    CGFloat height = (self.sy_width - 26.f) / ratio;
    self.focusView.frame = CGRectMake(0, top, self.sy_width, height);
    [self.focusView layoutSubviews];
   
    [self.mainTableView reloadData];
}
- (NSInteger)homeFocusImageCount{
    return [self.viewModel focusListCount];
}
- (NSString *)homeFocusImageURLAtIndex:(NSInteger)index {
    return [self.viewModel focusImageURLAtIndex:index];
}

- (void)homeFocusDidTapImageAtIndex:(NSInteger)index {
    NSString *jump = [self.viewModel focusJumpURLAtIndex:index];
    NSString *title = [self.viewModel focusTitleAtIndex:index];
    SYVideoRoomFocusJumpType type = [self.viewModel focusJumpTypeAtIndex:index];
    if (type == SYVideoRoomFocusJumpTypeWeb) {
        SYWebViewController *vc = [[SYWebViewController alloc] initWithURL:jump
                                                                  andTitle:title];
        if (self.delegate && [self.delegate respondsToSelector:@selector(roomHomeView_clickFocusView:)]) {
            [self.delegate roomHomeView_clickFocusView:vc];
        }
        
    } else if (type == SYVideoRoomFocusJumpTypeRoom) {
        NSString *channelID = jump;
        [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:channelID from:SYVoiceChatRoomFromTagFocus];
    }
    
//    [MobClick event:@"focusClick" attributes:@{@"position": @(index+1), @"destination": jump?:@"", @"name":title?:@""}];
}

- (void)homeFocusDidShowImageAtIndex:(NSInteger)index {
    if (!self.statPostedArray) {
        self.statPostedArray = [NSMutableArray new];
    }
    if (![self.statPostedArray containsObject:@(index)]) {
        [self.statPostedArray addObject:@(index)];
        NSString *jump = [self.viewModel focusJumpURLAtIndex:index];
        NSString *title = [self.viewModel focusTitleAtIndex:index];
//        [MobClick event:@"focusExposure" attributes:@{@"position": @(index+1), @"destination": jump?:@"", @"name":title?:@""}];
    }
}

@end
