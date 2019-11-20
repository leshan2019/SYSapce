//
//  SYMineIDCardNumberVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineIDCardNumberVC.h"
//#import <Masonry.h>
#import "SYCommonTopNavigationBar.h"
#import "SYPopUpWindows.h"

@interface SYMineIDCardNumberVC ()<SYCommonTopNavigationBarDelegate, UITextFieldDelegate, SYPopUpWindowsDelegate>
@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SYPopUpWindows *popupWindow;      // 弹窗
@end

@implementation SYMineIDCardNumberVC

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
        [SYToastView showToast:@"身份证号码不能为空"];
        return;
    }
    [_textField resignFirstResponder];
    // 有效性检查
    BOOL isValid = [SYUtil checkChinaCitizenIDCardsIsValid:_textField.text];
    if (isValid) {
        // todo: 查看是否已经注册过
        if (self.delegate && [self.delegate respondsToSelector:@selector(saveIDCardNumber:)]) {
            [self.delegate saveIDCardNumber:_textField.text];
            [SYToastView showToast:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        // 格式不正确，提示“请输入正确的身份证号码”
        if (self.popupWindow) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
        }
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
        self.popupWindow.delegate = self;
        [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Single withMainTitle:@"请输入正确的身份证号码" withSubTitle:nil withBtnTexts:@[@"我知道了"] withBtnTextColors:@[RGBACOLOR(11, 11, 11, 1)]];
        [window addSubview:self.popupWindow];
        [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(window);
        }];
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
    } else if (textField.text.length >= 18) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
}

#pragma mark - SYPopUpWindowsDelegate

- (void)handlePopUpWindowsMidBtnClickEvent {
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"身份证" rightTitle:@"保存" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"请输入你的身份证号码";
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
