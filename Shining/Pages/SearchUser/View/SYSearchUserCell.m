//
//  SYSearchUserCell.m
//  Shining
//
//  Created by 杨玄 on 2019/9/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSearchUserCell.h"
#import "SYVoiceRoomSexView.h"
#import "SYVIPLevelView.h"

@interface SYSearchUserCell ()

@property (nonatomic, strong) UIImageView *avatarView;      //头像
@property (nonatomic, strong) UILabel *nameLabel;           //name
@property (nonatomic, strong) SYVoiceRoomSexView *sexView;  //性别
@property (nonatomic, strong) SYVIPLevelView *vipView;
@property (nonatomic, strong) UILabel *idLabel;             //id
@property (nonatomic, strong) UIView *bottomLine;           //分割线

@end

@implementation SYSearchUserCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.vipView];
    [self.contentView addSubview:self.sexView];
    [self.contentView addSubview:self.idLabel];
    [self.contentView addSubview:self.bottomLine];

    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(42, 42));
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(14);
        make.top.equalTo(self.contentView).with.offset(15);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(0);
    }];

    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(4);
        make.centerY.equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(34, 14));
    }];

    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipView.mas_right).with.offset(4);
        make.centerY.equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(34, 14));
    }];

    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(94, 14));
    }];

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).with.offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];

    return self;
}

- (void)updateSYSearchUserViewWithHeaderUrl:(NSString *)imageUrl name:(NSString *)name gender:(NSString *)gender age:(NSUInteger)age userId:(NSString *)userId level:(NSUInteger)level {

    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];

    self.nameLabel.text = name;
    CGFloat maxWidth = __MainScreen_Width - 71 - 34*2 - 4*2 - 20;
    CGFloat titleWidth = [name sizeWithAttributes:@{NSFontAttributeName: self.nameLabel.font }].width + 1;
    if (titleWidth >= maxWidth) {
        titleWidth = maxWidth;
    }
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth);
    }];

    [self.vipView showWithVipLevel:level];

    [self.sexView setSex:gender andAge:age];
    CGSize size = self.sexView.frame.size;
    [self.sexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];

    self.idLabel.text = [NSString stringWithFormat:@"ID：%@",userId];
}

#pragma mark - LazyLoad

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = 20;
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.backgroundColor = [UIColor clearColor];;
        _nameLabel.textColor = RGBACOLOR(11,11,11,1);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    }
    return _nameLabel;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc]initWithFrame:CGRectMake(0, 0, 34, 14)];
    }
    return _sexView;
}

- (SYVIPLevelView *)vipView {
    if (!_vipView) {
        _vipView = [[SYVIPLevelView alloc] initWithFrame:CGRectZero];
    }
    return _vipView;
}

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [UILabel new];
        _idLabel.backgroundColor = [UIColor clearColor];;
        _idLabel.textColor = RGBACOLOR(0,0,0,1);
        _idLabel.textAlignment = NSTextAlignmentLeft;
        _idLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    }
    return _idLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

@end
