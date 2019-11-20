//
//  SYLiveRoomHostIDView.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomHostIDView.h"
#import "SYLiveRoomHostIDViewModel.h"

@interface SYLiveRoomHostIDView ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIButton *followButton;

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) BOOL isFollowing;
@property (nonatomic, strong) SYLiveRoomHostIDViewModel *viewModel;
@property (nonatomic, assign) BOOL isHost;

@end

@implementation SYLiveRoomHostIDView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewModel = [SYLiveRoomHostIDViewModel new];
        _isFollowing = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.layer.cornerRadius = self.sy_height / 2.f;
        [self addSubview:self.avatarView];
        [self addSubview:self.followButton];
        [self addSubview:self.nameLabel];
        [self addSubview:self.idLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showWithUsername:(NSString *)username
                  userID:(NSString *)userID
                  bestID:(NSString *)bestID
               avatarURL:(NSString *)avatarURL
             followState:(BOOL)isFollowing {
    self.userID = userID;
    self.username = username;
    self.nameLabel.text = username;
    NSString *showId = [bestID integerValue] > 0 ? bestID : userID;
    self.idLabel.text = [NSString stringWithFormat:@"ID:%@", showId];
    [self.avatarView setImageWithURL:[NSURL URLWithString:avatarURL]
                    placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    [self setFollowState:isFollowing];
}

- (void)setFollowState:(BOOL)isFollowing {
    self.isFollowing = isFollowing;
    if (isFollowing) {
        [self.followButton setImage:[UIImage imageNamed_sy:@"liveRoom_followed"]
                           forState:UIControlStateNormal];
    } else {
        [self.followButton setImage:[UIImage imageNamed_sy:@"liveRoom_follow"]
                           forState:UIControlStateNormal];
    }
}

- (void)setUserRoleWithIsHost:(BOOL)isHost {
    self.isHost = isHost;
    if (isHost) {
        self.followButton.hidden = YES;
        self.idLabel.sy_width = self.followButton.sy_right - self.idLabel.sy_left;
        self.nameLabel.sy_width = self.followButton.sy_right - self.nameLabel.sy_left;
    }
}

#pragma mark - UI

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.sy_height, self.sy_height)];
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = self.sy_height / 2.f;
        _avatarView.layer.borderColor = [[UIColor sam_colorWithHex:@"#E6E6E6"] CGColor];
        _avatarView.layer.borderWidth = 1.f;
        _avatarView.userInteractionEnabled = YES;
    }
    return _avatarView;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 30.f;
        CGFloat y = (self.sy_height - width) / 2.f;
        CGFloat x = self.sy_width - 4.f - width;
        _followButton.frame = CGRectMake(x, y, width, width);
        [_followButton addTarget:self
                          action:@selector(follow:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.avatarView.sy_width + 4.f, 2.f, 72.f, 17.f)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _nameLabel;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.sy_x, self.nameLabel.sy_bottom, self.nameLabel.sy_width, self.nameLabel.sy_height)];
        _idLabel.textColor = [UIColor whiteColor];
        _idLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _idLabel;
}

#pragma mark -
-(void)showFansView{
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    NSDictionary*dic = @{@"anchorid":self.userID,@"uid":user.userid};
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomHostViewDidTapShowFansView:)]) {
        [self.delegate liveRoomHostViewDidTapShowFansView:dic];
    }
}
- (void)follow:(id)sender {
    if (self.isHost) {
        [self showFansView];
    }else {
        if ([self.delegate respondsToSelector:@selector(liveRoomHostViewCanFollowUser)]) {
            if (![self.delegate liveRoomHostViewCanFollowUser]) {
                return;
            }
        }
        __weak typeof(self) weakSelf = self;
        if (self.isFollowing) {
            //        [self.viewModel requestCancelFollowUserWithUid:self.userID
            //                                                 block:^(BOOL success) {
            //                                                     if (success) {
            //                                                         [weakSelf setFollowState:NO];
            //                                                         [SYToastView showToast:@"取消关注成功"];
            //                                                     }
            //                                                 }];
            [self showFansView];
        } else {
            [self.viewModel requestFollowUserWithUid:self.userID
                                               block:^(BOOL success) {
                if (success) {
                    [weakSelf setFollowState:YES];
                    [SYToastView showToast:@"关注成功"];
                    if ([weakSelf.delegate respondsToSelector:@selector(liveRoomHostViewDidFollowUserWithUid:username:)]) {
                        [weakSelf.delegate liveRoomHostViewDidFollowUserWithUid:weakSelf.userID
                                                                       username:weakSelf.username];
                    }
                }
            }];
        }
    }
}

- (void)tap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveRoomHostViewDidTapUserWithUid:)]) {
        [self.delegate liveRoomHostViewDidTapUserWithUid:self.userID];
    }
}

@end
