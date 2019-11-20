//
//  SYVoiceRoomGiveGiftView.m
//  Shining
//
//  Created by 杨玄 on 2019/8/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGiveGiftView.h"
#import "SYGiveFriendGiftsVC.h"

@interface SYVoiceRoomGiveGiftView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton *blackBg;
@property (nonatomic, strong) UILabel *titleLabe;
@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UITextField *idInput;
@property (nonatomic, strong) UIButton *giveFriendBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIView *horizonLine;

@property (nonatomic, assign) BOOL showKeyboard;

@end

@implementation SYVoiceRoomGiveGiftView

- (void)dealloc {
    [self removeKeyboardNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self insertSubViews];
    [self updateSubviewsLayout];
    [self addKeyboardNotifcations];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.showKeyboard) {
        [self.idInput resignFirstResponder];
        self.showKeyboard = NO;
        return;
    }
    [self removeFromSuperview];
}

#pragma mark - Public

- (void)updateGiveFriendId:(NSString *)userId {
    self.idInput.text = userId;
}

#pragma mark - Private

- (void)insertSubViews {
    [self addSubview:self.blackBg];
    [self.blackBg addSubview:self.titleLabe];
    [self.blackBg addSubview:self.horizonLine];
    [self.blackBg addSubview:self.userIcon];
    [self.blackBg addSubview:self.idInput];
    [self.blackBg addSubview:self.giveFriendBtn];
    [self.blackBg addSubview:self.buyBtn];
}

- (void)updateSubviewsLayout {
    [self.blackBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(iPhoneX ? 102 + 34 : 102);
    }];
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blackBg).with.offset(14);
        make.left.equalTo(self.blackBg).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 15));
    }];
    [self.horizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.blackBg);
        make.right.equalTo(self.blackBg);
        make.top.equalTo(self.blackBg).with.offset(43);
        make.height.mas_equalTo(1);
    }];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabe.mas_bottom).with.offset(33);
        make.left.equalTo(self.blackBg).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.idInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).with.offset(4);
        make.centerY.equalTo(self.userIcon);
        make.size.mas_equalTo(CGSizeMake(80, 17));
    }];
    [self.giveFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.idInput.mas_right).with.offset(20);
        make.centerY.equalTo(self.userIcon);
        make.size.mas_equalTo(CGSizeMake(48, 17));
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.blackBg).with.offset(-10);
        make.centerY.equalTo(self.userIcon);
        make.size.mas_equalTo(CGSizeMake(80, 38));
    }];
}

#pragma mark - iphone5机型适配

- (void)addKeyboardNotifcations {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti {
    self.showKeyboard = YES;
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = value.CGRectValue;
    CGFloat offY = keyboardFrame.size.height;
    [self.blackBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(102);
        make.bottom.equalTo(self).with.offset(-offY);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.showKeyboard = NO;
    [self.blackBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(iPhoneX ? 102 + 34 : 102);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {  // 删除
        return YES;
    } else if (textField.text.length >= 8) {
        return NO;
    }
    return YES;
}

#pragma mark - Lazyload

- (UIButton *)blackBg {
    if (!_blackBg) {
        _blackBg = [UIButton new];
        _blackBg.backgroundColor = RGBACOLOR(39,38,44,1);
    }
    return _blackBg;
}

- (UILabel *)titleLabe {
    if (!_titleLabe) {
        _titleLabe = [UILabel new];
        _titleLabe.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _titleLabe.textColor = [UIColor whiteColor];
        _titleLabe.textAlignment = NSTextAlignmentLeft;
        _titleLabe.text = @"装扮赠送";
    }
    return _titleLabe;
}

- (UIView *)horizonLine {
    if (!_horizonLine) {
        _horizonLine = [UIView new];
        _horizonLine.backgroundColor = RGBACOLOR(216,216,216,0.2);
    }
    return _horizonLine;
}

- (UIImageView *)userIcon {
    if (!_userIcon) {
        _userIcon = [UIImageView new];
        _userIcon.image = [UIImage imageNamed_sy:@"box_give_friend_head"];
    }
    return _userIcon;
}

- (UITextField *)idInput {
    if (!_idInput) {
        _idInput = [[UITextField alloc]init];
        _idInput.backgroundColor = [UIColor clearColor];
        _idInput.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _idInput.textColor = RGBACOLOR(153, 153, 153, 1);
        _idInput.textAlignment = NSTextAlignmentLeft;
        _idInput.delegate = self;
        _idInput.keyboardType = UIKeyboardTypeNumberPad;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"赠送人ID"
                                                                         attributes:
                                              @{ NSForegroundColorAttributeName:RGBACOLOR(153, 153, 153, 1)}];
        _idInput.attributedPlaceholder = attrString;
    }
    return _idInput;
}

- (UIButton *)giveFriendBtn {
    if (!_giveFriendBtn) {
        _giveFriendBtn = [UIButton new];
        [_giveFriendBtn setTitle:@"赠送好友" forState:UIControlStateNormal];
        [_giveFriendBtn setTitleColor:RGBACOLOR(160,117,255,1) forState:UIControlStateNormal];
        _giveFriendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        [_giveFriendBtn addTarget:self action:@selector(handleGiveFriendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giveFriendBtn;
}

- (void)handleGiveFriendBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYVoiceRoomGiveGiftViewClickGiveFriendBtn)]) {
        [self.delegate SYVoiceRoomGiveGiftViewClickGiveFriendBtn];
    }
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton new];
        [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
        [_buyBtn setTitleColor:RGBACOLOR(255,255,255,1) forState:UIControlStateNormal];
        _buyBtn.backgroundColor = RGBACOLOR(113,56,239,1);
        _buyBtn.clipsToBounds = YES;
        _buyBtn.layer.cornerRadius = 19;
        [_buyBtn addTarget:self action:@selector(handleBuyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}

- (void)handleBuyBtnClick {
    if (self.idInput.text.length == 0) {
        [SYToastView showToast:@"用户ID不存在，请检查后再填写"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYVoiceRoomGiveGiftViewClickBuyBtn:)]) {
        [self.delegate SYVoiceRoomGiveGiftViewClickBuyBtn:self.idInput.text];
    }
}

@end
