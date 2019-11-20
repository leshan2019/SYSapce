//
//  SYPersonHomepageFansVC.m
//  Shining
//
//  Created by 杨玄 on 2019/9/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageFansVC.h"
#import "SYPersonHomepageVC.h"
#import "SYSegmentedControl.h"
#import "SYPersonHomepageFansViewModel.h"
#import "SYLeaderBoardCell.h"
#import "SYLeaderBoardHeaderView.h"

@interface SYPersonHomepageFansVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *topTitle;
@property (nonatomic, strong) SYSegmentedControl *segmentControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *listViewArray;
@property (nonatomic, strong) SYPersonHomepageFansViewModel *viewModel;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation SYPersonHomepageFansVC

- (void)dealloc {
    NSLog(@"SYPersonHomepageFansVc - dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    self.currentPage = 1;
    [self requestFansContributionListData:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)requestFansContributionListData:(NSInteger)page {
    NSInteger selectIndex = self.segmentControl.selectedSegmentIndex;
    SYGiftTimeRange range = SYGiftTimeRangeDaily;
    if (selectIndex == 1) {
        range = SYGiftTimeRangeWeekly;
    } else if (selectIndex == 2) {
        range = SYGiftTimeRangeTotal;
    }
    UICollectionView *collectionView = self.listViewArray[selectIndex];
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestFansContributionData:range page:page success:^(BOOL success) {
        [collectionView.mj_footer endRefreshing];
        weakSelf.tipLabel.hidden = YES;
        if (success) {
            if (page > 1) {
                weakSelf.currentPage ++;
            } else {
                collectionView.mj_footer.hidden = NO;
                [collectionView.mj_footer resetNoMoreData];
            }
            [collectionView reloadData];
        } else {
            if (page == 1) {
                collectionView.mj_footer.hidden = YES;
                weakSelf.tipLabel.hidden = NO;
            } else {
                [SYToastView showToast:@"暂无更多数据"];
            }
        }
    } failure:^{
        [collectionView.mj_footer endRefreshing];
        if (page == 1) {
            weakSelf.tipLabel.hidden = NO;
        } else {
            [SYToastView showToast:@"网络异常，请重试"];
        }
    }];
}

#pragma mark - Setter

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    self.viewModel.userId = userId;
}

#pragma mark - Private

- (void)initSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgImage];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.topTitle];
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.tipLabel];
    self.listViewArray = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        UICollectionView *colllectionView = [self collectionViewWithIndex:i];
        [self.scrollView addSubview:colllectionView];
        colllectionView.sy_left = self.scrollView.sy_width * i;
        [self.listViewArray addObject:colllectionView];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.sy_width * 3, self.scrollView.sy_height);;
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(6);
        make.top.equalTo(self.view).with.offset(iPhoneX ? (24+20) : 20);
        make.size.mas_equalTo(CGSizeMake(36, 44));
    }];

    [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.backBtn);
        make.size.mas_equalTo(CGSizeMake(243, 30));
    }];
}

