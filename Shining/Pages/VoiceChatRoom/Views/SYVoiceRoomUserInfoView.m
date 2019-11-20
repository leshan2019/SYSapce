//
//  SYVoiceRoomUserInfoView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomUserInfoView.h"
#import "SYVoiceRoomSexView.h"
#import "SYVoiceChatRoomUserInfoViewModel.h"
#import "SYVIPLevelView.h"
#import "SYBroadcasterLevelView.h"
#import "SYReportManager.h"
#import "SYAudioPlayer.h"
#import "SYGiftNetManager.h"

#define UserInfoBaseHeight 243.f
#define FollowStateTitle @"+关注"
#define UnFollowStateTitle @"已关注"

@interface SYVoiceRoomUserInfoView ()

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) NSInteger micPosition;
@property (nonatomic, strong) SYVoiceChatRoomUserInfoViewModel *viewModel;
@property (nonatomic, assign) BOOL isMyself;

@property (nonatomic, strong) UIView *backMask;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *buttonContainerView;

@property (nonatomic, strong) UIImageView *idIcon;
@property (nonatomic, strong) UILabel *idLabel;
//@property (nonatomic, strong) UIButton *reportButton;
//@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *personPageButton;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) SYVoiceRoomSexView *sexView;
@property (nonatomic, strong) SYVIPLevelView *vipView;
@property (nonatomic, strong) SYBroadcasterLevelView *broadcasterLevelView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *homePageButton;
@property (nonatomic, strong) UIButton *sendGiftButton;
@property (nonatomic, strong) UIButton *kickMicButton;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, strong) UIButton *forbidChatButton; // 禁言
@property (nonatomic, strong) UIButton *forbidEnterButton; // 禁入
@property (nonatomic, strong) UILabel *signatureLabel; // 个性签名

@property (nonatomic, assign) BOOL isFromMic;
@property (nonatomic, assign) BOOL isKickFromMic;

@property (nonatomic, strong) SYAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL voicePlaying;

@end

@implementation SYVoiceRoomUserInfoView

- (void)dealloc {
    if (self.audioPlayer) {
        [self.audioPlayer setPlayerCallBack:nil];
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isKickFromMic = NO;
        [self addSubview:self.backMask];
        [self addSubview:self.containerView];
        
        [self.containerView addSubview:self.idIcon];
        [self.containerView addSubview:self.idLabel];
//        [self.containerView addSubview:self.closeButton];
//        [self.containerView addSubview:self.reportButton];
        [self.containerView addSubview:self.personPageButton];
        [self.containerView addSubview:self.avatarView];
        [self.containerView addSubview:self.nameLabel];
        [self.containerView addSubview:self.broadcasterLevelView];
        [self.containerView addSubview:self.vipView];
        [self.containerView addSubview:self.sexView];
        [self.containerView addSubview:self.descLabel];
        [self.containerView addSubview:self.voiceButton];
        [self.containerView addSubview:self.signatureLabel];
        [self.containerView addSubview:self.buttonContainerView];
    }
    return self;
}

- (void)reloadMuteState {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(voiceRoomUserInfoViewUserIsMutedWithUid:atMicPosition:)]) {
        BOOL isMuted = [self.dataSource voiceRoomUserInfoViewUserIsMutedWithUid:self.uid
                                                                  atMicPosition:self.micPosition];
        [self.muteButton setTitle:isMuted?@"取消静音":@"静音"
                         forState:UIControlStateNormal];
    }
}

- (void)reloadForbidChatState:(BOOL)isForbidden
                          uid:(NSString *)uid {
    if ([self.uid isEqualToString:uid]) {
        [self.viewModel setIsForbiddenChat:isForbidden];
        [self.forbidChatButton setTitle:isForbidden?@"取消禁言":@"禁言"
                               forState:UIControlStateNormal];
    }
}

- (void)reloadForbidEnterState:(BOOL)isForbidden
                           uid:(NSString *)uid {
    if ([self.uid isEqualToString:uid]) {
        [self.viewModel setIsForbiddenEnter:isForbidden];
        [self.forbidEnterButton setTitle:isForbidden?@"取消禁入":@"禁入"
                                forState:UIControlStateNormal];
    }
}

