//
//  SYChatRoomVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomVC.h"
#import "SYVoiceChatRoomViewModel.h"
#import "SYVoiceRoomMicView.h"
#import "SYVoiceChatUserViewModel.h"
#import "SYVoiceRoomToolbar.h"
#import "SYVoiceRoomInputView.h"
#import "SYVoiceRoomApplyMicListView.h"
#import "SYVoiceTextMessageListView.h"
#import "SYVoiceRoomNavBar.h"
#import "SYVoiceRoomIDView.h"
#import "SYVoiceRoomPopularityView.h"
#import "SYVoiceRoomUserInfoView.h"
#import "SYVoiceRoomGiftView.h"
#import "SYVoiceRoomOptionView.h"
#import "SYVoiceChatRoomDetailInfoVC.h"
#import "SYGiftAnimationView.h"
#import "SYGiftInfoManager.h"
#import "SYLeaderboardVC.h"
#import "SYVoiceRoomGiftFloatView.h"
#import "SYVoiceRoomMusicVC.h"
#import "SYVoiceChatRoomUserInfoViewModel.h"
//#import "LetvLBZManager.h"
#import "SYMyCoinViewController.h"
#import "SYVoiceRoomNavTitleView.h"
#import "SYVoiceRoomMessageFloatView.h"
#import "SYVoiceRoomBoardView.h"
#import "SYVoiceRoomOnlineListView.h"
#import "SYVoiceRoomFunView.h"
#import "SYPersonHomepageVC.h"
#import "SYAnimationModel.h"
#import "SYNavigationController.h"
#import "ShiningSdkManager.h"
#import "SYReportManager.h"
#import "SYWebViewController.h"
#import "SYShareView.h"
#import "SYTestWebViewController.h"

#import "SYConversationListController.h"
#import "SYChatViewController.h"
#import "SYVoiceRoomExtView.h"
#import "SYVoiceRoomOperationView.h"
#import "SYVoiceRoomBossView.h"
#import "SYVoiceRoomBossPopView.h"

#import "SYGameBeeViewController.h"
#import "SYChildProtectManager.h"
//#import "HeziSDK.h"
#import "SYVoiceRoomSendRedpacketVC.h"
#import "SYGiftNetManager.h"
#import "SYVoiceRoomRedpacketView.h"
#import "SYVoiceRoomRedPacketCanGetWindow.h"
#import "SYRoomGroupRedpacketModel.h"
#import "SYVoiceRoomGetRedpacketResultVC.h"
#import "SYUserServiceAPI.h"

#define kVoiceRoomOperationButtonStartTag 398929

@interface SYVoiceChatRoomVC () <SYVoiceChatRoomViewModelDelegate, SYVoiceRoomToolbarDelegate, SYVoiceRoomApplyMicListViewDelegate,SYVoiceRoomApplyMicListViewDataSource, SYVoiceRoomMicViewDelegate, SYVoiceRoomInputViewDelegate, SYVoiceTextMessageListViewDataSource, SYVoiceTextMessageListViewDelegate, SYVoiceRoomNavBarDelegate, SYVoiceRoomOptionViewDelegate, SYVoiceRoomUserInfoViewDelegate, SYVoiceRoomUserInfoViewDataSource, SYVoiceRoomGiftViewDelegate, SYVoiceRoomGiftViewDataSource, SYGiftAnimationRenderHandlerDelegate, SYVoiceRoomBoardViewDelegate,SYVoiceRoomOnlineListViewDelegate, SYVoiceRoomFunViewDelegate, SYVoiceRoomMessageFloatViewDelegate, SYShareViewDelegate, SYVoiceRoomExtViewDelegate, SYVoiceRoomBossViewDelegate, SYVoiceRoomBossPopViewDelegate,SYGameBeeDelegate,
    SYVoiceRoomRedpacketViewDelegate,
    SYVoiceRoomRedPacketCanGetWindowDelegate>

@property (nonatomic, assign) SYChatRoomUserRole role;
@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) SYVoiceChatRoomViewModel *viewModel;
@property (nonatomic, assign) NSInteger selectedMicPosition;
@property (nonatomic, strong) NSMutableArray <SYVoiceChatUserViewModel *>*giftReceiverArray;
@property (nonatomic, strong) SYGiftAnimationView *animationView;
@property (nonatomic, strong) SYVoiceRoomGiftFloatView *giftFloatView;
@property (nonatomic, strong) MBProgressHUD *loadingHud;
@property (nonatomic, strong) UIImageView *guideImageView;

@property (nonatomic, strong) NSMutableArray *micViewArray;
@property (nonatomic, strong) SYVoiceRoomToolbar *toolbar;
@property (nonatomic, strong) SYVoiceTextMessageListView *messageListView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) SYVoiceRoomNavBar *navBar;
@property (nonatomic, strong) SYVoiceRoomNavTitleView *navTitleView;
@property (nonatomic, strong) SYVoiceRoomIDView *idView;
@property (nonatomic, strong) SYVoiceRoomPopularityView *popularityView;
@property (nonatomic, strong) UIButton *leftPlayRuleButton;
@property (nonatomic, strong) UIButton *onlineButton;
@property (nonatomic, strong) UIButton *applyMicNumButton; // 排麦数量按钮
@property (nonatomic, strong) UIButton *playButton; // 播放背景音乐按钮
@property (nonatomic, strong) SYVoiceRoomBossView *bossSeatView; // 老板位
@property (nonatomic, strong) SYVoiceRoomBossPopView *bossPopView;
//@property (nonatomic, strong) UIButton *gameButton;
@property (nonatomic, strong) SYVoiceRoomMessageFloatView *messageFloatView;
@property (nonatomic, strong) SYVoiceRoomBoardView *leaderBoardView;
@property (nonatomic, strong) SYVoiceRoomFunView *funView;
@property (nonatomic, strong) SYVoiceRoomExtView *pkView;
@property (nonatomic, strong) SYVoiceRoomOperationView *operationView;  // 运营位view
@property (nonatomic, strong) SYVoiceRoomRedpacketView *redPacketView;  // 聊天室红包view
@property (nonatomic, strong) SYVoiceRoomRedPacketCanGetWindow *redPacketGetView;   // 聊天室领取红包View
// 弹出view
@property (nonatomic, strong) SYVoiceRoomApplyMicListView *applyMicListView;
@property (nonatomic, strong) SYVoiceRoomUserInfoView *userInfoView;
@property (nonatomic, strong) SYVoiceRoomGiftView *giftView;
@property (nonatomic, strong) CALayer *animationLayer;
@property (nonatomic, strong) SYVoiceRoomInputView *inputView;
@property (nonatomic, strong) SYVoiceRoomOnlineListView *onlineListView;

@property (nonatomic, strong) SYVoiceRoomMusicVC *musicVC;

@property (nonatomic, strong) SYGameBeeViewController *beeVC;


@end

