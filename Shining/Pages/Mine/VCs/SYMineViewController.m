//
//  SYMineViewController.m
//  Shining
//
//  Created by 杨玄 on 2019/3/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineViewController.h"
#import "SYMineHeaderView.h"
#import "SYMineViewModel.h"
#import "SYMineListCell.h"
#import "SYMineShareFriendVC.h"
#import "SYMineSettingVC.h"
#import "SYMineModifyPersonInfoVC.h"
#import "SYUserServiceAPI.h"
#import "UserProfileManager.h"
#import "SYMyWalletViewController.h"
//#import "SYStartRecorderViewController.h"
#import "SYPersonHomepageVC.h"
#import "SYPersonHomepageEditVC.h"
#import "SYVoiceRoomPropVC.h"
#import "SYMineLevelVC.h"
#import "SYMineAttentionFansControl.h"
#import "SYContactViewController.h"
#import "ShiningSdkManager.h"
#import "SYDayTaskViewController.h"
#import "SYCommonStatusManager.h"
#import "SYMineClickAvatarTipView.h"

#define SYMineListCellID @"SYMineListCellID"

@interface SYMineViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SYMineHeaderViewDelegate>

@property (nonatomic, strong) UIButton *backBtn;            // 返回上一层

@property (nonatomic, strong) SYMineHeaderView *headerView; // 头像
@property (nonatomic, strong) UIView *spaceView;            // 间隔view
@property (nonatomic, strong) UICollectionView *listView;   // 列表
@property (nonatomic, strong) SYMineAttentionFansControl *attentionFansView;    // 关注+粉丝view
@property (nonatomic, strong) SYMineViewModel *viewModel;   // ViewModel

@property (nonatomic, strong) SYMineClickAvatarTipView *clickAvatarTip; // “点击头像可进入个人主页哦”

@property (nonatomic, assign) NSInteger userLevel;
@property (nonatomic, assign) BOOL isHadUnreadTask;

@end

@implementation SYMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sy_configDataInfoPageName:SYPageNameType_Mine];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.spaceView];
    [self.view addSubview:self.listView];
    [self.view addSubview:self.attentionFansView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(iPhoneX ? 180+24 : 180);
    }];
    [self.spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.spaceView.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
#ifdef ShiningSdk
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 28));
        make.left.equalTo(self.view).with.offset(7);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 24+28 : 28);
    }];
#endif
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:KNOTIFICATION_USERINFOREADY
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#ifdef ShiningSdk
    [self.navigationController setNavigationBarHidden:YES animated:YES];
#else
    [self.navigationController setNavigationBarHidden:YES];
#endif
    [self sy_setStatusBarDard];
    [self refreshSYMineHeaderView];
    if ([SYSettingManager showClickAvatarTip] && [SYSettingManager userHasLogin]) {
        [self.view addSubview:self.clickAvatarTip];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    if ([SYSettingManager userHasLogin]) {
        [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
            if (success) {
                [weakSelf refreshSYMineHeaderView];
            }
        }];
        
        [[SYCommonStatusManager sharedInstance]checkDayTaskUnReceived:^(BOOL isUnReceived) {
            weakSelf.isHadUnreadTask = isUnReceived;
            [weakSelf.listView reloadData];
        }];
        
    }else{
        self.isHadUnreadTask = NO;
        [self.listView reloadData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_USERINFOREADY object:nil];
}

#pragma mark - Private

- (void)refreshSYMineHeaderView {
    if ([SYSettingManager userHasLogin]) {
        UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
        if (userInfo && userInfo.userid) {
            self.userLevel = userInfo.level;
            [self.headerView updateHeaderViewWithAvatar:userInfo.avatar_imgurl name:userInfo.username idNumber:userInfo.userid  withBroadCasterLevel:userInfo.streamer_level isBroadcaster:userInfo.is_streamer isSuperAdmin:userInfo.is_super_admin bestId:userInfo.bestid];
        } else {
            [self.headerView updateHeaderViewWithAvatar:@"" name:@"-" idNumber:@"-" withBroadCasterLevel:0 isBroadcaster:0 isSuperAdmin:0 bestId:0];
        }
        __weak typeof(self) weakSelf = self;
        [[SYUserServiceAPI sharedInstance] requestUserAttentionAndFansCountWithUserid:userInfo.userid success:^(id  _Nullable response) {
            SYUserAttentionModel *attentionModel = (SYUserAttentionModel *)response;
            [weakSelf.attentionFansView updateControlWithAttentionCount:attentionModel.concern_total withFansCount:attentionModel.fans_total];
        } failure:^(NSError * _Nullable error) {
            [weakSelf.attentionFansView updateControlWithAttentionCount:0 withFansCount:0];
        }];
    } else {
        [self.headerView updateHeaderViewWithAvatar:@"" name:@"未登录" idNumber:@"未知" withBroadCasterLevel:0 isBroadcaster:0 isSuperAdmin:0 bestId:0];
        [self.attentionFansView updateControlWithAttentionCount:0 withFansCount:0];
    }

}