- (void)reloadIskickedFromMicWithUid:(NSString *)uid {
    if ([self.uid isEqualToString:uid]) {
        [self.kickMicButton setTitle:@"已下麦" forState:UIControlStateNormal];
        self.kickMicButton.enabled = NO;
        self.isKickFromMic = YES;
    }
}

- (void)reloadFollowState {
    if (self.isMyself) {
        // 自己
        [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
        self.followButton.enabled = NO;
    } else {
        NSString *title = FollowStateTitle;
        if (self.viewModel.isFollow) {
            title = UnFollowStateTitle;
        }
        [self.followButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)showWithChannelID:(NSString *)channelID
                  UserUid:(NSString *)uid
                 isMyself:(BOOL)isMyself
                isFromMic:(BOOL)isFromMic
              micPosition:(NSInteger)micPosition
                  isAdmin:(BOOL)isAdmin {
    // TODO: loading，然后请求用户接口，显示
    // 策略，1. 如果是管理员，则可以有第二行按钮。 2. 第二行按钮，如果是麦上的人，则为下麦和静音；如果是公屏或者
    // 排麦列表中的人，则为禁言和禁入。 3. 第一行按钮为关注和送礼物，如果是自己，默认为已关注，非自己为关注或者取消关注
    self.isFromMic = isFromMic;
    self.isMyself = isMyself;
    self.viewModel = [[SYVoiceChatRoomUserInfoViewModel alloc] initWithChannelID:channelID
                                                                             uid:uid];
    self.uid = uid;
    self.micPosition = micPosition;
    CGFloat buttonRow = isAdmin ? 2 : 1;
    if (isMyself && isFromMic) {
        buttonRow = 2;
    }
    CGFloat addtionHeight = buttonRow * 50.f;
    CGFloat height = UserInfoBaseHeight + addtionHeight;
    CGRect frame = self.containerView.frame;
    frame.size.height = height;
    self.containerView.frame = frame;
    self.containerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.buttonContainerView.frame = CGRectMake(0, UserInfoBaseHeight, self.containerView.sy_width, addtionHeight);
    
    NSMutableArray *buttonArray = [[NSMutableArray alloc] initWithObjects:self.followButton, self.homePageButton, self.sendGiftButton, nil];
    if (isAdmin) {
        if (isFromMic) {
            [buttonArray addObjectsFromArray:@[self.kickMicButton, self.muteButton]];
        } else {
            [buttonArray addObjectsFromArray:@[self.forbidEnterButton, self.forbidChatButton]];
        }
    } else if (isMyself) {
        if (isFromMic) {
            [buttonArray addObjectsFromArray:@[self.kickMicButton, self.muteButton]];
        }
    }
    if (isFromMic && (isAdmin || isMyself)) {
        [self reloadMuteState];
    }
    [self drawWithButtons:buttonArray];
    
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestUserStatusInfoWithBlock:^(BOOL success) {
        if (success) {
            [weakSelf.avatarView sd_setImageWithURL:[NSURL URLWithString:weakSelf.viewModel.userAvatar]
                                   placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder_big"]];
            NSString *name = weakSelf.viewModel.username;
            weakSelf.nameLabel.text = name;
            CGRect rect = [name boundingRectWithSize:CGSizeMake(weakSelf.containerView.sy_width, weakSelf.nameLabel.sy_height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: weakSelf.nameLabel.font}
                                             context:nil];
            weakSelf.nameLabel.sy_width = weakSelf.containerView.sy_width - 20.f;
            weakSelf.nameLabel.sy_left = (weakSelf.containerView.sy_width - weakSelf.nameLabel.sy_width) / 2.f;
            NSString *showId = [weakSelf.viewModel.userBestid integerValue] > 0 ? weakSelf.viewModel.userBestid : weakSelf.viewModel.userUid;
            weakSelf.idLabel.text = showId;
            [weakSelf.sexView setSex:weakSelf.viewModel.userGender
                             andAge:weakSelf.viewModel.age];
            [weakSelf.vipView showWithVipLevel:weakSelf.viewModel.level];
            [weakSelf reloadForbidChatState:weakSelf.viewModel.isForbiddenChat
                                    uid:weakSelf.uid];
            [weakSelf reloadForbidEnterState:weakSelf.viewModel.isForbiddenEnter
                                         uid:weakSelf.uid];
            weakSelf.descLabel.text = [NSString stringWithFormat:@"%@ %@", weakSelf.viewModel.sign?:@"", weakSelf.viewModel.location?:@""];
            rect = [weakSelf.descLabel.text boundingRectWithSize:CGSizeMake(weakSelf.descLabel.sy_width, weakSelf.descLabel.sy_height)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: weakSelf.descLabel.font}
                                             context:nil];
            CGFloat width = rect.size.width + weakSelf.sexView.sy_width + weakSelf.vipView.sy_width + 14.f;
            NSInteger broadcasterLevel = weakSelf.viewModel.broadcasterLevel;
            NSInteger isBroadcaster = weakSelf.viewModel.isBroadcaster;
            if (isBroadcaster == 1) {
                weakSelf.broadcasterLevelView.hidden = NO;
                [weakSelf.broadcasterLevelView showWithBroadcasterLevel:broadcasterLevel];
                width += (weakSelf.broadcasterLevelView.sy_width + 4.f);
                weakSelf.broadcasterLevelView.sy_left = (weakSelf.containerView.sy_width - width) / 2.f;
                weakSelf.vipView.sy_left = weakSelf.broadcasterLevelView.sy_right + 4.f;
            } else {
                weakSelf.broadcasterLevelView.hidden = YES;
                weakSelf.vipView.sy_left = (weakSelf.containerView.sy_width - width) / 2.f;
            }
            weakSelf.sexView.sy_left = weakSelf.vipView.sy_right + 4.f;
            weakSelf.descLabel.sy_left = weakSelf.sexView.sy_right + 10.f;
            [weakSelf reloadFollowState];
            weakSelf.sendGiftButton.enabled = YES;
            weakSelf.forbidChatButton.enabled = YES;
            weakSelf.forbidEnterButton.enabled = YES;
            weakSelf.homePageButton.enabled = YES;
            weakSelf.signatureLabel.text = weakSelf.viewModel.signature;
            weakSelf.voiceButton.hidden = [NSString sy_isBlankString:weakSelf.viewModel.voiceURL];
            [weakSelf showVoiceButtonWithTime:[weakSelf.viewModel voiceDuration]];
            
            if (!weakSelf.voiceButton.hidden && ![NSString sy_isBlankString:weakSelf.viewModel.signature]) {
                // 语音按钮和签名同时出现，需要加长view
                CGFloat addition = 22.f;
                weakSelf.voiceButton.sy_top += (addition + 4);
                weakSelf.buttonContainerView.sy_top += addition;
                weakSelf.containerView.sy_height += addition;
                weakSelf.containerView.center = CGPointMake(CGRectGetMidX(weakSelf.bounds), CGRectGetMidY(weakSelf.bounds));
            }
            
            if ([weakSelf.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidFetchUserInfoWithUid:isFromMic:atMicPosition:username:avatar:avatarBox:broadcasterLevel:isBroadcaster:isSuperAdmin:)]) {
                [weakSelf.delegate voiceRoomUserInfoViewDidFetchUserInfoWithUid:weakSelf.uid
                                                                      isFromMic:weakSelf.isFromMic
                                                                  atMicPosition:weakSelf.micPosition
                                                                       username:weakSelf.viewModel.username
                                                                         avatar:weakSelf.viewModel.userAvatar
                                                                      avatarBox:weakSelf.viewModel.userAvatarBox
                                                               broadcasterLevel:weakSelf.viewModel.broadcasterLevel
                 isBroadcaster:weakSelf.viewModel.isBroadcaster
                 isSuperAdmin:weakSelf.viewModel.isSuperAdmin];
            }
        } else {
            [SYToastView showToast:@"请检查您的网络情况"];
        }
    }];
}

- (void)drawWithButtons:(NSArray *)buttons {
    for (int i = 0; i < [buttons count]; i ++) {
        UIButton *button = buttons[i];
        if (i <= 2) {
            NSInteger pos = i % 3;
            CGRect frame = button.frame;
            frame.origin.x = pos * CGRectGetWidth(self.buttonContainerView.bounds) / 3.f;
            frame.origin.y = 0;
            frame.size.width = CGRectGetWidth(self.buttonContainerView.bounds) / 3.f;
            button.frame = frame;
            [self.buttonContainerView addSubview:button];
            
            if (i == 0) {
                // horizontal line
                CGRect frame = CGRectMake(0, button.sy_top, self.buttonContainerView.sy_width, 0.5);
                [self.buttonContainerView addSubview:[self lineWithFrame:frame]];
            }
            if (i < 2) {
                // vertical line
                CGRect frame = CGRectMake(button.sy_right, button.sy_top + (button.sy_height - 25.f) / 2.f, 0.5, 25.f);
                [self.buttonContainerView addSubview:[self lineWithFrame:frame]];
            }
        } else {
            NSInteger row = (i - 1) / 2;
            NSInteger pos = (i - 1) % 2;
            CGRect frame = button.frame;
            frame.origin.x = pos * CGRectGetWidth(self.buttonContainerView.bounds) / 2.f;
            frame.origin.y = row * 50.f;
            button.frame = frame;
            [self.buttonContainerView addSubview:button];
            if (pos == 0) {
                // horizontal line
                CGRect frame = CGRectMake(0, button.sy_top, self.buttonContainerView.sy_width, 0.5);
                [self.buttonContainerView addSubview:[self lineWithFrame:frame]];
                
                // vertical line
                frame = CGRectMake(button.sy_right, button.sy_top + (button.sy_height - 25.f) / 2.f, 0.5, 25.f);
                [self.buttonContainerView addSubview:[self lineWithFrame:frame]];
            }
        }
    }
}

#pragma mark - UI

- (UIView *)backMask {
    if (!_backMask) {
        _backMask = [[UIView alloc] initWithFrame:self.bounds];
        _backMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_backMask addGestureRecognizer:tap];
    }
    return _backMask;
}