@implementation SYVoiceChatRoomVC

- (void)dealloc {
    NSString *position = ([self.view superview]) ? @"direct" : @"float";
    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@"", @"position": position};
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

- (NSString *)roomName {
    return self.viewModel.roomInfo.roomName;
}

- (NSString *)roomIcon {
    return self.viewModel.roomInfo.roomIcon;
}

- (void)leaveChannel {
    [self.viewModel leaveChannel];
    if (self.musicVC) {
        [self.musicVC reset];
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
    self = [super init];
    if (self) {
        _titleString = title;
        _selectedMicPosition = 0;
        _channelID = channelID;
        _viewModel = [[SYVoiceChatRoomViewModel alloc] initWithChannelID:channelID
                                                                password:password];
        _viewModel.delegate = self;
        _micViewArray = [NSMutableArray arrayWithCapacity:7];
    }
    return self;
}

- (void)drawView {
    [self drawMicUserViews];
    
    [self.view addSubview:self.toolbar];
    SYVoiceChatRoomMicConfig micConfig = self.viewModel.roomInfo.micConfig;
    if (micConfig == SYVoiceChatRoomMicConfig0) {
        [self.toolbar hideApplyMicButton];
    }
    [self.toolbar changeUserRole:self.role];
    [self.toolbar changeApplyMicState:[self.viewModel isMyselfContainsInApplyMicList]];
    [self.toolbar setHasUnreadMessage:self.viewModel.hasUnreadMessage];
    SYVoiceChatUserViewModel *myself = self.viewModel.myself;
    if (myself) {
        [self.toolbar changeMicState:myself.isMuted];
    }
    [self.toolbar setPKFuncEnable:YES];
    [self.view addSubview:self.messageListView];
//    [self.view addSubview:self.gameButton];
    [self.view addSubview:self.giftFloatView];
    [self.view addSubview:self.messageFloatView];
    [self.view addSubview:self.leaderBoardView];
}

- (void)drawRoomInfoViews {
    BOOL showOnlineSwitch = [SYSettingManager voiceRoomShowOnline];
    BOOL needShowOnlineNum = showOnlineSwitch || (self.role >= SYChatRoomUserRoleHost || self.role == SYChatRoomUserRoleCommunity);
    
    if (!self.leftPlayRuleButton.superview) {
        [self.view addSubview:self.leftPlayRuleButton];
        if (needShowOnlineNum) {
            self.leftPlayRuleButton.sy_top = self.leftPlayRuleButton.sy_top - 16.f;
        }
    }

    if (!self.onlineButton.superview) {
        [self.view addSubview:self.onlineButton];
    }
    self.onlineButton.hidden = !needShowOnlineNum;
    NSString *online = [NSString stringWithFormat:@"%ld人在线", (long)self.viewModel.roomInfo.userNum];
    [self setOnlineNumberString:online];
//    [self.navBar setTitle:self.viewModel.roomInfo.roomName];
    
    if (!self.applyMicNumButton.superview && self.viewModel.roomInfo.micConfig != SYVoiceChatRoomMicConfig0) {
        [self.view addSubview:self.applyMicNumButton];
    }

    [self.navTitleView setTitle:self.viewModel.roomInfo.roomName
                           type:self.viewModel.roomInfo.categoryName
                         roomID:self.viewModel.roomInfo.roomID
                            hot:[NSString stringWithFormat:@"%ld", (long)self.viewModel.roomInfo.roomScore]];
    
    CGFloat top = iPhoneX ? 88.f : 64.f;
    top += 126.f;
    if (self.viewModel.roomInfo.micConfig == SYVoiceChatRoomMicConfig0) {
        self.leftPlayRuleButton.layer.mask = nil;
        self.leftPlayRuleButton.sy_width = 56.f;
        self.leftPlayRuleButton.sy_right = self.view.sy_width - 20.f;
        self.leftPlayRuleButton.sy_top = top;
        self.leftPlayRuleButton.layer.cornerRadius = self.leftPlayRuleButton.sy_height / 2.f;
        
        self.onlineButton.layer.mask = nil;
        self.onlineButton.layer.cornerRadius = self.onlineButton.sy_height / 2.f;
        self.onlineButton.sy_top = top;
        self.onlineButton.sy_right = self.leftPlayRuleButton.sy_left - 10.f;
    }
    
    self.backgroundImageView.image = [UIImage imageNamed_sy:self.viewModel.roomInfo.roomBackgroundImage];
}

- (void)drawMicUserViews {
    CGFloat width = 80.f;
    CGFloat height = 96.f;
    CGFloat x = (self.view.bounds.size.width - width) / 2.f;
    CGFloat y = iPhoneX ? 88.f : 64.f;
    y += 23.f;
    SYVoiceRoomMicViewStyle micStyle = SYVoiceRoomMicViewStyleHost;
    SYVoiceChatRoomMicConfig micConfig = self.viewModel.roomInfo.micConfig;
    if (micConfig == SYVoiceChatRoomMicConfig0) {
        y += 6.f;
        x = 24.f;
        width = self.view.sy_width - x - 140.f;
        if (self.view.sy_width < 370.f) {
            width += 20.f;
        }
        height = 84.f;
        micStyle = SYVoiceRoomMicViewStyleSingleHost;
    }
    SYVoiceRoomMicView *hostView = [[SYVoiceRoomMicView alloc] initWithFrame:CGRectMake(x, y, width, height) style:micStyle position:0];
    hostView.delegate = self;
    SYVoiceChatUserViewModel *host = [self.viewModel usersInMicAtPosition:0];
    [hostView drawWithUserViewModel:host];
    [self.view addSubview:hostView];
    [self.micViewArray addObject:hostView];
    
    [self drawPlayButton];
    
    NSInteger totalMicCount = 0;
    width = 80.f;
    CGFloat padding = 0.f;
    NSInteger rowCount = 3;
    if (micConfig == SYVoiceChatRoomMicConfig6) {
        x = 30.f;
        totalMicCount = 6;
        padding = (self.view.sy_width - x * 2 - width * 3) / 2.f;
    } else if (micConfig == SYVoiceChatRoomMicConfig8) {
        totalMicCount = 8;
        x = 10.f;
        width = MIN(80.f, (self.view.sy_width - 20.f) / 4.f);
        padding = (self.view.sy_width - x * 2 - width * 4) / 3.f;
        rowCount = 4;
    } else {
        return;
    }
    y = height + y;
    height = 94;
    for (int i = 0; i < totalMicCount; i ++) {
        NSInteger remain = i % rowCount;
        NSInteger row = i / rowCount;
        CGFloat originX = x + remain * width + remain * padding;
        CGFloat originY = y + row * height;
        SYVoiceRoomMicView *micView = [[SYVoiceRoomMicView alloc] initWithFrame:CGRectMake(originX, originY, width, height) style:SYVoiceRoomMicViewStyleOrdinary position:i+1];
        SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:i+1];
        if (i == totalMicCount - 1) {
            user.bossMic = YES;
        }
        [micView drawWithUserViewModel:user];
        [self.view addSubview:micView];
        [self.micViewArray addObject:micView];
        micView.delegate = self;
    }
}

