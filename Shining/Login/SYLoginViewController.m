//
//  SYLoginViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/6/19.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYLoginViewController.h"
#import "SYCustomUITextField.h"
#import "SYUserServiceAPI.h"
#import "SYPerfectUserInfoVC.h"
#import "SYWebViewController.h"
#import "WXApiRequestHandler.h"
#import "WXConstant.h"
#import "WXApiManager.h"

typedef NS_ENUM(NSInteger, SYLoginPageStatus) {
    SYLoginPageStatus_SDK,
    SYLoginPageStatus_APP
};

#define kLinkValue_license    @"sy_license://"
#define kLicenseUrl @"https://mp-cdn.le.com/web/doc/be/user_agreement"

@interface SYLoginViewController ()<UITextFieldDelegate,UITextViewDelegate,WXApiManagerDelegate,SYPopUpWindowsDelegate>
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UITextField *phoneTextField;
@property (nonatomic, strong)UITextField *vertifyField;
@property (nonatomic, strong)UIButton *authCodeBtn;
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UITextView *liceseTextView;
@property (nonatomic, strong)UIButton *closeBtn;
@property (nonatomic, strong)NSString *tempToken;
@property (nonatomic, assign)SYLoginPageStatus loginPageStatus;
@property (nonatomic, strong)UIButton *wxBtn;
@property (nonatomic, strong)UILabel *thirdLoginTitleLabel;
@property (nonatomic, strong) SYPopUpWindows *popupWindow;      // 各种弹窗
@property (nonatomic, strong) NSDictionary *loginRespone;
@end

@implementation SYLoginViewController

- (instancetype)initWithTempToken:(NSString *)tempToken
{
    self = [super init];
    if (self) {
        self.tempToken = tempToken;
        if (![NSString sy_isBlankString:tempToken]) {
            self.loginPageStatus = SYLoginPageStatus_SDK;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#ifndef ShiningSdk
    [self.navigationController setNavigationBarHidden:NO animated:animated];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
#ifndef ShiningSdk
    if ([NSString sy_isBlankString:self.tempToken]) {
        self.loginPageStatus = SYLoginPageStatus_APP;
    }
#endif
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.vertifyField];
    [self.view addSubview:self.authCodeBtn];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.liceseTextView];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.thirdLoginTitleLabel];
    [self.view addSubview:self.wxBtn];
    float scale_height = __MainScreen_Height/896;
    float scale_width = __MainScreen_Width/414;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(scale_height*(76+(iPhoneX ? 88 : 64)));
        make.left.equalTo(self.view).with.offset(56*scale_width);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(33);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(77*scale_height);
        make.right.equalTo(self.view).with.offset(-56*scale_width);
        make.height.mas_equalTo(50);
    }];
    
    [self.vertifyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.phoneTextField.mas_bottom).with.offset(26);
        make.right.equalTo(self.phoneTextField.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    [self.authCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.vertifyField.mas_top).with.offset(12);
        make.right.equalTo(self.vertifyField.mas_right).with.offset(-31);
        make.centerY.equalTo(self.vertifyField.mas_centerY);
        make.height.mas_equalTo(16);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.vertifyField.mas_bottom).with.offset(30);
        make.right.equalTo(self.phoneTextField.mas_right);
        make.height.mas_equalTo(44);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20+(iPhoneX ? 44 : 20));
        make.right.equalTo(self.view).with.offset(-20);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(36);
    }];
    
    [self.liceseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.loginBtn.mas_bottom).with.offset(13);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(25);
    }];
    
    [self.thirdLoginTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-130*scale_height);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(16);
    }];
    
    [self.wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.thirdLoginTitleLabel.mas_bottom).with.offset(24*scale_height);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    
    [WXApiManager sharedManager].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tap];

}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        if (self.loginPageStatus == SYLoginPageStatus_APP) {
            _titleLabel.text = @"登录Bee语音";
        }else{
            _titleLabel.text = @"绑定手机号";
        }
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
        _titleLabel.textColor = [UIColor sam_colorWithHex:@"#3E4A59"];
        
    }
    return _titleLabel;
}

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[SYCustomUITextField alloc] initWithFrame:CGRectZero];
        _phoneTextField.font = [UIFont systemFontOfSize:16];
        _phoneTextField.layer.cornerRadius = 22;
        _phoneTextField.layer.borderWidth= 2.0f;
        _phoneTextField.layer.borderColor= [UIColor sam_colorWithHex:@"#7B40FF"].CGColor;
        _phoneTextField.placeholder = @"输入手机号码";
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.delegate = self;

    }
    return _phoneTextField;
}

