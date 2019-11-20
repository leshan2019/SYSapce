//
//  SYPersonHomepageVC.m
//  Shining
//
//  Created by 杨玄 on 2019/4/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageVC.h"
#import "SYPersonHomepageViewModel.h"
#import "SYPersonHomepagePhotoWall.h"
#import "SYPersonHomepageIntroView.h"
#import "SYPersonHomepageEnterRoomView.h"
#import "SYChatViewController.h"
#import "SYUserServiceAPI.h"
#import "SYPersonHomepageEditVC.h"
#import <AVKit/AVKit.h>
#import "SYVoiceChatRoomManager.h"
#import "SYReportManager.h"
#import "SYPersonHomepageFansView.h"
#import "SYPersonHomepageFansVC.h"
#import "SYGiftNetManager.h"
#import "SYPersonHomepageDynamicInfoView.h"
#import "SYPersonHomepageVoiceCardView.h"
//#import "SYCreateActivityVC.h"
#import "SYNavigationController.h"
#import "SYPersonHomepageDynamicView.h"
#import "SYPersonHomepageVoiceCardVC.h"

// 照片墙 宽高比例
#define SYHomepagePhotoWallHeight 300/375.0f*__MainScreen_Width + (iPhoneX ? 24 : 0)
#define SYHomepageInRoomViewHeight 72
#define SYBlackListTag 11111
#define SYCancelAttentionTag 22222
#define SYDynamicInfoViewTop (iPhoneX ? 64 + 24 : 64)

@interface SYPersonHomepageVC ()<SYPersonHomepagePhotoWallDelegate,SYPopUpWindowsDelegate,
SYPersonHomepageViewModelDelegate, SYNoNetworkViewDelegate, SYDataErrorViewDelegate,
SYDynamicViewProtocol,
UIScrollViewDelegate,
UIGestureRecognizerDelegate,
SYDynamicViewScrollDelegate,
SYPersonHomepageDynamicInfoViewDelegate>

@property (nonatomic, strong) SYPersonHomepageViewModel *viewModel; // ViewModel

// View
@property (nonatomic, strong) UIView *loadingBaseView;                      // 放loading的view
@property (nonatomic, strong) UIScrollView *scrollView;                     // 滚动view
@property (nonatomic, strong) UIView *scrollContainerView;                  // Scroll上的view
@property (nonatomic, strong) SYPersonHomepagePhotoWall *photoWall;         // 照片墙
@property (nonatomic, strong) SYPersonHomepageIntroView *introView;         // 简介
@property (nonatomic, strong) SYPersonHomepageEnterRoomView *enterRoomView; // 当前房间
@property (nonatomic, strong) SYPersonHomepageFansView *fansView;           // 粉丝贡献
@property (nonatomic, strong) SYPersonHomepageVoiceCardView *voiceCardView; // 声音名片
@property (nonatomic, strong) SYPersonHomepageDynamicInfoView *dynamicInfoView;// 动态+资料

// 各种按钮
@property (nonatomic, strong) UIButton *topBackBtn;                 // top返回btn
@property (nonatomic, strong) UILabel *topTitle;                    // "userName"
@property (nonatomic, strong) UIButton *topMoreBtn;                 // top更多btn

@property (nonatomic, strong) UIButton *backBtn;                    // 返回btn
@property (nonatomic, strong) UIButton *moreBtn;                    // 更多btn
@property (nonatomic, strong) UIButton *chatBtn;                    // 聊天btn
@property (nonatomic, strong) UIButton *attentionBtn;               // 关注btn
@property (nonatomic, strong) UIButton *chatLongBtn;                // 聊天longBtn
@property (nonatomic, strong) UIButton *sendDynamicBtn;             // 发送动态btn
@property (nonatomic, strong) UIView *topNavView;                   // topNavView

@property (nonatomic, assign) BOOL inBlackList;                     // 用户是否在黑名单中
@property (nonatomic, assign) BOOL appearByPlayVideo;               // 标志：是否点击播放视频了
@property (nonatomic, assign) BOOL hasAttentionUser;                // 是否已关注用户
@property (nonatomic, strong) SYPopUpWindows *popupWindow;          // 弹窗

@property (nonatomic, strong) SYNoNetworkView *noNetworkView;       // 无网提示view
@property (nonatomic, strong) SYDataErrorView *dataErrorView;       // 数据异常提示view

// 处理手势冲突
@property (nonatomic, weak)   UIScrollView *dynamicScrollView;              // 动态的scrollView
@property (nonatomic, assign) CGFloat currentPany;
@property (nonatomic, assign) BOOL mainScrollEnable;
@property (nonatomic, assign) BOOL subScrollEnable;
@property (nonatomic, assign) BOOL isShowInfoView;

@property (nonatomic, weak) AVPlayerViewController *avPlayer;

@end

@implementation SYPersonHomepageVC

#pragma mark - LifeCycle