- (UICollectionView *)collectionViewWithIndex:(NSInteger)index {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.sy_width, 64.f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.sy_width, self.scrollView.sy_height - (iPhoneX ? 34 : 0))
                                                           collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = YES;
    [_collectionView registerClass:[SYLeaderBoardCell class]
        forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[SYLeaderBoardHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"header"];
    __weak typeof(self) weakSelf = self;
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        [weakSelf requestFansContributionListData:(weakSelf.currentPage + 1)];
    }];
    [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开手试试" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    _collectionView.mj_footer = footer;
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.viewModel.numberOfItems > 3) {
        return self.viewModel.numberOfItems - 3;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYLeaderBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                        forIndexPath:indexPath];
    NSInteger index = indexPath.item + 3;
    [cell showWithName:[self.viewModel usernameAtIndex:index]
                avatar:[self.viewModel avatarAtIndex:index]
             avatarBox:[self.viewModel avatarBoxAtIndex:index]
                   vip:[self.viewModel userVipLevelAtIndex:index]
         isBroadcaster:[self.viewModel userIsBroadcasterAtIndex:index]
      broadcasterLevel:[self.viewModel userBroadcasterLevelAtIndex:index]
                gender:[self.viewModel genderAtIndex:index]
                   age:[self.viewModel userAgeAtIndex:index]
                   sum:[self.viewModel sumStringAtIndex:index]
                 index:(index + 1)
           needShowVip:YES];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        SYLeaderBoardHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                 withReuseIdentifier:@"header"
                                                                                        forIndexPath:indexPath];
        NSString *imageName = @"voiceroom_podium_fan";
        NSString *musicName = @"voiceroom_podium_music_outcome";
        [headerView setImageName:imageName];
        [headerView setMusicImageName:musicName];

        NSInteger count = [self.viewModel numberOfItems];
        NSMutableArray *array = [NSMutableArray new];
        if (count > 0) {
            SYLeaderBoardUserView *view = [self userViewWithIndex:0];
            if (view) {
                [array addObject:view];
            }
        }
        if (count > 1) {
            SYLeaderBoardUserView *view = [self userViewWithIndex:1];
            if (view) {
                [array addObject:view];
            }
        }
        if (count > 2) {
            SYLeaderBoardUserView *view = [self userViewWithIndex:2];
            if (view) {
                [array addObject:view];
            }
        }
        [headerView setUserViews:array];

        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return [SYLeaderBoardHeaderView sizeForHeaderWithWidth:collectionView.sy_width];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item + 3;
    [self selectUserAtIndex:index];
}

#pragma mark - header

- (SYLeaderBoardUserView *)userViewWithIndex:(NSInteger)index {
    NSInteger count = [self.viewModel numberOfItems];
    if (index < count) {
        NSString *name = [self.viewModel usernameAtIndex:index];
        NSString *avatar = [self.viewModel avatarAtIndex:index];
        NSString *gender = [self.viewModel genderAtIndex:index];
        NSInteger isBroadcaster = [self.viewModel userIsBroadcasterAtIndex:index];
        NSInteger broadcasterLevel = [self.viewModel userBroadcasterLevelAtIndex:index];
        NSInteger level = [self.viewModel userVipLevelAtIndex:index];
        NSInteger age = [self.viewModel userAgeAtIndex:index];
        NSString *sum = [self.viewModel sumStringAtIndex:index];
        UIColor *color = [UIColor whiteColor];
        UIColor *sumColor = [UIColor sam_colorWithHex:@"#CCCCCC"];
        if (index == 0) {
            CGFloat width = 95.f + 40.f;
            CGFloat height = 98.f + 52.f;
            CGFloat top = [SYLeaderBoardHeaderView firstUserTopWithWidth:self.scrollView.sy_width] - 72.f;
            CGFloat x = (self.scrollView.sy_width - width) / 2.f;
            SYLeaderBoardUserView *view = [[SYLeaderBoardUserView alloc] initWithFrame:CGRectMake(x, top, width, height)];
            [view showWithRank:1
                          name:name
                        avatar:avatar
                 isBroadcaster:isBroadcaster
              broadcasterLevel:broadcasterLevel
                           vip:level
                        gender:gender
                           age:age
                           sum:sum];
            [view setAvatarSize:CGSizeMake(74.f, 74.f) left:4.f bottom:4.f];
            [view setNameColor:color
                      sumColor:sumColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(selectUserAtFirst:)];
            [view addGestureRecognizer:tap];
            return view;
        } else if (index == 1) {
            CGFloat width = 64.f + 40.f;
            CGFloat height = 80.f + 52.f;
            CGFloat top = [SYLeaderBoardHeaderView secondUserTopWithWidth:self.scrollView.sy_width] - 85.f;
            CGFloat x = 0.f;
            SYLeaderBoardUserView *view = [[SYLeaderBoardUserView alloc] initWithFrame:CGRectMake(x, top, width, height)];
            [view showWithRank:2
                          name:name
                        avatar:avatar
                 isBroadcaster:isBroadcaster
              broadcasterLevel:broadcasterLevel
                           vip:level
                        gender:gender
                           age:age
                           sum:sum];
            [view setAvatarSize:CGSizeMake(58.f, 58.f) left:3.5 bottom:3];
            [view setNameColor:color
                      sumColor:sumColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(selectUserAtSecond:)];
            [view addGestureRecognizer:tap];
            return view;
        } else if (index == 2) {
            CGFloat width = 70.f + 40.f;
            CGFloat height = 78.f + 52.f;
            CGFloat top = [SYLeaderBoardHeaderView thirdUserTopWithWidth:self.scrollView.sy_width] - 82.f;
            SYLeaderBoardUserView *view = [[SYLeaderBoardUserView alloc] initWithFrame:CGRectMake(self.scrollView.sy_width - width, top, width, height)];
            [view showWithRank:3
                          name:name
                        avatar:avatar
                 isBroadcaster:isBroadcaster
              broadcasterLevel:broadcasterLevel
                           vip:level
                        gender:gender
                           age:age
                           sum:sum];
            [view setAvatarSize:CGSizeMake(58.f, 58.f) left:2.5 bottom:3];
            [view setNameColor:color
                      sumColor:sumColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(selectUserAtThird:)];
            [view addGestureRecognizer:tap];
            return view;
        }
    }
    return nil;
}

