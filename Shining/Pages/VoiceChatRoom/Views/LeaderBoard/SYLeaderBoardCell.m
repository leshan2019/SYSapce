//
//  SYLeaderBoardCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLeaderBoardCell.h"
#import "SYVoiceRoomSexView.h"
#import "SYVIPLevelView.h"
#import "SYBroadcasterLevelView.h"

@interface SYLeaderBoardCell ()

@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *avatarBox;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) SYVIPLevelView *vipView;
@property (nonatomic, strong) SYBroadcasterLevelView *broadcasterLevelView;
@property (nonatomic, strong) SYVoiceRoomSexView *sexView;
@property (nonatomic, strong) UILabel *sumLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation SYLeaderBoardCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.indexLabel];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.avatarBox];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.broadcasterLevelView];
        [self.contentView addSubview:self.vipView];
        [self.contentView addSubview:self.sexView];
        [self.contentView addSubview:self.sumLabel];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)showWithName:(NSString *)name
              avatar:(NSString *)avatar
           avatarBox:(NSString *)avatarBox
                 vip:(NSInteger)vip
       isBroadcaster:(NSInteger)isBroadcaster
    broadcasterLevel:(NSInteger)broadcasterLevel
              gender:(NSString *)gender
                 age:(NSInteger)age
                 sum:(NSString *)sum
               index:(NSInteger)index
         needShowVip:(BOOL)needShowVip {
    self.vipView.hidden = !needShowVip;
    self.nameLabel.text = name;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatar]
                       placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    [self.avatarBox sd_setImageWithURL:[NSURL URLWithString:avatarBox]];
    self.indexLabel.text = [NSString stringWithFormat:@"%@", @(index)];
    [self.broadcasterLevelView showWithBroadcasterLevel:broadcasterLevel];
    [self.vipView showWithVipLevel:vip];
    [self.sexView setSex:gender andAge:age];
    if (isBroadcaster == 1) {
        self.broadcasterLevelView.hidden = NO;
        if (needShowVip) {
            self.vipView.sy_left = self.broadcasterLevelView.sy_right + 4.f;
        } else {
            self.vipView.sy_left = self.broadcasterLevelView.sy_left;
        }
    } else {
        self.broadcasterLevelView.hidden = YES;
        self.vipView.sy_left = self.broadcasterLevelView.sy_left;
    }
    self.sexView.sy_left = self.vipView.sy_right + 4.f;
    self.sumLabel.text = sum;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 20)];
        _indexLabel.font = [UIFont systemFontOfSize:14.f];
        _indexLabel.textColor = [UIColor whiteColor];
//        _indexLabel.textAlignment = NSTextAlignmentRight;
    }
    return _indexLabel;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        CGFloat width = 38.f;
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(52.f, 13.f, width, width)];
        _avatarView.layer.cornerRadius = width / 2.f;
        _avatarView.clipsToBounds = YES;
    }
    return _avatarView;
}

- (UIImageView *)avatarBox {
    if (!_avatarBox) {
        _avatarBox = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
        _avatarBox.center = self.avatarView.center;
    }
    return _avatarBox;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarView.frame) + 10.f, 15.f, self.bounds.size.width - 180.f, 17.f)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _nameLabel;
}

- (SYBroadcasterLevelView *)broadcasterLevelView {
    if (!_broadcasterLevelView) {
        _broadcasterLevelView = [[SYBroadcasterLevelView alloc] initWithFrame:CGRectMake(self.nameLabel.sy_left, self.nameLabel.sy_bottom + 3.f, 0, 0)];
    }
    return _broadcasterLevelView;
}

- (SYVIPLevelView *)vipView {
    if (!_vipView) {
        _vipView = [[SYVIPLevelView alloc] initWithFrame:CGRectMake(self.nameLabel.sy_left, self.nameLabel.sy_bottom + 3.f, 30, 14)];
    }
    return _vipView;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc] initWithFrame:CGRectMake(self.nameLabel.sy_left, self.nameLabel.sy_bottom + 3.f, 40.f, 14.f)];
    }
    return _sexView;
}

- (UILabel *)sumLabel {
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sy_width - 100.f, 24.f, 80.f, 17.f)];
        _sumLabel.font = [UIFont systemFontOfSize:12.f];
        _sumLabel.textColor = [UIColor whiteColor];
        _sumLabel.textAlignment = NSTextAlignmentRight;
    }
    return _sumLabel;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - 0.5, self.sy_width, 0.5)];
        _line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
    }
    return _line;
}

@end
