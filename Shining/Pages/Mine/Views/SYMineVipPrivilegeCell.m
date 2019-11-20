//
//  SYMineVipPrivilegeCell.m
//  Shining
//
//  Created by 杨玄 on 2019/6/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYMineVipPrivilegeCell.h"

@interface SYMineVipPrivilegeCell ()

@property (nonatomic, strong) UIImageView *iconImage;       // icon
@property (nonatomic, strong) UILabel *mainTitle;           // 主标题
@property (nonatomic, strong) UILabel *subTitle;            // 副标题

@end

@implementation SYMineVipPrivilegeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.contentView.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.mainTitle];
        [self.contentView addSubview:self.subTitle];

        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(52, 52));
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(iPhone5 ? 10 : 18);
        }];

        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_bottom).with.offset(6);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(20);
        }];

        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mainTitle.mas_bottom);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(17);
        }];

    }
    return self;
}

- (void)updateVipPrivilegeCellWithIcon:(NSString *)iconUrl title:(NSString *)title subTitle:(NSString *)subTitle {
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed_sy:@"mine_level_vip_icon_default"]];
    self.mainTitle.text = title;
    self.subTitle.text = subTitle;
}

#pragma mark - LazyLoad

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [UIImageView new];
        _iconImage.image = [UIImage imageNamed_sy:@"mine_level_vip_icon_default"];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImage;
}

- (UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [UILabel new];
        _mainTitle.textColor = RGBACOLOR(52,54,66,1);
        _mainTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _mainTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _mainTitle;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [UILabel new];
        _subTitle.textColor = RGBACOLOR(52,54,66,1);
        _subTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _subTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitle;
}

@end