- (UIView *)containerView {
    if (!_containerView) {
        CGFloat x = 32.f;
        CGFloat width = CGRectGetWidth(self.bounds) - 2 * x;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, UserInfoBaseHeight)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 10.f;
        _containerView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    return _containerView;
}

- (UIView *)buttonContainerView {
    if (!_buttonContainerView) {
        _buttonContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonContainerView.backgroundColor = [UIColor clearColor];
    }
    return _buttonContainerView;
}

- (UIImageView *)idIcon {
    if (!_idIcon) {
        _idIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14.f, 14.f, 13.f, 13)];
        _idIcon.image = [UIImage imageNamed_sy:@"voiceroom_id"];
    }
    return _idIcon;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.idIcon.frame) + 4.f, CGRectGetMinY(self.idIcon.frame), 150, 14.f)];
        _idLabel.font = [UIFont systemFontOfSize:14];
        _idLabel.textColor = [UIColor blackColor];
    }
    return _idLabel;
}

//- (UIButton *)closeButton {
//    if (!_closeButton) {
//        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _closeButton.frame = CGRectMake(CGRectGetMaxX(self.containerView.bounds) - 36.f, 6.f, 30.f, 30.f);
//        [_closeButton setImage:[UIImage imageNamed_sy:@"voiceroom_close"] forState:UIControlStateNormal];
//        [_closeButton addTarget:self
//                         action:@selector(tap:)
//               forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _closeButton;
//}