- (void)dealloc {
    NSLog(@"释放SYPersonHomepageVC");
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sy_configDataInfoPageName:SYPageNameType_HomePage];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initSubviews];
    [self addNotifications];
    [self requestInViewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    // 修改状态栏颜色
    CGFloat y = self.scrollView.contentOffset.y;
    if (y > 0) {
        [self sy_setStatusBarDard];
    } else {
        [self sy_setStatusBarLight];
    }
    // 判断是否在房间内
    BOOL isInRoom = [self.viewModel getUserIfEnterRoom];
    if (isInRoom) {
        [self.enterRoomView startAnimating];
    } else {
        [self.enterRoomView stopAnimating];
    }
    // 请求数据
    [self requestInViewWillAppear];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateScrollViewContentSize];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    BOOL isInRoom = [self.viewModel getUserIfEnterRoom];
    if (isInRoom) {
        [self.enterRoomView stopAnimating];
    }
}

#pragma mark - Data

// request 发生在viewDidLoad阶段
- (void)requestInViewDidLoad {
    [self requestUserDynamicListData];
}

// request 发生在viewWillAppear阶段
- (void)requestInViewWillAppear {
    if (self.appearByPlayVideo) {
        self.appearByPlayVideo = NO;
        return;
    }
    [self requestUserData];
    [self requestUserAttentionAndFansCount];
    [self requestUserFansContribution];
    [self requestUserIfInLivingRoom];
    [self requestIfHasAttentionUser];
}

- (void)requestAllData {
    [self requestUserData];
    [self requestUserAttentionAndFansCount];
    [self requestUserFansContribution];
    [self requestUserIfInLivingRoom];
    [self requestIfHasAttentionUser];
    [self requestUserDynamicListData];
}

// 请求用户data
- (void)requestUserData {
    self.scrollView.hidden = YES;
    [self hideLoadingView];
    [self hideNoNetworkView];
    [self hideDataErrorView];
    [self hideChatAttentionDynamicBtn];
    if (![SYNetworkReachability isNetworkReachable]) {
        [self showNoNetworkView];
        return;
    } else {
        UserProfileEntity *userModel = [self.viewModel getHomepageUserModel];
        if (userModel) {
            self.scrollView.hidden = NO;
            [self updateChatAttentionDynamicBtnState];
        } else {
            [self showLoadingView];
        }
    }
    // 主播数据
    [self.viewModel requestHomepageDataWithUserId:self.userId success:^(BOOL success) {
        if (success) {
            [self updateHomepageViewAfterGetdataSuccess];
        } else {
            [self updateHomepageViewAfterGetdataFailed];
        }
        [self refreshUserIfInBlackListWithfinishBlock:^(BOOL inBlackList) {
            self.inBlackList = inBlackList;
        }];
    }];
}

// 请求用户的关注数和粉丝数
- (void)requestUserAttentionAndFansCount {
    [self.viewModel requestHomepageAttentionAndFansCountWithUserId:self.userId succes:^(BOOL success) {
        if (success) {
            [self updateHomepageAttentionAndFansCountAfterGetDataSuccess];
        }
    }];
}

// 请求用户是否在直播间
- (void)requestUserIfInLivingRoom {
    // 主播是否在房间内
    [self.viewModel requestHomepageUserIfHasInChatRoomWithUserId:self.userId success:^(BOOL success) {
        [self updateEnterRoomViewState];
    }];
}

// 主播的粉丝贡献数据
- (void)requestUserFansContribution {
    [self.viewModel requestHomepageUserFansContributionListWithUserId:self.userId success:^(BOOL success) {
        [self updateFansViewData];
    }];
}

// 是否已关注主播
- (void)requestIfHasAttentionUser {
    [self.viewModel requestAttentionUserBefore:self.userId success:^(BOOL success) {
        [self updateAttentionBtnState:success];
    }];
}

// 请求用户动态列表数据
- (void)requestUserDynamicListData {
    [self.dynamicInfoView requestDynamicListData];
}

// 个人主页数据返回成功
- (void)updateHomepageViewAfterGetdataSuccess {
    [self hideLoadingView];
    self.scrollView.hidden = NO;
    [self updateChatAttentionDynamicBtnState];
    UserProfileEntity *userModel = [self.viewModel getHomepageUserModel];
    NSString *userName = userModel.username;
    NSString *gender = userModel.gender;
    NSInteger age = [SYUtil ageWithBirthdayString:userModel.birthday];
    NSInteger vipLevel = userModel.level;
    NSString *location = [self.viewModel getUserLocation];
    NSString *constellation = [self.viewModel getUserConstellation];
    NSString *videoUrl = [NSString sy_safeString:userModel.video_url];
    NSString *videoImage = [NSString sy_safeString:userModel.video_imgurl];
    NSString *voiceUrl = [NSString sy_safeString:userModel.voice_url];
    NSInteger voiceDuration = userModel.voice_duration;
    NSInteger broadCasterLevel = userModel.streamer_level;
    NSInteger isBroadcaster = userModel.is_streamer;
    NSString *signature = [NSString sy_safeString:userModel.signature];
    
    // topTitle
    self.topTitle.text = userName;

    // 更新照片墙
    [self.photoWall updatePhotoWallWithPhotos:[self.viewModel getPhotoWallPhotoArr] videoImage:videoImage videoUrl:videoUrl];

    // 简介
    if (signature.length > 0) {
        [self.introView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(123);
        }];
    } else {
        [self.introView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(97);
        }];
    }
    [self.introView updateHomepageIntroViewWithName:userName gender:gender age:age viplevel:vipLevel broadCasterLevel:broadCasterLevel isBroadcaster:isBroadcaster signatureStr:signature isSuperAdmin:userModel.is_super_admin];

    // 主播才有粉丝贡献榜
    [self updateFansViewState];
    
    // 更新声音名片状态
    [self updateVoiceCardViewState:voiceUrl duration:voiceDuration];

    // 更新资料
    NSString *showId = [userModel.bestid integerValue] > 0 ? userModel.bestid : userModel.userid;
    [self.dynamicInfoView updateInfoView:showId coordinate:location constellation:constellation];
}

