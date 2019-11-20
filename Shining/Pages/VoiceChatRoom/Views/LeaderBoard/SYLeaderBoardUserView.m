//
//  SYLeaderBoardUserView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLeaderBoardUserView.h"
#import "SYVoiceRoomSexView.h"
#import "SYVIPLevelView.h"
#import "SYBroadcasterLevelView.h"

@interface SYLeaderBoardUserView ()

@property (nonatomic, strong) UIImageView *crownView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) SYVIPLevelView *vipView;
@property (nonatomic, strong) SYBroadcasterLevelView *broadcasterLevelView;
@property (nonatomic, strong) SYVoiceRoomSexView *sexView;
@property (nonatomic, strong) UILabel *sumLabel;

@end

@implementation SYLeaderBoardUserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.crownView];
        [self.crownView addSubview:self.avatarView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.broadcasterLevelView];
        [self addSubview:self.vipView];
        [self addSubview:self.sexView];
        [self addSubview:self.sumLabel];
    }
    return self;
}

- (void)showWithRank:(NSInteger)rank
                name:(NSString *)name
              avatar:(NSString *)avatar
       isBroadcaster:(NSInteger)isBroadcaster
    broadcasterLevel:(NSInteger)broadcasterLevel
                 vip:(NSInteger)vip
              gender:(NSString *)gender
                 age:(NSInteger)age
                 sum:(NSString *)sum {
    NSString *crownName = @"";
    if (rank == 1) {
        crownName = @"voiceroom_crown_gold";
    } else if (rank == 2) {
        crownName = @"voiceroom_crown_silver";
    } else if (rank == 3) {
        crownName = @"voiceroom_crown_bronze";
    }
    self.crownView.image = [UIImage imageNamed_sy:crownName];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatar]
                       placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    self.nameLabel.text = name;
    [self.vipView showWithVipLevel:vip];
    [self.sexView setSex:gender andAge:age];
    self.sumLabel.text = sum;
    
    if (isBroadcaster == 1) {
        CGFloat width = self.broadcasterLevelView.sy_width + 4.f + self.sexView.sy_width;
        self.vipView.hidden = YES;
        self.broadcasterLevelView.hidden = NO;
        [self.broadcasterLevelView showWithBroadcasterLevel:broadcasterLevel];
        self.broadcasterLevelView.sy_left = (self.sy_width - width) / 2.f;
        self.sexView.sy_left = self.broadcasterLevelView.sy_right + 4.f;
        
    } else {
        CGFloat width = self.vipView.sy_width + 4.f + self.sexView.sy_width;
        self.broadcasterLevelView.hidden = YES;
        self.vipView.hidden = NO;
        self.vipView.sy_left = (self.sy_width - width) / 2.f;
        self.sexView.sy_left = self.vipView.sy_right + 4.f;
    }
}

- (void)setAvatarSize:(CGSize)size
                 left:(CGFloat)left
               bottom:(CGFloat)bottom {
    self.avatarView.sy_size = size;
    self.avatarView.sy_left = left;
    self.avatarView.sy_top = self.crownView.sy_height - size.height - bottom;
    self.avatarView.layer.cornerRadius = size.height / 2.f;
}

- (void)setNameColor:(UIColor *)color
            sumColor:(UIColor *)sumColor {
    self.nameLabel.textColor = color;
    self.sumLabel.textColor = sumColor;
}

- (UIImageView *)crownView {
    if (!_crownView) {
        _crownView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 0, self.sy_width - 40.f, self.sy_height - 52.f)];
    }
    return _crownView;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        CGFloat width = self.crownView.sy_width - 8.f;
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(4.f, self.crownView.sy_height - width - 4.f, width, width)];
        _avatarView.layer.cornerRadius = width / 2.f;
        _avatarView.clipsToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.crownView.sy_bottom + 3.f, self.sy_width, 14.f)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _nameLabel;
}

- (SYVIPLevelView *)vipView {
    if (!_vipView) {
        _vipView = [[SYVIPLevelView alloc] initWithFrame:CGRectMake(0, self.nameLabel.sy_bottom + 3.f, 30, 14)];
    }
    return _vipView;
}

- (SYBroadcasterLevelView *)broadcasterLevelView {
    if (!_broadcasterLevelView) {
        _broadcasterLevelView = [[SYBroadcasterLevelView alloc] initWithFrame:CGRectMake(0, self.nameLabel.sy_bottom + 3.f, 0, 0)];
    }
    return _broadcasterLevelView;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc] initWithFrame:CGRectMake(0, self.nameLabel.sy_bottom + 3.f, 40.f, 14.f)];
    }
    return _sexView;
}

- (UILabel *)sumLabel {
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.sexView.sy_bottom + 4.f, self.sy_width, 14.f)];
        _sumLabel.font = [UIFont systemFontOfSize:10.f];
        _sumLabel.textColor = [UIColor sam_colorWithHex:@"#CCCCCC"];
        _sumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sumLabel;
}

@end
