//
//  SYVoiceChatRoomWelcomeVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/13.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomWelcomeVC.h"
#import "SYCommonTopNavigationBar.h"
#import "SYVoiceChatNetManager.h"
#import "SYUserServiceAPI.h"

@interface SYVoiceChatRoomWelcomeVC ()<SYCommonTopNavigationBarDelegate, UITextViewDelegate>

@property (nonatomic, strong) SYCommonTopNavigationBar *topNavBar;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) SYVoiceChatNetManager *netManager;

@end

@implementation SYVoiceChatRoomWelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    [self.view addSubview:self.topNavBar];
    [self.view addSubview:self.textView];
    [self.topNavBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(64 + (iPhoneX ? 24 : 0));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topNavBar.mas_bottom);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(120);
    }];
}

#pragma mark - Setter

- (void)setWelCome:(NSString *)welCome {
    if ([NSString sy_isBlankString:welCome]) {
        self.textView.text = @"请输入房间欢迎语，最多输入90字";
        return;
    }
    self.textView.text = welCome;
}

#pragma mark - SYVoiceChatRoomCommonNavBarDelegate

- (void)handleGoBackBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSaveBtnClick {
    [_textView resignFirstResponder];
    if (_textView.text.length <= 0) {
        [SYToastView showToast:@"欢迎语不能为空哦~"];
        return;
    }
    if (_textView.text.length > 90) {
        [SYToastView showToast:@"欢迎语最多90个字哦~"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self requestValidContent:_textView.text block:^(BOOL success) {
        if (success) {
            [self updateVoiceRoomWelcome];
        } else {
            NSDictionary *pubParam = @{@"keyword":[NSString sy_safeString:weakSelf.textView.text],
                                       @"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],
                                       @"from":@"voiceroom"};
//            [MobClick event:@"textPorn" attributes:pubParam];
            [SYToastView showToast:@"欢迎语含有敏感信息!"];
        }
    }];
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

- (void)updateVoiceRoomWelcome {
    __weak typeof(self) weakSelf = self;
    [self.netManager requestUpdateChannelInfoWithChannelID:self.channelId name:@"" greeting:_textView.text desc:@"" icon:@""  iconFile:[NSData data] iconFile_16_9:[NSData data] backgroundImage:nil success:^(id  _Nullable response) {
        [SYToastView showToast:@"欢迎语更新成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nullable error) {
        [SYToastView showToast:@"欢迎语更新失败"];
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.length + range.location > textView.text.length) {
        return NO;
    }
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return newLength <= 90;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textView resignFirstResponder];
}

#pragma mark - LazyLoad

- (SYCommonTopNavigationBar *)topNavBar {
    if (!_topNavBar) {
        _topNavBar = [[SYCommonTopNavigationBar alloc] initWithFrame:CGRectZero midTitle:@"欢迎语" rightTitle:@"保存" hasAddBtn:NO];
        _topNavBar.delegate = self;
    }
    return _topNavBar;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        _textView.text = @"请输入房间欢迎语，最多输入90字";
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _textView.textColor = RGBACOLOR(153, 153, 153, 1);
    }
    return _textView;
}

- (SYVoiceChatNetManager *)netManager {
    if (!_netManager) {
        _netManager = [SYVoiceChatNetManager new];
    }
    return _netManager;
}

@end