// 个人主页数据返回失败
- (void)updateHomepageViewAfterGetdataFailed {
    [self hideLoadingView];
    UserProfileEntity *userModel = [self.viewModel getHomepageUserModel];
    if (userModel) {
        [self updateHomepageViewAfterGetdataSuccess];
    } else {
        self.scrollView.hidden = YES;
        [self hideChatAttentionDynamicBtn];
        [self showDataErrorView];
    }
}

// 用户是否在黑名单中
- (void)refreshUserIfInBlackListWithfinishBlock:(void (^)(BOOL inBlackList))finishblock {

    UserProfileEntity *userModel = [self.viewModel getHomepageUserModel];
    if ([NSString sy_isBlankString:userModel.em_username]) {
        finishblock(NO);
        return;
    }
    __block BOOL isInBlackList = NO;
    [[EMClient sharedClient].contactManager getBlackListFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (aList && aList.count>0) {
            for(NSString *username in aList){
                if ([userModel.em_username isEqualToString:username]) {
                    isInBlackList = YES;
                    break;
                }
            }
        }
        finishblock(isInBlackList);
    }];
}

// 更新用户的关注和粉丝数
- (void)updateHomepageAttentionAndFansCountAfterGetDataSuccess {
    NSInteger attentionCount = [self.viewModel getUserAttentionCount];
    NSInteger fansCount = [self.viewModel getUserFansCount];
    [self.introView updateHomepageIntrolViewWithAttentionCount:attentionCount fansCount:fansCount];
}

// 刷新用户所在直播房间信息状态
- (void)updateEnterRoomViewState {
    BOOL isInRoom = [self.viewModel getUserIfEnterRoom];
    NSString *roomIcon = [self.viewModel getUserEnterRoomIcon];
    NSString *roomName = [self.viewModel getUserEnterRoomName];
    if (isInRoom) {
        self.enterRoomView.hidden = NO;
        [self.enterRoomView updateHomepageEnterRoomViewWithRoomIcon:roomIcon roomName:roomName];
        [self.enterRoomView startAnimating];
    } else {
        self.enterRoomView.hidden = YES;
        [self.enterRoomView updateHomepageEnterRoomViewWithRoomIcon:@"" roomName:@""];
        [self.enterRoomView stopAnimating];
    }
}

// 刷新fansViewData
- (void)updateFansViewData {
    [self updateFansViewState];
    NSArray *fansData = [self.viewModel fansContributionList];
    [self.fansView updateFansView:fansData];
}

// 更新关注按钮状态
- (void)updateAttentionBtnState:(BOOL)attention {
    self.hasAttentionUser = attention;
    if (![self isUserSelf]) {
        self.chatBtn.hidden = attention;
        self.attentionBtn.hidden = attention;
        self.chatLongBtn.hidden = !attention;
    }
}

#pragma mark - Private

