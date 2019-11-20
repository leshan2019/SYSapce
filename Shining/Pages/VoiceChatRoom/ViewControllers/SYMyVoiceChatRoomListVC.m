//
//  SYMyVoiceChatRoomListVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMyVoiceChatRoomListVC.h"
#import "SYMyVoiceRoomListViewModel.h"
#import "SYMyVoiceRoomListViewCell.h"
#import "SYVoiceChatRoomVC.h"
#import "SYCreateVoiceRoomVC.h"
#import "SYVoiceChatRoomManager.h"
#import "SYCreateLivingRoomVC.h"
#import "SYChildProtectManager.h"
#import "SYLiveRoomVC.h"

@interface SYMyVoiceChatRoomListVC () <UICollectionViewDelegate, UICollectionViewDataSource, SYNoNetworkViewDelegate>

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SYMyVoiceRoomListViewModel *viewModel;

@property (nonatomic, strong) SYNoNetworkView *noNetworkView;
@property (nonatomic, strong) SYDataEmptyView *emptyDataView;

@property (nonatomic, assign) BOOL showRefreshHeader;
@property (nonatomic, assign) BOOL showRefreshFooter;
@end

@implementation SYMyVoiceChatRoomListVC

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self sy_configDataInfoPageName:SYPageNameType_MyRoomList];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    
    self.viewModel = [[SYMyVoiceRoomListViewModel alloc] init];
    self.currentPage = 1;
    self.title = @"我的房间";
    self.showRefreshHeader = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarDard];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.currentPage = 1;
    [self requestMyRoomList];
    
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestUserRightWithBlock:^(BOOL success) {
        if (success && [weakSelf.viewModel canCreateChannel]) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 50, 44);
            [button setTitle:@"创建房间" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(createRoom:)
             forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.rightBarButtonItem = item;
        } else {
            self.tabBarController.navigationItem.rightBarButtonItem = nil;
        }
    }];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 36, 44);
    [back setImage:[UIImage imageNamed_sy:@"voiceroom_back"]
          forState:UIControlStateNormal];
    [back addTarget:self
             action:@selector(back:)
     forControlEvents:UIControlEventTouchUpInside];
    back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    back.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)requestMyRoomList {
    [self.viewModel requestRoomListWithPage:self.currentPage
                                      block:^(BOOL success, BOOL emptyData) {
                                          if (success) {
                                              self.collectionView.hidden = NO;
                                              if (emptyData) {
                                                  [self addEmptyDataView];
                                              } else {
                                                  [self removeEmptyDataView];
                                                  self.showRefreshFooter = ![self.viewModel isLastPage];
                                                  [self tableViewDidFinishTriggerHeader:(self.currentPage==1) reload:YES];
                                              }
                                          } else {
                                              [self removeEmptyDataView];
                                              if (![SYNetworkReachability isNetworkReachable]) {
                                                  [self addNoNetworkView];
                                                  self.collectionView.hidden = YES;
                                              }
                                          }
                                      }];
}

- (void)requestMoreListData {
    if([self.viewModel isLastPage]){
        [self.collectionView.mj_footer endRefreshing];
        return;
    }
    self.currentPage++;
    [self requestMyRoomList];
}
#pragma mark -

- (void)addNoNetworkView {
    [self removeNoNetworkView];
    
    self.noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:self.view.bounds
                                                                  withDelegate:self];
    [self.view addSubview:self.noNetworkView];
}

- (void)removeNoNetworkView {
    if (self.noNetworkView) {
        [self.noNetworkView removeFromSuperview];
    }
    self.noNetworkView = nil;
}

- (void)SYNoNetworkViewClickRefreshBtn {
    [self removeNoNetworkView];
    
    self.currentPage = 1;
    [self requestMyRoomList];
}

- (void)addEmptyDataView {
    [self removeEmptyDataView];
    self.emptyDataView = [[SYDataEmptyView alloc] initWithFrame:self.view.bounds
                                                   withTipImage:@""
                                                     withTipStr:@"当前暂无房间哦～"];
    [self.view addSubview:self.emptyDataView];
}

- (void)removeEmptyDataView {
    if (self.emptyDataView) {
        [self.emptyDataView removeFromSuperview];
    }
    self.emptyDataView = nil;
}

#pragma mark -

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createRoom:(id)sender {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络连接中断，请检查网络"];
        return;
    }
    __block NSArray *createArr;
    [self.viewModel requestUserCreateRoomTypesWithBlock:^(BOOL living, BOOL voice) {
        if (living && voice) {
            createArr = @[@"直播间",@"聊天室"];
            [self showCreateOptionView:createArr];
        } else {
            if (living) {
                createArr = @[@"直播间"];
                [self enterCreateLivingRoomVC];
            } else if (voice) {
                createArr = @[@"聊天室"];
                [self enterCreateVoiceRoomVC];
            } else {
                [SYToastView showToast:@"创建房间异常，请稍后重试"];
            }
        }
    }];
}

