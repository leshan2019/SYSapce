//
//  SYLiveRoomVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomVC.h"
#import "SYLiveRoomViewModel.h"
#import "SYLiveRoomToolbar.h"
#import "SYLiveRoomPopularityView.h"
#import "SYVoiceRoomBoardView.h"
#import "SYVoiceRoomOperationView.h"
#import "SYVoiceTextMessageListView.h"
#import "SYVoiceChatRoomViewModel.h"
#import "SYLeaderboardVC.h"
#import "SYLiveRoomHostIDView.h"
#import "SYLiveRoomBossView.h"
#import "SYVoiceRoomBossPopView.h"
#import "SYChildProtectManager.h"
#import "ShiningSdkManager.h"
#import "SYGameBeeViewController.h"
#import "SYWebViewController.h"
#import "SYVideoPushViewController.h"
#import "SYVideoPullViewController.h"
#import "SYVoiceRoomUserInfoView.h"
#import "SYPersonHomepageVC.h"
#import "SYVoiceRoomGiftView.h"
#import "SYNavigationController.h"
#import "SYMyCoinViewController.h"
#import "SYGiftInfoManager.h"
#import "SYVoiceRoomInputView.h"
#import "SYVoiceRoomFunView.h"
#import "SYChatViewController.h"
#import "SYReportManager.h"
#import "SYVoiceRoomGiftFloatView.h"
#import "SYVoiceRoomMessageFloatView.h"
#import "SYGiftAnimationView.h"
#import "SYLivingAPI.h"
#import "SYShareView.h"
#import "SYPersonHomepageFansVC.h"
#import "SYVoiceChatRoomDetailInfoVC.h"
#import "SYVoiceRoomOnlineListView.h"
#import "SYLiveBigTextMessageListView.h"
#import "SYLiveBigMessageListPopView.h"
#import "SYLiveRoomFinishView.h"
#import "SYUserServiceAPI.h"
#import "SYLiveRoomLiveToolView.h"
#import "SYVoiceChatNetManager.h"
#import "SYLiveRoomHostTimerView.h"
#import "SYGiftNetManager.h"
#import "SYVoiceRoomSendRedpacketVC.h"
#import "SYVoiceRoomExtView.h"
#import "SYVoiceRoomRedpacketView.h"
#import "SYVoiceRoomRedPacketCanGetWindow.h"
#import "SYRoomGroupRedpacketModel.h"
#import "SYVoiceRoomGetRedpacketResultVC.h"
#import "SYLiveRoomFansView.h"
#import "SYConversationListController.h"

@interface SYLiveRoomVC () <SYVoiceRoomBoardViewDelegate, SYVoiceTextMessageListViewDelegate, SYVoiceTextMessageListViewDataSource, SYVoiceChatRoomViewModelDelegate, SYVoiceRoomBossViewDelegate, SYVoiceRoomBossPopViewDelegate, SYLiveRoomToolbarDelegate, SYVoiceRoomUserInfoViewDelegate, SYVoiceRoomUserInfoViewDataSource, SYGameBeeDelegate, SYVoiceRoomGiftViewDelegate, SYVoiceRoomGiftViewDataSource, /*SYVideoPushViewControllerDelegate,*/ SYVoiceRoomFunViewDelegate, SYVoiceRoomInputViewDelegate, SYVoiceRoomMessageFloatViewDelegate, SYGiftAnimationRenderHandlerDelegate, SYLiveRoomHostIDViewDelegate, SYLiveBigMessageListPopViewDelegate, SYLiveRoomFinishViewDelegate, SYLiveRoomLiveToolViewDelegate,SYVoiceRoomExtViewDelegate,SYVoiceRoomRedpacketViewDelegate,SYVoiceRoomRedPacketCanGetWindowDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) SYLivingStreamType streamType;
@property (nonatomic, strong) SYVideoPullViewController* videoPullController;
//@property (nonatomic, strong) SYVideoPushViewController* videoPushController;

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, assign) SYChatRoomUserRole role;
@property (nonatomic, strong) SYVoiceChatRoomViewModel *viewModel;
@property (nonatomic, strong) SYLiveRoomToolbar *toolbar;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *recoverButton;
@property (nonatomic, strong) SYLiveRoomPopularityView *popularityView;
@property (nonatomic, strong) SYVoiceRoomBoardView *leaderBoardView;
@property (nonatomic, strong) SYVoiceRoomOperationView *operationView;  // 运营位view
@property (nonatomic, strong) SYVoiceTextMessageListView *messageListView;
@property (nonatomic, strong) SYLiveRoomHostIDView *hostIDView;
@property (nonatomic, strong) UIView *subviewContainer;

@property (nonatomic, strong) SYLiveRoomBossView *bossSeatView; // 老板位
@property (nonatomic, strong) SYVoiceRoomBossPopView *bossPopView;

@property (nonatomic, strong) SYGameBeeViewController *beeVC;
//@property (nonatomic, strong) UIButton *leftPlayRuleButton;
@property (nonatomic, strong) SYVoiceRoomUserInfoView *userInfoView;
@property (nonatomic, strong) SYVoiceRoomGiftView *giftView;
@property (nonatomic, strong) NSMutableArray *giftReceiverArray;
@property (nonatomic, strong) SYVoiceRoomInputView *inputView;

@property (nonatomic, strong) SYVoiceRoomFunView *funView;
@property (nonatomic, strong) SYVoiceRoomGiftFloatView *giftFloatView;
@property (nonatomic, strong) SYVoiceRoomMessageFloatView *messageFloatView;

@property (nonatomic, strong) SYGiftAnimationView *animationView;

@property (nonatomic, strong) UIButton *onlineButton;
@property (nonatomic, strong) SYVoiceRoomOnlineListView *onlineListView;

@property (nonatomic, assign) BOOL isRoomOpen;
@property (nonatomic, assign) BOOL isMyselfHost; // 自己是主播
@property (nonatomic, strong) SYLiveBigMessageListPopView *messageListPopView; // 大公屏弹出view

@property (nonatomic, strong) SYLiveRoomFinishView *finishView;
@property (nonatomic, strong) SYLiveRoomLiveToolView *toolView;
@property (nonatomic, strong) SYVoiceRoomExtView *userToolView;

@property (nonatomic, strong) NSString *roomName;

@property (nonatomic, strong) NSTimer *hostPlayTimer;
@property (nonatomic, assign) NSInteger hostPlayDuration;
@property (nonatomic, strong) SYLiveRoomHostTimerView *timerView;

@property (nonatomic, strong) NSString *jumpRoomId;

@property (nonatomic, assign) BOOL isFinished; // 直播结束

@property (nonatomic, strong) SYVoiceRoomRedpacketView *redPacketView;  // 聊天室红包view
@property (nonatomic, strong) SYVoiceRoomRedPacketCanGetWindow *redPacketGetView;   // 聊天室领取红包View

@property (nonatomic, strong) UILabel *roomIDLabel; // 房间号label
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SYLiveRoomVC

- (void)dealloc {
//    NSString *position = ([self.view superview]) ? @"direct" : @"float";
//    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@"", @"position": position};
//    [MobClick event:@"roomLeave" attributes:dict];
    [self leaveChannel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_messageFloatView) {
        [self.messageFloatView destory];
    }
    if (_animationView) {
        [self.animationView destory];
    }
    if (self.bossPopView) {
        [self.bossPopView destroy];
    }
    
    if (self.beeVC) {
        [self.beeVC.view removeFromSuperview];
    }
    
    if (self.giftView) {
        [self.giftView destroy];
    }

    if (self.redPacketView) {
        [self.redPacketView stopRuningTimer];
    }
}

- (instancetype)initWithChannelID:(NSString *)channelID
                            title:(NSString *)title {
    return [self initWithChannelID:channelID
                             title:title
                          password:@""];
}

- (instancetype)initWithChannelID:(NSString *)channelID
                            title:(NSString *)title
                         password:(NSString *)password {
    return [self initWithChannelID: channelID
                             title: title
                          password: password
                        streamType: SYLivingStreamTypePull];
}

- (instancetype)initWithChannelID:(NSString *)channelID
                            title:(NSString *)title
                         password:(NSString *)password
                       streamType:(SYLivingStreamType) streamType {
    self = [super init];
    if (self) {
        _channelID = channelID;
        _streamType = streamType;
        _roomName = title;
        _viewModel = [[SYVoiceChatRoomViewModel alloc] initWithChannelID:channelID
                                                                password:password];
        _viewModel.delegate = self;
        [_viewModel disableUpdateRolesList];
        _hostPlayDuration = 0;
        _isFinished = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#ifdef ShiningSdk
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#endif
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    if (self.redPacketView) {
        [self refreshVoiceRoomGroupRedpacketList];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)leaveChannel {
    [self.viewModel leaveChannel];
    [self stopHostPlayTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewModel joinLiveRoom];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[SYGiftInfoManager sharedManager] updateGiftList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStatusChanged:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userInfoReady:)
                                                 name:KNOTIFICATION_USERINFOREADY
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(networkChanged:)
        name:SYNetworkingReachabilityDidChangeNotification
      object:nil];
}

- (void)networkChanged:(id)sender {
    if (![SYNetworkReachability isNetworkReachable]) {
        // 断网直接踢出房间
        [self stopHostPlayTimer];
    }
}

- (void)drawViewsWithHost:(BOOL)isHost {
    self.isMyselfHost = isHost;
    if (isHost) {
        [SYSettingManager setLivingChannelID:self.channelID];
    }
    [self.viewModel startProcess];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.subviewContainer];
    [self.subviewContainer addSubview:self.toolbar];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.recoverButton];
    [self.view addSubview:self.hostIDView];
    [self.subviewContainer addSubview:self.messageListView];
    [self.scrollView addSubview:self.leaderBoardView];
    [self.view addSubview:self.giftFloatView];
    [self.view addSubview:self.messageFloatView];
    
    for (UIView *subView in self.scrollView.subviews) {
        subView.sy_left = subView.sy_left + self.scrollView.sy_width;
    }
    
    if (isHost) {
        self.timerView = [[SYLiveRoomHostTimerView alloc] initWithFrame:CGRectMake(16.f, self.hostIDView.sy_bottom + 40, 150, 20)];
        [self.subviewContainer addSubview:self.timerView];
        [self.timerView setTime:self.hostPlayDuration];
        self.scrollView.scrollEnabled = NO;
    }
    [self setupUnreadMessageCount];
}

