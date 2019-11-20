//
//  SYLeaderBoardView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLeaderBoardView.h"
#import "SYLeaderBoardViewModel.h"
#import "SYLeaderBoardCell.h"
#import "SYSegmentedControl.h"
#import "SYLeaderBoardHeaderView.h"
#import "SYLeaderBoardScrollView.h"

#define kLeaderBoardCollectionViewStartTag 30203

@interface SYLeaderBoardView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SYLeaderBoardViewModel *viewModel;
@property (nonatomic, strong) SYSegmentedControl *segmentControl;
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) SYLeaderBoardScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *listViewArray;

@end

@implementation SYLeaderBoardView

- (instancetype)initWithFrame:(CGRect)frame
                    channelID:(NSString *)channelID
                         type:(SYLeaderBoardViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = 0;
        _listViewArray = [NSMutableArray new];
        _viewModel = [[SYLeaderBoardViewModel alloc] initWithViewChannelID:channelID
                                                                      type:type];
        [self addSubview:self.backView];
        [self addSubview:self.segmentControl];
        [self addSubview:self.scrollView];
        
//        [self addSubview:self.collectionView];
        [self addSubview:self.hintLabel];
        
        for (int i = 0; i < 3; i ++) {
            UICollectionView *colllectionView = [self collectionViewWithIndex:i];
            [self.scrollView addSubview:colllectionView];
            colllectionView.sy_left = self.scrollView.sy_width * i;
            [_listViewArray addObject:colllectionView];
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.sy_width * 3, self.scrollView.sy_height);
        
        [self requestData];
    }
    return self;
}

- (void)requestData {
    SYGiftTimeRange range = SYGiftTimeRangeDaily;
    if (self.segmentControl.selectedSegmentIndex == 1) {
        range = SYGiftTimeRangeWeekly;
    } else if (self.segmentControl.selectedSegmentIndex == 2) {
        range = SYGiftTimeRangeTotal;
    }
    __weak typeof(self) weakSelf = self;
    UICollectionView *collectionView = self.listViewArray[self.segmentControl.selectedSegmentIndex];
    [self.viewModel requestDataListWithTimeRange:range block:^(BOOL success) {
        if (success) {
            [collectionView reloadData];
            weakSelf.hintLabel.hidden = ([weakSelf.viewModel rowCount] > 0);
        } else {
            [SYToastView showToast:@"网络开小差了"];
        }
    }];
}

- (UIImageView *)backView {
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:self.bounds];
        NSString *imageName = (self.viewModel.type == SYLeaderBoardViewTypeOutcome) ? @"voiceroom_board_fan" : @"voiceroom_board_income";
        _backView.image = [UIImage imageNamed_sy:imageName];
    }
    return _backView;
}

- (SYLeaderBoardScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[SYLeaderBoardScrollView alloc] initWithFrame:CGRectMake(0, self.segmentControl.sy_bottom, self.sy_width, self.sy_height - self.segmentControl.sy_bottom)];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (SYSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        CGFloat y = 64.f;
        if (iPhoneX) {
            y += 24.f;
        }
        _segmentControl = [[SYSegmentedControl alloc] initWithFrame:CGRectMake(0, y, self.sy_width, 37.f)
                                                         titleArray:@[@"日榜", @"周榜", @"总榜"]];
        [_segmentControl addTarget:self
                                action:@selector(changeIndex:)
                      forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UICollectionView *)collectionViewWithIndex:(NSInteger)index {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(self.sy_width, 64.f);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.sy_width, self.scrollView.sy_height)
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
    _collectionView.tag = kLeaderBoardCollectionViewStartTag + index;
    return _collectionView;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        CGFloat y = [SYLeaderBoardHeaderView sizeForHeaderWithWidth:self.scrollView.sy_width].height + 10.f + 88.f + 44.f;
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, self.sy_width, 20)];
        if (self.viewModel.type == SYLeaderBoardViewTypeIncome) {
            _hintLabel.textColor = [UIColor sam_colorWithHex:@"#E6E6E6"];
        } else if (self.viewModel.type == SYLeaderBoardViewTypeOutcome) {
            _hintLabel.textColor = [UIColor sam_colorWithHex:@"#999999"];
        }
        _hintLabel.font = [UIFont systemFontOfSize:14.f];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = @"还没有人打赏主播哦~赶紧抢占第一个吧！";
        _hintLabel.hidden = YES;
    }
    return _hintLabel;
}

- (void)changeIndex:(id)sender {
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.sy_width * index, 0)
                             animated:YES];
    [self requestData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX(0, [self.viewModel rowCount] - 3);
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
           needShowVip:(self.viewModel.type == SYLeaderBoardViewTypeOutcome)];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        SYLeaderBoardHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                 withReuseIdentifier:@"header"
                                                                                        forIndexPath:indexPath];
        NSString *imageName = (self.viewModel.type == SYLeaderBoardViewTypeIncome) ? @"voiceroom_podium_income" : @"voiceroom_podium_fan";
        NSString *musicName = (self.viewModel.type == SYLeaderBoardViewTypeIncome) ? @"voiceroom_podium_music_income" : @"voiceroom_podium_music_outcome";
        [headerView setImageName:imageName];
        [headerView setMusicImageName:musicName];
        
        NSInteger count = [self.viewModel rowCount];
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

#pragma mark -

- (SYLeaderBoardUserView *)userViewWithIndex:(NSInteger)index {
    NSInteger count = [self.viewModel rowCount];
    if (index < count) {
        NSString *name = [self.viewModel usernameAtIndex:index];
        NSString *avatar = [self.viewModel avatarAtIndex:index];
        NSString *gender = [self.viewModel genderAtIndex:index];
        NSInteger isBroadcaster = [self.viewModel userIsBroadcasterAtIndex:index];
        NSInteger broadcasterLevel = [self.viewModel userBroadcasterLevelAtIndex:index];
        NSInteger level = [self.viewModel userVipLevelAtIndex:index];
        NSInteger age = [self.viewModel userAgeAtIndex:index];
        NSString *sum = [self.viewModel sumStringAtIndex:index];
        UIColor *color = (self.viewModel.type == SYLeaderBoardViewTypeIncome) ? [UIColor sam_colorWithHex:@"#2294E8"] : [UIColor whiteColor];
        UIColor *sumColor = (self.viewModel.type == SYLeaderBoardViewTypeIncome) ? [UIColor sam_colorWithHex:@"#60BCFF"] : [UIColor sam_colorWithHex:@"#CCCCCC"];
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
    NSString *uid = [self.viewModel userIDAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(leaderBoardViewDidSelectUserWithUid:)]) {
        [self.delegate leaderBoardViewDidSelectUserWithUid:uid];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView == scrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.sy_width;
        self.segmentControl.selectedSegmentIndex = index;
    }
}

@end