- (UIButton *)personPageButton {
    if (!_personPageButton) {
        _personPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _personPageButton.frame = CGRectMake(CGRectGetMaxX(self.containerView.bounds) - 43.f, 6.f, 30.f, 30.f);
        [_personPageButton setImage:[UIImage imageNamed_sy:@"voiceroom_personpage"] forState:UIControlStateNormal];
        [_personPageButton addTarget:self
                              action:@selector(goToHomePage:)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _personPageButton;
}

//- (UIButton *)reportButton {
//    if (!_reportButton) {
//        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _reportButton.frame = CGRectMake(CGRectGetMinX(self.closeButton.frame) - 40.f, 6.f, 30.f, 30);
//        _reportButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
//        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
//        [_reportButton setTitleColor:[UIColor sam_colorWithHex:@"#999999"]
//                            forState:UIControlStateNormal];
//        [_reportButton addTarget:self
//                          action:@selector(report:)
//                forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _reportButton;
//}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        CGFloat width = 100.f;
        CGFloat x = (CGRectGetWidth(self.containerView.frame) - width) / 2.f;
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 40, width, width)];
        _avatarView.layer.cornerRadius = width / 2.f;
        _avatarView.clipsToBounds = YES;
//        _avatarView.layer.borderColor = [[UIColor sam_colorWithHex:@"#7B40FF"] CGColor];
//        _avatarView.layer.borderWidth = 4.f;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.avatarView.frame), CGRectGetMaxY(self.avatarView.frame) + 15.f, CGRectGetWidth(self.avatarView.frame), 20.f)];
        _nameLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc] initWithFrame:CGRectMake(0, self.nameLabel.sy_bottom + 5.f, 30.f, 14)];
    }
    return _sexView;
}

