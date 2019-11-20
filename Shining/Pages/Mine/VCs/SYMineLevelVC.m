//
//  SYMineLevelVC.m
//  Shining
//
//  Created by 杨玄 on 2019/6/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMineLevelVC.h"
#import "SYMineLevelUserInfoView.h"
#import "SYMineVipPrivilegeCell.h"
#import "SYUserServiceAPI.h"
#import "SYVipPrivilegeModel.h"
#import "SYVipLevelModel.h"

#define SYMineVipPrivilegeCellId @"SYMineVipPrivilegeCellId"

@interface SYMineLevelVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton *backBtn;                // 返回btn

@property (nonatomic, strong) UIScrollView *scrollView;         // 滚动view
@property (nonatomic, strong) UIView *scrollContainerView;      // Scroll上的view

@property (nonatomic, strong) UILabel *titleLabel;              // "我的等级"
@property (nonatomic, strong) UIImageView *grayImageBg;         // 灰色背景墙
@property (nonatomic, strong) SYMineLevelUserInfoView *userInfoView;    // 用户信息
@property (nonatomic, strong) UIImageView *circleImage;         // 圆形image
@property (nonatomic, strong) UILabel *vipPrivilegeLabel;       // "VIP特权"
@property (nonatomic, strong) UICollectionView *listView;       // listView
@property (nonatomic, strong) UILabel *bottomTipLabel;          // "- 后续特权敬请期待 -"

@property (nonatomic, strong) NSArray *vipPrivilegeDataArray;   // VIP特权array
@property (nonatomic, strong) NSArray *vipLevelDataArray;       // VIP等级array

@end

@implementation SYMineLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];

    [self.userInfoView updateUserInfoWithName:userInfo.username avatarUrl:userInfo.avatar_imgurl currentLevel:userInfo.level nextLevel:userInfo.level+1 consumeHoney:userInfo.level_point currentLevelMinCoin:userInfo.level_point currentLevelMaxCoin:userInfo.level_point];

    // 请求VIP特权列表
    __weak typeof(self) weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestVipPrivilegeWithSuccess:^(id  _Nullable response) {
        SYVipPrivilegeListModel *listModel = (SYVipPrivilegeListModel *)response;
        weakSelf.vipPrivilegeDataArray = [listModel.list mutableCopy];
    } failure:^(NSError * _Nullable error) {
        weakSelf.vipPrivilegeDataArray = @[];
    }];

    // 请求VipLevel列表 - 不展示
    [[SYUserServiceAPI sharedInstance] requestVipLevelWithSuccess:^(id  _Nullable response) {
        SYVipLevelListModel *listModel = (SYVipLevelListModel *)response;
        weakSelf.vipLevelDataArray = [listModel.list mutableCopy];
    } failure:^(NSError * _Nullable error) {
        weakSelf.vipLevelDataArray = @[];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat sizeY = CGRectGetMaxY(self.bottomTipLabel.frame) + (iPhoneX ? 80 + 34 : 80);
    self.scrollView.contentSize = CGSizeMake(0, sizeY);
    [self.scrollContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(sizeY);
    }];
}

- (void)setVipPrivilegeDataArray:(NSArray *)vipPrivilegeDataArray {
    _vipPrivilegeDataArray = vipPrivilegeDataArray;
    NSInteger numOfData = vipPrivilegeDataArray.count;
    CGFloat itemHeight = self.view.sy_width/3;
    CGFloat lineCount = numOfData / 3.0;
    CGFloat listHeight = ceil(lineCount) * itemHeight;
    [self.listView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(listHeight);
    }];
    [self.listView reloadData];
}

- (void)setVipLevelDataArray:(NSArray *)vipLevelDataArray {
    _vipLevelDataArray = vipLevelDataArray;
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    NSInteger currentLevel = userInfo.level;
    NSInteger nextLevel = currentLevel + 1;
    NSInteger currentCost = userInfo.level_point;
    NSInteger minCoin = currentCost;
    NSInteger maxCoin = currentCost;
    if (vipLevelDataArray.count > 0) {
        for (int i = 0; i < vipLevelDataArray.count; i++) {
            SYVipLevelModel *model = [vipLevelDataArray objectAtIndex:i];
            if ((model.id - 1) == currentLevel) {
                minCoin = model.min_coin_cost;
                maxCoin = model.max_coin_cost;
                if (i == vipLevelDataArray.count - 1) {
                    nextLevel = 0;      // 到达最高等级了,直接改成0
                }
                break;
            }
        }
    }
    [self.userInfoView updateUserInfoWithName:userInfo.username avatarUrl:userInfo.avatar_imgurl currentLevel:currentLevel nextLevel:nextLevel consumeHoney:currentCost currentLevelMinCoin:minCoin currentLevelMaxCoin:maxCoin];
}