#pragma mark - UI

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(self.view.sy_width * 2.f, self.view.sy_height);
        _scrollView.contentOffset = CGPointMake(self.view.sy_width, 0);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)subviewContainer {
    if (!_subviewContainer) {
        _subviewContainer = [[UIView alloc] initWithFrame:self.view.bounds];
        _subviewContainer.backgroundColor = [UIColor clearColor];
    }
    return _subviewContainer;
}

- (SYLiveRoomToolbar *)toolbar {
    if (!_toolbar) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = iPhoneX ? 50.f + 34.f : 50.f;
        CGFloat originY = self.view.bounds.size.height - height;
        _toolbar = [[SYLiveRoomToolbar alloc] initWithFrame:CGRectMake(0, originY, width, height)];
        _toolbar.delegate = self;
    }
    return _toolbar;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.view.sy_width - 16.f - 36.f, 6.f + self.toolbar.sy_top, 36.f, 36.f);
        [_closeButton setImage:[UIImage imageNamed_sy:@"liveRoom_close"]
                      forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(liveRoomToolbarDidSelectClose)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)recoverButton {
    if (!_recoverButton) {
        _recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recoverButton.frame = CGRectMake(self.closeButton.sy_left - 14.f - 36.f, 6.f + self.toolbar.sy_top, 36.f, 36.f);
        [_recoverButton setImage:[UIImage imageNamed_sy:@"liveRoom_recover"]
                      forState:UIControlStateNormal];
        [_recoverButton addTarget:self
                         action:@selector(recoverScroll)
               forControlEvents:UIControlEventTouchUpInside];
        _recoverButton.hidden = YES;
    }
    return _recoverButton;
}

- (SYLiveRoomHostIDView *)hostIDView {
    if (!_hostIDView) {
        CGFloat y = iPhoneX ? 23 + 24 : 23;
        _hostIDView = [[SYLiveRoomHostIDView alloc] initWithFrame:CGRectMake(16, y, 148, 38)];
        _hostIDView.delegate = self;
    }
    return _hostIDView;
}

- (SYVoiceRoomBoardView *)leaderBoardView {
    if (!_leaderBoardView) {
        CGFloat width = [SYVoiceRoomBoardView minimumWidth];
        CGFloat x = self.view.sy_width - 16.f - width;
        CGFloat y = iPhoneX ? 46 : 22;
        _leaderBoardView = [[SYVoiceRoomBoardView alloc] initWithFrame:CGRectMake(x, y, width, 36)
                                                             channelID:self.channelID
                                                                  type:SYVoiceRoomBoardViewTypeLiveRoom];
        _leaderBoardView.delegate = self;
        [_leaderBoardView requestData];
    }
    return _leaderBoardView;
}

- (SYVoiceTextMessageListView *)messageListView {
    if (!_messageListView) {
        CGFloat originY = self.toolbar.sy_top - 170.f;
        CGFloat height = 170.f;
        _messageListView = [[SYVoiceTextMessageListView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, height)];
        _messageListView.dataSource = self;
        _messageListView.delegate = self;
    }
    return _messageListView;
}

//- (UIButton *)leftPlayRuleButton {
//    if (!_leftPlayRuleButton) {
//        _leftPlayRuleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGFloat y = iPhoneX ? 90 : 66;
//        _leftPlayRuleButton.frame = CGRectMake(self.view.sy_width - 16.f - 55.f, y, 55.f, 24.f);
//        _leftPlayRuleButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        [_leftPlayRuleButton addTarget:self action:@selector(selectPlayRule)
//                      forControlEvents:UIControlEventTouchUpInside];
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        layer.frame = _leftPlayRuleButton.bounds;
//        CGFloat radius = 12.f;
//        layer.path = [UIBezierPath bezierPathWithRoundedRect:_leftPlayRuleButton.bounds
//                                           byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
//                                                 cornerRadii:CGSizeMake(radius, radius)].CGPath;
//        _leftPlayRuleButton.layer.mask = layer;
//
//        [_leftPlayRuleButton setImage:[UIImage imageNamed_sy:@"voiceroom_louder"]
//                             forState:UIControlStateNormal];
//        [_leftPlayRuleButton setTitle:@"玩法" forState:UIControlStateNormal];
//        _leftPlayRuleButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
//        [_leftPlayRuleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
//
//        _leftPlayRuleButton.layer.mask = nil;
//        _leftPlayRuleButton.sy_width = 56.f;
//        _leftPlayRuleButton.layer.cornerRadius = self.leftPlayRuleButton.sy_height / 2.f;
//    }
//    return _leftPlayRuleButton;
//}

- (SYVideoPullViewController*) videoPullController {
    if (!_videoPullController) {
        SYVideoPullViewController* controller = [[SYVideoPullViewController alloc] initWithRoomId: self.channelID];
        _videoPullController = controller;
    }
    return _videoPullController;
}

//- (SYVideoPushViewController*) videoPushController {
//    if (!_videoPushController) {
//        SYVideoPushViewController* controller = [[SYVideoPushViewController alloc] initWithRoomId: self.channelID
//                                                 skipPreview:self.isRoomOpen];
//        _videoPushController = controller;
//        _videoPushController.delegate = self;
//    }
//    return _videoPushController;
//}

- (SYVoiceRoomGiftFloatView *)giftFloatView {
    if (!_giftFloatView) {
        _giftFloatView = [[SYVoiceRoomGiftFloatView alloc] initWithFrame:CGRectMake(0, self.messageListView.sy_top - 50.f, self.view.sy_width, 50)];
    }
    return _giftFloatView;
}

- (SYVoiceRoomMessageFloatView *)messageFloatView {
    if (!_messageFloatView) {
        CGFloat y = iPhoneX ? 90 : 66;
        y += 26.f;
        _messageFloatView = [[SYVoiceRoomMessageFloatView alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, 26.f + 16.f)];
        _messageFloatView.delegate = self;
    }
    return _messageFloatView;
}

- (SYLiveRoomPopularityView *)popularityView {
    if (!_popularityView) {
        CGFloat y = iPhoneX ? 90 : 66;
        _popularityView = [[SYLiveRoomPopularityView alloc] initWithFrame:CGRectMake(16.f, y, 20, 22)];
    }
    return _popularityView;
}

- (UIButton *)onlineButton {
    if (!_onlineButton) {
        _onlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = iPhoneX ? 90 : 66;
        _onlineButton.frame = CGRectMake(16.f, y, 20, 22);
        _onlineButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _onlineButton.layer.cornerRadius = 11.f;
        [_onlineButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
        _onlineButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _onlineButton.hidden = YES;
        [_onlineButton addTarget:self action:@selector(openOnline:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _onlineButton;
}

- (UILabel *)roomIDLabel {
    if (!_roomIDLabel) {
        CGFloat width = 84.f;
        _roomIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.sy_width - width - 14.f, self.popularityView.sy_top, width, 22.f)];
        _roomIDLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _roomIDLabel.textColor = [UIColor whiteColor];
        _roomIDLabel.font = [UIFont systemFontOfSize:12];
        _roomIDLabel.textAlignment = NSTextAlignmentCenter;
        _roomIDLabel.text = [NSString stringWithFormat:@"房间：%@", self.channelID];
        _roomIDLabel.layer.cornerRadius = 11.f;
        _roomIDLabel.clipsToBounds = YES;
    }
    return _roomIDLabel;
}

#pragma mark - video push controller delegate
/*
- (void) videoPushViewControllerSuccessFlipHorizontal:(BOOL)mirrorState
                                          toastString:(NSString *)toastString {
    [self.toolView showToast:toastString];
}

- (void) videoPushViewControllerStreamingConnected: (SYVideoPushViewController *)controller {
    [self.viewModel startLiveStreaming:nil userName:nil];
}

- (void) videoPushViewControllerStartPushStream: (SYVideoPushViewController*) controller {
//    [self drawViews];
//    [self.viewModel liveStreamStarted];
    [self startHostPlayTimer];
}

- (void) videoPushViewControllerStartShowClicked: (SYVideoPushViewController*) controller {
    __weak typeof(self) weakSelf = self;
    [[SYLivingAPI shared] openRoomWithRoomId:self.channelID
                                successBlock:^(id  _Nullable response) {
                                    [weakSelf drawViewsWithHost:YES];
                                } failureBlock:^(NSError * _Nullable error) {
                                    
                                }];
}

- (void) videoPushViewControllerConfigClicked: (SYVideoPushViewController*) controller {
    SYVoiceChatRoomDetailInfoVC* vc = [[SYVoiceChatRoomDetailInfoVC alloc] init];
    vc.isRoomOwner = (self.role == SYChatRoomUserRoleHomeOwner);
    vc.channelId = self.channelID;
    vc.isLiving = YES;
    [self.navigationController pushViewController: vc animated: YES];
}

- (void) videoPushViewControllerCloseClicked: (SYVideoPushViewController*) controller {
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
        [self.delegate voiceChatRoomVCForceClosedWithVC:self];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) videoPushViewController: (SYVideoPushViewController*) controller getRoomTitleSuccess: (void (^)(NSString * _Nonnull title)) success {
    // 获取房间标题
    if (success) {
        success(self.viewModel.currentUser.username);
    }
}

- (void) videoPushViewController:(SYVideoPushViewController*) controller setRoomTitle:(NSString*) title {
    // 设置房间标题
    [[SYVoiceChatNetManager new] requestUpdateChannelInfoWithChannelID:self.channelID name:title greeting:@"" desc:@"" icon:@"" iconFile:[NSData data] iconFile_16_9:[NSData data] backgroundImage:nil success:^(id  _Nullable response) {
        [SYToastView showToast:@"更新成功~"];
    } failure:^(NSError * _Nullable error) {
        [SYToastView showToast:@"更新失败~"];
    }];
}

- (void) videoPushViewControllerStreamingDisconnected: (SYVideoPushViewController*) controller withError: (NSError*) error {
    if (error) {
        // 非正常断开，弹出一个 Alert 框。
        UIAlertController* alert = [UIAlertController alertControllerWithTitle: nil message: @"推流非正常断开" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle: @"重试" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.videoPushController reStartPushStream];
        }];
        [alert addAction: ok];
        
        [self presentViewController: alert animated: YES completion: nil];
    }
//    [self.viewModel liveStreamInterrupted];
}
 */

#pragma mark - pull vc delegate

- (void) videoPullViewController: (SYVideoPullViewController*) controller playWithError: (NSError*) error {
    
}

- (void) videoPullViewControllerPlayerStopped: (SYVideoPullViewController*) controller {
//    [self.viewModel liveStreamInterrupted];
}

- (void) videoPullViewControllerPlayerReconnectingBegin: (SYVideoPullViewController*) controller {
//    [self.viewModel liveStreamStarted];
}

- (void) videoPullViewControllerPlayerReconnectingEnd: (SYVideoPullViewController*) controller {
    
}

#pragma mark - toolbar delegate

- (void)liveRoomToolbarDidSelectClose {
    if (self.isMyselfHost) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要关闭直播吗？"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [[SYLivingAPI shared] closeRoomWithRoomId:self.channelID
                                                                                         successBlock:^(id  _Nullable response) {
                                                                                             [SYSettingManager setLivingChannelID:nil];
                                                                                             [self.viewModel closeChannel];
                                                                                         } failureBlock:^(NSError * _Nullable error) {
                                                                                             [self.viewModel closeChannel];
                                                                                         }];
                                                        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    } else {
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
            [self.delegate voiceChatRoomVCForceClosedWithVC:self];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)liveRoomToolbarTouchGiftButton {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    self.giftReceiverArray = [NSMutableArray new];
    SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:0];
    [self.giftReceiverArray addObject:user];
    SYVoiceRoomGiftView *giftView = [[SYVoiceRoomGiftView alloc] initWithFrame:self.view.bounds
                                                                      isAllMic:NO
                                                                     channelID:self.channelID];
    [giftView setHighlightedIndex:0];
    giftView.delegate = self;
    giftView.dataSource = self;
    [giftView loadGifts];
    [self.view addSubview:giftView];
    self.giftView = giftView;
    
    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@"", @"position": @"bottom"};
