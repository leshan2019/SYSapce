//
//  SYMyVoiceRoomListViewCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMyVoiceRoomListViewCell.h"

@interface SYMyVoiceRoomListViewCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *roleLabel;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *userNumLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *statusIndicator;

@end

@implementation SYMyVoiceRoomListViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView.layer addSublayer:self.gradientLayer];
        [self.contentView addSubview:self.roleLabel];
        [self.contentView addSubview:self.userNumLabel];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.statusIndicator];
    }
    return self;
}

- (void)showCellWithRoomName:(NSString *)roomName
                    roomIcon:(NSString *)roomIcon
                     userNum:(NSInteger)userNum
                        role:(NSInteger)role
                      isOpen:(BOOL)isOpen {
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:roomIcon]
                       placeholderImage:[SYUtil placeholderImageWithSize:self.avatarView.sy_size]];
    self.nameLabel.text = roomName;
    self.roleLabel.text = (role == 1) ? @"房主" : @"管理员";
    if (role == 1) {
        NSArray *colors = @[(__bridge id)[UIColor sam_colorWithHex:@"#AD73FD"].CGColor, (__bridge id)[UIColor sam_colorWithHex:@"#753FFB"].CGColor];
        self.gradientLayer.colors = colors;
    } else {
        NSArray *colors = @[(__bridge id)[UIColor sam_colorWithHex:@"#FAC253"].CGColor, (__bridge id)[UIColor sam_colorWithHex:@"#F8822A"].CGColor];
        self.gradientLayer.colors = colors;
    }
    self.userNumLabel.text = [NSString stringWithFormat:@"当前%ld人在线", (long)userNum];
    self.statusLabel.text = isOpen ? @"开放中" : @"关闭中";
    self.statusIndicator.backgroundColor = isOpen ? [UIColor sam_colorWithHex:@"#07E582"] : [UIColor sam_colorWithHex:@"#B3B8BA"];
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(12.f, 11.f, 106, 106)];
        _avatarView.layer.cornerRadius = 10.f;
        _avatarView.clipsToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.avatarView.sy_right + 10.f, 32.f, self.sy_width - (self.avatarView.sy_right + 10.f) - 12.f, 18.f)];
        _nameLabel.font = [UIFont systemFontOfSize:16.f];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UILabel *)roleLabel {
    if (!_roleLabel) {
        _roleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.sy_left, self.nameLabel.sy_bottom + 6.f, 46, 20.f)];
        _roleLabel.font = [UIFont systemFontOfSize:12.f];
        _roleLabel.textColor = [UIColor whiteColor];
        _roleLabel.backgroundColor = [UIColor clearColor];
        _roleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _roleLabel;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(self.nameLabel.sy_left, self.nameLabel.sy_bottom + 6.f, 46, 20.f);
        NSArray *colors = @[(__bridge id)[UIColor sam_colorWithHex:@"#AD73FD"].CGColor, (__bridge id)[UIColor sam_colorWithHex:@"#753FFB"].CGColor];
        gradientLayer.colors = colors;
        gradientLayer.cornerRadius = 2.f;
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}

- (UILabel *)userNumLabel {
    if (!_userNumLabel) {
        _userNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.sy_left, self.roleLabel.sy_bottom + 4.f, self.nameLabel.sy_width, 14)];
        _userNumLabel.font = [UIFont systemFontOfSize:12.f];
        _userNumLabel.textColor = [UIColor sam_colorWithHex:@"#999999"];
    }
    return _userNumLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        CGFloat width = 35.f;
        CGFloat height = 12.f;
        CGFloat y = (self.sy_height - height) / 2.f;
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.sy_width - 10.f - width, y, width, height)];
        _statusLabel.font = [UIFont systemFontOfSize:11.f];
        _statusLabel.textColor = [UIColor sam_colorWithHex:@"#999999"];
    }
    return _statusLabel;
}

- (UIView *)statusIndicator {
    if (!_statusIndicator) {
        CGFloat width = 10.f;
        CGFloat height = 10.f;
        CGFloat y = (self.sy_height - height) / 2.f;
        _statusIndicator = [[UIView alloc] initWithFrame:CGRectMake(self.statusLabel.sy_left - 4.f - width, y, width, height)];
        _statusIndicator.layer.cornerRadius = 5.f;
    }
    return _statusIndicator;
}

@end
