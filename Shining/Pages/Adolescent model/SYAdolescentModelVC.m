//
//  SYAdolescentModelVC.m
//  Shining
//
//  Created by 杨玄 on 2019/9/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//
/*
#import "SYAdolescentModelVC.h"
#import "SYIDCardAuthenticationVC.h"
#import "SYUserServiceAPI.h"

@interface SYAdolescentModelVC ()
@property (nonatomic, strong) UIScrollView *scrollView;     // 滑动view
@property (nonatomic, strong) UIView *navBack;
@property (nonatomic, strong) UILabel *navTitle;            // @"身份验证"
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *titleLabel;          // @"未身份认证，进入青少年模式"
@property (nonatomic, strong) UIView *pointOne;
@property (nonatomic, strong) UILabel *tipOne;              // @"无法充值蜜豆"
@property (nonatomic, strong) UIView *pointTwo;
@property (nonatomic, strong) UILabel *tipTwo;              // @"无法进行打赏"
@property (nonatomic, strong) UIView *pointThree;
@property (nonatomic, strong) UILabel *tipThree;            // @"无法参与砸蛋等游戏"
@property (nonatomic, strong) UIView *pointFour;
@property (nonatomic, strong) UILabel *tipFour;             // @"只可进入未成年人"
@property (nonatomic, strong) UILabel *bottomTitle;             // @"身份认证成年后，可开启正常模式"
@property (nonatomic, strong) UIButton *ensureBtn;          // "确定"
@property (nonatomic, strong) UIButton *gotoAuthenBtn;      // "去认证"
@end

@implementation SYAdolescentModelVC

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
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tipImageView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.pointOne];
    [self.scrollView addSubview:self.tipOne];
    [self.scrollView addSubview:self.pointTwo];
    [self.scrollView addSubview:self.tipTwo];
    [self.scrollView addSubview:self.pointThree];
    [self.scrollView addSubview:self.tipThree];
    [self.scrollView addSubview:self.pointFour];
    [self.scrollView addSubview:self.tipFour];
    [self.scrollView addSubview:self.bottomTitle];
    [self.scrollView addSubview:self.ensureBtn];
    [self.scrollView addSubview:self.gotoAuthenBtn];
    [self.view addSubview:self.navBack];
    [self.navBack addSubview:self.navTitle];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).with.offset(iPhoneX ? 24+64+10 : 64+10);
        make.size.mas_equalTo(CGSizeMake(206, 174));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipImageView.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(234, 25));
    }];
    [self.pointOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.centerX.equalTo(self.scrollView).with.offset(-85);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(29);
    }];
    [self.tipOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointOne);
        make.left.equalTo(self.pointOne.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(151, 25));
    }];
    [self.pointTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.left.equalTo(self.pointOne);
        make.top.equalTo(self.pointOne.mas_bottom).with.offset(25);
    }];
    [self.tipTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointTwo);
        make.left.equalTo(self.pointTwo.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(151, 25));
    }];
    [self.pointThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.left.equalTo(self.pointOne);
        make.top.equalTo(self.pointTwo.mas_bottom).with.offset(25);
    }];
    [self.tipThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointThree);
        make.left.equalTo(self.pointThree.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(151, 25));
    }];
    [self.pointFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.left.equalTo(self.pointOne);
        make.top.equalTo(self.pointThree.mas_bottom).with.offset(25);
    }];
    [self.tipFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pointFour);
        make.left.equalTo(self.pointFour.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(250, 25));
    }];
    [self.bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(161);
        make.centerX.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(210, 20));
    }];
    [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomTitle.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(263, 44));
    }];
    [self.gotoAuthenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ensureBtn.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.scrollView);
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
    self.scrollView.contentSize = CGSizeMake(0, 479 + 44 + (iPhoneX ? (24 + 64) : 64) + (iPhone5 ? 30 : 0));
}

#pragma mark - BtnClickEvent

// 确定
- (void)handleEnsureBtnClickEvent {
    [self.navigationController popToRootViewControllerAnimated:YES];
    // 直接进入青少年模式
    [[SYUserServiceAPI sharedInstance] requestModifyUserAuthModelToAdolescentModel:^(id  _Nullable response) {
        if (response) {
            [self updateUserInfo];
        }
    }];
}

// 去认证
- (void)handleAuthenBtnClickEvent {
    SYIDCardAuthenticationVC *vc = [SYIDCardAuthenticationVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateUserInfo {
    // 刷新个人用户信息
    [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_USERINFOREADY object:nil];
        }
    }];
}

#pragma mark - Lazyload

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

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
        _titleLabel.text = @"未身份认证，进入青少年模式";
    }
    return _titleLabel;
}

- (UIView *)pointOne {
    if (!_pointOne) {
        _pointOne = [UIView new];
        _pointOne.layer.cornerRadius = 2.5;
        _pointOne.backgroundColor = RGBACOLOR(113,56,239,1);
    }
    return _pointOne;
}

- (UILabel *)tipOne {
    if (!_tipOne) {
        _tipOne = [UILabel new];
        _tipOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _tipOne.textColor = RGBACOLOR(11,11,11,1);
        _tipOne.textAlignment = NSTextAlignmentLeft;
        _tipOne.text = @"无法充值蜜豆";
    }
    return _tipOne;
}

- (UIView *)pointTwo {
    if (!_pointTwo) {
        _pointTwo = [UIView new];
        _pointTwo.layer.cornerRadius = 2.5;
        _pointTwo.backgroundColor = RGBACOLOR(113,56,239,1);
    }
    return _pointTwo;
}

- (UILabel *)tipTwo {
    if (!_tipTwo) {
        _tipTwo = [UILabel new];
        _tipTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _tipTwo.textColor = RGBACOLOR(11,11,11,1);
        _tipTwo.textAlignment = NSTextAlignmentLeft;
        _tipTwo.text = @"无法进行打赏";
    }
    return _tipTwo;
}

- (UIView *)pointThree {
    if (!_pointThree) {
        _pointThree = [UIView new];
        _pointThree.layer.cornerRadius = 2.5;
        _pointThree.backgroundColor = RGBACOLOR(113,56,239,1);
    }
    return _pointThree;
}

- (UILabel *)tipThree {
    if (!_tipThree) {
        _tipThree = [UILabel new];
        _tipThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _tipThree.textColor = RGBACOLOR(11,11,11,1);
        _tipThree.textAlignment = NSTextAlignmentLeft;
        _tipThree.text = @"无法参与砸蛋等游戏";
    }
    return _tipThree;
}

- (UIView *)pointFour {
    if (!_pointFour) {
        _pointFour = [UIView new];
        _pointFour.layer.cornerRadius = 2.5;
        _pointFour.backgroundColor = RGBACOLOR(113,56,239,1);
    }
    return _pointFour;
}

- (UILabel *)tipFour {
    if (!_tipFour) {
        _tipFour = [UILabel new];
        _tipFour.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _tipFour.textColor = RGBACOLOR(11,11,11,1);
        _tipFour.textAlignment = NSTextAlignmentLeft;
        _tipFour.text = @"只可进入特定的房间";
    }
    return _tipFour;
}

- (UILabel *)bottomTitle {
    if (!_bottomTitle) {
        _bottomTitle = [UILabel new];
        _bottomTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _bottomTitle.textColor = RGBACOLOR(153,153,153,1);
        _bottomTitle.textAlignment = NSTextAlignmentCenter;
        _bottomTitle.text = @"身份认证成年后，可开启正常模式";
    }
    return _bottomTitle;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton new];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:RGBACOLOR(255,255,255,0.8) forState:UIControlStateHighlighted];
        [_ensureBtn setBackgroundImage:[SYUtil imageFromColor:RGBACOLOR(0,0,0,0.2)] forState:UIControlStateHighlighted];
        _ensureBtn.backgroundColor = RGBACOLOR(113,56,239,1);
        _ensureBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _ensureBtn.layer.cornerRadius = 22;
        _ensureBtn.clipsToBounds = YES;
        [_ensureBtn addTarget:self action:@selector(handleEnsureBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}

- (UIButton *)gotoAuthenBtn {
    if (!_gotoAuthenBtn) {
        _gotoAuthenBtn = [UIButton new];
        [_gotoAuthenBtn setTitle:@"去认证" forState:UIControlStateNormal];
        _gotoAuthenBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_gotoAuthenBtn setTitleColor:RGBACOLOR(68,68,68,1) forState:UIControlStateNormal];
        [_gotoAuthenBtn setBackgroundImage:[SYUtil imageFromColor:RGBACOLOR(204,204,204,1)]
                                  forState:UIControlStateHighlighted];
        _gotoAuthenBtn.clipsToBounds = YES;
        _gotoAuthenBtn.layer.cornerRadius = 22;
        _gotoAuthenBtn.layer.borderWidth = 1;
        _gotoAuthenBtn.layer.borderColor = RGBACOLOR(153,153,153,1).CGColor;
        [_gotoAuthenBtn addTarget:self action:@selector(handleAuthenBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gotoAuthenBtn;
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
 */