- (UITextField *)vertifyField {
    if (!_vertifyField) {
        _vertifyField = [[SYCustomUITextField alloc] initWithFrame:CGRectZero];
        _vertifyField.layer.cornerRadius = 22;
        _vertifyField.layer.borderWidth= 2.0f;
        _vertifyField.layer.borderColor= [UIColor sam_colorWithHex:@"#7B40FF"].CGColor;
        _vertifyField.placeholder = @"输入验证码";
        _vertifyField.keyboardType = UIKeyboardTypeNumberPad;
        _vertifyField.delegate = self;
        
    }
    return _vertifyField;
}

- (UIButton *)authCodeBtn {
    if (!_authCodeBtn) {
        _authCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authCodeBtn setTitleColor:[UIColor sam_colorWithHex:@"#7B40FF"] forState:UIControlStateNormal];
        [_authCodeBtn setTitleColor:[UIColor sam_colorWithHex:@"#CCCCCC"] forState:UIControlStateDisabled];
        [_authCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _authCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_authCodeBtn addTarget:self action:@selector(authCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        _authCodeBtn.enabled = NO;
    }
    return _authCodeBtn;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = [UIColor colorWithRed:123/255.0 green:64/255.0 blue:255/255.0 alpha:0.7];
        [_loginBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        _loginBtn.layer.cornerRadius = 22;
        _loginBtn.enabled = NO;
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _loginBtn;
}

- (UITextView *)liceseTextView {
    if (!_liceseTextView) {
        _liceseTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        NSString *textStr = @"登录即同意《Bee语音用户协议》";
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:textStr];
        [text addAttribute:NSLinkAttributeName
                     value:kLinkValue_license
                     range:[textStr rangeOfString:@"《Bee语音用户协议》"]];
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor sam_colorWithHex:@"#7B40FF"]};

        _liceseTextView.linkTextAttributes = linkAttributes;
        _liceseTextView.attributedText = text ;
        _liceseTextView.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _liceseTextView.textColor = [UIColor sam_colorWithHex:@"#3E4A59"];
        _liceseTextView.textAlignment = NSTextAlignmentCenter;
        _liceseTextView.editable =NO;
        _liceseTextView.delegate =self;
        _liceseTextView.scrollEnabled = NO;
        if (self.loginPageStatus != SYLoginPageStatus_APP) {
            _liceseTextView.hidden = YES;
        }
    }
    return _liceseTextView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed_sy:@"login_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.loginPageStatus == SYLoginPageStatus_APP) {
            _closeBtn.hidden = NO;
        }
        if (![NSString sy_isBlankString: self.tempToken]) {
            _closeBtn.hidden = YES;
        }
    }
    return _closeBtn;
}

- (UILabel *)thirdLoginTitleLabel {
    if (!_thirdLoginTitleLabel) {
        _thirdLoginTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _thirdLoginTitleLabel.text = @"第三方登录";
        _thirdLoginTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _thirdLoginTitleLabel.textColor = [UIColor sam_colorWithHex:@"#BAC0C5"];
        _thirdLoginTitleLabel.textAlignment = NSTextAlignmentCenter;
        if (self.loginPageStatus != SYLoginPageStatus_APP) {
            _thirdLoginTitleLabel.hidden = YES;
        }
    }
    return _thirdLoginTitleLabel;
}

- (UIButton *)wxBtn {
    if (!_wxBtn) {
        _wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxBtn setImage:[UIImage imageNamed_sy:@"login_wxbtn_normal"] forState:UIControlStateNormal];
        [_wxBtn setImage:[UIImage imageNamed_sy:@"login_wxbtn_highlighted"] forState:UIControlStateHighlighted];
        [_wxBtn addTarget:self action:@selector(wxLogin:) forControlEvents:UIControlEventTouchUpInside];
        if (self.loginPageStatus != SYLoginPageStatus_APP) {
            _wxBtn.hidden = YES;
        }
    }
    return _wxBtn;
}

- (void)authCodeAction:(id)sender
{
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"请检查您的网络情况～"];
        return;
    }
    if (![self isValidPhoneNum:self.phoneTextField.text]) {
        [SYToastView showToast:@"手机号错误，请重新输入"];
        return;
    }
   
    [self openCountdown];
    [[SYUserServiceAPI sharedInstance]requestVcode:self.phoneTextField.text];
}


- (void)showLoginUpWindonws:(NSInteger)from {

    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
    self.popupWindow.delegate = self;
    self.popupWindow.tag = 10000+from;
    [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Pair withMainTitle:@"请确认您是否满18周岁，未满18周岁不能登录" withSubTitle:@"" withBtnTexts:@[@"取消",@"确定"] withBtnTextColors:@[RGBACOLOR(102, 102, 102, 1),RGBACOLOR(11, 11, 11, 1)]];
    [window addSubview:self.popupWindow];
    [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];

}

