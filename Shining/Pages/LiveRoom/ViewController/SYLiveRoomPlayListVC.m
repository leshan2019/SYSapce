//
//  SYLiveRoomPlayListVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/11/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomPlayListVC.h"
#import "SYVerticalPageView.h"
#import "SYLiveRoomPlayListCell.h"
#import "SYLiveRoomPlayListViewModel.h"

@interface SYLiveRoomPlayListVC () <SYVerticalPageViewDelegate>

@property (nonatomic, strong) SYVerticalPageView *listView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) SYLiveRoomVC *liveRoomVC;
@property (nonatomic, strong) SYLiveRoomPlayListViewModel *viewModel;

@end

@implementation SYLiveRoomPlayListVC

- (instancetype)initWithChannelIDList:(NSArray <NSString *>*)channelIDList
                     currentChannelID:(NSString *)currentChannelID
                             password:(NSString *)password
                           categoryID:(NSInteger)categoryID {
    self = [super init];
    if (self) {
        _viewModel = [[SYLiveRoomPlayListViewModel alloc] initWithChannelIDList:channelIDList
                                                               initialChannelID:currentChannelID
                                                                     categoryID:categoryID];
        _currentIndex = -1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.listView];
    [self.viewModel fetchAllLiveRoomWithBlock:^(BOOL success) {
        if (success) {
            [self.listView reloadData];
            [self.listView setCurrentPageIndex:[self.viewModel initialIndex]
                                      animated:NO];
        }
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (SYVerticalPageView *)listView {
    if (!_listView) {
        _listView = [[SYVerticalPageView alloc] initWithFrame:self.view.bounds];
        [_listView registerClass:[SYLiveRoomPlayListCell class]];
        _listView.delegate = self;
    }
    return _listView;
}

#pragma mark - add or remove liveroomvc

- (void)removeLiveRoomVC {
    if (self.liveRoomVC) {
        [self.liveRoomVC.view removeFromSuperview];
        [self.liveRoomVC removeFromParentViewController];
    }
}

- (void)addLiveRoomVCWithIndex:(NSInteger)index
                       pageVew:(UIView *)pageView {
    [self removeLiveRoomVC];
    NSString *channelID = [self.viewModel channelIDAtIndex:index];
    self.liveRoomVC = [[SYLiveRoomVC alloc] initWithChannelID:channelID
                                                        title:@""
                                                     password:@""];
    self.liveRoomVC.delegate = self.delegate;
    [self addChildViewController:self.liveRoomVC];
    [pageView addSubview:self.liveRoomVC.view];
    [self.liveRoomVC didMoveToParentViewController:self];
}

#pragma mark - delegate

// 有多少页
- (NSUInteger) numberOfPagesInPageView: (SYVerticalPageView*) view {
    return [self.viewModel channelCount];
}

// 将要显示和隐藏
- (void) verticalPageView: (SYVerticalPageView*) view willDisplayPage: (UIView*) page atIndex: (NSInteger) index {
    
}
- (void) verticalPageView: (SYVerticalPageView*) view didDisplayPage: (UIView*) page atIndex: (NSInteger) index {
    if (self.currentIndex != index) {
        self.currentIndex = index;
        [self addLiveRoomVCWithIndex:index
                             pageVew:page];
    }
}
// 将要隐藏和隐藏
- (void) verticalPageView: (SYVerticalPageView*) view willEndDisplayPage: (UIView*) page atIndex: (NSInteger) index {
    
}
- (void) verticalPageView: (SYVerticalPageView*)view didEndDisplayPage: (UIView*) page atIndex:(NSInteger)index {
    
}
// 创建 Page
- (UIView*) verticalPageView: (SYVerticalPageView*) view pageAtIndex: (NSInteger) index {
    SYLiveRoomPlayListCell *cell = (SYLiveRoomPlayListCell *)[view dequeueReusablePage];
    if (!cell) {
        cell = [[SYLiveRoomPlayListCell alloc] initWithFrame:view.bounds];
    }
    NSString *url = [self.viewModel channelCoverImageURLAtIndex:index];
    [cell showWithRoomCoverURL:url];
    return cell;
}

// 开始拖动
- (void) verticalPageViewWillBeginDragging: (SYVerticalPageView*) view {
    
}
// 结束拖动
- (void) verticalPageViewDidEndDragging: (SYVerticalPageView*) view {
    
}

@end