- (void)initSubviews {
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    // loadingBaseView
    [self.view addSubview:self.loadingBaseView];
    // 异常提示view
    [self.view addSubview:self.noNetworkView];
    [self.view addSubview:self.dataErrorView];

    // 滚动控件
    [self.view addSubview:self.scrollView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panGesture.delegate = self;
    [self.scrollView addGestureRecognizer:panGesture];
    
    [self.scrollView addSubview:self.scrollContainerView];

    [self.scrollContainerView addSubview:self.photoWall];
    [self.scrollContainerView addSubview:self.introView];
    [self.scrollContainerView addSubview:self.fansView];
    [self.scrollContainerView addSubview:self.voiceCardView];
    [self.scrollContainerView addSubview:self.dynamicInfoView];
    
    self.dynamicScrollView = [self.dynamicInfoView getDynammicScrollView];
    [self.dynamicInfoView setDynamicViewScrollDelegate:self];
    
    // 直播中
    [self.scrollContainerView addSubview:self.enterRoomView];

    // 悬浮控件
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.moreBtn];
    [self.view addSubview:self.chatBtn];
    [self.view addSubview:self.attentionBtn];
    [self.view addSubview:self.chatLongBtn];
    [self.view addSubview:self.sendDynamicBtn];
    
    // 配合动态view使用
    [self.view addSubview:self.topNavView];
    
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {

    [self.scrollContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.mas_equalTo(__MainScreen_Width);
        make.height.mas_equalTo(1000);
    }];

    [self.photoWall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.scrollContainerView);
        make.width.mas_equalTo(self.view.sy_width);
        make.height.mas_equalTo(SYHomepagePhotoWallHeight);
    }];

    [self.introView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.photoWall.mas_bottom);
        make.width.mas_equalTo(self.view.sy_width);
        make.height.mas_equalTo(123);
    }];

    [self.fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.introView.mas_bottom);
        make.width.mas_equalTo(self.view.sy_width);
        make.height.mas_equalTo(0);
    }];
    
    [self.voiceCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.fansView.mas_bottom);
        make.width.mas_equalTo(self.view.sy_width);
        make.height.mas_equalTo(0);
    }];

    [self.dynamicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView);
        make.top.equalTo(self.voiceCardView.mas_bottom);
        make.width.mas_equalTo(self.view.sy_width);
        make.height.mas_equalTo(self.view.sy_height - SYDynamicInfoViewTop);
    }];
    
    [self.enterRoomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollContainerView).with.offset(15);
        make.bottom.equalTo(self.photoWall.mas_bottom).with.offset(-15);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(36);
    }];

    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(6);
        make.top.equalTo(self.view).with.offset(iPhoneX ? (24+20) : 20);
        make.size.mas_equalTo(CGSizeMake(36, 44));
    }];

    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-6);
        make.centerY.equalTo(self.backBtn);
        make.size.mas_equalTo(CGSizeMake(36, 44));
    }];

    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(self.view.sy_width/2.0 - 164 - 5);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -(16+34) : -16);
        make.size.mas_equalTo(CGSizeMake(164, 76));
    }];

    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).with.offset(-(self.view.sy_width/2.0 - 164 - 5));
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -(16+34) : -16);
        make.size.mas_equalTo(CGSizeMake(164, 76));
    }];
    
    [self.chatLongBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -46 : -12);
        make.size.mas_equalTo(CGSizeMake(342,84));
    }];
    
    [self.sendDynamicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -46 : -12);
        make.size.mas_equalTo(CGSizeMake(342,84));
    }];
    
    [self.topNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(SYDynamicInfoViewTop);
    }];
    
    [self.topBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topNavView).with.offset(6);
        make.top.equalTo(self.topNavView).with.offset(iPhoneX ? (24+20) : 20);
        make.size.mas_equalTo(CGSizeMake(36, 44));
    }];

    [self.topMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topNavView).with.offset(-6);
        make.centerY.equalTo(self.topBackBtn);
        make.size.mas_equalTo(CGSizeMake(36, 44));
    }];
    
    [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBackBtn.mas_right).with.offset(10);
        make.right.equalTo(self.topMoreBtn.mas_left).with.offset(-10);
        make.centerY.equalTo(self.topBackBtn);
        make.height.mas_equalTo(22);
    }];
    
}

- (void)updateScrollViewContentSize {
    [self.view layoutIfNeeded];
    CGFloat sizeY = 0;
    sizeY = CGRectGetMaxY(self.dynamicInfoView.frame);
    self.scrollView.contentSize = CGSizeMake(0, sizeY);
    [self.scrollContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(sizeY);
    }];
}

// 是否是自己的主页
- (BOOL)isUserSelf {
    UserProfileEntity *userModel = [UserProfileEntity getUserProfileEntity];
    return [userModel.userid isEqualToString:self.userId];
}

//  是否是主播
- (BOOL)isBroadCaster {
    UserProfileEntity *userModel = [self.viewModel getHomepageUserModel];
    return userModel.is_streamer > 0;
}

// 更新聊天，关注，发布按钮状态
- (void)updateChatAttentionDynamicBtnState {
    self.sendDynamicBtn.hidden = ![self isUserSelf];
    if ([self isUserSelf]) {
        self.chatBtn.hidden = YES;
        self.attentionBtn.hidden = YES;
        self.chatLongBtn.hidden = YES;
    } else {
        [self updateAttentionBtnState:self.hasAttentionUser];
    }
}

// 隐藏聊天，关注，发布按钮
- (void)hideChatAttentionDynamicBtn {
    self.chatBtn.hidden = YES;
    self.attentionBtn.hidden = YES;
    self.chatLongBtn.hidden = YES;
    self.sendDynamicBtn.hidden = YES;
}