//    [MobClick event:@"roomGiftClick" attributes:dict];
}

- (void)liveRoomToolbarTouchInputButton {
    if (!self.inputView) {
        SYVoiceRoomInputView *view = [[SYVoiceRoomInputView alloc] initWithFrame:self.view.bounds];
        view.delegate = self;
        self.inputView = view;
        [view setRoomID:self.channelID
                 userID:self.viewModel.myself.uid];
    }
    [self.inputView becomeFirstResponder];
    [self.view addSubview:self.inputView];
}

- (void)liveRoomToolbarTouchExpressionButton {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    if (!self.funView) {
        SYVoiceRoomFunView *gameView = [[SYVoiceRoomFunView alloc] initWithFrame:self.view.bounds];
        gameView.delegate = self;
        self.funView = gameView;
    }
    BOOL inMic = NO;
    [self.funView setGameEntranceHidden:!inMic];
    [self.funView refreshData];
    [self.view addSubview:self.funView];
}

- (void)liveRoomToolbarTouchPrivateMessageButton {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    // 点击私信按钮
    SYConversationListController *vc = [[SYConversationListController alloc] init];
    vc.usedByPrivateMessage = YES;
    
    SYNavigationController *nav = [[SYNavigationController alloc] initWithRootViewController:vc];
    nav.usedByPrivateMessage = YES;
    [nav setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    self.definesPresentationContext = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)liveRoomToolbarTouchShareButton {
    // 分享房间
    SYShareView *shareView = [[SYShareView alloc] initWithFrame:self.view.bounds];
    shareView.delegate = self;
    [self.view addSubview:shareView];
}

- (void)liveRoomToolbarTouchMoreButton {
//    if (self.isMyselfHost) {
//        SYLiveRoomLiveToolView *toolView = self.toolView;
//        if (!toolView) {
//            toolView = [[SYLiveRoomLiveToolView alloc] initWithFrame:self.view.bounds mirroOpen:![self.videoPushController mirrorState]];
//            toolView.delegate = self;
//            [self.view addSubview:toolView];
//            self.toolView = toolView;
//        }else {
//            toolView.mirrorOpen = ![self.videoPushController mirrorState];
//            [toolView updateHostState:self.isMyselfHost];
//            if (toolView.superview == nil) {
//                [self.view addSubview:toolView];
//            }
//        }
//    }else {
        if (!self.userToolView) {
            self.userToolView = [[SYVoiceRoomExtView alloc] initWithFrame:self.view.bounds];
            self.userToolView.delegate = self;
        }
        [self.userToolView setVoiceViewModel:self.viewModel roomType:YES];
        [self.view addSubview:self.userToolView];
//    }
}



- (void)voiceRoomExtViewDidRedPct {
    if (![self.viewModel isMyselfLogin]) {
        // 先登录
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    SYVoiceRoomSendRedpacketVC *vc = [SYVoiceRoomSendRedpacketVC new];
    vc.roomId = self.channelID;
    __weak typeof(self) weakSelf = self;
    vc.sendSuccess = ^(BOOL needOverScreen) {
        if (needOverScreen) {
            // 全屏飘屏
            [weakSelf.viewModel sendOverScreenGroupRedpacketSignalling];
        }
        // 发送群红包成功后，发送一条成功的信令
        [weakSelf.viewModel sendRoomGroupRedpacketSignalling];
    };
    [self.navigationController pushViewController:vc animated:YES];
    [self.userToolView removeFromSuperview];
}


- (void)animationSwitchAction:(BOOL)isOff {
    [SYSettingManager setAnimationOff:isOff];
}

- (void)voiceRoomExtViewDidPrivateMsg {
    [self liveRoomToolbarTouchPrivateMessageButton];
    [self.userToolView removeFromSuperview];
}

- (void)voiceRoomExtViewDidChartHideAction:(BOOL)isHide
{
//    [SYSettingManager setChartHide:isHide];
    [[SYUserServiceAPI sharedInstance]updateUserProperty:@"toplist_invisible" isOpen:isHide success:^(BOOL isSuccess) {
        if (isSuccess) {
            [SYSettingManager setChartHide:isHide];
        }
    }];
}


#pragma mark - leader board delegate method

- (void)voiceRoomBoardViewDidEnterLeaderBoard {
    SYLeaderboardVC *vc = [[SYLeaderboardVC alloc] initWithChannelID:self.channelID];
    vc.onlyShowOutcome = YES;
    __weak typeof(self) weakSelf = self;
    vc.followSuccessBlock = ^(NSString * _Nonnull userId, NSString * _Nonnull userName) {
        [weakSelf.viewModel sendFollowUserMessageWithUserId:userId
                                                   username:userName];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
//    SYVoiceChatUserViewModel *host = [self.viewModel usersInMicAtPosition:0];
//    SYPersonHomepageFansVC *vc = [SYPersonHomepageFansVC new];
//    vc.userId = host.uid;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)voiceRoomBoardViewDidTouchUserWithUid:(NSString *)uid {
    [self showUserInfoViewWithUserUid:uid
                            isFromMic:NO
                          micPosition:0];
}

#pragma mark - view model delegate

- (void)voiceChatRoomOnlineUserNumberDidChangedWithNumber:(NSInteger)number myself:(BOOL)isMyself {
    if (isMyself && self.isMyselfHost) {
        // 由于视频直播会join两次，所以自己进入房间的不再加1
        return;
    }
    [self setOnlineNumber:number];
}

- (void)voiceChatRoomInfoDataReady {
    // 房间信息获取到
//    if (!self.leftPlayRuleButton.superview) {
//        [self.subviewContainer addSubview:self.leftPlayRuleButton];
//    }
    if (!self.popularityView.superview) {
        [self.subviewContainer addSubview:self.popularityView];
    }
    [self.popularityView setPopularity:self.viewModel.roomInfo.roomScore];
    if (!self.onlineButton.superview) {
        [self.subviewContainer addSubview:self.onlineButton];
    }
    [self setOnlineNumber:self.viewModel.roomInfo.userNum];
    if (!self.roomIDLabel.superview) {
        [self.subviewContainer addSubview:self.roomIDLabel];
    }
}

- (void)voiceChatRoomDidGetMyRole:(SYChatRoomUserRole)role {
    self.role = role;
}

- (void)voiceChatRoomDataPrepared {
    // rolelist 获取到
    SYVoiceChatUserViewModel *host = [self.viewModel usersInMicAtPosition:0];
    [self.hostIDView showWithUsername:host.name
                               userID:host.uid
                               bestID:host.bestid
                            avatarURL:host.avatarURL
                          followState:NO];
    [self.hostIDView setUserRoleWithIsHost:self.isMyselfHost];
    [self.toolbar setUserRoleWithIsHost:self.isMyselfHost];
    
    // 获取关注信息
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestFollowStateWithBlock:^(BOOL isFollowed) {
        [weakSelf.hostIDView setFollowState:isFollowed];
    }];
}

- (void)voiceChatRoomBossStatusChanged {
    if (!self.bossSeatView) {
        self.bossSeatView = [[SYLiveRoomBossView alloc] initWithFrame:CGRectMake(self.hostIDView.sy_right + 10.f, self.hostIDView.sy_top + 4.f, 30.f, 30.f)];
        self.bossSeatView.delegate = self;
        [self.subviewContainer addSubview:self.bossSeatView];
        if (self.giftView) {
            [self.view insertSubview:self.bossSeatView
                        belowSubview:self.giftView];
        }
        // 本版本隐藏boss
//        self.bossSeatView.hidden = YES;
    }
    
    [self.bossSeatView showWithBossViewModel:self.viewModel.bossViewModel];
    if (self.bossPopView) {
        [self.bossPopView showWithBossViewModel:self.viewModel.bossViewModel];
    }
//    if (self.redPacketView && self.redPacketView.hidden == NO) {
//        self.bossSeatView.hidden = YES;
//    }
}

- (void)voiceChatRoomDidReceivePublicScreenMessage {
    if (_messageListView) {
        [self.messageListView reloadData];
    }
    if (self.messageListPopView) {
        [self.messageListPopView reloadData];
    }
    NSInteger index = [self.viewModel textMessageListCount] - 1;
    SYVoiceTextMessageViewModel *message = [self.viewModel textMessageViewModelAtIndex:index];
    if (message.messageType == SYVoiceTextMessageTypeGift) {
        [self.giftFloatView addFloatGiftWithGiftMessageViewModel:message];
        if ([self.giftView superview]) {
            [self.view insertSubview:self.giftFloatView
                        aboveSubview:self.giftView];
        }
        [_messageListView addGiftInfo:message];
    }
    [self.messageFloatView addMessage:message];
}

- (void)voiceChatRoomDidReceiveOverScreenMessage:(SYVoiceTextMessageViewModel *)message {
    [self.messageFloatView addMessage:message];
    [self.view bringSubviewToFront:self.messageFloatView];
}

- (void)voiceChatRoomDidReceiveGiftWithGiftID:(NSInteger)giftID
                                randomGiftIDs:(nonnull NSArray *)randomGiftIDs
                                   withSender:(nonnull SYVoiceRoomUser *)sender
                                 withReciever:(nonnull SYVoiceRoomUser *)reciever{
    if (self.isFinished) {
        return;
    }
    if (!self.animationView) {
        self.animationView = [[SYGiftAnimationView alloc] initWithFrame:self.view.bounds];
        self.animationView.delegate = self;
    }
    self.animationView.audioEffectPlayer = [self.viewModel audioEffectPlayer];
    
    SYAnimationModel *model = [SYAnimationModel new];
    model.animationType =  SYAnimationType_Gift;
    model.animationId = giftID;
    model.user = sender;
    model.recieverUser = reciever;
    if ([randomGiftIDs count] > 0) {
        model.isRandomGift = YES;
        model.randomGiftArray = randomGiftIDs;
    }
    //    [self.animationView addGiftAnimationWithGiftID:giftID];
    [self.animationView addGiftAnimationWithAnimationModel:model];
    [self.view addSubview:self.animationView];
}

- (void)voiceChatRoomShowUserProp:(nonnull SYVoiceRoomUser *)user
{
    if (self.isFinished) {
        return;
    }
    if (!self.animationView) {
        self.animationView = [[SYGiftAnimationView alloc] initWithFrame:self.view.bounds];
        self.animationView.delegate = self;
    }
    self.animationView.audioEffectPlayer = [self.viewModel audioEffectPlayer];
    SYAnimationModel *model = [SYAnimationModel new];
    model.animationType =  SYAnimationType_Driver;
    model.animationId = user.vehicle;
    model.user = user;
    [self.animationView addGiftAnimationWithAnimationModel:model];
    
    [self.view addSubview:self.animationView];
}

- (void)voiceChatRoomDataError:(SYVoiceChatRoomError)error {
    switch (error) {
        case SYVoiceChatRoomErrorForbiddenEnter:
        {
            [SYToastView showToast:@"您已被管理员禁入此房间"];
//            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
//                [self.delegate voiceChatRoomVCForceClosedWithVC:self];
//            }
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
                [self.delegate voiceChatRoomVCForceClosedWithVC:self];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case SYVoiceChatRoomErrorForbiddenChat:
        {
            [SYToastView showToast:@"您已被管理员禁言"];
        }
            break;
        case SYVoiceChatRoomErrorNetwork:
        {
            [SYToastView showToast:@"请检查您的网络情况"];
        }
            break;
        case SYVoiceChatRoomErrorSignaling:
        {
            [SYToastView showToast:@"请检查您的网络情况"];
        }
            break;
        case SYVoiceChatRoomErrorAuthority:
        {
            [SYToastView showToast:@"您不能进行此操作"];
        }
            break;
        case SYVoiceChatRoomErrorJoinChannelFailed:
        {
//            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
//                [self.delegate voiceChatRoomVCForceClosedWithVC:self];
//            }
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
                [self.delegate voiceChatRoomVCForceClosedWithVC:self];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case SYVoiceChatRoomErrorRoomClosed:
        {
            [SYToastView showToast:@"此房间已关闭"];
//            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
//                [self.delegate voiceChatRoomVCForceClosedWithVC:self];
//            }
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
                [self.delegate voiceChatRoomVCForceClosedWithVC:self];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case SYVoiceChatRoomErrorRoomLocked:
        {
            [SYToastView showToast:@"房间密码错误"];
        }
            break;
        case SYVoiceChatRoomErrorDownloadOtherApp:
        {
            NSString *toast = [SYSettingManager downloadAppToast];
            if (![NSString sy_isBlankString:toast]) {
                [SYToastView showToast:toast];
            }
        }
            break;
        default:
            break;
    }
}

- (void)liveRoomHostDidJoinRoomWithRoomOpenState:(BOOL)isOpen
                                          hostID:(NSString *)hostID
                                            role:(SYChatRoomUserRole)role {
    self.isRoomOpen = isOpen;
    UserProfileEntity *mySelfUserInfo = [UserProfileEntity getUserProfileEntity];
    self.isMyselfHost = (mySelfUserInfo.userid && [hostID isEqualToString:mySelfUserInfo.userid]);
//    if (self.isMyselfHost) {
//        // 开播了，并且自己就是主播
//        [self addChildViewController: self.videoPushController];
//        [self.view addSubview: self.videoPushController.view];
//        [self.videoPushController didMoveToParentViewController: self];
//        __weak typeof(self) weakSelf = self;
//        [[SYLivingAPI shared] openRoomWithRoomId:self.channelID
//                                    successBlock:^(id  _Nullable response) {
//                                        [weakSelf drawViewsWithHost:YES];
//                                    } failureBlock:^(NSError * _Nullable error) {
//
//                                    }];
//    } else if (isOpen && [NSString sy_isBlankString:hostID] && role >= SYChatRoomUserRoleAdminister) {
//        self.isMyselfHost = YES;
//        // 开播了，并且自己就是主播
//        [self addChildViewController: self.videoPushController];
//        [self.view addSubview: self.videoPushController.view];
//        [self.videoPushController didMoveToParentViewController: self];
//        __weak typeof(self) weakSelf = self;
//        [[SYLivingAPI shared] openRoomWithRoomId:self.channelID
//                                    successBlock:^(id  _Nullable response) {
//                                        [weakSelf drawViewsWithHost:YES];
//                                    } failureBlock:^(NSError * _Nullable error) {
//
//                                    }];
//    } else if (!isOpen && role >= SYChatRoomUserRoleAdminister) {
//        [self addChildViewController: self.videoPushController];
//        [self.view addSubview: self.videoPushController.view];
//        [self.videoPushController didMoveToParentViewController: self];
//    } else {
        [self addChildViewController: self.videoPullController];
        [self.view addSubview: self.videoPullController.view];
        [self.videoPullController didMoveToParentViewController: self];
        [self drawViewsWithHost:NO];
//    }
}


- (void)liveRoomDidReceiveStartStreamingMessage {
    if (!self.isMyselfHost) {
        [self.videoPullController reGetStreamPullUrl];
    }
}

- (void)voiceChatRoomDidCloseChannel {
    if (self.isMyselfHost) {
        [self leaveChannel];
        if (self.jumpRoomId) {
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCChangeAnotherRoomWithVC:roomId:)]) {
                [self.delegate voiceChatRoomVCChangeAnotherRoomWithVC:self roomId:self.jumpRoomId];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
                [self.delegate voiceChatRoomVCForceClosedWithVC:self];
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        self.isFinished = YES;
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        if (_videoPullController) {
            [self.videoPullController removeFromParentViewController];
            [self.videoPullController cancelRetry];
            _videoPullController = nil;
        }
        // 展示直播完成页面
        SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:0];
        SYLiveRoomFinishView *finishView = [[SYLiveRoomFinishView alloc] initWithFrame:self.view.bounds];
        SYSexType sexType = SYSexType_Unknown;
        if ([user.gender isEqualToString:@"male"]) {
            sexType = SYSexType_male;
        } else if ([user.gender isEqualToString:@"female"]) {
            sexType = SYSexType_female;
        }
        [finishView setUserInfoAvatar:user.avatarURL
                             userName:user.name
                            userLevel:user.level
                            hostLevel:user.broadcaster_level
                              userAge:user.age
                              userSex:sexType
                           isFollowed:self.hostIDView.isFollowing];
        finishView.delegate = self;
        [self.view addSubview:finishView];
        self.finishView = finishView;
    }
}

- (void)voiceChatRoomUserIsForbiddenEnterChannelWithUid:(NSString *)uid {
    if ([uid isEqualToString:self.viewModel.myself.uid]) {
        [SYToastView showToast:@"您被禁入该房间"];
        [self leaveChannel];
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
            [self.delegate voiceChatRoomVCForceClosedWithVC:self];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.userInfoView reloadForbidEnterState:YES
                                              uid:uid];
    }
}

- (void)voiceChatRoomUserCancelForbiddenEnterChannelWithUid:(NSString *)uid {
    [self.userInfoView reloadForbidEnterState:NO
                                          uid:uid];
}

- (BOOL)voiceChatRoomNeedVoiceSDK {
    return NO;
}

- (void)voiceChatRoomDidFetchRoomHotScore:(NSInteger)score {
    [self.popularityView setPopularity:score];
    self.onlineButton.sy_left = self.popularityView.sy_right + 6.f;
}

#pragma mark - 运营位相关

- (void)voiceChatRoomOperationDataReady {
    NSArray *viewModels = [self.viewModel operationViewModels];
    CGFloat width = 46;
    CGFloat space = 20;
    CGFloat height = [self calculateOperationViewHeight:viewModels];
    if (!self.operationView) {
        CGRect operationViewFrame = CGRectMake(self.view.sy_width - width - 12.f, self.view.sy_height - (iPhoneX ? 84 : 50) - space - height, width, height);
        __weak typeof(self) weakSelf = self;
        self.operationView = [[SYVoiceRoomOperationView alloc] initWithFrame:operationViewFrame clickBlock:^(SYVoiceRoomOperationViewModel * _Nullable model) {
            [weakSelf handleClickOperationModel:model];
        }];
        [self.subviewContainer addSubview:self.operationView];
        if (self.giftView) {
            [self.view insertSubview:self.operationView
                        belowSubview:self.giftView];
        }
    } else {
        CGRect operationViewFrame = self.operationView.frame;
        operationViewFrame.origin.y = self.view.sy_height - (iPhoneX ? 84 : 50) - space - height;
        operationViewFrame.size.height = height;
        self.operationView.frame = operationViewFrame;
    }
    [self.operationView updateOperationDatas:viewModels];

//    if ([SYSettingManager isVoiceRoomFirstEnter]) {
//        [SYSettingManager setOffVoiceRoomFirstEnterFlag];
//        [self.view addSubview:self.guideImageView];
//    }
}

- (CGFloat)calculateOperationViewHeight:(NSArray *)viewModels {
    CGFloat height = 0;
    CGFloat tempHeight = 0;
    if (viewModels && viewModels.count > 0) {
        for (int i = 0; i < viewModels.count; i++) {
            NSArray *subArr = [viewModels objectAtIndex:i];
            if (subArr.count == 1) {
                tempHeight = 46;
            } else if (subArr.count > 1) {
                tempHeight = 46 + 4 +5;
            }
            if (i == 0) {
                height += tempHeight;
            } else {
                height += (tempHeight + 20);
            }
        }
    }
    return height;
}

- (void)handleClickOperationModel:(SYVoiceRoomOperationViewModel *)operationViewModel {
    if (!operationViewModel) {
        return;
    }
    // 点击上报
    NSDictionary *dict = @{@"position": @(operationViewModel.position), @"destination": operationViewModel.webURL?:@"",
                           @"name": operationViewModel.title?:@"", @"type": @(operationViewModel.operationType)};
//    [MobClick event:@"roomOpClick" attributes:dict];
    
    if (operationViewModel.operationType == SYVoiceRoomOperationTypeLBZ) {
        if (![self.viewModel isMyselfLogin]) {
            // 进入乐必中必须登录
            [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
            return;
        }
        [self playGameWithURL:operationViewModel.webURL];
    } else if(operationViewModel.operationType == SYVoiceRoomOperationTypeBee){
        if (![self giftViewShouldOperateTeenager]) {
            return;
        }
        _beeVC = [[SYGameBeeViewController alloc ] init];
        _beeVC.view.frame = self.view.bounds;
        _beeVC.channelID = self.channelID;
        _beeVC.vc = self;
        _beeVC.delegate = self;
        __weak typeof(self) weakSelf = self;
        [self.view.window addSubview:_beeVC.view];
    }
    else if(operationViewModel.operationType == SYVoiceRoomOperationTypeLink){
        if (operationViewModel.webURL) {
            if (![self giftViewShouldOperateTeenager]) {
                return;
            }
            SYWebViewController *vc = [[SYWebViewController alloc] initWithURL:operationViewModel.webURL
                                                                      andTitle:operationViewModel.title
                                                                     andRoomId:self.channelID];
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    }
}

- (BOOL)giftViewShouldOperateTeenager {
    return NO;//![[SYChildProtectManager sharedInstance] needChildProtectWithNavigationController:self.navigationController];
}

- (void)playGameWithURL:(NSString *)url {
#ifdef UseSettingTestDevEnv
    [SYToastView showToast:@"iOS暂时下线了"];
#endif
    /*
     MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
     hud.opacity = 0.7;
     hud.removeFromSuperViewOnHide = YES;
     [self.view addSubview:hud];
     [hud show:YES];
     self.loadingHud = hud;
     SYVoiceChatRoomUserInfoViewModel *fetcher = [[SYVoiceChatRoomUserInfoViewModel alloc] init];
     [fetcher requestLBZTicketWithBlock:^(NSDictionary *ticketDict) {
     if ([ticketDict isKindOfClass:[NSDictionary class]]) {
     NSString *_url = url ?: @"http://test-lebz.le.com/game/syLuck/?activity_id=29";
     [[LetvLBZManager shareInstance] interLbzViewControllerWithSdkTargetURL:_url andUserTicket:ticketDict[@"ticket"] andUid:ticketDict[@"userid"] reginTicketHandler:^(id data, ShanYinRegainTicketResponseCallback ticketCallback) {
     
     } PayHandler:^(id data, ShanYinPayResponseCallback payCallback) {
     SYMyCoinViewController *coinVC = [[SYMyCoinViewController alloc] init];
     [coinVC requestMyCoin];
     UINavigationController *navi = [data objectForKey:@"nav"];
     [navi presentViewController:[[SYNavigationController alloc] initWithRootViewController:coinVC] animated:YES completion:nil];
     coinVC.resultBlock = ^{
     if (payCallback) {
     payCallback(@"", YES);
     }
     };
     } currentViewController:self];
     }
     [self.loadingHud hide:YES];
     self.loadingHud = nil;
     }];
     */
}

#pragma mark - private

- (void)loginStatusChanged:(id)sender {
    NSNotification *noti = (NSNotification *)sender;
    BOOL login = [noti.object boolValue];
    if (!login) {
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
            [self.delegate voiceChatRoomVCForceClosedWithVC:self];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)userInfoReady:(id)sender {
    // 登录成功，刷新用户信息
    if (![self.viewModel isMyselfLogin]) {
        [SYToastView showToast:@"登录成功"];
    }
    [self.viewModel updateMyselfUserInfo];
    // 获取关注信息
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestFollowStateWithBlock:^(BOOL isFollowed) {
        if (weakSelf.isFinished) {
            [weakSelf.finishView setFollowState:isFollowed];
        } else {
            [weakSelf.hostIDView setFollowState:isFollowed];
        }
    }];
}

- (void)enterForeground:(id)sender {
    if (self.view.superview) {
        // 不是浮球状态
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    BOOL hasUnread = NO;
    for (EMConversation *conversation in conversations) {
        if (conversation.type == EMConversationTypeChat) {
            if (conversation.unreadMessagesCount > 0) {
                hasUnread = YES;
                break;
            }
        }
    }
    [self.toolbar setHasUnreadMessage:hasUnread];
    [self.userToolView setHasUnreadMessage:hasUnread];
}

- (void)selectPlayRule {
    SYCustomPostView *postView = [[SYCustomPostView alloc] initWithTitle:@"玩法说明"
                                                                 message:self.viewModel.roomInfo.roomDesc];
    [postView show];
}

- (void)showUserInfoViewWithUserUid:(NSString *)uid
                          isFromMic:(BOOL)isFromMic
                        micPosition:(NSInteger)micPosition {
    if ([uid longLongValue] >= 1000000000) {
        // 游客id，不显示
        return;
    }
    SYVoiceRoomUserInfoView *userInfoView = [[SYVoiceRoomUserInfoView alloc] initWithFrame:self.view.bounds];
    userInfoView.dataSource = self;
    userInfoView.delegate = self;
    BOOL isAdmin = (micPosition == 0 && isFromMic) ? (self.viewModel.initialRole == SYChatRoomUserRoleHomeOwner) : (self.viewModel.initialRole >= SYChatRoomUserRoleAdminister); // 主持人位只有房主可以有操作权限，其他只有加好友送礼物权限
    [userInfoView showWithChannelID:self.channelID
                            UserUid:uid
                           isMyself:[uid isEqualToString:self.viewModel.myself.uid]
                          isFromMic:isFromMic
                        micPosition:micPosition
                            isAdmin:isAdmin];
    [self.view addSubview:userInfoView];
    self.userInfoView = userInfoView;
}

- (void)setOnlineNumber:(NSInteger)num {
    if (num < 0) {
        num = 0;
    }
    NSString *string = [NSString stringWithFormat:@"在线：%ld", num];
    [self.onlineButton setTitle:string forState:UIControlStateNormal];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(999, 22) options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: self.onlineButton.titleLabel.font}
                                       context:nil];
    self.onlineButton.sy_width = rect.size.width + 16.f;
    self.onlineButton.sy_left = self.popularityView.sy_right + 6.f;
    BOOL showOnlineSwitch = [SYSettingManager voiceRoomShowOnline];
    self.onlineButton.hidden = (!showOnlineSwitch && self.role < SYChatRoomUserRoleHost);
}

- (void)openOnline:(id)sender {
    if (self.onlineListView) {
        [self.onlineListView removeFromSuperview];
        self.onlineListView = nil;
    }
    self.onlineListView = [[SYVoiceRoomOnlineListView alloc] initWithFrame:self.view.bounds withChannelID:self.channelID];
    self.onlineListView.delegate = self;
    [self.view addSubview:self.onlineListView];
}

- (void)startHostPlayTimer {
    [self stopHostPlayTimer];
    self.hostPlayDuration = 0;
    self.hostPlayTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(hostPlayTimerAction:)
                                                        userInfo:nil
                                                         repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.hostPlayTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopHostPlayTimer {
    if (self.hostPlayTimer && [self.hostPlayTimer isKindOfClass:[NSTimer class]] &&
        [self.hostPlayTimer isValid]) {
        [self.hostPlayTimer invalidate];
    }
    self.hostPlayTimer = nil;
}

- (void)hostPlayTimerAction:(id)sender {
    self.hostPlayDuration++;
    [self.timerView setTime:self.hostPlayDuration];
}

- (void)recoverScroll {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.sy_width, 0)
                             animated:YES];
    self.recoverButton.hidden = YES;
}

#pragma mark - SYVoiceTextMessageListViewDataSource

- (NSInteger)numberOfItemsOfVoiceTextMessageListView:(SYVoiceTextMessageListView *)view {
    return [self.viewModel textMessageListCount];
}

- (SYVoiceTextMessageViewModel *)voiceTextMessageListView:(SYVoiceTextMessageListView *)view
                                  messageViewModelAtIndex:(NSInteger)index {
    return [self.viewModel textMessageViewModelAtIndex:index];
}

- (void)voiceTextMessageListViewDidSelectUserAtIndex:(NSInteger)index {
    // 弹出用户信息
    SYVoiceTextMessageViewModel *message = [self.viewModel textMessageViewModelAtIndex:index];
    if (message && message.userUid) {
        [self showUserInfoViewWithUserUid:message.userUid isFromMic:NO micPosition:0];
    }
}

- (void)voiceTextMessageListViewDidSelectReceiverAtIndex:(NSInteger)index {
    // 弹出用户信息
    SYVoiceTextMessageViewModel *message = [self.viewModel textMessageViewModelAtIndex:index];
    if (message && message.receiverUid) {
        [self showUserInfoViewWithUserUid:message.receiverUid isFromMic:NO micPosition:0];
    }
}

#pragma mark - Boss

- (void)voiceRoomBossViewDidClicked {
    [self.bossPopView destroy];
    SYVoiceRoomBossPopView *view = [[SYVoiceRoomBossPopView alloc] initWithFrame:self.view.bounds];
    view.delegate = self;
    [view showWithBossViewModel:self.viewModel.bossViewModel];
    [self.view addSubview:view];
    self.bossPopView = view;
}

- (void)voiceRoomBossPopViewDidShowGift {
    [self liveRoomToolbarTouchGiftButton];
}

- (void)voiceRoomBossPopViewDidShowPersonPageWithUid:(NSString *)uid {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    SYPersonHomepageVC *vc = [[SYPersonHomepageVC alloc] init];
    vc.userId = uid;
    __weak typeof(self) weakSelf = self;
    vc.attentionBlock = ^(NSString * _Nonnull userId, NSString * _Nonnull userName) {
        [weakSelf.viewModel sendFollowUserMessageWithUserId:userId
                                                   username:userName];
        if ([userId isEqualToString:weakSelf.viewModel.liveRoomHost.uid]) {
            [weakSelf.hostIDView setFollowState:YES];
        }
    };
    vc.cancelAttentionBlock = ^(NSString * _Nonnull userId, NSString * _Nonnull userName) {
        if ([userId isEqualToString:weakSelf.viewModel.liveRoomHost.uid]) {
            [weakSelf.hostIDView setFollowState:NO];
        }
    };
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - bee

#pragma mark - bee delegate
- (void)completeGameBee{
    _beeVC = nil;
}

/**
 * 弹出登录
 */
- (void)popGameBeeLogin{
    [ShiningSdkManager checkLetvAutoLogin:self];
}

- (void)gameBeeDidGetGiftWithName:(NSString *)giftName
                            price:(NSInteger)price
                           giftId:(NSInteger)giftId
                         giftIcon:(NSString *)giftIcon
                         gameName:(NSString *)gameName {
    [self.viewModel sendBeeHoneyMessageWithGiftName:giftName
                                              price:price
                                             giftId:giftId
                                           giftIcon:giftIcon
                                           gameName:gameName];
}

#pragma mark - userinfoview delegate datasource

- (void)voiceRoomUserInfoViewDidFetchUserInfoWithUid:(NSString *)uid
                                           isFromMic:(BOOL)isFromMic
                                       atMicPosition:(NSInteger)micPosition
                                            username:(NSString *)username
                                              avatar:(NSString *)avatar
                                           avatarBox:(NSInteger)avatarBox
                                    broadcasterLevel:(NSInteger)broadcasterLevel
                                       isBroadcaster:(NSInteger)isBroadcaster
                                        isSuperAdmin:(NSUInteger)isSuperAdmin{
    [self.viewModel changeUserInfoAtPosition:micPosition
                                   isFromMic:isFromMic
                                         uid:uid
                                    username:username
                                      avatar:avatar
                                   avatarBox:avatarBox
                            broadcasterLevel:broadcasterLevel
                               isBroadcaster:isBroadcaster
                                isSuperAdmin:isSuperAdmin];
}

- (BOOL)voiceRoomUserInfoViewUserIsMutedWithUid:(NSString *)uid
                                  atMicPosition:(NSInteger)micPosition {
    SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:micPosition];
    if (user && [user.uid isEqualToString:uid]) {
        return user.isMuted;
    }
    return NO;
}

- (void)voiceRoomUserInfoViewDidKickUserFromMicWithUid:(NSString *)uid
                                         atMicPosition:(NSInteger)micPosition {
    SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:micPosition];
    if (user && [user.uid isEqualToString:uid]) {
        if (micPosition == 0) {
            [self.viewModel kickHost];
        } else {
            [self.viewModel kickMicAtMicPostion:micPosition];
        }
    }
}

- (void)voiceRoomUserInfoViewDidChangeMuteStateWithUid:(NSString *)uid
                                         atMicPosition:(NSInteger)micPosition {
    SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:micPosition];
    if (user && [user.uid isEqualToString:uid]) {
        BOOL isMuted = user.isMuted;
        if (isMuted) {
            if (micPosition == 0) {
                [self.viewModel cancelMuteHostMicAtMicPosition:micPosition];
            } else {
                [self.viewModel cancelMuteMicAtMicPosition:micPosition];
            }
        } else {
            if (micPosition == 0) {
                [self.viewModel muteHostMicAtMicPostion:micPosition];
            } else {
                [self.viewModel muteMicAtMicPostion:micPosition];
            }
        }
    }
}

