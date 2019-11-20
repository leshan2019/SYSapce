//
//  SYVoiceRoomGetRedPacketUserCell.m
//  Shining
//
//  Created by yangxuan on 2019/9/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGetRedPacketUserCell.h"

@interface SYVoiceRoomGetRedPacketUserCell ()

@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation SYVoiceRoomGetRedPacketUserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)configueData:(NSString *)userIcon name:(NSString *)userName coinCount:(NSInteger)coinCount getTime:(NSString *)time {
    // avatar
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:userIcon] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];
    // coin
    NSString *coinStr = [NSString stringWithFormat:@"%ld蜜豆",coinCount];
    CGFloat coinWidth = [coinStr sizeWithAttributes:@{NSFontAttributeName: self.coinLabel.font}].width+1;
    [self.coinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(coinWidth);
    }];
    self.coinLabel.text = coinStr;
    // time
    NSString *timeStr = time;
    CGFloat timeWidth = [timeStr sizeWithAttributes:@{NSFontAttributeName: self.timeLabel.font}].width+1;
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(timeWidth);
    }];
    self.timeLabel.text = timeStr;
    // name
    self.userName.text = userName;
    CGFloat titleWidth = [userName sizeWithAttributes:@{NSFontAttributeName: self.userName.font}].width+1;
    CGFloat maxWidth = self.contentView.sy_width - 71 - (coinWidth > timeWidth ? coinWidth : timeWidth) - 20 - 14;
    if (titleWidth > maxWidth) {
        titleWidth = maxWidth;
    }
    [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth);
    }];
}

#pragma mark - Private

- (void)initSubViews {
    [self.contentView addSubview:self.userIcon];
    [self.contentView addSubview:self.userName];
    [self.contentView addSubview:self.coinLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bottomLine];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(42, 42));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).with.offset(14);
        make.centerY.equalTo(self.userIcon);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(21);
    }];
    
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(17);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coinLabel.mas_bottom).with.offset(2);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(14);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - LazyLoad

- (UIImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [UIImageView new];
        _userIcon.clipsToBounds = YES;
        _userIcon.layer.cornerRadius = 21;
    }
    return _userIcon;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [UILabel new];
        _userName.textColor = RGBACOLOR(11,11,11,1);
        _userName.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _userName.textAlignment = NSTextAlignmentLeft;
    }
    return _userName;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [UILabel new];
        _coinLabel.textColor = RGBACOLOR(68,68,68,1);
        _coinLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _coinLabel.textAlignment = NSTextAlignmentRight;
    }
    return _coinLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = RGBACOLOR(153,153,153,1);
        _timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

@end