- (SYVIPLevelView *)vipView {
    if (!_vipView) {
        _vipView = [[SYVIPLevelView alloc] initWithFrame:CGRectMake(0, self.nameLabel.sy_bottom + 5.f, 30.f, 14.f)];
    }
    return _vipView;
}

- (SYBroadcasterLevelView *)broadcasterLevelView {
    if (!_broadcasterLevelView) {
        _broadcasterLevelView = [[SYBroadcasterLevelView alloc] initWithFrame:CGRectMake(0, self.nameLabel.sy_bottom + 5.f, 0, 0)];
        _broadcasterLevelView.hidden = YES;
    }
    return _broadcasterLevelView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 5.f, CGRectGetWidth(self.nameLabel.frame), 14.f)];
        _descLabel.font = [UIFont systemFontOfSize:12.f];
        _descLabel.textColor = [UIColor sam_colorWithHex:@"#444444"];
    }
    return _descLabel;
}

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.frame = CGRectMake(0, 0, 70.f, 24);
        _voiceButton.center = CGPointMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMaxY(self.descLabel.frame) + 6 + 12);
        _voiceButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_voiceButton setBackgroundImage:[UIImage imageNamed_sy:@"voiceroom_voice_bg"]
                                forState:UIControlStateNormal];
//        _voiceButton.layer.cornerRadius = 12.f;
        _voiceButton.clipsToBounds = YES;
        [_voiceButton setTitle:@"00:00" forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed_sy:@"voiceroom_play"] forState:UIControlStateNormal];
        [_voiceButton setImageEdgeInsets:UIEdgeInsetsMake(0, 46, 0, 0)];
        [_voiceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -36, 0, 0)];
        [_voiceButton addTarget:self
                         action:@selector(playVoice:)
               forControlEvents:UIControlEventTouchUpInside];
        _voiceButton.hidden = YES;
    }
    return _voiceButton;
}

- (UILabel *)signatureLabel {
    if (!_signatureLabel) {
        _signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(33.f, self.descLabel.sy_bottom + 8.f, self.containerView.sy_width - 66.f, 15)];
        _signatureLabel.font = [UIFont systemFontOfSize:12.f];
        _signatureLabel.textColor = [UIColor sam_colorWithHex:@"#999999"];
        _signatureLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _signatureLabel;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [self buttonWithTitle:FollowStateTitle
                                   titleColor:[UIColor sam_colorWithHex:@"#666666"]
                                     selector:@selector(follow:)];
    }
    return _followButton;
}

- (UIButton *)homePageButton {
    if (!_homePageButton) {
        _homePageButton = [self buttonWithTitle:@"私信"
                                     titleColor:[UIColor sam_colorWithHex:@"#666666"]
                                       selector:@selector(goToPrivateMessage:)];
        _homePageButton.enabled = NO;
    }
    return _homePageButton;
}