- (void)voiceRoomUserInfoViewDidSelectGiftButtonWithUser:(SYVoiceChatUserViewModel *)user {
    if (!user) {
        return;
    }
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    NSInteger highlightedIndex = 0;
    self.giftReceiverArray = [NSMutableArray new];
    if (self.userInfoView.isFromMic) {
        SYVoiceChatUserViewModel *_user = [self.viewModel usersInMicAtPosition:0];
        [self.giftReceiverArray addObject:_user];
        for (SYVoiceChatUserViewModel *_user in self.giftReceiverArray) {
            if ([_user.uid isEqualToString:user.uid]) {
                break;
            }
            highlightedIndex ++;
        }
    } else {
        [self.giftReceiverArray addObject:user];
    }
    SYVoiceRoomGiftView *giftView = [[SYVoiceRoomGiftView alloc] initWithFrame:self.view.bounds
                                                                      isAllMic:NO
                                                                     channelID:self.channelID];
    if (self.userInfoView.isFromMic) {
        [giftView setHighlightedIndex:highlightedIndex];
    }
    giftView.delegate = self;
    giftView.dataSource = self;
    [giftView loadGifts];
    [self.view addSubview:giftView];
    self.giftView = giftView;
    
    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@"", @"position": @"user"};
//    [MobClick event:@"roomGiftClick" attributes:dict];
}

