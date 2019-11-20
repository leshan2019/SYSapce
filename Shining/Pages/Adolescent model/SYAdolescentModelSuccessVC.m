//
//  SYAdolescentModelSuccessVC.m
//  Shining
//
//  Created by 杨玄 on 2019/9/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYAdolescentModelSuccessVC.h"
#import "SYUserServiceAPI.h"

@interface SYAdolescentModelSuccessVC ()
@property (nonatomic, strong) UIView *navBack;
@property (nonatomic, strong) UILabel *navTitle;            // @"身份验证"
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *titleLabel;          // @"已认证为成年人，进入正常模式功能没有限制，均可使用"
@property (nonatomic, strong) UIButton *ensureBtn;          // "确定"
@end

@implementation SYAdolescentModelSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Private

- (void)initWithSubviews {
    [self.view addSubview:self.tipImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.ensureBtn];
    [self.view addSubview:self.navBack];
    [self.navBack addSubview:self.navTitle];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(iPhoneX ? 24+64+45 : 64+45);
        make.size.mas_equalTo(CGSizeMake(227, 143));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipImageView.mas_bottom).with.offset(55);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(252, 55));
    }];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(122);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(263, 44));
    }];
    [self.navBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(iPhoneX ? 64 + 24 : 64);
    }];
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 22));
        make.bottom.equalTo(self.navBack).with.offset(-11);
        make.centerX.equalTo(self.navBack);
    }];
}

#pragma mark - BtnClickEvent

// 确定
- (void)handleEnsureBtnClickEvent {
    [self.navigationController popToRootViewControllerAnimated:YES];
    // 刷新个人用户信息
    [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_USERINFOREADY object:nil];
        }
    }];
}

#pragma mark - Lazyload

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [UIImageView new];
        _tipImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tipImageView.image = [UIImage imageNamed_sy:@"sy_adolescent_vc"];
    }
    return _tipImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _titleLabel.textColor = RGBACOLOR(11,11,11,1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"已认证为成年人，进入正常模式功能没有限制，均可使用";
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton new];
        _ensureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:RGBACOLOR(255,255,255,0.8) forState:UIControlStateHighlighted];
        [_ensureBtn setBackgroundImage:[SYUtil imageFromColor:RGBACOLOR(0,0,0,0.2)] forState:UIControlStateHighlighted];
        _ensureBtn.backgroundColor = RGBACOLOR(113,56,239,1);
        _ensureBtn.layer.cornerRadius = 22;
        _ensureBtn.clipsToBounds = YES;
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(handleEnsureBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}

- (UIView *)navBack {
    if (!_navBack) {
        _navBack = [UIView new];
        _navBack.backgroundColor = RGBACOLOR(245,246,247,0.82);
    }
    return _navBack;
}

- (UIView *)navTitle {
    if (!_navTitle) {
        _navTitle = [UILabel new];
        _navTitle.text = @"身份验证";
        _navTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:17];
        _navTitle.textColor = [UIColor blackColor];
        _navTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitle;
}

@end
