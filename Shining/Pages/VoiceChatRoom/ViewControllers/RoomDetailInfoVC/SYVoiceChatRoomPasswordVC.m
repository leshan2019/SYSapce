//
//  SYVoiceChatRoomPasswordVC.m
//  Shining
//
//  Created by 杨玄 on 2019/4/17.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomPasswordVC.h"
//#import <Masonry.h>
#import "SYCommonTopNavigationBar.h"
#import "SYVoiceChatNetManager.h"

@interface SYVoiceChatRoomPasswordVC ()<SYCommonTopNavigationBarDelegate, UITextFieldDelegate>
@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SYVoiceChatNetManager *netManager;
@end

@implementation SYVoiceChatRoomPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    [self.view addSubview:self.topNavBar];
    [self.view addSubview:self.textField];
    [self.topNavBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topNavBar.mas_bottom);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(52);
    }];
}

#pragma mark - SYVoiceChatRoomCommonNavBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSaveBtnClick {
    if (_textField.text.length != 0 && _textField.text.length != 4) {
        [SYToastView showToast:@"请输入4位数字密码"];
        return;
    }
    [_textField resignFirstResponder];
    NSInteger lock = 0;
    NSString *password = _textField.text;
    if (password.length > 0) {
        lock = 1;
    }
    __weak typeof(self) weakSelf = self;
    [self.netManager requestUpdateRoomPasswordWithChannelId:self.channelId lock:lock password:password success:^(id  _Nullable response) {
        [SYToastView showToast:@"房间密码设置成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nullable error) {
        [SYToastView showToast:@"房间密码设置失败"];
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
    } else if (textField.text.length >= 4) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
}

#pragma mark - Setter

- (void)setOriginPassword:(NSString *)originPassword {
    self.textField.text = originPassword;
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"房间密码" rightTitle:@"保存" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"请输入4位数字密码";
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _textField.textColor = RGBACOLOR(153, 153, 153, 1);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.delegate = self;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _textField;
}

- (SYVoiceChatNetManager *)netManager {
    if (!_netManager) {
        _netManager = [SYVoiceChatNetManager new];
    }
    return _netManager;
}

@end