- (void)voiceRoomUserInfoViewDidForbidUserChatWithUser:(SYVoiceChatUserViewModel *)user {
    [self.viewModel forbidUserChatWithUser:user];
}

- (void)voiceRoomUserInfoViewDidCancelForbidUserChatWithUser:(SYVoiceChatUserViewModel *)user {
    [self.viewModel cancelForbidUserChatWithUser:user];
}

- (void)voiceRoomUserInfoViewDidForbidUserEnterWithUser:(SYVoiceChatUserViewModel *)user{
    [self.viewModel forbidUserEnterWithUser:user];
}

- (void)voiceRoomUserInfoViewDidCancelForbidUserEnterWithUser:(SYVoiceChatUserViewModel *)user {
    [self.viewModel cancelForbidUserEnterWithUser:user];
}

- (void)voiceRoomUserInfoViewDidClose {
    self.userInfoView = nil;
}

- (void)voiceRoomUserInfoViewGoToUserHomePageWithUid:(NSString *)uid {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    SYPersonHomepageVC *vc = [[SYPersonHomepageVC alloc] init];
    vc.userId = uid;
    __weak typeof(self) weakSelf = self;
    vc.attentionBlock = ^(NSString * _Nonnull userId, NSString * _Nonnull userName) {
        [weakSelf.viewModel sendFollowUserMessageWithUserId:userId
                                                   username:userName];
        if ([userId isEqualToString:weakSelf.viewModel.liveRoomHost.uid]) {
            [weakSelf.hostIDView setFollowState:YES];
        }
    };
    vc.cancelAttentionBlock = ^(NSString * _Nonnull userId, NSString * _Nonnull userName) {
        if ([userId isEqualToString:weakSelf.viewModel.liveRoomHost.uid]) {
            [weakSelf.hostIDView setFollowState:NO];
        }
    };
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
//    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@"", @"opUser": uid?:@""};
//    [MobClick event:@"roomUserHomeClick" attributes:dict];
}