// 更新粉丝贡献view状态
- (void)updateFansViewState {
    BOOL isBroadCaster = [self isBroadCaster];
    if (isBroadCaster) {
        self.fansView.hidden = NO;
        [self.fansView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(46);
        }];
    } else {
        self.fansView.hidden = YES;
        [self.fansView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    [self updateScrollViewContentSize];
}

// 更新声音名片状态
- (void)updateVoiceCardViewState:(NSString *)voiceUrl duration:(NSInteger)duration {
    if (voiceUrl.length > 0 && duration > 0) {
        [self.voiceCardView updateVoiceControl:voiceUrl voiceDuration:duration];
        self.voiceCardView.hidden = NO;
        [self.voiceCardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(46);
        }];
    } else {
        self.voiceCardView.hidden = YES;
        [self.voiceCardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    [self updateScrollViewContentSize];
}

// 停止播放录音
- (void)stopPlayRecord {
    [self.voiceCardView stopPlayVoice];
}

#pragma mark - 数据异常提示

- (void)showNoNetworkView {
    self.noNetworkView.hidden = NO;
}

- (void)hideNoNetworkView {
    self.noNetworkView.hidden = YES;
}

- (void)showDataErrorView {
    self.dataErrorView.hidden = NO;
}

- (void)hideDataErrorView {
    self.dataErrorView.hidden = YES;
}

- (void)showLoadingView {
    [MBProgressHUD showHUDAddedTo:self.loadingBaseView animated:NO];
}

- (void)hideLoadingView {
    [MBProgressHUD hideHUDForView:self.loadingBaseView animated:NO];
}

#pragma mark - BtnClickEvent

// 点击返回按钮
- (void)handleGoBackBtnClickEvent {
    [self stopPlayRecord];
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击更多按钮
- (void)handleMoreBtnClickEvent {
//    [self stopPlayRecord];
//    if (![SYNetworkReachability isNetworkReachable]) {
//        [SYToastView showToast:@"网络异常，请检查网络设置~"];
//        return;
//    }
//    NSMutableArray *actions = [NSMutableArray arrayWithArray:@[@"举报", self.inBlackList ? @"取消拉黑" : @"拉黑"]];
//    if (self.hasAttentionUser) {
//        [actions addObject:@"取消关注"];
//    }
//    SYCustomActionSheet *sheet = [[SYCustomActionSheet alloc] initWithActions:actions
//                                                                  cancelTitle:@"取消"
//                                                                  selectBlock:^(NSInteger index) {
//                                                                      switch (index) {
//                                                                          case 0:
//                                                                          {
//                                                                               [[SYReportManager sharedInstance] SYReportVC:self withVisit:@"个人主页-举报" withReporterId:self.userId];
//                                                                          }
//                                                                              break;
//                                                                          case 1:
//                                                                          {
//                                                                              // 拉黑+取消拉黑
//                                                                              [self handleBlackListBtn];
//                                                                          }
//                                                                              break;
//                                                                          case 2:
//                                                                          {
//                                                                              // 取消关注
//                                                                              [self handleCancelAttentionBtnClickEvent];
//                                                                          }
//                                                                              break;
//                                                                          default:
//                                                                              break;
//                                                                      }
//                                                                  } cancelBlock:^{
//
//                                                                  }];
//    [sheet show];
}

// 拉黑或者取消拉黑
- (void)handleBlackListBtn {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络设置~"];
        return;
    }
    if (self.inBlackList) {
        // 取消拉黑
        UserProfileEntity *userModel = [self.viewModel getHomepageUserModel];
        if ([NSString sy_isBlankString:userModel.em_username]) {
            [SYToastView showToast:@"取消拉黑失败，请重试~"];
            return;
        }
        __weak typeof(self) weakSelf = self;
        [[EMClient sharedClient].contactManager removeUserFromBlackList:userModel.em_username completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                weakSelf.inBlackList = NO;
                [SYToastView showToast:@"已移除黑名单"];
            } else {
                [SYToastView showToast:@"取消拉黑失败，请重试~"];
            }
        }];

    } else {
        // 拉黑需要二次确认
        if (self.popupWindow) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
        }
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
        self.popupWindow.delegate = self;
        self.popupWindow.tag = SYBlackListTag;
        NSString *mainTitle = @"拉黑后不会再收到对方消息，是否确认";
        [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Pair withMainTitle:mainTitle withSubTitle:@"" withBtnTexts:@[@"取消",@"确认"] withBtnTextColors:@[RGBACOLOR(102, 102, 102, 1),RGBACOLOR(11, 11, 11, 1)]];
        [window addSubview:self.popupWindow];
        [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window);
        }];
    }

}

// 点击聊天按钮
- (void)handleChatBtnClickEvent {
    [self stopPlayRecord];
    UserProfileEntity *userModel = [self.viewModel getHomepageUserModel];
    if (userModel) {
        UIViewController *chatController = [[SYChatViewController alloc] initWithUserProfileEntity:userModel];
        chatController.title = userModel.username;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

// 关注
- (void)handleAttentionBtnClickEvent {
    [self stopPlayRecord];
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络设置~"];
        return;
    }
    // 关注
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestAttentionUserWithUserid:self.userId success:^(BOOL success) {
        if (success) {
            [SYToastView showToast:@"关注成功"];
            [weakSelf updateAttentionBtnState:YES];
            if (weakSelf.attentionBlock) {
                UserProfileEntity *userModel = [weakSelf.viewModel getHomepageUserModel];
                weakSelf.attentionBlock(userModel.userid, userModel.username);
            }
            SYGiftNetManager *netManager = [SYGiftNetManager new];
            [netManager dailyTaskLog:3];
        } else {
            [SYToastView showToast:@"关注失败，请重试~"];
        }
    }];
}

// 取消关注
- (void)handleCancelAttentionBtnClickEvent {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络设置~"];
        return;
    }
    // 取消关注需要二次确认
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
    self.popupWindow.delegate = self;
    self.popupWindow.tag = SYCancelAttentionTag;
    NSString *mainTitle = @"取消关注后将不能在关注列表中找到对方，是否确认";
    [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Pair withMainTitle:mainTitle withSubTitle:@"" withBtnTexts:@[@"取消",@"确认"] withBtnTextColors:@[RGBACOLOR(102, 102, 102, 1),RGBACOLOR(11, 11, 11, 1)]];
    [window addSubview:self.popupWindow];
    [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

// 主播发表动态
- (void)handleSendDynamicBtnClickEvent {
//    __weak typeof(self) weakSelf = self;
//    SYCreateActivityVC *vc = [[SYCreateActivityVC alloc] initCreateActivityVCWithBlock:^{
//        [weakSelf requestUserDynamicListData];
//    }];
//    SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:vc];
//    navi.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self.navigationController presentViewController:navi
//                                            animated:YES
//                                          completion:nil];
}

// 进入用户所在的房间
- (void)handleEnterRoomBtnClickEvent {
    [self stopPlayRecord];
    SYChatRoomModel *roomModel = [self.viewModel getUserEnterRoomModel];    
    [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:roomModel.id from:SYVoiceChatRoomFromTagUserPage];
}

#pragma mark - Rotate

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - StatusBarStyle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Notification

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reCyclePlay)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)enterForeground {
    BOOL isInRoom = [self.viewModel getUserIfEnterRoom];
    if (isInRoom) {
        [self.enterRoomView startAnimating];
    }
}

