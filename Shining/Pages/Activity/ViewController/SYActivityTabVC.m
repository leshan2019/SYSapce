//
//  SYActivityTabVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYActivityTabVC.h"
#import "SYCategoryView.h"
#import "SYPersonHomepageDynamicView.h"
#import "SYCreateActivityVC.h"
#import "SYNavigationController.h"
#import "SYDynamicViewProtocol.h"
#import "SYPersonHomepageVC.h"
#import "SYChatViewController.h"
#import "SYUserServiceAPI.h"
#import "ShiningSdkManager.h"
#import <AVKit/AVKit.h>

#define MAX_FONT 22.f

@interface SYActivityTabVC () <SYCategoryViewDelegate,UIScrollViewDelegate,
SYDynamicViewProtocol>

@property (nonatomic, strong) SYCategoryTitleView *tabScrollView;

// UIScrollView
@property (nonatomic, strong) UIScrollView *bgScrollView;

// 广场view
@property (nonatomic, strong) SYPersonHomepageDynamicView *squareDynamicView;

// 关注view
@property (nonatomic, strong) SYPersonHomepageDynamicView *concernDynamicView;

// 发布动态
@property (nonatomic, strong) UIButton *postButton;

// SDK - 新增返回按钮
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, weak) AVPlayerViewController *avPlayer;

@end

@implementation SYActivityTabVC

- (void)dealloc {
    [self removeNotification];
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tabScrollView.titles =  @[@"广场",@"关注"];
    self.tabScrollView.frame = CGRectMake(0, 0, 88+40,44);
    [self.tabScrollView reloadData];
    
    [self.view addSubview:self.bgScrollView];
    
    [self.bgScrollView addSubview:self.squareDynamicView];
    [self.bgScrollView addSubview:self.concernDynamicView];
    
    [self.squareDynamicView requestFirstPageListData];
    [self.concernDynamicView requestFirstPageListData];
    
    [self addNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarDard];
    [self.navigationController setNavigationBarHidden:NO];
    
    UIBarButtonItem *tabItem = [[UIBarButtonItem alloc] initWithCustomView:self.tabScrollView];

#ifdef ShiningSdk
    self.tabBarController.navigationItem.leftBarButtonItems = nil;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.tabBarController.navigationItem.leftBarButtonItems = @[backItem,tabItem];
#else
    self.tabBarController.navigationItem.leftBarButtonItem = tabItem;
#endif
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.postButton];
}

#pragma mark - Private

- (BOOL)checkUserHasLoginAccount {
    if ([SYSettingManager userHasLogin]) {
        return YES;
    }
    [ShiningSdkManager checkLetvAutoLogin:self];
    return NO;
}

#pragma mark - Notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:KNOTIFICATION_USERINFOREADY
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStatusChanged:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshSquareListData)
                                                 name:SYSquareRefreshNotificaion
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reCyclePlay)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 登录成功
- (void)loginSuccess:(id)sender {
    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
    if (_squareDynamicView) {
        [self.squareDynamicView configeUserId:userInfo.userid];
        [self.squareDynamicView requestFirstPageListData];
    }
    if (_concernDynamicView) {
        [self.concernDynamicView configeUserId:userInfo.userid];
        [self.concernDynamicView requestFirstPageListData];
    }
}

// 退出登录
- (void)loginStatusChanged:(id)sender {
    NSNotification *noti = (NSNotification *)sender;
    BOOL login = [noti.object boolValue];
    if (!login) {
        [self.concernDynamicView requestFirstPageListData];
    }
}

- (void)refreshSquareListData {
    if (_squareDynamicView) {
        [self.squareDynamicView requestFirstPageListData];
    }
    if (_concernDynamicView) {
        [self.concernDynamicView requestFirstPageListData];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.bgScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.view.sy_width;
        if (index == 1) {
            // 滑到关注页面的时候，如果没有登录，直接调起登录
            [self checkUserHasLoginAccount];
        }
    }
}

#pragma mark - SYCategoryViewDelegate

- (void)categoryView:(SYCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (index == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 滑到关注页面的时候，如果没有登录，直接调起登录
            [self checkUserHasLoginAccount];
        });
    }
}

#pragma mark - SYDynamimcViewProtocol

// 调起登录
- (void)SYDynamicViewClickLogin {
    [ShiningSdkManager checkLetvAutoLogin:self];
}

// 进入个人主页
- (void)SYDynamicViewClickAvatar:(NSString *)userId {
    SYPersonHomepageVC *vc = [SYPersonHomepageVC new];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

// 进入直播间
- (void)SYDynamicViewClickEnterLivingRoom:(NSString *)roomId {
    [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:roomId from:SYVoiceChatRoomFromTagUserPage];
}

// 打招呼
- (void)SYDynamicViewClickGreet:(UserProfileEntity *)userModel {
    if (userModel) {
        SYChatViewController *chatController = [[SYChatViewController alloc] initWithUserProfileEntity:userModel];
        chatController.title = userModel.username;
        [self.navigationController pushViewController:chatController animated:YES];
    } else {
        [SYToastView showToast:@"网络异常，请稍后重试~"];
    }
}

// 播放视频
- (void)SYDynamicViewClickPlayVideo:(NSString *)videoUrl {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络设置~"];
        return;
    }
    if ([NSString sy_isBlankString:videoUrl]) {
        [SYToastView showToast:@"播放异常，请稍后重试~"];
        return;
    }
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [avPlayerVC.player play];
    avPlayerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    self.avPlayer = avPlayerVC;
    [self presentViewController:avPlayerVC animated:YES completion:nil];
}

