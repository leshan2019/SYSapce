//
//  SYMineSettingVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/21.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//
/*
#import "SYMineSettingVC.h"
#import "SYMineSettingViewModel.h"
#import "SYMineSettingListCell.h"
#import "SYCommonTopNavigationBar.h"
#import "SYPopUpWindows.h"
#import "SYMineAboutUsVC.h"
#import "SYMineVerifyIDCardVC.h"
#import "EMDemoOptions.h"
#import "UserProfileManager.h"
#import "SYUserServiceAPI.h"
#import "SYReportManager.h"
#import "SYTestingViewController.h"
#import "ShiningSdkManager.h"
//#import "SYIDCardAuthenticationVC.h"
#import "SYAdolescentModelWindow.h"
#import "SYAdolescentModelVC.h"
#import "SYAdolescentModelSuccessVC.h"

#import "SYVideoPushViewController.h"
#import "SYVideoPullViewController.h"
#import "TokenIOTestViewController.h"

#define SYMineSettingListCellID @"SYMineSettingListCellID"
#define SYCleanUpCachTag      111111
#define SYCheckVersionTag     222222
#define SYIdentifyIDCardtag   333333
#define SYLogoutTag           444444

@interface SYMineSettingVC () <UICollectionViewDelegate, UICollectionViewDataSource, SYCommonTopNavigationBarDelegate, SYPopUpWindowsDelegate>
@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UICollectionView *listView;       // listView
@property (nonatomic, strong) SYMineSettingViewModel *viewModel;
@property (nonatomic, strong) SYPopUpWindows *popupWindow;      // 各种弹窗
@property (nonatomic, assign) NSInteger feedBackUnread;//反馈未读消息数
@end

@implementation SYMineSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sy_configDataInfoPageName:SYPageNameType_Setting];
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    self.feedBackUnread = 0;
    [self.view addSubview:self.topNavBar];
    [self.view addSubview:self.listView];
    [self.topNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topNavBar.mas_bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    __weak typeof(self) weakSelf = self;
//    [[SYReportManager sharedInstance].feedbackKit getUnreadCountWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
//        weakSelf.feedBackUnread = unreadCount;
//        [weakSelf.listView reloadData];
//    }];
}

#pragma mark - SYVoiceChatRoomCommonNavBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.viewModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYMineSettingListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SYMineSettingListCellID forIndexPath:indexPath];
    SYMineSettingCellType type = [self.viewModel cellTypeForIndexPath:indexPath];
    NSString *title = [self.viewModel mainTitleForIndexPath:indexPath];
    NSString *subTitle = [self.viewModel subTitleForIndexPath:indexPath];
    BOOL open = [self.viewModel hasOpenNewMessageNotify:indexPath];
    BOOL show = [self.viewModel showBottomLine:indexPath];
    [cell updateSettingListCellWithType:type withTitle:title withSubTitle:subTitle withOpenMessageNotify:open withShowBottomLine:show];
    if (type == SYMineSettingCellType_FeedBack) {
        [cell showUnreadRedPoint:self.feedBackUnread <= 0];
    }else{
        [cell showUnreadRedPoint:YES];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(section > 0 ? 10 : 0, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SYMineSettingCellType type = [self.viewModel cellTypeForIndexPath:indexPath];
    switch (type) {
        case SYMineSettingCellType_CleanUpCache: {
            [self syCleanUpSystemCaches];
        }
            break;
        case SYMineSettingCellType_Version: {
            [self syCheckSystemVersion];
        }
            break;
        case SYMineSettingCellType_IDCard: {
            [self syIdentifyIdCards];
        }
            break;
        case SYMineSettingCellType_AboutMe: {
            [self syEnterAboutUsVC];
        }
            break;
        case SYMineSettingCellType_LoginOut: {
            [self syLoginOut];
        }
            break;
        case SYMineSettingCellType_FeedBack: {
            [self syEnterFeedBackVC];
        }
            break;
#ifdef UseSettingTestDevEnv
        case SYMineSettingCellType_Test: {
            [self syEnterTestVC];
        }
            break;
        case SYMineSettingCellType_TestVideoPush: {
            SYVideoPushViewController* controller = [[SYVideoPushViewController alloc] initWithRoomId: @"10149"];
            [self.navigationController pushViewController: controller animated:YES];
            break;
        }
        case SYMineSettingCellType_TestVideoPull: {
            SYVideoPullViewController* controller = [[SYVideoPullViewController alloc] initWithRoomId: @"10149"];
            [self.navigationController pushViewController: controller animated: YES];
            break;
        }
        case SYMineSettingCellType_TestTokenIO: {
            TokenIOTestViewController* controller = [[TokenIOTestViewController alloc] init];
            [self.navigationController pushViewController: controller animated: YES];
            break;
        }
#endif
        default:
            break;
    }
}

#pragma mark - SYPopUpWindowsDelegate

- (void)handlePopUpWindowsLeftBtnClickEvent {
    if (self.popupWindow && self.popupWindow.superview) {
        if (self.popupWindow.tag == SYCleanUpCachTag || self.popupWindow.tag == SYLogoutTag) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
        }
    }
}

- (void)handlePopUpWindowsRightBtnClickEvent {
    if (self.popupWindow && self.popupWindow.superview) {
        if (self.popupWindow.tag == SYCleanUpCachTag) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                SYMineSettingListCell *cell = (SYMineSettingListCell *)[self.listView cellForItemAtIndexPath:indexPath];
                [cell updateCellSubtitle:@"0.0M"];
                [SYToastView showToast:@"清空完成"];
            }];
        } else if (self.popupWindow.tag == SYLogoutTag) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
            [[UserProfileManager sharedInstance] logOut:^(BOOL isSucess) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
#ifdef ShiningSdk
            [ShiningSdkManager setLetvLoginOut];
#endif
        }
    }
}

- (void)handlePopUpWindowsMidBtnClickEvent {
    if (self.popupWindow && self.popupWindow.superview) {
        if (self.popupWindow.tag == SYCheckVersionTag) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
            // todo: 去下载
            [SYToastView showToast:@"去下载"];
        }
        if (self.popupWindow.tag == SYIdentifyIDCardtag) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
        }
    }
}

#pragma mark - CellClick

// 清空缓存
- (void)syCleanUpSystemCaches {
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
    self.popupWindow.delegate = self;
    self.popupWindow.tag = SYCleanUpCachTag;
    [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Pair withMainTitle:@"清空缓存" withSubTitle:@"需要清空缓存数据吗?" withBtnTexts:@[@"取消",@"确定"] withBtnTextColors:@[RGBACOLOR(102, 102, 102, 1),RGBACOLOR(11, 11, 11, 1)]];
    [window addSubview:self.popupWindow];
    [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

// 版本检测
- (void)syCheckSystemVersion {
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
    self.popupWindow.delegate = self;
    self.popupWindow.tag = SYCheckVersionTag;
    [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Single withMainTitle:@"发现最新版本" withSubTitle:nil withBtnTexts:@[@"去下载"] withBtnTextColors:@[RGBACOLOR(11, 11, 11, 1)]];
    [window addSubview:self.popupWindow];
    [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

// 身份认证
- (void)syIdentifyIdCards {
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    NSInteger authModel = userInfo.auth_model;
    if (authModel == 2) {   // 已认证，不需要再次认证
        [SYToastView showToast:@"已完成身份认证，无需再次认证~"];
        return;
    }
    SYIDCardAuthenticationVC *vc = [SYIDCardAuthenticationVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 调试设置
- (void)syEnterTestVC {
    SYTestingViewController *vc = [SYTestingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 关于我们
- (void)syEnterAboutUsVC {
    SYMineAboutUsVC *vc = [SYMineAboutUsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

// 用户反馈
- (void)syEnterFeedBackVC {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络连接中断，请检查网络"];
        return;
    }
    [[SYReportManager sharedInstance] SYReportVC:self withVisit:@""withReporterId:@""];
}

// 退出登录
- (void)syLoginOut {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络设置~"];
        return;
    }
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
    self.popupWindow.delegate = self;
    self.popupWindow.tag = SYLogoutTag;
    [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Pair withMainTitle:@"确定退出吗" withSubTitle:@"" withBtnTexts:@[@"取消",@"确定"] withBtnTextColors:@[RGBACOLOR(102, 102, 102, 1),RGBACOLOR(11, 11, 11, 1)]];
    [window addSubview:self.popupWindow];
    [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"设置" rightTitle:@"" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UICollectionView *)listView {
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(__MainScreen_Width, 52);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        _listView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        [_listView registerClass:[SYMineSettingListCell class] forCellWithReuseIdentifier:SYMineSettingListCellID];
    }
    return _listView;
}

- (SYMineSettingViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SYMineSettingViewModel alloc] init];
    }
    return _viewModel;
}

@end
 */
