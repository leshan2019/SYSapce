//
//  SYVoiceChatRoomRenameVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomRenameVC.h"
#import "SYCommonTopNavigationBar.h"
#import "SYVoiceChatNetManager.h"
#import "SYUserServiceAPI.h"

#define SYMaxNameLength 20

@interface SYVoiceChatRoomRenameVC ()<SYCommonTopNavigationBarDelegate, UITextFieldDelegate>

@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) SYVoiceChatNetManager *netManager;

@end

@implementation SYVoiceChatRoomRenameVC

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
    if ([NSString sy_isBlankString:_textField.text]) {
        [SYToastView showToast:@"房间名不能为空哦~"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self requestValidContent:_textField.text block:^(BOOL success) {
        if (success) {
            [self upateVoiceRoomName];
        } else {
            NSDictionary *pubParam = @{@"keyword":[NSString sy_safeString:weakSelf.textField.text],
                                       @"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],
                                       @"from":@"voiceroom"};
//            [MobClick event:@"textPorn" attributes:pubParam];
            [SYToastView showToast:@"房间名含有敏感信息!"];
        }
    }];
    [_textField resignFirstResponder];
}

// 文字鉴黄
- (void)requestValidContent:(NSString *)content
                      block:(void(^)(BOOL success))block {
    [[SYUserServiceAPI sharedInstance] requestValidateText:content
                                                   success:^(id  _Nullable response) {
                                                       if ([response isKindOfClass:[NSDictionary class]]) {
                                                           if (block) {
                                                               block([response[@"validate"] boolValue]);
                                                           }
                                                       } else {
                                                           if (block) {
                                                               block(NO);
                                                           }
                                                       }
                                                   } failure:^(NSError * _Nullable error) {
                                                       if (block) {
                                                           block(NO);
                                                       }
                                                   }];
}

// 更改房间名字
- (void)upateVoiceRoomName {
    __weak typeof(self) weakSelf = self;
    [self.netManager requestUpdateChannelInfoWithChannelID:self.channelId name:_textField.text greeting:@"" desc:@"" icon:@"" iconFile:[NSData data] iconFile_16_9:[NSData data] backgroundImage:nil success:^(id  _Nullable response) {
        [SYToastView showToast:@"房间名更新成功~"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nullable error) {
        [SYToastView showToast:@"房间名更新失败~"];
    }];

}

//#pragma mark - UITextFieldTextDidChangeNotification
//
//- (void)addKeyBoardNotification {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
//}
//
//- (void)removeKeyBoardNotification {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
//}
//
//- (void)textFiledEditChanged:(NSNotification *)noti
//{
//    UITextField *infoText = noti.object;
//    int kMaxLength = 20;
//    NSString *toBeString = infoText.text;
//    NSString *lang = [UIApplication sharedApplication].textInputMode.primaryLanguage; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 中文输入
//        UITextRange *selectedRange = [infoText markedTextRange];
//        //获取高亮部分
//        // 系统的UITextRange，有两个变量，一个是start，一个是end，这是对于的高亮区域
//        UITextPosition *position = [infoText positionFromPosition:selectedRange.start offset:0];
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position) {
//            if (toBeString.length > kMaxLength) {
//                infoText.text = [toBeString substringToIndex:kMaxLength];
//            }
//        }
//        // 有高亮选择的字符串，则暂不对文字进行统计和限制
//        else{
//        }
//    }
//    else{
//        if (toBeString.length > kMaxLength) {// 表情之类的，中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
//            infoText.text = [toBeString substringToIndex:kMaxLength];
//        }
//    }
//}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 20;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
}

#pragma mark - Setter

- (void)setOriginRoomName:(NSString *)originRoomName {
    self.textField.text = originRoomName;
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"房间名" rightTitle:@"保存" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"请输入房间名称(0/20)";
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _textField.textColor = RGBACOLOR(153, 153, 153, 1);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.delegate = self;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
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