- (void)drawPlayButton {
    if (self.role == SYChatRoomUserRoleHost) {
        if (self.playButton.superview == nil) {
            [self.view addSubview:self.playButton];
        }
        if (self.viewModel.roomInfo.micConfig == SYVoiceChatRoomMicConfig0) {
            self.playButton.sy_top = self.leftPlayRuleButton.sy_top;
            self.playButton.sy_right = self.onlineButton.sy_left - 10.f;
        } else {
            if ([self.micViewArray count] > 0) {
                SYVoiceRoomMicView *hostView = [self.micViewArray objectAtIndex:0];
                CGRect frame = self.playButton.frame;
                frame.origin.x = CGRectGetMinX(hostView.frame) - 50.f;
                frame.origin.y = 103.f;
                if (iPhoneX) {
                    frame.origin.y += 22.f;
                }
                self.playButton.frame = frame;
            }
        }
    } else {
        [self.playButton removeFromSuperview];
    }
}

- (SYVoiceRoomToolbar *)toolbar {
    if (!_toolbar) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = iPhoneX ? 50.f + 34.f : 50.f;
        CGFloat originY = self.view.bounds.size.height - height;
        _toolbar = [[SYVoiceRoomToolbar alloc] initWithFrame:CGRectMake(0, originY, width, height)];
        _toolbar.delegate = self;
    }
    return _toolbar;
}

- (SYVoiceTextMessageListView *)messageListView {
    if (!_messageListView) {
//        SYVoiceRoomMicView *view = [self.micViewArray lastObject];
//        CGFloat originY = CGRectGetMaxY(view.frame);
        CGFloat originY = iPhoneX ? 88.f : 64.f;
        originY += 23.f;
        originY += 96.f;
        if (self.viewModel.roomInfo.micConfig == SYVoiceChatRoomMicConfig0) {
            originY += 56.f;
        } else {
            originY += (94.f * 2);
        }
        CGFloat height = CGRectGetMinY(self.toolbar.frame) - originY;
        _messageListView = [[SYVoiceTextMessageListView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, height)];
        _messageListView.dataSource = self;
        _messageListView.delegate = self;
    }
    return _messageListView;
}

- (SYVoiceRoomGiftFloatView *)giftFloatView {
    if (!_giftFloatView) {
        _giftFloatView = [[SYVoiceRoomGiftFloatView alloc] initWithFrame:CGRectMake(0, 400, self.view.sy_width, 50)];
    }
    return _giftFloatView;
}

- (SYVoiceRoomMessageFloatView *)messageFloatView {
    if (!_messageFloatView) {
        CGFloat y = iPhoneX ? 72.f : 48.f;
        _messageFloatView = [[SYVoiceRoomMessageFloatView alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, 26.f + 16.f)];
        _messageFloatView.delegate = self;
    }
    return _messageFloatView;
}

- (SYVoiceRoomBoardView *)leaderBoardView {
    if (!_leaderBoardView) {
        CGFloat x = self.view.sy_width / 2.f + 50.f;
        CGFloat width = self.view.sy_width - x;
        if (width < [SYVoiceRoomBoardView minimumWidth]) {
            width = [SYVoiceRoomBoardView minimumWidth];
            x = self.view.sy_width - width;
        }
        CGFloat y = iPhoneX ? 88.f : 64.f;
        y += 54.f;
        _leaderBoardView = [[SYVoiceRoomBoardView alloc] initWithFrame:CGRectMake(x, y, width, 36)
                                                             channelID:self.channelID];
        _leaderBoardView.delegate = self;
        [_leaderBoardView requestData];
    }
    return _leaderBoardView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.image = [UIImage imageNamed_sy:@"voiceroom_bg_0"];
    }
    return _backgroundImageView;
}

- (SYVoiceRoomNavBar *)navBar {
    if (!_navBar) {
        CGFloat height = iPhoneX ? 88.f : 64.f;
        _navBar = [[SYVoiceRoomNavBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
        _navBar.delegate = self;
    }
    return _navBar;
}

- (SYVoiceRoomNavTitleView *)navTitleView {
    if (!_navTitleView) {
        _navTitleView = [[SYVoiceRoomNavTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.sy_width - 100, 44.f)];
    }
    return _navTitleView;
}

- (SYVoiceRoomIDView *)idView {
    if (!_idView) {
        _idView = [[SYVoiceRoomIDView alloc] initWithFrame:CGRectMake(0, 92.f, 68.f, 24.f)];
    }
    return _idView;
}

- (SYVoiceRoomPopularityView *)popularityView {
    if (!_popularityView) {
        _popularityView = [[SYVoiceRoomPopularityView alloc] initWithFrame:CGRectMake(0, 122.f, 78.f, 24.f)];
    }
    return _popularityView;
}

- (UIButton *)leftPlayRuleButton {
    if (!_leftPlayRuleButton) {
        _leftPlayRuleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = 106.f;
        if (iPhoneX) {
            y += 24.f;
        }
        _leftPlayRuleButton.frame = CGRectMake(0, y, 55.f, 24.f);
        _leftPlayRuleButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_leftPlayRuleButton addTarget:self action:@selector(selectPlayRule)
                     forControlEvents:UIControlEventTouchUpInside];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = _leftPlayRuleButton.bounds;
        CGFloat radius = 12.f;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:_leftPlayRuleButton.bounds
                                           byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                 cornerRadii:CGSizeMake(radius, radius)].CGPath;
        _leftPlayRuleButton.layer.mask = layer;
        
        [_leftPlayRuleButton setImage:[UIImage imageNamed_sy:@"voiceroom_louder"]
                            forState:UIControlStateNormal];
        [_leftPlayRuleButton setTitle:@"玩法" forState:UIControlStateNormal];
        _leftPlayRuleButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_leftPlayRuleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
    }
    return _leftPlayRuleButton;
}

- (UIButton *)onlineButton {
    if (!_onlineButton) {
        CGFloat y = 122.f;
        if (iPhoneX) {
            y += 24;
        }
        _onlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _onlineButton.frame = CGRectMake(0, y, 70.f, 24);
        _onlineButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_onlineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _onlineButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_onlineButton addTarget:self action:@selector(openOnline:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _onlineButton;
}

- (UIButton *)applyMicNumButton {
    if (!_applyMicNumButton) {
        _applyMicNumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyMicNumButton.frame = CGRectMake(0, self.onlineButton.sy_bottom + 8.f, 70.f, 24);
        _applyMicNumButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_applyMicNumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyMicNumButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
        _applyMicNumButton.hidden = YES;
//        [_onlineButton addTarget:self action:@selector(openOnline:)
//                forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyMicNumButton;
}

- (void)setOnlineNumberString:(NSString *)string {
    [self.onlineButton setTitle:string forState:UIControlStateNormal];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: self.onlineButton.titleLabel.font}
                                       context:nil];
    self.onlineButton.sy_width = rect.size.width + 16.f;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.onlineButton.bounds
                                       byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight
                                             cornerRadii:CGSizeMake(12.f, 12.f)].CGPath;
    layer.frame = self.onlineButton.bounds;
    self.onlineButton.layer.mask = layer;
}

