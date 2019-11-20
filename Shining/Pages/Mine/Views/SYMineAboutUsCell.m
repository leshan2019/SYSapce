//
//  SYMineAboutUsCell.m
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineAboutUsCell.h"

@interface SYMineAboutUsCell ()

@property (nonatomic, strong) UILabel *mainTitle;           // 主标题
@property (nonatomic, strong) UILabel *subTitle;            // 副标题
@property (nonatomic, strong) UIImageView *rightIcon;       // 右侧角标
@property (nonatomic, strong) UIView *bottomView;           // 底部分割线

@end

@implementation SYMineAboutUsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.contentView.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:self.mainTitle];
        [self.contentView addSubview:self.subTitle];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addSubview:self.bottomView];

        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(60, 15));
        }];

        [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.centerY.equalTo(self.mainTitle);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];

        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightIcon.mas_left).with.offset(-2);
            make.centerY.equalTo(self.mainTitle);
            make.left.equalTo(self.mainTitle.mas_right).with.offset(5);
            make.height.mas_equalTo(16);
        }];

        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];

    }
    return self;
}

#pragma mark - Public

- (void)updateCellWithType:(SYMineAboutUsCellType)type withTitle:(NSString *)title withSubtitle:(NSString *)subTitle {
    self.subTitle.hidden = type != SYMineAboutUsCellType_ServiceQQ;
    self.mainTitle.text = title;
    self.subTitle.text = subTitle;
}

#pragma mark - LazyLoad

- (UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [UILabel new];
        _mainTitle.textColor = RGBACOLOR(11, 11, 11, 1);
        _mainTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _mainTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _mainTitle;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [UILabel new];
        _subTitle.textColor = RGBACOLOR(153, 153, 153, 1);
        _subTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _subTitle.textAlignment = NSTextAlignmentRight;
    }
    return _subTitle;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [UIImageView new];
        _rightIcon.image = [UIImage imageNamed_sy:@"voiceroom_right_icon"];
    }
    return _rightIcon;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomView;
}

@end