- (UIButton *)sendGiftButton {
    if (!_sendGiftButton) {
        _sendGiftButton = [self buttonWithTitle:@"送礼物"
                                     titleColor:[UIColor sam_colorWithHex:@"#FF40E8"]
                                       selector:@selector(sendGift:)];
        _sendGiftButton.enabled = NO;
    }
    return _sendGiftButton;
}

- (UIButton *)kickMicButton {
    if (!_kickMicButton) {
        _kickMicButton = [self buttonWithTitle:@"下麦"
                                    titleColor:[UIColor sam_colorWithHex:@"#666666"]
                                      selector:@selector(kickMic:)];
    }
    return _kickMicButton;
}

- (UIButton *)muteButton {
    if (!_muteButton) {
        _muteButton = [self buttonWithTitle:@"静音"
                                 titleColor:[UIColor sam_colorWithHex:@"#666666"]
                                   selector:@selector(muteMic:)];
    }
    return _muteButton;
}

- (UIButton *)forbidChatButton {
    if (!_forbidChatButton) {
        _forbidChatButton = [self buttonWithTitle:@"禁言"
                                       titleColor:[UIColor sam_colorWithHex:@"#666666"]
                                         selector:@selector(forbidChat:)];
        _forbidChatButton.enabled = NO;
    }
    return _forbidChatButton;
}

- (UIButton *)forbidEnterButton {
    if (!_forbidEnterButton) {
        _forbidEnterButton = [self buttonWithTitle:@"禁入"
                                        titleColor:[UIColor sam_colorWithHex:@"#666666"]
                                          selector:@selector(forbidEnter:)];
        _forbidEnterButton.enabled = NO;
    }
    return _forbidEnterButton;
}

#pragma mark - voice button time

- (void)showVoiceButtonWithTime:(NSInteger)time {
    if (time < 0) {
        time = 0;
    }
    NSString *string = [NSString stringWithFormat:@"00:%ld", (long)time];
    if (time < 10) {
        string = [NSString stringWithFormat:@"00:0%ld", (long)time];
    }
    [self.voiceButton setTitle:string forState:UIControlStateNormal];
}

#pragma mark - button constructor

- (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                     selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds) / 2.f, 50);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView *)lineWithFrame:(CGRect)frame {
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
    return line;
}

#pragma mark - action

- (void)tap:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidClose)]) {
        [self.delegate voiceRoomUserInfoViewDidClose];
    }
    [self removeFromSuperview];
}

- (void)report:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewClickReport:)]) {
        [self.delegate voiceRoomUserInfoViewClickReport:self.uid];
    }
}

- (void)playVoice:(id)sender {
    if (self.voicePlaying) {
        [self.audioPlayer stop];
        [self.audioPlayer setPlayerCallBack:nil];
        self.audioPlayer = nil;
    } else {
        self.voicePlaying = YES;
        NSString *voiceUrl = self.viewModel.voiceURL;
        self.audioPlayer = [[SYAudioPlayer alloc] initWithUrls:@[voiceUrl] seekDuration:0 duration:0];
        __weak typeof(self) weakSelf = self;
        [self.audioPlayer setPlayerCallBack:^(SYAudioPlayStatus status, NSTimeInterval playTime, NSTimeInterval playDutation, NSString * _Nonnull error) {
            NSInteger duration = [weakSelf.viewModel voiceDuration];
            duration = MIN(playDutation, duration);
            if (status == SYAudioPlayStatusFinish ||
                status == SYAudioPlayStatusError) {
                [weakSelf showVoiceButtonWithTime:duration];
                [weakSelf.voiceButton setImage:[UIImage imageNamed_sy:@"voiceroom_play"]
                                      forState:UIControlStateNormal];
                weakSelf.voicePlaying = NO;
                [weakSelf.audioPlayer setPlayerCallBack:nil];
                [weakSelf.audioPlayer stop];
                weakSelf.audioPlayer = nil;
            } else if (status == SYAudioPlayStatusPrepare) {
                weakSelf.voicePlaying = YES;
                [weakSelf showVoiceButtonWithTime:duration];
                [weakSelf.voiceButton setImage:[UIImage imageNamed_sy:@"voiceroom_pause"]
                                      forState:UIControlStateNormal];
            } else if (status == SYAudioPlayStatusPlaying && playDutation > 0) {
                weakSelf.voicePlaying = YES;
                NSInteger time = duration - (NSInteger)playTime;
                [weakSelf showVoiceButtonWithTime:time];
            }
        }];
        [self.audioPlayer play];
    }
}