- (void)setApplyMicUserNum:(NSInteger)num {
    num = MAX(num, 0);
    NSString *string = [NSString stringWithFormat:@"%ld人排麦", (long)num];
    [self.applyMicNumButton setTitle:string forState:UIControlStateNormal];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(999, 20) options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: self.applyMicNumButton.titleLabel.font}
                                       context:nil];
    self.applyMicNumButton.sy_width = rect.size.width + 16.f;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = [UIBezierPath bezierPathWithRoundedRect:self.applyMicNumButton.bounds
                                       byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight
                                             cornerRadii:CGSizeMake(12.f, 12.f)].CGPath;
    layer.frame = self.applyMicNumButton.bounds;
    self.applyMicNumButton.layer.mask = layer;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(0, 0, 26, 26);
        [_playButton setImage:[UIImage imageNamed_sy:@"voiceroom_music"]
                     forState:UIControlStateNormal];
        [_playButton addTarget:self
                        action:@selector(playMusic:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIImageView *)guideImageView {
    if (!_guideImageView) {
        _guideImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _guideImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissGuide:)];
        [_guideImageView addGestureRecognizer:tap];
        if (iPhoneX) {
            _guideImageView.image = [UIImage imageNamed_sy:@"voiceroom_guide_x"];
        } else {
            _guideImageView.image = [UIImage imageNamed_sy:@"voiceroom_guide"];
        }
    }
    return _guideImageView;
}

//- (UIButton *)gameButton {
//    if (!_gameButton) {
//        _gameButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _gameButton.frame = CGRectMake(self.view.sy_width - 13.f - 46.f, self.toolbar.sy_top - 23.f - 46.f, 46, 46);
//        [_gameButton setImage:[UIImage imageNamed_sy:@"voiceroom_game"]
//                     forState:UIControlStateNormal];
//        [_gameButton addTarget:self
//                        action:@selector(playGame:)
//              forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _gameButton;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.backgroundImageView];
    
    [self sy_configDataInfoPageName:SYPageNameType_VoiceRoom];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.opacity = 0.7;
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    self.loadingHud = hud;
    [self.view addSubview:self.navBar];
    [self.navBar setTitleView:self.navTitleView];
//    [self.navBar setTitle:self.titleString];
    [self.viewModel startProcess];
    
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#ifdef ShiningSdk
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#endif
    [self sy_setStatusBarLight];
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma arguments - unReadMessageNotification

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
}

#pragma mark - private method