- (void)setUserLevel:(NSInteger)userLevel {
    if (_userLevel == userLevel) {
        return;
    }
    _userLevel = userLevel;
    [self.listView reloadData];
}

- (BOOL)checkUserHasLoginAccount {
    if ([SYSettingManager userHasLogin]) {
        return YES;
    }
    [ShiningSdkManager checkLetvAutoLogin:self];
    return NO;
}

- (void)loginSuccess:(id)sender {
    [self refreshSYMineHeaderView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYMineListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYMineListCellID forIndexPath:indexPath];
    SYMineListCellType type = [self.viewModel cellTypeforIndexPath:indexPath];
    NSString *icon = [self.viewModel leftIconForIndexPath:indexPath];
    NSString *title = [self.viewModel mainTitleForIndexPath:indexPath];
    [cell updateMyneListCellWithType:type withIcon:icon title:title userLevel:self.userLevel];
    if (type == SYMineListCellType_DayTask) {
        [cell showUnreadRedPoint:self.isHadUnreadTask];
    }else{
        [cell showUnreadRedPoint:NO];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BOOL hasLogin = [self checkUserHasLoginAccount];
    if (!hasLogin) {
        return;
    }
    SYMineListCellType type = [self.viewModel cellTypeforIndexPath:indexPath];
    switch (type) {
        case SYMineListCellType_DayTask:{
            SYDayTaskViewController *vc = [SYDayTaskViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYMineListCellType_MyWallet: {
            SYMyWalletViewController *vc = [SYMyWalletViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYMineListCellType_MyDressUpStore: {
            SYVoiceRoomPropVC *vc = [[SYVoiceRoomPropVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYMineListCellType_MyVoice: {
//            SYStartRecorderViewController *vc = [[SYStartRecorderViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYMineListCellType_MyVipLevel: {
            SYMineLevelVC *vc = [SYMineLevelVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYMineListCellType_MyRecommend: {
            SYMineShareFriendVC *vc = [SYMineShareFriendVC new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SYMineListCellType_MySetting: {
//            SYMineSettingVC *vc = [SYMineSettingVC new];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(section == 0 ? 0 : 10, 0, 0, 0);
}

#pragma mark - SYMineHeaderViewDelegate

- (void)clickAvatar {
    BOOL hasLogin = [self checkUserHasLoginAccount];
    if (!hasLogin) {
        return;
    }
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    SYPersonHomepageVC *vc = [SYPersonHomepageVC new];
    vc.userId = userInfo.userid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editPersonalInformation {
    BOOL hasLogin = [self checkUserHasLoginAccount];
    if (hasLogin) {
        if (![SYNetworkReachability isNetworkReachable]) {
            [SYToastView showToast:@"网络异常，请检查网络设置~"];
            return;
        }
        SYPersonHomepageEditVC *vc = [SYPersonHomepageEditVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - LazyLoad

- (SYMineHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[SYMineHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIView *)spaceView {
    if (!_spaceView) {
        _spaceView = [UIView new];
        _spaceView.backgroundColor = [UIColor whiteColor];
    }
    return _spaceView;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(__MainScreen_Width, 52);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        [_listView registerClass:[SYMineListCell class] forCellWithReuseIdentifier:SYMineListCellID];
    }
    return _listView;
}

- (SYMineAttentionFansControl *)attentionFansView {
    if (!_attentionFansView) {
        _attentionFansView = [[SYMineAttentionFansControl alloc] initWithFrame:CGRectMake(20, iPhoneX ? 146+24 : 146, self.view.sy_width - 40, 54)];
        __weak typeof(self) weakSelf = self;
        _attentionFansView.clickBlock = ^(NSString * _Nullable type) {
            BOOL hasLogin = [weakSelf checkUserHasLoginAccount];
            if (hasLogin) {
                SYContactViewController *chatController = [[SYContactViewController alloc] init];
                if ([type isEqualToString:@"我的关注"]) {
                    [chatController setSelectPage:0];
                    [weakSelf.navigationController pushViewController:chatController animated:YES];
                } else if ([type isEqualToString:@"我的粉丝"]) {
                    [chatController setSelectPage:1];
                    [weakSelf.navigationController pushViewController:chatController animated:YES];
                }
            }
        };
        [_attentionFansView updateControlWithAttentionCount:0 withFansCount:0];
    }
    return _attentionFansView;
}

- (SYMineViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYMineViewModel new];
    }
    return _viewModel;
}

- (SYMineClickAvatarTipView *)clickAvatarTip {
    if (!_clickAvatarTip) {
        _clickAvatarTip = [[SYMineClickAvatarTipView alloc] initWithFrame:self.view.bounds];
    }
    return _clickAvatarTip;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack_h"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(handleBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

// 返回
- (void)handleBackBtn {
    [[ShiningSdkManager shareShiningSdkManager] exitShiningAppMainView:^{

    }];
}

@end