- (void)follow:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewShouldFollowUser)]) {
        if (![self.delegate voiceRoomUserInfoViewShouldFollowUser]) {
            return;
        }
    }
    if (self.viewModel.isFollow) {
        [self.viewModel requestCancelFollowUserWithBlock:^(BOOL success) {
            if (success) {
                [self reloadFollowState];
                [SYToastView showToast:@"取消关注成功"];
                if ([self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidCancelFollowUserWithUser:)]) {
                    [self.delegate voiceRoomUserInfoViewDidCancelFollowUserWithUser:self.viewModel.userViewModel];
                }
            } else {
                [SYToastView showToast:@"取消关注失败"];
            }
        }];
    } else {
        [self.viewModel requestFollowUserWithBlock:^(BOOL success) {
            if (success) {
                [self reloadFollowState];
                [SYToastView showToast:@"关注成功"];
                if ([self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidFollowUserWithUser:)]) {
                    [self.delegate voiceRoomUserInfoViewDidFollowUserWithUser:self.viewModel.userViewModel];
                }
                SYGiftNetManager *netManager = [SYGiftNetManager new];
                [netManager dailyTaskLog:3];
            } else {
                [SYToastView showToast:@"关注失败"];
            }
        }];
    }
}

- (void)goToHomePage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewGoToUserHomePageWithUid:)]) {
        [self.delegate voiceRoomUserInfoViewGoToUserHomePageWithUid:self.uid];
    }
    [self tap:nil];
}

- (void)goToPrivateMessage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewGoToPrivateMessageWithUserId:username:avatar:em_username:)]) {
        [self.delegate voiceRoomUserInfoViewGoToPrivateMessageWithUserId:self.uid
                                                                username:self.viewModel.username
                                                                  avatar:self.viewModel.userAvatar
                                                             em_username:self.viewModel.em_username];
    }
    [self tap:nil];
}

- (void)sendGift:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidSelectGiftButtonWithUser:)]) {
        [self.delegate voiceRoomUserInfoViewDidSelectGiftButtonWithUser:self.viewModel.userViewModel];
    }
    [self tap:nil];
}

- (void)kickMic:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidKickUserFromMicWithUid:atMicPosition:)]) {
        [self.delegate voiceRoomUserInfoViewDidKickUserFromMicWithUid:self.uid
                                                        atMicPosition:self.micPosition];
    }
}

- (void)muteMic:(id)sender {
    if (self.isKickFromMic) {
        [SYToastView showToast:@"用户已下麦，无法进行此操作"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidChangeMuteStateWithUid:atMicPosition:)]) {
        [self.delegate voiceRoomUserInfoViewDidChangeMuteStateWithUid:self.uid
                                                        atMicPosition:self.micPosition];
    }
}

- (void)forbidChat:(id)sender {
    if (self.viewModel.isForbiddenChat) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidCancelForbidUserChatWithUser:)]) {
            [self.delegate voiceRoomUserInfoViewDidCancelForbidUserChatWithUser:self.viewModel.userViewModel];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidForbidUserChatWithUser:)]) {
            [self.delegate voiceRoomUserInfoViewDidForbidUserChatWithUser:self.viewModel.userViewModel];
        }
    }
}

- (void)forbidEnter:(id)sender {
    if (self.viewModel.isForbiddenEnter) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidCancelForbidUserEnterWithUser:)]) {
            [self.delegate voiceRoomUserInfoViewDidCancelForbidUserEnterWithUser:self.viewModel.userViewModel];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomUserInfoViewDidForbidUserEnterWithUser:)]) {
            [self.delegate voiceRoomUserInfoViewDidForbidUserEnterWithUser:self.viewModel.userViewModel];
        }
    }
}

@end