- (void)voiceRoomUserInfoViewGoToPrivateMessageWithUserId:(NSString *)userId
                                                 username:(NSString *)username
                                                   avatar:(NSString *)avatar
                                              em_username:(NSString *)em_username {
    
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    
    UserProfileEntity *mySelfUserInfo = [UserProfileEntity getUserProfileEntity];
    if ([mySelfUserInfo.userid isEqualToString:userId] && [mySelfUserInfo.username isEqualToString:username]) {
        return;
    }
    UserProfileEntity *user = [UserProfileEntity new];
    user.userid = userId;
    user.em_username = em_username;
    user.avatar_imgurl = avatar;
    user.username = username;
    
    SYConversationListController *rootVC = [[SYConversationListController alloc] init];
    rootVC.usedByPrivateMessage = YES;
    SYNavigationController *nav = [[SYNavigationController alloc] initWithRootViewController:rootVC];
    nav.usedByPrivateMessage = YES;
    [nav setModalPresentationStyle:UIModalPresentationOverFullScreen];
    self.definesPresentationContext = YES;
    // 聊天页面
    SYChatViewController *chatVC = [[SYChatViewController alloc] initWithUserProfileEntity:user];
    chatVC.usedByPrivateMessage = YES;
    NSMutableArray *viewControllers = [nav.viewControllers mutableCopy];
    [viewControllers addObject:chatVC];
    [nav setViewControllers:viewControllers animated:NO];
    [self presentViewController:nav animated:YES completion:nil];
    //    [nav pushViewController:chatVC animated:NO];
}

- (BOOL)voiceRoomUserInfoViewShouldFollowUser {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return NO;
    }
    return YES;
}

- (void)voiceRoomUserInfoViewClickReport:(NSString *)reporterId {
//    [[SYReportManager sharedInstance] SYReportVC:self withVisit:@"名片-举报" withReporterId:reporterId];
}

- (void)voiceRoomUserInfoViewDidFollowUserWithUser:(SYVoiceChatUserViewModel *)user {
    [self.viewModel sendFollowUserMessageWithUser:user];
    SYVoiceChatUserViewModel *host = [self.viewModel usersInMicAtPosition:0];
    if ([user.uid isEqualToString:host.uid]) {
        [self.hostIDView setFollowState:YES];
    }
}

- (void)voiceRoomUserInfoViewDidCancelFollowUserWithUser:(SYVoiceChatUserViewModel *)user {
    SYVoiceChatUserViewModel *host = [self.viewModel usersInMicAtPosition:0];
    if ([user.uid isEqualToString:host.uid]) {
        [self.hostIDView setFollowState:NO];
    }
}

