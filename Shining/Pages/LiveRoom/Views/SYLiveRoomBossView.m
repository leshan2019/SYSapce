//
//  SYLiveRoomBossView.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomBossView.h"

@interface SYLiveRoomBossView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *topImageView;

@end

@implementation SYLiveRoomBossView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backImageView];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.topImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showWithBossViewModel:(SYVoiceRoomBossViewModel *)viewModel {
    if (viewModel.isValid) {
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:viewModel.userAvatar]
                             placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    } else {
        [self.avatarImageView setImage:nil];
    }
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.image = [UIImage imageNamed_sy:@"liveRoom_boss_bg"];
    }
    return _backImageView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _avatarImageView.layer.cornerRadius = _avatarImageView.sy_height / 2.f;
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _topImageView.image = [UIImage imageNamed_sy:@"liveRoom_boss_top"];
    }
    return _topImageView;
}

- (void)tap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomBossViewDidClicked)]) {
        [self.delegate voiceRoomBossViewDidClicked];
    }
}

@end
