//
//  SYVoiceRoomOnlineListCell.m
//  Shining
//
//  Created by 杨玄 on 2019/4/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomOnlineListCell.h"
//#import <UIImageView+WebCache.h>
#import "SYVoiceRoomSexView.h"
#import "SYVIPLevelView.h"

@interface SYVoiceRoomOnlineListCell ()

@property (strong, nonatomic) UIImageView *avatarView;      //头像
@property (strong, nonatomic) UILabel *titleLabel;          //name
@property (strong, nonatomic) SYVoiceRoomSexView *sexView;  //性别
@property (nonatomic, strong) SYVIPLevelView *vipView;

@end

@implementation SYVoiceRoomOnlineListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.sexView];
        [self.contentView addSubview:self.vipView];

        [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).with.offset(6);
            make.top.equalTo(self.contentView).with.offset(11);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(0);
        }];

        [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.avatarView.mas_right).with.offset(6);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
            make.size.mas_equalTo(CGSizeMake(34, 14));
        }];

        [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vipView.mas_right).with.offset(4);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
            make.size.mas_equalTo(CGSizeMake(34, 14));
        }];

    }
    return self;
}

- (void)updateCellWithHeaderImage:(NSString *)imageUrl withName:(NSString *)name                        withGender:(NSString *)gender withAge:(NSUInteger)age withId:(NSString *)idText withLevel:(NSUInteger)level{

    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];

    self.titleLabel.text = name;
    CGFloat maxWidth = __MainScreen_Width - 71 - 34 - 4 - 20;
    CGFloat titleWidth = [name sizeWithAttributes:@{NSFontAttributeName: _titleLabel.font}].width;
    if (titleWidth >= maxWidth) {
        titleWidth = maxWidth;
    }
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth+1);
    }];

    [self.vipView showWithVipLevel:level];

    [self.sexView setSex:gender andAge:age];
    CGSize size = self.sexView.frame.size;
    [self.sexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];

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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    }
    return _titleLabel;
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

@end