#pragma mark - gift view datasource & delegate

- (NSArray <SYVoiceChatUserViewModel *>*)giftViewReceiversWithGiftView:(SYVoiceRoomGiftView *)giftView {
    return self.giftReceiverArray;
}

- (void)giftViewDidCloseWithGiftView:(SYVoiceRoomGiftView *)giftView {
    //    self.giftReceiverArray = nil;
}

- (void)giftView:(SYVoiceRoomGiftView *)giftView
didGoToCachierWithGiftViewWithCoin:(NSInteger)coin {
    SYMyCoinViewController *coinVC = [[SYMyCoinViewController alloc] init];
    coinVC.coin = [NSString stringWithFormat:@"%@", @(coin)];
    coinVC.roomId = self.channelID;
    __weak typeof(self) weakSelf = self;
    coinVC.resultBlock = ^{
        if (weakSelf.giftView) {
            [weakSelf.giftView loadBalance];
        }
    };
    [self.navigationController pushViewController:coinVC animated:YES];
    
    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@""};
//    [MobClick event:@"roomChargeClick" attributes:dict];
}

- (void)giftView:(SYVoiceRoomGiftView *)giftView
didSendGiftToUser:(SYVoiceChatUserViewModel *)user
          giftID:(NSInteger)giftID
    randomGiftId:(NSInteger)randomGiftId
            nums:(NSInteger)nums {
    [self.viewModel sendGiftMessageWithReceiver:user
                                         giftID:giftID
                                   randomGiftID:randomGiftId
                                           nums:nums];
    SYGiftModel *gift = [[SYGiftInfoManager sharedManager] giftWithGiftID:giftID];
    if (gift) {
        NSInteger categoryID = gift.category_id;
        NSInteger price = gift.price;
        NSString *name = gift.name;
        NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@"", @"giftID": @(giftID), @"giftCategory": @(categoryID), @"giftPrice": @(price), @"giftName": name?:@""};
//        [MobClick event:@"roomGiftSendClick" attributes:dict];
    }
    
    if (gift.price >= [SYSettingManager bossTrigger]) {
        [self.viewModel refreshBossInfo];
    }
}

- (void)giftView:(SYVoiceRoomGiftView *)giftView
didSendRandomGiftWithGiftIDs:(NSArray *)giftIDs
          giftID:(NSInteger)giftID {
    [self.viewModel sendRandomGiftMessageWithGiftIDs:giftIDs
                                              giftID:giftID];
    SYGiftModel *gift = [[SYGiftInfoManager sharedManager] giftWithGiftID:giftID];
    if (gift) {
        NSInteger categoryID = gift.category_id;
        NSInteger price = gift.price;
        NSString *name = gift.name;
        NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@"", @"giftID": @(giftID), @"giftCategory": @(categoryID), @"giftPrice": @(price), @"giftName": name?:@""};
//        [MobClick event:@"roomGiftSendClick" attributes:dict];
    }
}

- (void)giftViewDidFinishSendGift {
    [self.viewModel refreshPKInfo];
}

- (BOOL)giftViewCanSendGiftWithGiftLevel:(NSInteger)giftLevel {
    return self.viewModel.myself.level >= giftLevel;
}

- (BOOL)giftViewShouldOperateUserRelatives {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return NO;
    }
    return YES;
}

- (void)giftViewDidSendGiftToUpdateVIPLevel {
    [self.viewModel requestMyselfInfo];
}

- (void)giftViewLackOfBalance {
    [self voiceRoomInputViewLackOfBalance];
}

#pragma mark - gameview delegate

- (void)voiceRoomFunViewDidSelectGame:(SYVoiceRoomGameType)game {
//    [self.viewModel sendGameMessageWithGame:game isHost:(self.role == SYChatRoomUserRoleHost)];
}

- (void)voiceRoomFunViewDidSelectExpression:(NSInteger)expressionId {
    [self.viewModel sendExpressionWithExpressionID:expressionId];
}

#pragma mark - inputview delegate

- (void)voiceRoomInputViewDidSendText:(NSString *)text {
    [self.viewModel sendTextMessage:text];
}

- (void)voiceRoomInputViewDidSendDanmaku:(NSString *)danmuku
                                 danmuId:(NSInteger)danmuId {
    [self.viewModel sendDanmaku:danmuku danmukuId:danmuId];
    [self.viewModel requestMyselfInfo];
}

- (BOOL)voiceRoomInputViewCanVipDanmakuBeSendWithDanmakuLevel:(NSInteger)level {
    return self.viewModel.myself.level >= level;
}

- (BOOL)voiceRoomInputViewShouldSend {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return NO;
    }
    return YES;
}

- (BOOL)voiceRoomInputViewNeedChildProtect {
    return NO;//[[SYChildProtectManager sharedInstance] needChildProtectWithNavigationController:self.navigationController];
}

- (void)voiceRoomInputViewLackOfBalance {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"余额不足"
                                                                   message:@"请前往充值"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                   }];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去充值"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        SYMyCoinViewController *coinVC = [[SYMyCoinViewController alloc] init];
                                                        coinVC.roomId = self.channelID;
                                                        [coinVC requestMyCoin];
                                                        coinVC.resultBlock = ^{
                                                            if (weakSelf.giftView) {
                                                                [weakSelf.giftView loadBalance];
                                                            }
                                                        };
                                                        [self.navigationController pushViewController:coinVC animated:YES];
                                                    }];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (BOOL)voiceRoomInputViewCanSendDanmaku {
    return ![self.viewModel isMyselfForbiddenChat];
}

#pragma mark -

- (void)voiceRoomMessageFloatViewOpenRoomWithRoomId:(NSString *)roomId {
    if ([self.channelID isEqualToString:roomId]) {
        return;
    }
    if (self.isMyselfHost) {
        self.jumpRoomId = roomId;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要关闭直播吗？"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           self.jumpRoomId = nil;
                                                       }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [[SYLivingAPI shared] closeRoomWithRoomId:self.channelID
                                                                                         successBlock:^(id  _Nullable response) {
                                                                                             [SYSettingManager setLivingChannelID:nil];
                                                                                             [self.viewModel closeChannel];
                                                                                         } failureBlock:^(NSError * _Nullable error) {
                                                                                             [self.viewModel closeChannel];
                                                                                         }];
                                                        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    } else {
        if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCChangeAnotherRoomWithVC:roomId:)]) {
            [self.delegate voiceChatRoomVCChangeAnotherRoomWithVC:self roomId:roomId];
        }
    }
}

#pragma mark -

- (void)giftAnimationRenderHandlerStartAnimation {
    [self.view bringSubviewToFront:self.animationView];
    if (self.messageFloatView.isAnimate) {
        [self.view insertSubview:self.animationView belowSubview:self.messageFloatView];
    }
}

- (BOOL)isAnimationOff {
    return [SYSettingManager isAnimationOff];
}
#pragma mark -

- (void)liveRoomHostViewDidTapUserWithUid:(NSString *)uid {
    [self showUserInfoViewWithUserUid:uid isFromMic:NO micPosition:0];
}

- (BOOL)liveRoomHostViewCanFollowUser {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return NO;
    }
    return YES;
}

- (void)liveRoomHostViewDidFollowUserWithUid:(NSString *)uid
                                    username:(NSString *)username {
    [self.viewModel sendFollowUserMessageWithUserId:uid
                                           username:username];
    SYGiftNetManager *netManager = [SYGiftNetManager new];
    [netManager dailyTaskLog:3];
}
- (void)liveRoomHostViewDidTapShowFansView:(NSDictionary*)dic{
    for (UIView *tmp in self.view.subviews) {
        if ([tmp isKindOfClass:[SYLiveRoomFansView class]]) {
            [tmp removeFromSuperview];
        }
    }
    SYLiveRoomFansView *fansView = [[SYLiveRoomFansView alloc]initWithFrame:[UIScreen mainScreen].bounds isHost:self.isMyselfHost roomData:dic];//
    [[[UIApplication sharedApplication] keyWindow] addSubview:fansView];
}
#pragma mark -

- (void)shareViewDidSelectShareType:(SYShareViewType)type {
    if (type == SYShareViewTypeWeixinSession) {
        [self.viewModel shareRoomToWeixinSession];
    }else if (type == SYShareViewTypeWeixinTimeline) {
        [self.viewModel shareRoomToWeixinTimeLine];
    }
}

#pragma mark - SYVoiceRoomOnlineListViewDelegate

- (void)handleOnlineListViewClickEventWithModel:(SYVoiceRoomUserModel *)model {
    if (model) {
        [self.onlineListView removeFromSuperview];
        self.onlineListView = nil;
        [self showUserInfoViewWithUserUid:model.id isFromMic:NO micPosition:0];
    }
}

- (void)onlineListViewDidFetchOnlineNumber:(NSInteger)num {
    [self setOnlineNumber:num];
    [self.viewModel updateOnlineNumber:num];
}

#pragma mark -

- (void)messageListPopViewDidClose {
    [self.messageListPopView removeFromSuperview];
    self.messageListPopView = nil;
    self.subviewContainer.hidden = NO;
}

#pragma mark -

- (void)liveRoomFinishView_clickInfoBtn {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    __weak typeof(self) weakSelf = self;
    SYPersonHomepageVC *vc = [[SYPersonHomepageVC alloc] init];
    vc.userId = self.viewModel.liveRoomHost.uid;
    vc.attentionBlock = ^(NSString * _Nonnull userId, NSString * _Nonnull userName) {
        [weakSelf.finishView setFollowState:YES];
    };
    vc.cancelAttentionBlock = ^(NSString * _Nonnull userId, NSString * _Nonnull userName) {
        [weakSelf.finishView setFollowState:NO];
    };
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)liveRoomFinishView_clickAddAttentionBtn {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    if (self.finishView.isFollowing) {
        [[SYUserServiceAPI sharedInstance] requestCancelFollowUserWithUid:self.viewModel.liveRoomHost.uid
                                                                  success:^(id  _Nullable response) {
                                                                      [self.finishView setFollowState:NO];
                                                                      [SYToastView showToast:@"取消关注成功"];
                                                                  } failure:^(NSError * _Nullable error) {
                                                                      
                                                                  }];
    } else {
        [[SYUserServiceAPI sharedInstance] requestFollowUserWithUid:self.viewModel.liveRoomHost.uid
                                                            success:^(id  _Nullable response) {
                                                                [self.finishView setFollowState:YES];
                                                                [SYToastView showToast:@"关注成功"];
                                                            } failure:^(NSError * _Nullable error) {
                                                                
                                                            }];
    }
}

