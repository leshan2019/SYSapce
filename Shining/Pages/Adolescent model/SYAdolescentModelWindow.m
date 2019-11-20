//
//  SYAdolescentModelWindow.m
//  Shining
//
//  Created by 杨玄 on 2019/9/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYAdolescentModelWindow.h"

@interface SYAdolescentModelWindow ()
// UI
@property (nonatomic, strong) UIButton *whiteBox;               // 底部白框
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLabel;                // @"为呵护未成年人健康成长..."
@property (nonatomic, strong) UIButton *enterAdolescentBtn;     // "不认证，进入青少年模式 >" or "暂不认证 >"
@property (nonatomic, strong) UIButton *gotoAuthenBtn;          // "去认证"按钮
@property (nonatomic, strong) UIView *horizonLine;              // 分割线

// type
@property (nonatomic, assign) SYAdolescentModelType windowType;

// 回调
@property (nonatomic, copy) AuthenClick authenClick;
@property (nonatomic, copy) AdolescentModelClick adolesClick;
@property (nonatomic, copy) TemporaryAuthenClick temporaryClick;

@end

@implementation SYAdolescentModelWindow

+ (instancetype)createSYAdolescentModelWindowWithType:(SYAdolescentModelType)type Authen:(AuthenClick)authenClick AdolescentModel:(AdolescentModelClick)adolesClick TempraryAuthen:(TemporaryAuthenClick)temporaryClick {
    SYAdolescentModelWindow *window = [[SYAdolescentModelWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    window.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
    window.windowType = type;
    window.authenClick = authenClick;
    window.adolesClick = adolesClick;
    window.temporaryClick = temporaryClick;
    [window initWithSubviews];
    return window;
}

#pragma mark - Private

- (void)initWithSubviews {
    // UI
    [self addSubview:self.whiteBox];
    [self.whiteBox addSubview:self.tipImageView];
    [self.whiteBox addSubview:self.tipLabel];
    [self.whiteBox addSubview:self.enterAdolescentBtn];
    [self.whiteBox addSubview:self.horizonLine];
    [self.whiteBox addSubview:self.gotoAuthenBtn];

    // Layout
    [self mas_makeConstraints];

    // Text
    if (self.windowType == SYAdolescentModelType_Normal) {
        self.tipLabel.text = @"为呵护未成年人健康成长，Bee语音特别推出青少年模式，该模式下一些功能将有所限制。\n选择暂不认证，默认为您已满18岁";
        [self.enterAdolescentBtn setTitle:@"去认证 >" forState:UIControlStateNormal];
        [self.gotoAuthenBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    } else {
        self.tipLabel.text = @"为呵护未成年人健康成长，Bee语音特别推出青少年模式，该模式下一些功能将有所限制。\n使用正常模式需进行身份验证，不认证将进入青少年模式。";
        [self.enterAdolescentBtn setTitle:@"不认证，进入青少年模式 >" forState:UIControlStateNormal];
        [self.gotoAuthenBtn setTitle:@"去认证" forState:UIControlStateNormal];
    }
}

- (void)mas_makeConstraints {
    [self.whiteBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        if (self.windowType == SYAdolescentModelType_Normal) {
            make.size.mas_equalTo(CGSizeMake(270, 332));
        } else {
            make.size.mas_equalTo(CGSizeMake(270, 355));
        }
    }];
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBox).with.offset(10);
        make.centerX.equalTo(self.whiteBox);
        make.size.mas_equalTo(CGSizeMake(139, 117));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipImageView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.whiteBox);
        if (self.windowType == SYAdolescentModelType_Normal) {
            make.size.mas_equalTo(CGSizeMake(238, 92));
        } else {
            make.size.mas_equalTo(CGSizeMake(238, 115));
        }
    }];
    [self.enterAdolescentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteBox);
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(168, 23));
    }];
    [self.horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBox);
        make.right.equalTo(self.whiteBox);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.enterAdolescentBtn.mas_bottom).with.offset(10);
    }];
    [self.gotoAuthenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.horizonLine.mas_bottom).with.offset(0);
        make.left.equalTo(self.whiteBox);
        make.right.equalTo(self.whiteBox);
        make.height.mas_equalTo(50);
    }];
}

// “不认证，进入青少年模式 >” + “暂不认证 >”
- (void)handleEnterAdolescentBtnClickEvent {
    [self removeFromSuperview];
    if (self.windowType == SYAdolescentModelType_Strict) {
        // 进入青少年模式
        if (self.adolesClick) {
            self.adolesClick();
        }
    } else {
        // 去认证
        if (self.authenClick) {
            self.authenClick();
        }
    }
}

// “去认证”点击事件
- (void)handleGotoAuthenBtnClickEvent {
    [self removeFromSuperview];
    if (self.windowType == SYAdolescentModelType_Strict) {
        // 进入青少年模式
        if (self.authenClick) {
            self.authenClick();
        }
    } else {
        // 暂不认证，默认满18岁
        if (self.temporaryClick) {
            self.temporaryClick();
        }
    }
}

#pragma mark - LazyLoad

- (UIButton *)whiteBox {
    if (!_whiteBox) {
        _whiteBox = [UIButton new];
        _whiteBox.backgroundColor = [UIColor whiteColor];
        _whiteBox.layer.cornerRadius = 5;
    }
    return _whiteBox;
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [UIImageView new];
        _tipImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tipImageView.image = [UIImage imageNamed_sy:@"sy_adolescent_toast"];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _tipLabel.textColor = RGBACOLOR(68,68,68,1);
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIButton *)enterAdolescentBtn {
    if (!_enterAdolescentBtn) {
        _enterAdolescentBtn = [UIButton new];
        [_enterAdolescentBtn setTitleColor:RGBACOLOR(113,56,239,1) forState:UIControlStateNormal];
        _enterAdolescentBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_enterAdolescentBtn addTarget:self action:@selector(handleEnterAdolescentBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterAdolescentBtn;
}

- (UIView *)horizonLine {
    if (!_horizonLine) {
        _horizonLine = [UIView new];
        _horizonLine.backgroundColor = RGBACOLOR(0,0,0,0.08);
    }
    return _horizonLine;
}

- (UIButton *)gotoAuthenBtn {
    if (!_gotoAuthenBtn) {
        _gotoAuthenBtn = [UIButton new];
        [_gotoAuthenBtn setTitle:@"去认证" forState:UIControlStateNormal];
        [_gotoAuthenBtn setTitleColor:RGBACOLOR(11,11,11,1) forState:UIControlStateNormal];
        _gotoAuthenBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_gotoAuthenBtn addTarget:self action:@selector(handleGotoAuthenBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoAuthenBtn;
}

@end