- (void)loginAction:(id)sender
{
    [self doLoginAction];
}

- (void)doLoginAction {
    if (![self isValidPhoneNum:self.phoneTextField.text]) {
        [SYToastView showToast:@"请输入正确的手机号码"];
        return;
    }
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"请检查您的网络情况～"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *tempTk = [[UserProfileManager sharedInstance] getTempAccessToken];
    NSInteger vendor = (self.vendor == 1)?1:3;
    [[SYUserServiceAPI sharedInstance]requestLoginSignup:self.phoneTextField.text vcode:self.vertifyField.text tempToken:tempTk vendor:vendor success:^(id  _Nullable response) {
#ifdef ShiningSdk
        [weakSelf doLoginSuccessNext:response];
#else
        if ([SYSettingManager childInterval] == 1) {
            weakSelf.loginRespone = response;
            [weakSelf showLoginUpWindonws:1];
        }else {
            [weakSelf doLoginSuccessNext:response];
        }
#endif
    } failure:^(NSError * _Nullable error) {
        if (![NSObject sy_empty:error]) {
            switch (error.code) {
                case 2004:
                    [SYToastView showToast:@"请点击发送并填写正确验证码"];
                    break;
                case 2005:
                    [SYToastView showToast:@"验证码已失效，请重新获取"];
                    break;
                case 2006:
                case 2014:
                    [SYToastView showToast:@"验证码错误，请重新填写"];
                    break;
                case 2007:
                    [SYToastView showToast:@"系统错误，请稍后再试"];
                    break;
                case 2016:
                    [SYToastView showToast:@"此手机号已被注册"];
                    break;
                case 2028:
                    [SYToastView showToast:@"该手机号已经绑定，请直接使用该手机号登录"];
                    break;
                default:
                    [SYToastView showToast:error.localizedDescription];
                    break;
            }
        }else{
            [SYToastView showToast:@"系统开了点小差儿，请稍后再试哦～"];
        }
    }];
}


- (void)doLoginSuccessNext:(NSDictionary *)respone {
    if ([NSString sy_empty:respone]) {
        return;
    }
    NSNumber* need_next_step = [respone objectForKey:@"need_next_step"];
    if ([need_next_step boolValue]) {
        //去完善信息页
        [[UserProfileManager sharedInstance] setUserManualLogin:YES];
    }
    //登录成功去登录环信账号
    NSString *em_username = respone[@"em_username"];
    NSString *em_password = respone[@"em_password"];
    [[UserProfileManager sharedInstance]login:em_username Password:em_password VC:self];
    [[UserProfileManager sharedInstance] setFromLoginPage:YES];
}

- (void)closeAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)wxLogin:(id)sender
{
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"请检查您的网络情况～"];
        return;
    }
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = kAuthScope; // @"post_timeline,sns"
    req.state = kAuthState;
    [WXApi sendAuthReq:req
        viewController:self
              delegate:[WXApiManager sharedManager]];
}

- (BOOL)isValidPhoneNum:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3|4|5|6|7|8|9)\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    if([regextestmobile evaluateWithObject:mobileNum] == YES){
        return YES;
    }else{
        return NO;
    }
}

- (void)dismissKeyBoard
{
    [self.phoneTextField resignFirstResponder];
    [self.vertifyField resignFirstResponder];
}

// 开启倒计时效果
-(void)openCountdown{
    
    __weak typeof(self)weakSelf = self;
    NSTimeInterval seconds = 60.f;
    CFTimeInterval endTime = CACurrentMediaTime() + seconds; // 最后期限
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        CFTimeInterval interval = endTime - CACurrentMediaTime();
        if (interval > 0) { // 更新倒计时
            NSString *timeStr = [NSString stringWithFormat:@"%.0f秒后重发", interval];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.authCodeBtn.enabled = NO;
                [weakSelf.authCodeBtn setTitle:timeStr forState:UIControlStateNormal];
                [weakSelf.authCodeBtn setTitleColor:[UIColor sam_colorWithHex:@"#CCCCCC"] forState:UIControlStateNormal];
            });
        } else { // 倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.authCodeBtn.enabled = YES;
                [weakSelf.authCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [weakSelf.authCodeBtn setTitleColor:[UIColor sam_colorWithHex:@"#7B40FF"] forState:UIControlStateNormal];

            });
        }
    });
    dispatch_resume(_timer);
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTextField) {
        if (textField.text.length + string.length > 11) {
            return NO;
        }
        if (textField.text.length < range.location + range.length) {
            return NO;
        }
    }else if (textField == self.vertifyField){
        if (textField.text.length + string.length > 6) {
            return NO;
        }
        if (textField.text.length < range.location + range.length) {
            return NO;
        }
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        self.vertifyField.text = @"";
    }
    return YES;
}