- (void)enterBackground {
    BOOL isInRoom = [self.viewModel getUserIfEnterRoom];
    if (isInRoom) {
        [self.enterRoomView stopAnimating];
    }
}

- (void)reCyclePlay {
    if (self.avPlayer) {
        [self.avPlayer.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self.avPlayer.player play];
    }
}

#pragma mark - SYPopUpWindowsDelegate

- (void)handlePopUpWindowsLeftBtnClickEvent {
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
}

- (void)handlePopUpWindowsRightBtnClickEvent {
    NSInteger tag = self.popupWindow.tag;
    [self.popupWindow removeFromSuperview];
    self.popupWindow = nil;
    switch (tag) {
        case SYBlackListTag:
        {
            UserProfileEntity *userModel = [self.viewModel getHomepageUserModel];
            if ([NSString sy_isBlankString:userModel.em_username]) {
                [SYToastView showToast:@"拉黑失败，请重试~"];
                return;
            }
            __weak typeof(self) weakSelf = self;
            // 拉黑
            if (!self.inBlackList) {
                [[EMClient sharedClient].contactManager addUserToBlackList:userModel.em_username completion:^(NSString *aUsername, EMError *aError) {
                    if (!aError) {
                        weakSelf.inBlackList = YES;
                        [SYToastView showToast:@"已加入黑名单"];
                    } else {
                        [SYToastView showToast:@"拉黑失败，请重试~"];
                    }
                }];
            }
        }
            break;
        case SYCancelAttentionTag:
        {
            // 取消关注
            __weak typeof(self) weakSelf = self;
            [self.viewModel requestCancelAttentionUserWithUserid:self.userId success:^(BOOL success) {
                if (success) {
                    [SYToastView showToast:@"取消关注成功"];
                    [weakSelf updateAttentionBtnState:NO];
                    if (weakSelf.cancelAttentionBlock) {
                        UserProfileEntity *userModel = [weakSelf.viewModel getHomepageUserModel];
                        weakSelf.cancelAttentionBlock(userModel.userid, userModel.username);
                    }
                } else {
                    [SYToastView showToast:@"取消关注失败，请重试~"];
                }
            }];
        }
            break;
        default:
            break;
    }

}

#pragma mark - SYPersonHomepagePhotoWallDelegate

- (void)handleSYPersonHomepagePhotoWallVideoClick:(NSString *)videoUrl {
    [self stopPlayRecord];
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
    [self presentViewController:avPlayerVC animated:YES completion:nil];
    self.appearByPlayVideo = YES;
}

#pragma mark - SYPersonHomepageViewModelDelegate

- (void)SYPersonHomepageViewModelStopPlayRecord {
    [self.voiceCardView stopPlayVoice];
}

#pragma mark - SYDynamicViewProtocol

// 头像
- (void)SYDynamicViewClickAvatar:(NSString *)userId {
    SYPersonHomepageVC *vc = [SYPersonHomepageVC new];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

// 播放视频
- (void)SYDynamicViewClickPlayVideo:(NSString *)videoUrl {
    [self stopPlayRecord];
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
    [self presentViewController:avPlayerVC animated:YES completion:nil];
    self.appearByPlayVideo = YES;
    self.avPlayer = avPlayerVC;
}

#pragma mark - SYNoNetworkViewDelegate

- (void)SYNoNetworkViewClickRefreshBtn {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络设置~"];
        return;
    }
    [self requestAllData];
}

#pragma mark - SYDataErrorViewDelegate