#pragma mark - Click

// 前三名点击头像框
- (void)selectUserAtFirst:(id)sender {
    [self selectUserAtIndex:0];
}

- (void)selectUserAtSecond:(id)sender {
    [self selectUserAtIndex:1];
}

- (void)selectUserAtThird:(id)sender {
    [self selectUserAtIndex:2];
}

- (void)selectUserAtIndex:(NSInteger)index {
    NSString *userId = [self.viewModel userIDAtIndex:index];
    SYPersonHomepageVC *vc = [SYPersonHomepageVC new];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

// 返回按钮
- (void)handleGoBackBtnClickEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

// 切换榜单
- (void)changeIndex:(id)sender {
    self.currentPage = 1;
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.sy_width * index, 0)
                             animated:YES];
    [self requestFansContributionListData:1];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView == scrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.sy_width;
        self.segmentControl.selectedSegmentIndex = index;
    }
}

#pragma mark - lazyLoad

- (SYPersonHomepageFansViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYPersonHomepageFansViewModel new];
    }
    return _viewModel;
}

- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _bgImage.image = [UIImage imageNamed_sy:@"voiceroom_board_fan"];
    }
    return _bgImage;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn addTarget:self action:@selector(handleGoBackBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed_sy:@"homepage_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)topTitle {
    if (!_topTitle) {
        _topTitle = [UIButton new];
        [_topTitle setTitle:@"粉丝贡献榜" forState:UIControlStateNormal];
        [_topTitle setTitleColor:RGBACOLOR(113,56,239,1) forState:UIControlStateNormal];
        _topTitle.backgroundColor = [UIColor whiteColor];
        _topTitle.layer.cornerRadius = 15;
        _topTitle.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _topTitle;
}

- (SYSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        CGFloat y = 64.f;
        if (iPhoneX) {
            y += 24.f;
        }
        _segmentControl = [[SYSegmentedControl alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, 37.f)
                                                         titleArray:@[@"日榜", @"周榜", @"总榜"]];
        [_segmentControl addTarget:self
                            action:@selector(changeIndex:)
                  forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.segmentControl.sy_bottom, self.view.sy_width, self.view.sy_height - self.segmentControl.sy_bottom)];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        CGFloat y = [SYLeaderBoardHeaderView sizeForHeaderWithWidth:self.scrollView.sy_width].height + 10.f + 88.f + 44.f;
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, 20)];
        _tipLabel.textColor = [UIColor sam_colorWithHex:@"#999999"];
        _tipLabel.font = [UIFont systemFontOfSize:14.f];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"还没有人打赏主播哦~赶紧抢占第一个吧！";
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}

@end
