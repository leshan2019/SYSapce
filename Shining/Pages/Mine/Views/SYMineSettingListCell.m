//
//  SYMineSettingListCell.m
//  Shining
//
//  Created by 杨玄 on 2019/3/21.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineSettingListCell.h"
//#import <Masonry.h>

@interface SYMineSettingListCell ()

@property (nonatomic, strong) UILabel *mainTitle;           // 主标题
@property (nonatomic, strong) UILabel *subTitle;            // 副标题
@property (nonatomic, strong) UIImageView *rightIcon;       // 右侧角标
@property (nonatomic, strong) UISwitch *switchBtn;          // 开关按钮
@property (nonatomic, strong) UIView *bottomView;           // 底部分割线
@property (nonatomic, strong) UILabel *redLbl;              // 红点

@property (nonatomic, assign) SYMineSettingCellType type;

@end

@implementation SYMineSettingListCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.mainTitle];
        [self.contentView addSubview:self.subTitle];
        [self.contentView addSubview:self.switchBtn];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.redLbl];

        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(100, 15));
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

        [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(49, 31));
            make.centerY.equalTo(self.mainTitle);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];

        [self.redLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.right.equalTo(self.rightIcon.mas_left).with.offset(-5);
            make.centerY.equalTo(self.mainTitle);
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

- (void)updateSettingListCellWithType:(SYMineSettingCellType)type withTitle:(NSString *)title withSubTitle:(NSString *)subTitle withOpenMessageNotify:(BOOL)open withShowBottomLine:(BOOL)show{
    self.type = type;
    self.switchBtn.hidden = (type != SYMineSettingCellType_NewMessage && type != SYMineSettingCellType_Noise);
    self.rightIcon.hidden = (type == SYMineSettingCellType_NewMessage || type == SYMineSettingCellType_Noise);
    self.subTitle.hidden = (type == SYMineSettingCellType_NewMessage || type == SYMineSettingCellType_Noise);
    self.mainTitle.text = title;
    self.subTitle.text = subTitle;
    self.bottomView.hidden = !show;
    if (type == SYMineSettingCellType_NewMessage ||
        type == SYMineSettingCellType_Noise) {
        self.switchBtn.on = open;
    }
    if (type == SYMineSettingCellType_IDCard) {
        UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
        NSInteger authModel = userInfo.auth_model;
        if (authModel == 2) {
            self.subTitle.textColor = RGBACOLOR(68, 68, 68, 1);
        } else {
            self.subTitle.textColor = RGBACOLOR(153, 153, 153, 1);
        }
    }
}

- (void)showUnreadRedPoint:(BOOL)isHidden {
    self.redLbl.hidden = isHidden;
}

- (void)updateCellSubtitle:(NSString *)subTitle {
    self.subTitle.text = subTitle;
}

#pragma mark - LazyLoad


- (UILabel *)redLbl {
    if (!_redLbl) {
        _redLbl = [UILabel new];
        _redLbl.layer.backgroundColor = [UIColor redColor].CGColor;
        _redLbl.textColor = RGBACOLOR(11, 11, 11, 1);
        _redLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _redLbl.textAlignment = NSTextAlignmentCenter;
        _redLbl.hidden = YES;
        _redLbl.layer.cornerRadius = 10/2;
    }
    return _redLbl;
}

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
        _subTitle.textColor = RGBACOLOR(68, 68, 68, 1);
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

- (UISwitch *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switchBtn setTintColor:RGBACOLOR(223, 223, 223, 1)];
        [_switchBtn setBackgroundColor:RGBACOLOR(223, 223, 223, 1)];
        [_switchBtn setOnTintColor:RGBACOLOR(113, 56, 239, 1)];
        [_switchBtn setThumbTintColor:[UIColor whiteColor]];
        _switchBtn.clipsToBounds = YES;
        _switchBtn.layer.cornerRadius = 15.5f;
        [_switchBtn addTarget:self action:@selector(handleSwitchBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomView;
}

- (void)handleSwitchBtnClickEvent:(UISwitch *)switchBtn {
    if (self.type == SYMineSettingCellType_NewMessage) {
        BOOL open = [SYSettingManager isOpenNewMessageNotify];
        switchBtn.on = !open;
        [SYSettingManager setNewMessageNotify:!open];
    } else if (self.type == SYMineSettingCellType_Noise) {
        [SYSettingManager setVoiceRoomMicDenoiseFlag:switchBtn.on];
    }
}

@end