- (void)SYDataErrorViewClickRefreshBtn {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络异常，请检查网络设置~"];
        return;
    }
    [self requestAllData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat y = self.scrollView.contentOffset.y;
        CGSize contentSize = self.scrollView.contentSize;
        // 处理tonBar渐变
        CGFloat ratio = 1.0 / (contentSize.height - self.view.sy_height);
        self.topNavView.alpha = y * ratio;
        // 处理手势冲突
        if (scrollView.contentOffset.y >= (NSInteger)(contentSize.height - self.view.sy_height)) {
            [scrollView setContentOffset:CGPointMake(0, (contentSize.height - self.view.sy_height)) animated:NO];
            self.scrollView.scrollEnabled = NO;
            self.mainScrollEnable = NO;
            self.dynamicScrollView.scrollEnabled = YES;
            self.subScrollEnable = YES;
        }
        // 吸顶的时候，状态栏变成黑色
        if (y > 0) {
            if (@available(iOS 13.0, *)) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
            } else {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }
        } else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateChanged) {
        self.currentPany = 0;
        self.mainScrollEnable = NO;
        self.subScrollEnable = NO;
    } else {
        CGFloat currentY = [gesture translationInView:self.scrollView].y;
        if (self.mainScrollEnable || self.subScrollEnable) {
            if (self.currentPany == 0) {
                self.currentPany = currentY;
            }
            CGFloat offSety = self.currentPany - currentY;
            if (self.mainScrollEnable) {
                CGSize contentSize = self.scrollView.contentSize;
                CGFloat supposeY = (contentSize.height - self.view.sy_height) + offSety;
                if (supposeY >= 0) {
                    self.scrollView.contentOffset = CGPointMake(0, supposeY);
                } else {
                    self.scrollView.contentOffset = CGPointMake(0, 0);
                }
            } else {
                NSLog(@"offSetY - %f",offSety);
                self.dynamicScrollView.contentOffset = CGPointMake(0, offSety);
            }
        } else {
            CGFloat tempy = [gesture translationInView:self.scrollView].y;
            CGFloat tempx = [gesture translationInView:self.scrollView].x;
            BOOL scrollVertical = fabs(tempy) > fabs(tempx);
            NSLog(@"tempx - %f; tempy - %f",tempx,tempy);
            if (self.isShowInfoView) {
                if (tempy > 0 && scrollVertical && !self.scrollView.scrollEnabled) {
                    self.dynamicScrollView.contentOffset = CGPointMake(0, 0);
                    self.dynamicScrollView.scrollEnabled = NO;
                    self.scrollView.scrollEnabled = YES;
                    self.mainScrollEnable = YES;
                }
            } else {
                CGSize contentSize = self.scrollView.contentSize;
                if (tempy < 0 && scrollVertical  && self.scrollView.scrollEnabled && !self.dynamicScrollView.scrollEnabled && (self.scrollView.contentOffset.y >= (contentSize.height - self.view.sy_height))) {
                    self.dynamicScrollView.scrollEnabled = YES;
                    self.subScrollEnable = YES;
                    self.scrollView.scrollEnabled = NO;
                    self.mainScrollEnable = NO;
                }
            }
        }
    }
}

#pragma mark - SYDynamicViewScrollDelegate

- (void)changeOffSet:(CGFloat)y {
    if (y < 0) {
        [self.dynamicScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        self.scrollView.scrollEnabled = YES;
        self.mainScrollEnable = YES;
        self.dynamicScrollView.scrollEnabled = NO;
        self.subScrollEnable = NO;
    } else {
        NSLog(@"dynamicScrollOffSet - y == %f",y);
    }
}

- (void)setDynamicScrollView:(UIScrollView *)dynamicScrollView {
    _dynamicScrollView = dynamicScrollView;
    _dynamicScrollView.scrollEnabled = NO;
}

#pragma mark - SYPersonHomepageDynamicInfoViewDelegate

- (void)changeDynamicInfoViewScrollViewContentOffset:(CGFloat)x {
    if (x > self.dynamicInfoView.sy_width / 2) {
        self.isShowInfoView = YES;
    } else {
        self.isShowInfoView = NO;
    }
}

#pragma mark - Lazyload

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = RGBACOLOR(242, 244, 245, 1);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.hidden = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)scrollContainerView {
    if (!_scrollContainerView) {
        _scrollContainerView = [UIView new];
        _scrollContainerView.backgroundColor = RGBACOLOR(242, 244, 245, 1);
    }
    return _scrollContainerView;
}

- (SYPersonHomepageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [SYPersonHomepageViewModel new];
        _viewModel.delegate = self;
    }
    return _viewModel;
}

- (SYPersonHomepagePhotoWall *)photoWall {
    if (!_photoWall) {
        _photoWall = [[SYPersonHomepagePhotoWall alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, SYHomepagePhotoWallHeight)];
        [_photoWall updatePhotoWallWithPhotos:@[@""] videoImage:@"" videoUrl:@""];
        _photoWall.delegate = self;
    }
    return _photoWall;
}

- (SYPersonHomepageIntroView *)introView {
    if (!_introView) {
        _introView = [[SYPersonHomepageIntroView alloc] initWithFrame:CGRectZero];
    }
    return _introView;
}