- (void)reCyclePlay {
    if (self.avPlayer) {
        [self.avPlayer.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self.avPlayer.player play];
    }
}

#pragma mark - sendDynamic

- (void)post:(id)sender {
    if ([self checkUserHasLoginAccount]) {
        __weak typeof(self) weakSelf = self;
        SYCreateActivityVC *vc = [[SYCreateActivityVC alloc] initCreateActivityVCWithBlock:^{
            [weakSelf refreshSquareListData];
        }];
        SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:vc];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:navi
                                                animated:YES
                                              completion:nil];
    }
}

#pragma mark - Lazyload

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 28)];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed_sy:@"shiningAbBack_h"] forState:UIControlStateHighlighted];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -9, 0, 0);
        [_backBtn addTarget:self action:@selector(handleBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

// 返回
- (void)handleBackBtn {
    [[ShiningSdkManager shareShiningSdkManager] exitShiningAppMainView:^{

    }];
}

- (SYCategoryTitleView *)tabScrollView{
    if (!_tabScrollView) {
        SYCategoryTitleView*tabView = [[SYCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        tabView.cellSpacing = 22;
        tabView.backgroundColor = [UIColor clearColor];
        tabView.delegate = self;
        tabView.contentEdgeInsetLeft= 10;
        tabView.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        tabView.titleSelectedFont = [UIFont systemFontOfSize:MAX_FONT weight:UIFontWeightSemibold];
        tabView.titleSelectedColor = [UIColor sy_colorWithHexString:@"#612AE0"];
        tabView.titleColor = [UIColor sy_colorWithHexString:@"#909090"];
        tabView.titleColorGradientEnabled = YES;
        tabView.titleLabelZoomEnabled = YES;
        tabView.titleLabelAnchorPointStyle = SYCategoryTitleLabelAnchorPointStyleBottom;
        
        SYCategoryIndicatorLineView *lineView = [[SYCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = [UIColor sy_colorWithHexString:@"#612AE0"];
        lineView.indicatorWidth = 12;
        lineView.lineStyle = SYCategoryIndicatorLineStyle_LengthenOffset;
        tabView.indicators = @[lineView];
        tabView.contentScrollView = self.bgScrollView;
        _tabScrollView = tabView;
    }
    return _tabScrollView;
}

- (UIButton *)postButton {
    if (!_postButton) {
        _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _postButton.frame = CGRectMake(0, 0, 70, 44);
        CAGradientLayer *_gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 8, 70, 28);
        _gradientLayer.colors = @[(__bridge id)[UIColor sy_colorWithHexString:@"#8C15FF"].CGColor,(__bridge id)[UIColor sy_colorWithHexString:@"#E763FA"].CGColor];
        _gradientLayer.cornerRadius = 14.f;
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        [_postButton.layer addSublayer:_gradientLayer];
        [_postButton setTitle:@"发动态" forState:UIControlStateNormal];
        [_postButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightSemibold];
        [_postButton addTarget:self
                          action:@selector(post:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _postButton;
}

- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        CGFloat top = iPhoneX ? (64 + 24) : 64;
        CGFloat height = self.view.sy_height - top - (iPhoneX ? 49 + 34 : 49);
        CGRect frame = CGRectMake(0, top, self.view.sy_width, height);
        UIScrollView *scr = [[UIScrollView alloc] initWithFrame:frame];
        scr.delegate = self;
        scr.contentSize = CGSizeMake(self.view.sy_width*2, height);
        scr.showsVerticalScrollIndicator = NO;
        scr.showsHorizontalScrollIndicator = NO;
        scr.pagingEnabled = YES;
        scr.bounces = NO;
        if (@available(iOS 11.0, *)) {
            scr.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _bgScrollView = scr;
    }
    return _bgScrollView;
}

- (SYPersonHomepageDynamicView *)squareDynamicView {
    if (!_squareDynamicView) {
        _squareDynamicView = [[SYPersonHomepageDynamicView alloc] initWithFrame:self.bgScrollView.bounds type:SYDynamicType_Square];
        _squareDynamicView.delegate = self;
        UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
        [_squareDynamicView configeUserId:userInfo.userid];
    }
    return _squareDynamicView;
}

- (SYPersonHomepageDynamicView *)concernDynamicView {
    if (!_concernDynamicView) {
        CGRect frame = CGRectMake(self.squareDynamicView.sy_right, 0, self.bgScrollView.sy_width, self.bgScrollView.sy_height);
        _concernDynamicView = [[SYPersonHomepageDynamicView alloc] initWithFrame:frame type:SYDynamicType_Concern];
        _concernDynamicView.delegate = self;
        __weak typeof(self) weakSelf = self;
        [_concernDynamicView configeJumpToSquareBlock:^{
            [weakSelf.bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [weakSelf.tabScrollView selectItemAtIndex:0];
        }];
        UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
        [_concernDynamicView configeUserId:userInfo.userid];
    }
    return _concernDynamicView;
}

@end