- (void)liveRoomFinishView_clickBackBtn {
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
        [self.delegate voiceChatRoomVCForceClosedWithVC:self];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)liveRoomToolView_userCancel {
    self.toolView = nil;
}

- (void)liveRoomToolView_clickBtn:(SYLiveRoomLiveToolViewActionType)type other:(nonnull id)object {
    BOOL hideToolView = YES;
    switch (type) {
        case SYLiveRoomLiveToolViewActionType_biggerFont:
        {
            if (!self.messageListPopView) {
                self.messageListPopView = [[SYLiveBigMessageListPopView alloc] initWithFrame:self.view.bounds];
            }
            [self.view insertSubview:self.messageListPopView
                        aboveSubview:self.subviewContainer];
            self.messageListPopView.dataSource = self;
            self.messageListPopView.delegate = self;
            self.messageListPopView.actionDelegate = self;
            [self.messageListPopView reloadData];
            
            self.subviewContainer.hidden = YES;
        }
            break;
        case SYLiveRoomLiveToolViewActionType_clear:
        {
            hideToolView = NO;
            [self.viewModel clearPublicScreen];
            [self.toolView showToast:@"已清屏"];
        }
            break;
        case SYLiveRoomLiveToolViewActionType_roomInfo:
        {
            SYVoiceChatRoomDetailInfoVC* vc = [[SYVoiceChatRoomDetailInfoVC alloc] init];
            vc.isRoomOwner = (self.viewModel.initialRole == SYChatRoomUserRoleHomeOwner);
            vc.channelId = self.channelID;
            vc.isLiving = YES;
            [self.navigationController pushViewController: vc animated: YES];
        }
            break;
            
        case SYLiveRoomLiveToolViewActionType_beauty: {
            // 美颜
//            [self.videoPushController presentBeautifyController];
            break;
        }
            
        case SYLiveRoomLiveToolViewActionType_mirror: {
            // 镜像
//            BOOL isMirror = [(NSNumber *)object boolValue];
//            [self.videoPushController flipHorizontal:isMirror];
//            hideToolView = NO;
            break;
        }
            
        case SYLiveRoomLiveToolViewActionType_rollback: {
//            // 反转
//            [self.videoPushController switchCamera];
//            hideToolView = NO;
            break;
        }
        case SYLiveRoomLiveToolViewActionType_privateMsg: {
            // 私信
            [self liveRoomToolbarTouchPrivateMessageButton];
            break;
        }
        case SYLiveRoomLiveToolViewActionType_closeAnimation: {
            // 关闭动效
            BOOL isAnimation = [(NSNumber *)object boolValue];
            [self animationSwitchAction:isAnimation];
            hideToolView = NO;
            break;
        }
        case SYLiveRoomLiveToolViewActionType_redpackage: {
            // 群红包
            [self voiceRoomExtViewDidRedPct];
            break;
        }
        case SYLiveRoomLiveToolViewActionType_hide: {
            //榜单隐藏
            BOOL isAnimation = [(NSNumber *)object boolValue];
            [self voiceRoomExtViewDidChartHideAction:isAnimation] ;
            hideToolView = NO;
            break;
        }
        default:
            break;
    }
    if (hideToolView) {
        [self.toolView removeFromSuperview];
        self.toolView = nil;
    }
}


#pragma mark - 聊天室内红包逻辑

// 刷新群红包列表回调
- (void)voiceChatRoomRefreshGroupRedPacketData {
    NSArray *redPacketData = [self.viewModel redPacketCanGetListData];
    if (redPacketData.count > 0) {
        if (self.redPacketView) {
            self.redPacketView.hidden = NO;
            [self.redPacketView updateRedpacketCount:redPacketData.count];
            [self.redPacketView updateRedpacketGetTime:[self.viewModel redPacketCanGetTime]];
        }
        if (self.redPacketGetView && self.redPacketGetView.superview) {
            [self.redPacketGetView updateRecpacketData:redPacketData];
        }
        if (iPhone5) {
            if (self.bossSeatView) {
                self.bossSeatView.hidden = YES;
            }
        }
    } else {
        self.redPacketView.hidden = YES;
        if (self.redPacketGetView) {
            [self.redPacketGetView removeFromSuperview];
            self.redPacketGetView = nil;
        }
        if (iPhone5) {
            if (self.bossSeatView) {
                self.bossSeatView.hidden = NO;
            }
        }
    }
}

// 添加红包到view
- (void)voiceChatRoomRedpacketDataReady {
    NSArray *redPacketData = [self.viewModel redPacketCanGetListData];
    if (!_redPacketView) {
        __weak typeof(self) weakSelf = self;
        CGFloat height = 12 + 1 + 34 + 2 + 10;
        CGFloat y = self.view.sy_height - (iPhoneX ? 84 : 50) - 90 - height;
        CGRect frame = CGRectMake(self.view.sy_width - 46 - 12, y, 46, height);
        _redPacketView = [[SYVoiceRoomRedpacketView alloc] initWithFrame:frame delegate:self withClickBlock:^{
            [weakSelf handleClickRedpacketEvent];
        }];
        [self.view addSubview:self.redPacketView];
        if (self.giftView) {
            [self.view insertSubview:self.redPacketView
                        belowSubview:self.giftView];
        }
    }

    if (redPacketData.count > 0) {
        self.redPacketView.hidden = NO;
        [self.redPacketView updateRedpacketCount:redPacketData.count];
        [self.redPacketView updateRedpacketGetTime:[self.viewModel redPacketCanGetTime]];
        if (iPhone5) {
            if (self.bossSeatView) {
                self.bossSeatView.hidden = YES;
            }
        }
    } else {
        self.redPacketView.hidden = YES;
        [self.redPacketView stopRuningTimer];
        if (iPhone5) {
            if (self.bossSeatView) {
                self.bossSeatView.hidden = NO;
            }
        }
    }
}

// 点击聊天室内运营位上方的红包icon
- (void)handleClickRedpacketEvent {
    if (![self.viewModel isMyselfLogin]) {
        // 抢红包，先登录
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    NSArray *redPacketData = [self.viewModel redPacketCanGetListData];
    NSInteger count = redPacketData.count;
    if (count == 1 && [self.redPacketView canGetRedPacket]) {
        // 单个红包，并且可领取，则直接领取
        SYRoomGroupRedpacketModel *model = [redPacketData objectAtIndex:0];
        [self SYVoiceRoomRedPacketCanGetWindowClickGetBtn:model];
    } else {
        // 多个红包，或者单个红包，但是领取时间没有到，则弹出红包弹窗
        if (!_redPacketGetView) {
            _redPacketGetView = [[SYVoiceRoomRedPacketCanGetWindow alloc] initWithFrame:self.view.bounds];
            _redPacketGetView.delegate = self;
        }
        [self.redPacketGetView updateRecpacketData:redPacketData];
        [self.view addSubview:self.redPacketGetView];
    }
}

// 领取红包接口
- (void)handleGetGroupRedpacket:(NSString *)redPacketId
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure{
    [self.viewModel requestGetRoomGroupRedpacket:redPacketId success:success failure:failure];
}

#pragma mark - SYVoiceRoomRedPacketCanGetWindowDelegate

- (void)SYVoiceRoomRedPacketCanGetWindowClickGetBtn:(id)model {
    if ([model isKindOfClass:[SYRoomGroupRedpacketModel class]]) {
        SYRoomGroupRedpacketModel *clickModel = (SYRoomGroupRedpacketModel *)model;
        [self handleGetGroupRedpacket:clickModel.redbag_id success:^(id  _Nullable response) {
            SYRoomGroupRedpacketGetResultModel *model = (SYRoomGroupRedpacketGetResultModel *)response;
//            [self refreshVoiceRoomGroupRedpacketList];//领取成功，跳转到别的页面，如果返聊天室，就会刷新数据，这里不用刷了
            if (model) {
                if (model.redbag_nums <= 0) {
                    // 该红包个数已被抢光，发送信令，通知所有用户，移除该条数据
                    [self.viewModel sendRoomGroupRedpacketHasGetedEmpty:clickModel.redbag_id roomid:clickModel.room_id ownerId:clickModel.owner_id];
                }
                if (model.result == 1) {
                    // 领取成功，发送领取成功信令
                    UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
                    [self.viewModel sendGetRoomGroupRedpacketSignalling:userInfo.userid
                                                               userName:userInfo.username
                                                      redPacketSenderId:model.owner_id
                                                    redPacketSenderName:model.owner_name
                                                           getCoinCount:model.coins];
                    // 领取成功，跳转成功页
                    SYVoiceRoomGetRedpacketResultVC * vc = [SYVoiceRoomGetRedpacketResultVC new];
                    vc.resultModel = model;
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (model.result == 0) {
                    [SYToastView showToast:@"手慢了，没有抢到哦~"];
                }
            }
        } failure:^(NSError * _Nullable error) {
            if (error) {
                NSInteger code = error.code;
                if (code == 1004) {
                    [SYToastView showToast:@"手慢了，红包已失效"];
                } else {
                    [SYToastView showToast:@"领取失败"];
                }
            } else {
                [SYToastView showToast:@"领取失败"];
            }
            [self refreshVoiceRoomGroupRedpacketList];
            // 领取失败，只有一个数据的时候，直接隐藏红包列表弹窗
            NSArray *redPacketData = [self.viewModel redPacketCanGetListData];
            if (redPacketData.count == 1 && self.redPacketGetView && self.redPacketGetView.superview) {
                [self.redPacketGetView removeFromSuperview];
            }
        }];
    }
}

// 刷新聊天室群红包列表
- (void)refreshVoiceRoomGroupRedpacketList {
    [self.viewModel refreshRoomGroupRedpacketList];
}

- (NSInteger)hasPassedTime {
    return [self.viewModel getHasPassedTimeAfterGetRedPacketListData];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView &&
        scrollView.contentOffset.x < scrollView.sy_width / 2.f) {
        self.recoverButton.hidden = NO;
        return;
    }
    self.recoverButton.hidden = YES;
}

@end