- (SYPersonHomepageEnterRoomView *)enterRoomView {
    if (!_enterRoomView) {
        _enterRoomView = [[SYPersonHomepageEnterRoomView alloc] initWithFrame:CGRectZero];
        _enterRoomView.hidden = YES;
        _enterRoomView.clipsToBounds = YES;
        [_enterRoomView addTarget:self action:@selector(handleEnterRoomBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterRoomView;
}

- (SYPersonHomepageFansView *)fansView {
    if (!_fansView) {
        __weak typeof(self)weakSelf = self;
        _fansView = [[SYPersonHomepageFansView alloc] initFansContributionView:CGRectZero tapFans:^(NSString * _Nonnull userId) {
            [weakSelf stopPlayRecord];
            SYPersonHomepageVC *vc = [SYPersonHomepageVC new];
            vc.userId = userId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } tapArrow:^{
            [weakSelf stopPlayRecord];
            SYPersonHomepageFansVC *vc = [SYPersonHomepageFansVC new];
            vc.userId = weakSelf.userId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        _fansView.hidden = YES;
    }
    return _fansView;
}

- (SYPersonHomepageVoiceCardView *)voiceCardView {
    if (!_voiceCardView) {
        __weak typeof(self) weakSelf = self;
        _voiceCardView = [[SYPersonHomepageVoiceCardView alloc] initVoiceCardViewWithFrame:CGRectZero recordVoice:nil tapArrowBlock:^{
            [weakSelf stopPlayRecord];
            if ([weakSelf isUserSelf]) {
                SYPersonHomepageVoiceCardVC *vc = [SYPersonHomepageVoiceCardVC new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                SYPersonHomepageVoiceCardVC *vc = [[SYPersonHomepageVoiceCardVC alloc] initWithUserid:weakSelf.userId];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        _voiceCardView.hidden = YES;
    }
    return _voiceCardView;
}

- (SYPersonHomepageDynamicInfoView *)dynamicInfoView {
    if (!_dynamicInfoView) {
        _dynamicInfoView = [[SYPersonHomepageDynamicInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.sy_width, self.view.sy_height - SYDynamicInfoViewTop) userId:self.userId];
        _dynamicInfoView.delegate = self;
        _dynamicInfoView.scrollDelegate = self;
    }
    return _dynamicInfoView;
}

- (UIButton *)chatBtn {
    if (!_chatBtn) {
        _chatBtn = [UIButton new];
        [_chatBtn setImage:[UIImage imageNamed_sy:@"homepage_chat"] forState:UIControlStateNormal];
        [_chatBtn addTarget:self action:@selector(handleChatBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        _chatBtn.hidden = YES;
    }
    return _chatBtn;
}

- (UIButton *)chatLongBtn {
    if (!_chatLongBtn) {
        _chatLongBtn = [UIButton new];
        [_chatLongBtn setImage:[UIImage imageNamed_sy:@"homepage_chat_long"] forState:UIControlStateNormal];
        [_chatLongBtn addTarget:self action:@selector(handleChatBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        _chatLongBtn.hidden = YES;
    }
    return _chatLongBtn;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [UIButton new];
        [_attentionBtn setImage:[UIImage imageNamed_sy:@"homepage_attention"] forState:UIControlStateNormal];
        [_attentionBtn setImage:[UIImage imageNamed_sy:@"homepage_attention"] forState:UIControlStateSelected];
        [_attentionBtn addTarget:self action:@selector(handleAttentionBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        _attentionBtn.hidden = YES;
    }
    return _attentionBtn;
}

- (UIButton *)sendDynamicBtn {
    if (!_sendDynamicBtn) {
        _sendDynamicBtn = [UIButton new];
        [_sendDynamicBtn setImage:[UIImage imageNamed_sy:@"homepage_dynamic_send"] forState:UIControlStateNormal];
        [_sendDynamicBtn addTarget:self action:@selector(handleSendDynamicBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        _sendDynamicBtn.hidden = YES;
    }
    return _sendDynamicBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn addTarget:self action:@selector(handleGoBackBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed_sy:@"homepage_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton new];
        [_moreBtn addTarget:self action:@selector(handleMoreBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [_moreBtn setImage:[UIImage imageNamed_sy:@"homepage_more"] forState:UIControlStateNormal];
        _moreBtn.hidden = [self isUserSelf];
    }
    return _moreBtn;
}

- (SYNoNetworkView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:self.view.bounds
                                                                  withDelegate:self];
        _noNetworkView.hidden = YES;
    }
    return _noNetworkView;
}

- (SYDataErrorView *)dataErrorView {
    if (!_dataErrorView) {
        _dataErrorView = [[SYDataErrorView alloc] initSYDataErrorViewWithFrame:self.view.bounds withDelegate:self];
        _dataErrorView.hidden = YES;
    }
    return _dataErrorView;
}

- (UIView *)loadingBaseView {
    if (!_loadingBaseView) {
        _loadingBaseView = [[UIView alloc] initWithFrame:self.view.bounds];
        _loadingBaseView.backgroundColor = [UIColor clearColor];
    }
    return _loadingBaseView;
}

- (UIView *)topNavView {
    if (!_topNavView) {
        _topNavView = [UIView new];
        _topNavView.backgroundColor = RGBACOLOR(245,246,247,1);
        [_topNavView addSubview:self.topBackBtn];
        [_topNavView addSubview:self.topTitle];
        [_topNavView addSubview:self.topMoreBtn];
        _topNavView.alpha = 0;
    }
    return _topNavView;
}

- (UIButton *)topBackBtn {
    if (!_topBackBtn) {
        _topBackBtn = [UIButton new];
        [_topBackBtn addTarget:self action:@selector(handleGoBackBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [_topBackBtn setImage:[UIImage imageNamed_sy:@"homepage_back_top"] forState:UIControlStateNormal];
    }
    return _topBackBtn;
}

- (UIButton *)topMoreBtn {
    if (!_topMoreBtn) {
        _topMoreBtn = [UIButton new];
        [_topMoreBtn addTarget:self action:@selector(handleMoreBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [_topMoreBtn setImage:[UIImage imageNamed_sy:@"homepage_more_top"] forState:UIControlStateNormal];
        _topMoreBtn.hidden = [self isUserSelf];
    }
    return _topMoreBtn;
}

- (UILabel *)topTitle {
    if (!_topTitle) {
        _topTitle = [UILabel new];
        _topTitle.textColor = RGBACOLOR(48,48,48,1);
        _topTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _topTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _topTitle;
}

@end
