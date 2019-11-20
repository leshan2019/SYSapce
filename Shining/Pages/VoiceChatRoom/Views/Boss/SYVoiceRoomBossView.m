//
//  SYVoiceRoomBossView.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/7.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomBossView.h"

@interface SYVoiceRoomBossView ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *stripView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation SYVoiceRoomBossView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.avatarView];
        [self addSubview:self.stripView];
        [self.stripView addSubview:self.nameLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showWithBossViewModel:(SYVoiceRoomBossViewModel *)viewModel {
    if (viewModel.isValid) {
        self.nameLabel.text = viewModel.userName;
        [self.avatarView setImageWithURL:[NSURL URLWithString:viewModel.userAvatar]
                        placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    } else {
        self.nameLabel.text = @"老板位";
        self.avatarView.image = nil;
    }
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgView.image = [UIImage imageNamed_sy:@"voiceroom_boss_seat"];
    }
    return _bgView;
}

- (UIImageView *)stripView {
    if (!_stripView) {
        CGFloat width = 56.f;
        CGFloat height = 18.f;
        _stripView = [[UIImageView alloc] initWithFrame:CGRectMake((self.sy_width - width) / 2.f, self.sy_height - height, width, height)];
        _stripView.image = [UIImage imageNamed_sy:@"voiceroom_boss_seat_strip"];
    }
    return _stripView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.f, 0, self.stripView.sy_width - 26, self.stripView.sy_height)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:9.f];
        _nameLabel.textColor = [UIColor sam_colorWithHex:@"#8E4E00"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        CGFloat width = 45.f;
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake((self.sy_width - width) / 2.f, 17.f, width, width)];
        _avatarView.layer.cornerRadius = width / 2.f;
        _avatarView.clipsToBounds = YES;
    }
    return _avatarView;
}

- (void)tap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomBossViewDidClicked)]) {
        [self.delegate voiceRoomBossViewDidClicked];
    }
}

@end