- (void)selectPlayRule {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"玩法说明"
//                                                                   message:self.viewModel.roomInfo.roomDesc
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的"
//                                                     style:UIAlertActionStyleDefault
//                                                   handler:^(UIAlertAction * _Nonnull action) {
//
//                                                   }];
//    [alert addAction:action];
//    [self presentViewController:alert
//                       animated:YES
//                     completion:nil];
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

- (void)playMusic:(id)sender {
    SYVoiceRoomMusicVC *vc = [SYVoiceRoomMusicVC sharedVC];
    self.musicVC = vc;
    vc.playControlDelegate = [self.viewModel playControlInstance];
    [self.navigationController pushViewController:vc animated:YES];
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
}

- (void)enterForeground:(id)sender {
    if (self.view.superview) {
        // 不是浮球状态
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
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

- (BOOL)checkUserMicphonePermission {
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    BOOL canRecord = (permission == AVAudioSessionRecordPermissionGranted ||
                      permission == AVAudioSessionRecordPermissionUndetermined);
    if (!canRecord) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您没有麦克风权限"
                                                                       message:@"请开启麦克风权限"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去开启"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
    return canRecord;
}

- (void)dismissGuide:(id)sender {
    if (_guideImageView) {
        [self.guideImageView removeFromSuperview];
        self.guideImageView.image = nil;
    }
}

#pragma mark - ViewModel delegate method

- (void)voiceChatRoomDidGetMyRole:(SYChatRoomUserRole)role {
    self.role = role;
    [self drawPlayButton];
}

- (void)voiceChatRoomInfoDataReady {
    [self drawRoomInfoViews];
}

- (void)voiceChatRoomDataPrepared {
    [self drawView];
    [self.loadingHud hide:YES];
    self.loadingHud = nil;
    
    [self setApplyMicUserNum:[self.viewModel usersCountInApplyMicList]];
    self.applyMicNumButton.hidden = !(self.role >= SYChatRoomUserRoleHost ||
                                      self.role == SYChatRoomUserRoleCommunity);


    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@"", @"from": self.from?:@""}];
    if (self.reportInfo && self.reportInfo.count > 0) {
        [dict addEntriesFromDictionary:self.reportInfo];
    }
//    [MobClick event:@"roomJoin" attributes:dict];
}

- (void)voiceChatRoomUpdateToolBar {
    if (_toolbar) {
        [self.toolbar changeUserRole:self.role];
        [self.toolbar changeApplyMicState:[self.viewModel isMyselfContainsInApplyMicList]];
        SYVoiceChatUserViewModel *myself = self.viewModel.myself;
        if (myself) {
            [self.toolbar changeMicState:myself.isMuted];
        }
        [self.toolbar setPKFuncEnable:YES];
    }
}

- (void)voiceChatRoomDataError:(SYVoiceChatRoomError)error {
    switch (error) {
        case SYVoiceChatRoomErrorForbiddenEnter:
        {
            [SYToastView showToast:@"您已被管理员禁入此房间"];
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
            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
                [self.delegate voiceChatRoomVCForceClosedWithVC:self];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case SYVoiceChatRoomErrorRoomClosed:
        {
            [SYToastView showToast:@"此房间已关闭"];
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

- (void)voiceChatRoomUserInMicChangedWithUser:(SYVoiceChatUserViewModel *)user
                                     position:(NSInteger)position
                                      isUpMic:(BOOL)isUpMic {
    if (position >= 0 && position < [self.micViewArray count]) {
        if (position > 0 && position == [self.micViewArray count] - 1) {
            user.bossMic = YES;
        }
        SYVoiceRoomMicView *micView = self.micViewArray[position];
        [micView drawWithUserViewModel:user];
        if (!isUpMic) {
            [micView removeSpeakerAudioWave];
        }
    }
    if (self.applyMicListView && isUpMic) {
        [self.applyMicListView reloadData];
    }
    [self setApplyMicUserNum:[self.viewModel usersCountInApplyMicList]];
    [self.toolbar changeUserRole:self.role];
    [self.toolbar changeApplyMicState:[self.viewModel isMyselfContainsInApplyMicList]];
    SYVoiceChatUserViewModel *myself = self.viewModel.myself;
    if (myself) {
        [self.toolbar changeMicState:myself.isMuted];
        if (!isUpMic && position == 0 && [myself.uid isEqualToString:user.kickedUid]) {
            if (self.musicVC) {
                [self.musicVC reset];
            }
        }
    }
    if (!isUpMic) {
        [self.userInfoView reloadIskickedFromMicWithUid:user.kickedUid];
    }
    
    
}

- (void)voiceChatRoomUserInMicMuteStateChangedWithState:(BOOL)isMuted
                                               position:(NSInteger)position {
    if (position >= 0 && position < [self.micViewArray count]) {
        SYVoiceRoomMicView *micView = self.micViewArray[position];
        [micView changeMuteState:isMuted];
        SYVoiceChatUserViewModel *myself = self.viewModel.myself;
        if (myself) {
            [self.toolbar changeMicState:myself.isMuted];
        }
        if (self.userInfoView) {
            [self.userInfoView reloadMuteState];
        }
    }
}

- (void)voiceChatRoomUsersInMicDidChanged {
    NSInteger count = [self.micViewArray count];
    if (count > 0) {
        for (int i = 0; i < count; i ++) {
            SYVoiceRoomMicView *micView = [self.micViewArray objectAtIndex:i];
            SYVoiceChatUserViewModel *viewModel = [self.viewModel usersInMicAtPosition:i];
            if (viewModel) {
                if (count > 1 && i == count - 1) {
                    viewModel.bossMic = YES;
                }
                [micView drawWithUserViewModel:viewModel];
            }
        }
    }
}

- (void)voiceChatRoomUserInApplyMicListChanged {
    [self.applyMicListView reloadData];
    [self setApplyMicUserNum:[self.viewModel usersCountInApplyMicList]];
    [self.toolbar changeApplyMicState:[self.viewModel isMyselfContainsInApplyMicList]];
}

- (void)voiceChatRoomDidReceivePublicScreenMessage {
    if (_messageListView) {
        [self.messageListView reloadData];
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
    
    // 麦位动画
    if (message.messageType == SYVoiceTextMessageTypeGift && message.receiverUid) {
        NSInteger micPosition = [self.viewModel userMicPositionInMicListWithUid:message.receiverUid];
        if (micPosition != NSNotFound && micPosition >= 0 && micPosition < [self.micViewArray count]) {
            SYGiftModel *gift = [[SYGiftInfoManager sharedManager] giftWithGiftID:message.giftId];
            if ([NSString sy_isBlankString:gift.animation]) {
                // 无动画，走麦位
                SYVoiceRoomMicView *micView = [self.micViewArray objectAtIndex:micPosition];
                [micView showGiftAnimationWithImageUrl:message.giftURL];
            }
        }
    }
}

- (void)voiceChatRoomUserIsForbiddenChatWithUid:(NSString *)uid {
    if (self.userInfoView) {
        [self.userInfoView reloadForbidChatState:YES
                                             uid:uid];
    }
}

- (void)voiceChatRoomUserCancelForbiddenChatWithUid:(NSString *)uid {
    if (self.userInfoView) {
        [self.userInfoView reloadForbidChatState:NO
                                             uid:uid];
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

- (void)voiceChatRoomDidCloseChannel {
    [self leaveChannel];
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
        [self.delegate voiceChatRoomVCForceClosedWithVC:self];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)voiceChatRoomDidIndicateSpeakersInMicPositions:(NSArray <NSNumber *>*)positions
                                              isMyself:(BOOL)isMyself {
    // 检测到麦上说话位置
    for (int i = 0; i < [self.micViewArray count]; i ++) {
        SYVoiceRoomMicView *micView = self.micViewArray[i];
        if ([positions containsObject:@(i)]) {
            [micView drawSpeakerAudioWave];
        }
    }
}

- (void)voiceChatRoomDidReceiveGiftWithGiftID:(NSInteger)giftID
                                randomGiftIDs:(nonnull NSArray *)randomGiftIDs
                                   withSender:(nonnull SYVoiceRoomUser *)sender
                                 withReciever:(nonnull SYVoiceRoomUser *)reciever
{
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

- (void)voiceChatRoomDidStartGameWithMicPosition:(NSInteger)position
                                            game:(SYVoiceRoomGameType)game
                                  gameImageNames:(NSArray *)gameImageNames
                                 resultImageName:(NSString *)resultImageName {
    SYVoiceRoomMicView *view = [self.micViewArray objectAtIndex:position];
    NSMutableArray *images = [NSMutableArray new];
    for (NSString *imageName in gameImageNames) {
        UIImage *image = [UIImage imageNamed_sy:imageName];
        if (image) {
            [images addObject:image];
        }
    }
    NSInteger repeat = 3;
    if (game == SYVoiceRoomGameNumber) {
        repeat = 2.f;
    }
    [view showGameImages:images repeatTime:repeat result:resultImageName];
}

- (void)voiceChatRoomDidReceiveExpressionWithPosition:(NSInteger)position
                                     expressionImages:(NSArray <UIImage *>*)expressionImages {
    if (position >= 0 && position < [self.micViewArray count]) {
        SYVoiceRoomMicView *view = [self.micViewArray objectAtIndex:position];
        [view showExpressionImages:expressionImages];
    }
}

- (void)voiceChatRoomDidFetchRoomHotScore:(NSInteger)score {
    [self.navTitleView updateHot:score];
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
        [self.view addSubview:self.operationView];
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
    
    if ([SYSettingManager isVoiceRoomFirstEnter]) {
        [SYSettingManager setOffVoiceRoomFirstEnterFlag];
        [self.view addSubview:self.guideImageView];
    }
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
    }else if(operationViewModel.operationType == SYVoiceRoomOperationTypeCheckIn) {
        [self triggerWithEvent:@"checkin"];
    }
}

-(void)triggerWithEvent:(NSString *)event
{
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    NSString *mobile = ![NSString sy_isBlankString: user.mobile]?user.mobile:@"13800138000";
//    [HeziTrigger trigger:event userInfo:@{@"username":user.userid?:@"",@"mobile":mobile}  showIconInView:self.view rootController:self delegate:self shareBlock:^(HeziShareModel *sharemodel) {
//        NSLog(@"sharemodel titkle==%@",sharemodel.title);
//    }];
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

#pragma mark --

- (void)voiceChatRoomDidReceiveOverScreenMessage:(SYVoiceTextMessageViewModel *)message {
    [self.messageFloatView addMessage:message];
    [self.view bringSubviewToFront:self.messageFloatView];
}

- (void)voiceChatRoomOnlineUserNumberDidChangedWithNumber:(NSInteger)number myself:(BOOL)isMyself {
    NSString *online = [NSString stringWithFormat:@"%ld人在线", number];
    [self setOnlineNumberString:online];
}

- (void)voiceChatRoomPKStatusChanged {
    if (self.pkView) {
        [self.pkView setVoiceViewModel:self.viewModel];
    }
}

- (void)voiceChatRoomDidCheckUnreadMessage:(BOOL)hasUnread {
    if (_toolbar) {
        [self.toolbar setHasUnreadMessage:self.viewModel.hasUnreadMessage];
    }
}

- (void)voiceChatRoomBossStatusChanged {
    if (!self.bossSeatView) {
        self.bossSeatView = [[SYVoiceRoomBossView alloc] initWithFrame:CGRectMake(self.view.sy_width - 82.f, self.messageListView.sy_top + 6.f, 66.f, 66.f)];
        self.bossSeatView.delegate = self;
        [self.view addSubview:self.bossSeatView];
        if (self.giftView) {
            [self.view insertSubview:self.bossSeatView
                        belowSubview:self.giftView];
        }
    }
    
    [self.bossSeatView showWithBossViewModel:self.viewModel.bossViewModel];
    if (self.bossPopView) {
        [self.bossPopView showWithBossViewModel:self.viewModel.bossViewModel];
    }
    if (self.redPacketView && self.redPacketView.hidden == NO) {
        self.bossSeatView.hidden = YES;
    }
}

#pragma mark - board view delegate

- (void)voiceRoomBoardViewDidEnterLeaderBoard {
    SYLeaderboardVC *vc = [[SYLeaderboardVC alloc] initWithChannelID:self.channelID];
    __weak typeof(self) weakSelf = self;
    vc.followSuccessBlock = ^(NSString * _Nonnull userId, NSString * _Nonnull userName) {
        [weakSelf.viewModel sendFollowUserMessageWithUserId:userId
                                                   username:userName];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)voiceRoomBoardViewDidTouchUserWithUid:(NSString *)uid {
    [self showUserInfoViewWithUserUid:uid
                            isFromMic:NO
                          micPosition:0];
}

#pragma mark - userinfo view delegate

- (void)voiceRoomMicViewDidSelectMic:(SYVoiceRoomMicView *)micView
                             atIndex:(NSInteger)index {
    if (micView.isOccupied) {
        SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:index];
        [self showUserInfoViewWithUserUid:user.uid isFromMic:YES micPosition:index];
    } else {
        if (self.viewModel.initialRole >= SYChatRoomUserRoleAdminister) {
            if (index == 0) {
                if ([self.viewModel isMyselfContainsInApplyMicList]) {
                    [self.viewModel changeMyselfFromOtherToHost];
                } else if (self.role == SYChatRoomUserRoleBroadcaster) {
                    [self.viewModel changeMyselfFromOtherToHost];
                } else {
                    if (![self checkUserMicphonePermission]) {
                        return;
                    }
                    [self.viewModel confirmMyselfHost];
                }
            } else {
                self.selectedMicPosition = index;
                SYVoiceRoomMicView *micView = [self.micViewArray objectAtIndex:index];
                CGPoint pointer = CGPointMake(CGRectGetMidX(micView.frame), CGRectGetMinY(micView.frame) + CGRectGetWidth(micView.frame));
                SYVoiceRoomOptionView *optionView = [[SYVoiceRoomOptionView alloc] initWithFrame:self.view.bounds showAtPoint:pointer micIndex:index];
                optionView.delegate = self;
                SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:index];
                [optionView setMutedState:user.isMuted];
                [self.view addSubview:optionView];
            }
        } else if (self.role <= SYChatRoomUserRoleCommunity) {
            // 普通听众，点击空麦位如同点击排麦按钮
            if (!self.applyMicListView) {
                [self voiceRoomToolbarTouchSeatButton];
            }
        }
//        if (index == 0 && self.role >= SYChatRoomUserRoleAdminister) {
//            // 点击空主持人位
//            if ([self.viewModel isMyselfContainsInApplyMicList]) {
//                [self.viewModel changeMyselfFromOtherToHost];
//            } else {
//                [self.viewModel confirmMyselfHost];
//            }
//        } else if (index == 0 && self.role == SYChatRoomUserRoleBroadcaster &&
//                   self.viewModel.initialRole >= SYChatRoomUserRoleAdminister) {
//            [self.viewModel changeMyselfFromOtherToHost];
//        } else if (self.viewModel.initialRole >= SYChatRoomUserRoleHost) {
//            self.selectedMicPosition = index;
//            SYVoiceRoomMicView *micView = [self.micViewArray objectAtIndex:index];
//            CGPoint pointer = CGPointMake(CGRectGetMidX(micView.frame), CGRectGetMinY(micView.frame) + CGRectGetWidth(micView.frame));
//            SYVoiceRoomOptionView *optionView = [[SYVoiceRoomOptionView alloc] initWithFrame:self.view.bounds showAtPoint:pointer micIndex:index];
//            optionView.delegate = self;
//            SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:index];
//            [optionView setMutedState:user.isMuted];
//            [self.view addSubview:optionView];
//        }
    }
}

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

#pragma mark - optionview delegate

- (void)voiceRoomOptionViewDidSelectConfirmMicAtIndex:(NSInteger)index {
    [self voiceRoomToolbarTouchSeatButton];
}

- (void)voiceRoomOptionViewDidSelectMuteMicAtIndex:(NSInteger)index {
    self.selectedMicPosition = 0;
    BOOL isMuted = NO;
    SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:index];
    if (user) {
        isMuted = user.isMuted;
    }
    if (isMuted) {
        if (index == 0) {
            [self.viewModel cancelMuteHostMicAtMicPosition:index];
        } else {
            [self.viewModel cancelMuteMicAtMicPosition:index];
        }
    } else {
        if (index == 0) {
            [self.viewModel muteHostMicAtMicPostion:index];
        } else {
            [self.viewModel muteMicAtMicPostion:index];
        }
    }
}

- (void)voiceRoomOptionViewDidCancel {
    self.selectedMicPosition = 0;
}

#pragma mark - toolbar delegate method

- (void)voiceRoomToolbarTouchInputButton {
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

- (void)voiceRoomToolbarTouchSeatButton {
    if (self.viewModel.roomInfo.micConfig == SYVoiceChatRoomMicConfig0) {
        return;
    }
    SYVoiceRoomApplyMicListView *view = [[SYVoiceRoomApplyMicListView alloc] initWithFrame:self.view.bounds];
    view.dataSource = self;
    view.delegate = self;
    [self.view addSubview:view];
    self.applyMicListView = view;
    [view reloadData];
}

- (void)voiceRoomToolbarTouchMicButton {
    if (self.viewModel.myself.isMuted) {
        [self.viewModel cancelMuteMyself];
    } else {
        [self.viewModel muteMyself];
    }
}

- (void)voiceRoomToolbarTouchGiftButton {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    self.giftReceiverArray = [NSMutableArray new];
    for (SYVoiceRoomMicView *micView in self.micViewArray) {
        if (micView.isOccupied) {
            NSInteger index = [self.micViewArray indexOfObject:micView];
            SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:index];
            [self.giftReceiverArray addObject:user];
        }
    }
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

- (void)voiceRoomToolbarTouchExpressionButton {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    if (!self.funView) {
        SYVoiceRoomFunView *gameView = [[SYVoiceRoomFunView alloc] initWithFrame:self.view.bounds];
        gameView.delegate = self;
        self.funView = gameView;
    }
    BOOL inMic = (self.role == SYChatRoomUserRoleHost ||
                  self.role == SYChatRoomUserRoleBroadcaster);
    [self.funView setGameEntranceHidden:!inMic];
    [self.funView refreshData];
    [self.view addSubview:self.funView];
}

- (void)voiceRoomToolbarTouchPKButton {
    if (!self.pkView) {
        self.pkView = [[SYVoiceRoomExtView alloc] initWithFrame:self.view.bounds];
        self.pkView.delegate = self;
    }
    [self.pkView setVoiceViewModel:self.viewModel];
    [self.view addSubview:self.pkView];
}

- (void)voiceRoomToolbarTouchPrivateMessageButton {
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

#pragma mark - input delegate method

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
    return  NO;//[[SYChildProtectManager sharedInstance] needChildProtectWithNavigationController:self.navigationController];
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

#pragma mark - wait mic list view delegate & datasource

- (NSInteger)voiceRoomApplyMicListViewItemCount {
    return [self.viewModel usersCountInApplyMicList];
}

- (SYVoiceChatUserViewModel *)voiceRoomApplyMicListViewItemModelAtIndex:(NSInteger)index {
    return [self.viewModel usersInApplyMicListAtIndex:index];
}

- (BOOL)voiceRoomApplyMicListViewNeedConfirmButtonAtIndex:(NSInteger)index {
    if (self.selectedMicPosition > 0) {
        return (self.viewModel.initialRole >= SYChatRoomUserRoleAdminister);
    }
    return NO;
}

- (BOOL)voiceRoomApplyMicListViewIsMyselfInApplyList {
    return [self.viewModel isMyselfContainsInApplyMicList];
}

- (NSInteger)voiceRoomApplyMicListViewMyselfIndex {
    return [self.viewModel myselfIndexInApplyMicList];
}

- (BOOL)voiceRoomApplyMicListViewIsNeedApplyButton {
    return (self.role < SYChatRoomUserRoleBroadcaster ||
            self.role > SYChatRoomUserRoleHost);
}

- (void)voiceRoomApplyMicListViewDidSelectConfirmButtonAtIndex:(NSInteger)index {
    if (self.selectedMicPosition > 0) {
        [self.viewModel confirmMicAtIndex:index
                               micPostion:self.selectedMicPosition];
    }
    self.selectedMicPosition = 0;
}

- (void)voiceRoomApplyMicListViewDidSelectRowAtIndex:(NSInteger)index {
    SYVoiceChatUserViewModel *user = [self.viewModel usersInApplyMicListAtIndex:index];
    [self showUserInfoViewWithUserUid:user.uid isFromMic:NO micPosition:0];
}

- (void)voiceRoomApplyMicListViewDidSelectApplyButton {
    if (![self.viewModel isMyselfLogin]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    if (![self checkUserMicphonePermission]) {
        return;
    }
    BOOL contains = [self.viewModel isMyselfContainsInApplyMicList];
    if (contains) {
        [self.viewModel cancelApplyMic];
    } else {
        [self.viewModel applyMic];
    }
}

- (void)voiceRoomApplyMicListViewDidDisappeared {
    self.applyMicListView = nil;
    self.selectedMicPosition = 0;
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
    if (message && message.userUid) {
        [self showUserInfoViewWithUserUid:message.receiverUid isFromMic:NO micPosition:0];
    }
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
                                        isSuperAdmin:(NSUInteger)isSuperAdmin
{
    [self.viewModel changeUserInfoAtPosition:micPosition
                                   isFromMic:isFromMic
                                         uid:uid
                                    username:username
                                      avatar:avatar
                                   avatarBox:avatarBox
                            broadcasterLevel:broadcasterLevel
                               isBroadcaster:isBroadcaster
                                isSuperAdmin:isSuperAdmin
     ];
    if (isFromMic && micPosition >= 0 && micPosition < [self.micViewArray count]) {
        SYVoiceRoomMicView *micView = self.micViewArray[micPosition];
        SYVoiceChatUserViewModel *user = [self.viewModel usersInMicAtPosition:micPosition];
        if (micPosition > 0 && micPosition == [self.micViewArray count] - 1) {
            user.bossMic = YES;
        }
        [micView drawWithUserViewModel:user];
    }
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
        for (SYVoiceRoomMicView *micView in self.micViewArray) {
            if (micView.isOccupied) {
                NSInteger index = [self.micViewArray indexOfObject:micView];
                SYVoiceChatUserViewModel *_user = [self.viewModel usersInMicAtPosition:index];
                [self.giftReceiverArray addObject:_user];
            }
        }
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
    if (self.userInfoView.isFromMic && self.selectedMicPosition != 0) {
        self.selectedMicPosition = 0;
    }
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
    };
    [self.navigationController pushViewController:vc
                                         animated:YES];
    
    NSDictionary *dict = @{@"roomID": self.channelID?:@"", @"userID": self.viewModel.myself.uid?:@"", @"opUser": uid?:@""};
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
}

#pragma mark - gift view delegate datasource

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

- (BOOL)giftViewShouldOperateTeenager {
    return  NO;//![[SYChildProtectManager sharedInstance] needChildProtectWithNavigationController:self.navigationController];
}

- (void)giftViewDidSendGiftToUpdateVIPLevel {
    [self.viewModel requestMyselfInfo];
}

- (void)giftViewLackOfBalance {
    [self voiceRoomInputViewLackOfBalance];
}

#pragma mark - custom navbar delegate

- (void)voiceRoomBarDidTapBack {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceChatRoomVC:didPopOutWithRoomName:roomIcon:)]) {
        [self.delegate voiceChatRoomVC:self
                 didPopOutWithRoomName:self.viewModel.roomInfo.roomName
                              roomIcon:self.viewModel.roomInfo.roomIcon];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)voiceRoomBarDidTapMore {
    void (^leaveBlock)(void) = ^ {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"离开房间"
                                                                       message:@"退出房间将不能和小伙伴畅聊了，确定离开房间？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"再玩一会儿"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"离开房间"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCForceClosedWithVC:)]) {
                                                                [self.delegate voiceChatRoomVCForceClosedWithVC:self];
                                                            }
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    };
    __weak typeof(self) weakSelf = self;
    void (^clockBlock)(void) = ^ {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"关闭房间"
                                                                       message:@"关闭房间后，您的房间将不会出现在聊天室列表中"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"再玩一会儿"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"关闭房间"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [weakSelf.viewModel closeChannel];
                                                        }];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    };
    void (^shareBlock)(void) = ^{
        // 分享房间
        SYShareView *shareView = [[SYShareView alloc] initWithFrame:weakSelf.view.bounds];
        shareView.delegate = weakSelf;
        [weakSelf.view addSubview:shareView];
        
        NSDictionary *dict = @{@"roomID": weakSelf.channelID?:@"", @"userID": weakSelf.viewModel.myself.uid?:@""};
//        [MobClick event:@"roomShareClick" attributes:dict];
    };
    if (self.viewModel.initialRole < SYChatRoomUserRoleAdminister) {
        NSMutableArray *actions = [NSMutableArray arrayWithArray:@[@"离开房间"]];
        [actions addObject:@"分享房间"];
        SYCustomActionSheet *sheet = [[SYCustomActionSheet alloc] initWithActions:actions
                                                                      cancelTitle:@"取消"
                                                                      selectBlock:^(NSInteger index) {
                                                                          switch (index) {
                                                                              case 0:
                                                                              {
                                                                                  leaveBlock();
                                                                              }
                                                                                  break;
                                                                              case 1:
                                                                              {
                                                                                  shareBlock();
                                                                              }
                                                                                  break;
                                                                                  
                                                                              default:
                                                                                  break;
                                                                          }
                                                                      } cancelBlock:^{
                                                                          
                                                                      }];
        [sheet show];
    } else {
        NSString *title = self.viewModel.roomInfo.isClosed ? @"开启房间" : @"关闭房间";
        NSMutableArray *actions = [NSMutableArray arrayWithArray:@[@"离开房间", title, @"房间信息"]];
        [actions addObject:@"分享房间"];
        __weak typeof(self) weakSelf = self;
        SYCustomActionSheet *sheet = [[SYCustomActionSheet alloc] initWithActions:actions
                                                                      cancelTitle:@"取消"
                                                                      selectBlock:^(NSInteger index) {
                                                                          switch (index) {
                                                                              case 0:
                                                                              {
                                                                                  leaveBlock();
                                                                              }
                                                                                  break;
                                                                              case 1:
                                                                              {
                                                                                  if (weakSelf.viewModel.roomInfo.isClosed) {
                                                                                      [weakSelf.viewModel openChannel];
                                                                                  } else {
                                                                                      clockBlock();
                                                                                  }
                                                                              }
                                                                                  break;
                                                                              case 2:
                                                                              {
                                                                                  SYVoiceChatRoomDetailInfoVC *vc = [[SYVoiceChatRoomDetailInfoVC alloc] init];
                                                                                  vc.channelId = weakSelf.channelID;
                                                                                  vc.isRoomOwner = (weakSelf.viewModel.initialRole == SYChatRoomUserRoleHomeOwner);
                                                                                  vc.selectRoomBackDropimage = @"voiceroom_bg";
                                                                                  vc.delegate = weakSelf.viewModel;
                                                                                   [weakSelf.navigationController pushViewController:vc animated:YES];
                                                                              }
                                                                                  break;
                                                                              case 3:
                                                                              {
                                                                                  // 分享房间
                                                                                  shareBlock();
                                                                              }
                                                                                  break;
                                                                                  
                                                                              default:
                                                                                  break;
                                                                          }
                                                                      } cancelBlock:^{
                                                                          
                                                                      }];
        [sheet show];
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

#pragma mark - music vc delegate

#pragma mark - SYVoiceRoomOnlineListViewDelegate

- (void)handleOnlineListViewClickEventWithModel:(SYVoiceRoomUserModel *)model {
    if (model) {
        if ([model.id longLongValue] >= 1000000000) {
            // 游客id，不显示
            return;
        }
        [self.onlineListView removeFromSuperview];
        self.onlineListView = nil;
        [self showUserInfoViewWithUserUid:model.id isFromMic:NO micPosition:0];
    }
}

- (void)onlineListViewDidFetchOnlineNumber:(NSInteger)num {
    NSString *online = [NSString stringWithFormat:@"%ld人在线", num];
    [self setOnlineNumberString:online];
    [self.viewModel updateOnlineNumber:num];
}

#pragma mark - fun delegate

- (void)voiceRoomFunViewDidSelectGame:(SYVoiceRoomGameType)game {
    [self.viewModel sendGameMessageWithGame:game isHost:(self.role == SYChatRoomUserRoleHost)];
}

- (void)voiceRoomFunViewDidSelectExpression:(NSInteger)expressionId {
    [self.viewModel sendExpressionWithExpressionID:expressionId];
}

#pragma mark - message float view delegate

- (void)voiceRoomMessageFloatViewOpenRoomWithRoomId:(NSString *)roomId {
    if ([self.delegate respondsToSelector:@selector(voiceChatRoomVCChangeAnotherRoomWithVC:roomId:)]) {
        [self.delegate voiceChatRoomVCChangeAnotherRoomWithVC:self roomId:roomId];
    }
}

#pragma mark -

- (void)shareViewDidSelectShareType:(SYShareViewType)type {
    if (type == SYShareViewTypeWeixinSession) {
#ifdef ShiningSdk
        [self.viewModel shareRoomToWeixin];
#else
        [self.viewModel shareRoomToWeixinSession];
#endif
    }else if (type == SYShareViewTypeWeixinTimeline) {
        [self.viewModel shareRoomToWeixinTimeLine];
    }
}

#pragma mark - pk

- (void)voiceRoomExtViewDidStartPK {
    if (self.viewModel.initialRole < SYChatRoomUserRoleAdminister) {
        [SYToastView showToast:@"您不能进行此操作"];
        return;
    }
    [self.viewModel startPK];
}

- (void)voiceRoomExtViewDidStopPK {
    if (self.viewModel.initialRole < SYChatRoomUserRoleAdminister) {
        [SYToastView showToast:@"您不能进行此操作"];
        return;
    }
    [self.viewModel stopPK];
}

- (void)voiceRoomExtViewDidClearPublicScreen {
    if (self.viewModel.initialRole < SYChatRoomUserRoleAdminister) {
        [SYToastView showToast:@"您不能进行此操作"];
        return;
    }
    [self.viewModel clearPublicScreen];
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
    [self.pkView removeFromSuperview];
}


- (void)voiceRoomExtViewDidPrivateMsg {
    [self voiceRoomToolbarTouchPrivateMessageButton];
    [self.pkView removeFromSuperview];
}

- (void)animationSwitchAction:(BOOL)isOff
{
    [SYSettingManager setAnimationOff:isOff];
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
    [self voiceRoomToolbarTouchGiftButton];
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
    };
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

@end