- (void)textChanged:(id)sender {
    NSNotification *noti = (NSNotification *)sender;
    UITextField *textField = [noti object];
    if (textField == self.phoneTextField) {
        self.authCodeBtn.enabled = (self.phoneTextField.text.length == 11);
    }
    self.loginBtn.enabled = ![NSString sy_isBlankString:self.phoneTextField.text] && ![NSString sy_isBlankString:self.vertifyField.text];
    if (self.loginBtn.enabled) {
        self.loginBtn.backgroundColor = DEFAULT_THEME_COLOR;
    }else{
        self.loginBtn.backgroundColor = [UIColor colorWithRed:123/255.0 green:64/255.0 blue:255/255.0 alpha:0.7];
    }
}


//是否自动旋转,返回YES可以自动旋转,返回NO禁止旋转
- (BOOL)shouldAutorotate{
    return NO;
}

//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
API_AVAILABLE(ios(10.0)){
    if ([URL.absoluteString isEqualToString:kLinkValue_license])
    {   //实现“协议”的点击方法
        SYWebViewController *webView = [[SYWebViewController alloc] initWithURL:kLicenseUrl andTitle:@"《Bee语音用户注册协议》"];
        [self.navigationController pushViewController:webView animated:YES];
        return NO;
    }
    return YES;
}
//IOS10以下
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([URL.absoluteString isEqualToString:kLinkValue_license])
    {   //实现“协议”的点击方法
        SYWebViewController *webView = [[SYWebViewController alloc] initWithURL:kLicenseUrl andTitle:@"《Bee语音用户注册协议》"];
        [self.navigationController pushViewController:webView animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark -WechatAuthAPIDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    if (![NSString sy_isBlankString:response.code]) {
        [[SYUserServiceAPI sharedInstance]requestOAuthWXLogin:response.code success:^(id  _Nullable response) {
            if ([NSObject sy_empty:response]) {
                return;
            }
            NSString *code = [response objectForKey:@"code"];
            if ([code integerValue] == 0) {
                NSDictionary *dict = [response objectForKey:@"data"];
                NSNumber *need_mobile = [dict objectForKey:@"need_mobile"];
                NSNumber *need_info = [dict objectForKey:@"need_info"];
                NSString *token = [dict objectForKey:@"accesstoken"];
                if (![need_mobile boolValue]) {//已经绑定了手机号
                    [SYSettingManager setAccessToken:token];
                    NSString *em_password = [dict objectForKey:@"em_password"];
                    NSString *em_username = [dict objectForKey:@"em_username"];
                    [[UserProfileManager sharedInstance]login:em_username Password:em_password VC:self];
                    [[UserProfileManager sharedInstance] setTempAccessToken:@""];
                }else {//没有绑定手机号
                    [[UserProfileManager sharedInstance] setTempAccessToken:token];
                    SYLoginViewController *vc = [[SYLoginViewController alloc]initWithTempToken:token];
                    vc.vendor = 1;
                    [self.navigationController pushViewController:vc animated:NO];
                }
                [[UserProfileManager sharedInstance] setNeedInfo:[need_info boolValue]];
                [[UserProfileManager sharedInstance] setNeedMobile:[need_mobile boolValue]];
            }else{
                NSString *errMsg = [response objectForKey:@"message"];

                [SYToastView showToast:![NSString sy_isBlankString:errMsg]?errMsg:@"系统开了点小差儿，请稍后再试哦～"];
            }
        } failure:^(NSError * _Nullable error) {
            [SYToastView showToast:@"系统开了点小差儿，请稍后再试哦～"];
        }];
    }
    
}



#pragma mark - SYPopUpWindowsDelegate

- (void)handlePopUpWindowsLeftBtnClickEvent {
    if (self.popupWindow && self.popupWindow.superview) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
        [[UserProfileManager sharedInstance] logOut];
    }
}

- (void)handlePopUpWindowsRightBtnClickEvent {
    if (self.popupWindow && self.popupWindow.superview) {
        if (self.popupWindow.tag == 10001) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
            [self doLoginSuccessNext:self.loginRespone];
            self.loginRespone = nil;
        } else if (self.popupWindow.tag == 10002) {
            [self.popupWindow removeFromSuperview];
            self.popupWindow = nil;
        }
    }
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}

@end