- (void)showCreateOptionView:(NSArray *)options {
    __weak typeof(self) weakSelf = self;
    SYCustomActionSheet *sheet = [[SYCustomActionSheet alloc] initWithActions:options
                                                                  cancelTitle:@"取消"
                                                                  selectBlock:^(NSInteger index) {
                                                                      NSString *createType = [options objectAtIndex:index];
                                                                      if ([createType isEqualToString:@"直播间"]) {
                                                                          [weakSelf enterCreateLivingRoomVC];
                                                                      } else if ([createType isEqualToString:@"聊天室"]) {
                                                                          [weakSelf enterCreateVoiceRoomVC];
                                                                      }
                                                                  } cancelBlock:^{
                                                                      
                                                                  }];
    [sheet show];
}

// 进入创建聊天室vc
- (void)enterCreateVoiceRoomVC {
    SYCreateVoiceRoomVC *vc = [[SYCreateVoiceRoomVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 进入创建直播间vc
- (void)enterCreateLivingRoomVC {
    SYCreateLivingRoomVC *vc = [[SYCreateLivingRoomVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(self.view.sy_width, 128);
        CGFloat y = iPhoneX ? 64 + 24 : 63;
        CGRect frame = CGRectMake(0, y, self.view.sy_width, self.view.sy_height - y);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[SYMyVoiceRoomListViewCell class]
            forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel roomListCount];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYMyVoiceRoomListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell showCellWithRoomName:[self.viewModel roomNameAtIndex:indexPath.item]
                      roomIcon:[self.viewModel roomIconAtIndex:indexPath.item]
                       userNum:[self.viewModel roomUserNumAtIndex:indexPath.item]
                          role:[self.viewModel myRoomRoleAtIndex:indexPath.item]
                        isOpen:[self.viewModel isRoomOpenAtIndex:indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络连接中断，请检查网络"];
        return;
    }
    
    NSString *channelID = [self.viewModel roomIdAtIndex:indexPath.item];
    NSInteger categoryID = [self.viewModel roomCategoryIdAtIndex:indexPath.item];
    
    NSArray *whiteList = [SYSettingManager roomCategoryIdWhiteList];
    NSString *categoryStr = [NSString stringWithFormat:@"%ld", categoryID];
//    if (![whiteList containsObject:categoryStr]) {
//        if ([[SYChildProtectManager sharedInstance] needChildProtectWithNavigationController:self.navigationController]) {
//            return;
//        }
//    }
    
    [SYVoiceChatRoomManager sharedManager].fromTag = SYVoiceChatRoomFromTagList;
    if (![channelID isEqualToString:[SYVoiceChatRoomManager sharedManager].channelID]) {
        NSString *title = [self.viewModel roomNameAtIndex:indexPath.item];
        NSInteger type = [self.viewModel roomTypeAtIndex:indexPath.item];
        if (type == 2) {
            SYLiveRoomVC *vc = [[SYLiveRoomVC alloc] initWithChannelID:channelID
                                                                 title:title];
            [[SYVoiceChatRoomManager sharedManager] presentLiveRoom:vc];
        } else {
            SYVoiceChatRoomVC *vc = [[SYVoiceChatRoomVC alloc] initWithChannelID:channelID
                                                                           title:title];
            [[SYVoiceChatRoomManager sharedManager] presentVoiceChatRoom:vc];
        }
    } else {
        [[SYVoiceChatRoomManager sharedManager] presentCurrentVoiceChatRoom];
    }
}


- (void)setShowRefreshHeader:(BOOL)showRefreshHeader {
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            __weak typeof(self) weakSelf = self;
            self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                weakSelf.currentPage =1;
                [weakSelf requestMyRoomList];
            }];
            self.collectionView.mj_header.accessibilityIdentifier = @"myroom_refresh_header";
        }
        else{
            [self.collectionView setMj_header:nil];
        }
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter {
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            __weak typeof(self) weakSelf = self;
            self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                [weakSelf  requestMoreListData];
            }];
            self.collectionView.mj_footer.accessibilityIdentifier = @"myroom_refresh_footer";
        }
        else{
            [self.collectionView setMj_footer:nil];
        }
    }
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.collectionView reloadData];
        }
        
        if (isHeader) {
            [weakSelf.collectionView.mj_header endRefreshing];
        }
        else{
            [weakSelf.collectionView.mj_footer endRefreshing];
        }
    });
}

@end
