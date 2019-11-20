//
//  SYMineIDCardNameVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineIDCardNameVC.h"
//#import <Masonry.h>
#import "SYCommonTopNavigationBar.h"

@interface SYMineIDCardNameVC ()<SYCommonTopNavigationBarDelegate, UITextFieldDelegate>
@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UITextField *textField;
@end

@implementation SYMineIDCardNameVC

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - SYVoiceChatRoomCommonNavBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSaveBtnClick {
    if (_textField.text.length <= 0) {
        [SYToastView showToast:@"姓名不能为空"];
        return;
    }
    [_textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveIDCardName:)]) {
        [self.delegate saveIDCardName:_textField.text];
        [SYToastView showToast:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {  // 删除
        return YES;
    } else if (textField.text.length >= 12) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"姓名" rightTitle:@"保存" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"请输入真实姓名";
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _textField.textColor = RGBACOLOR(153, 153, 153, 1);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.delegate = self;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

@end