#pragma mark - PrivateMethod

- (void)initSubviews {
    // 滚动控件
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContainerView];
    [self.scrollContainerView addSubview:self.grayImageBg];
    [self.scrollContainerView addSubview:self.userInfoView];
    [self.scrollContainerView addSubview:self.circleImage];
    [self.scrollContainerView addSubview:self.vipPrivilegeLabel];
    [self.scrollContainerView addSubview:self.listView];
    [self.scrollContainerView addSubview:self.bottomTipLabel];

    // constraints
    [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.mas_equalTo(self.view.sy_width);
        make.height.mas_equalTo(1000);
    }];
    [self.grayImageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.scrollContainerView);
        make.right.equalTo(self.scrollContainerView);
        make.height.mas_equalTo(self.view.sy_width * 362 / 375);
    }];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollContainerView);
        make.size.mas_equalTo(CGSizeMake(304, 196));
        make.top.equalTo(self.scrollContainerView).with.offset(iPhoneX ? 105+24 : 105);
    }];
    [self.circleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.right.equalTo(self.scrollContainerView);
        make.top.equalTo(self.userInfoView).with.offset(132);
        make.height.mas_equalTo(196);
    }];
    [self.vipPrivilegeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 24));
        make.top.equalTo(self.userInfoView).with.offset(186);
        make.centerX.equalTo(self.scrollContainerView);
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.right.equalTo(self.scrollContainerView);
        make.top.equalTo(self.vipPrivilegeLabel.mas_bottom).with.offset(8);
        make.height.mas_equalTo(0);
    }];
    [self.bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.right.equalTo(self.scrollContainerView);
        make.top.equalTo(self.listView.mas_bottom).with.offset(50);
        make.height.mas_equalTo(20);
    }];
    // 返回
    [self.view addSubview:self.backBtn];
    [self.scrollContainerView addSubview:self.titleLabel];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 44));
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 44 : 20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 22));
        make.top.equalTo(self.scrollContainerView).with.offset(iPhoneX ? 31+24 : 31);
        make.centerX.equalTo(self.scrollContainerView);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.vipPrivilegeDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYMineVipPrivilegeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYMineVipPrivilegeCellId forIndexPath:indexPath];
    SYVipPrivilegeModel *model = [self.vipPrivilegeDataArray objectAtIndex:indexPath.item];
    NSString *subTitle = [NSString stringWithFormat:@"VIP%ld点亮",model.vip_level];
    [cell updateVipPrivilegeCellWithIcon:model.icon title:model.descp subTitle:subTitle];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.sy_width / 3;
    return CGSizeMake(width, width);
}

#pragma mark - LazyLoad

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)scrollContainerView {
    if (!_scrollContainerView) {
        _scrollContainerView = [UIView new];
        _scrollContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollContainerView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"voiceroom_back"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(handleBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

// 返回
- (void)handleBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"我的等级";
    }
    return _titleLabel;
}

- (UIImageView *)grayImageBg {
    if (!_grayImageBg) {
        _grayImageBg = [UIImageView new];
        _grayImageBg.image = [UIImage imageNamed_sy:@"mine_level_gray_bg"];
        _grayImageBg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _grayImageBg;
}

- (SYMineLevelUserInfoView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[SYMineLevelUserInfoView alloc] initWithFrame:CGRectZero];
    }
    return _userInfoView;
}

- (UIImageView *)circleImage {
    if (!_circleImage) {
        _circleImage = [UIImageView new];
        _circleImage.image = [UIImage imageNamed_sy:@"mine_level_circle"];
    }
    return _circleImage;
}

- (UILabel *)vipPrivilegeLabel {
    if (!_vipPrivilegeLabel) {
        _vipPrivilegeLabel = [UILabel new];
        _vipPrivilegeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _vipPrivilegeLabel.textColor = RGBACOLOR(52,54,66,1);
        _vipPrivilegeLabel.textAlignment = NSTextAlignmentCenter;
        _vipPrivilegeLabel.text = @"VIP特权";
    }
    return _vipPrivilegeLabel;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = [UIColor whiteColor];
        _listView.scrollEnabled = NO;
        [_listView registerClass:[SYMineVipPrivilegeCell class] forCellWithReuseIdentifier:SYMineVipPrivilegeCellId];
    }
    return _listView;
}

- (UILabel *)bottomTipLabel {
    if (!_bottomTipLabel) {
        _bottomTipLabel = [UILabel new];
        _bottomTipLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _bottomTipLabel.textColor = RGBACOLOR(68,68,68,1);
        _bottomTipLabel.textAlignment = NSTextAlignmentCenter;
//        _bottomTipLabel.text = @"- 后续特权敬请期待 -";
        _bottomTipLabel.text = @"";
    }
    return _bottomTipLabel;
}

@end
