//
//  ShiningSdkManager.m
//  ShiningSdk
//
//  Created by letv_lzb on 2019/4/10.
//  Copyright © 2019 leshan. All rights reserved.
//

#import "ShiningSdkManager.h"
#import "SYVoiceRoomHomeVC.h"
#import "SYPopUpWindows.h"
#import "SYUserServiceAPI.h"
//#import <FlutterPluginRegistrant/FlutterPluginRegistrant-umbrella.h>
//#import "FlientViewController.h"
//#import "FlutterManager.h"
#import "SYVoiceChatRoomManager.h"
#import "UserProfileManager.h"
#import "SYWebViewController.h"
#import "SYLoginViewController.h"
#import "SYNavigationController.h"


@interface ShiningSdkManager ()<SYPopUpWindowsDelegate>
@property (nonatomic, copy)NSString *ssotk;
@property (nonatomic, copy)NSString *le_mobile;
@property (nonatomic, copy)NSString *le_avatarUrl;
@property (nonatomic, copy)NSString *le_username;
@property (nonatomic, copy)NSString *le_did;
@property (nonatomic, strong)SYPopUpWindows *popupWindow;
@property (nonatomic, weak)UIViewController *displayLoginVC;
@property (nonatomic, strong) NSUserDefaults *groupDefault;

- (UIViewController *)chatHomeListVC;
- (UIViewController *)BeeMainViewController;


@end


@implementation ShiningSdkManager

SYSingleCaseM(ShiningSdkManager);


+ (void)setLetvLoginOut {
    [[ShiningSdkManager shareShiningSdkManager] clearLetvInfo];
    if ([ShiningSdkManager shareShiningSdkManager].delegate && [[ShiningSdkManager shareShiningSdkManager].delegate respondsToSelector:@selector(didLogOutWithLetv:callBack:)]) {
        [[ShiningSdkManager shareShiningSdkManager].delegate didLogOutWithLetv:nil callBack:^(BOOL isSucess) {

        }];
    }
}


/**
 乐视视频用户登录消息同步

 @param ssotk ssotk
 @param mobile 手机号
 @param url 头像url
 */
+ (void)setLoginSuccess:(NSString *)ssotk mobile:(NSString *)mobile avatarUrl:(NSString *)url username:(NSString *)name{
    [[ShiningSdkManager shareShiningSdkManager] loginSuccess:ssotk le_mobile:mobile avatarUrl:url username:name];
}


+ (void)setLetvDid:(NSString *)did {
    [[ShiningSdkManager shareShiningSdkManager] setLe_did:did];
}

/**
 闪音聊天室首页（乐视视频定制）

 @return vc
 */
+ (UIViewController *)getHomeListVC {
    return [[self shareShiningSdkManager] chatHomeListVC];
}

/// Bee语音独立app
+ (UIViewController *)getBeeMainVC {
    return [[self shareShiningSdkManager] BeeMainViewController];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginStatusChanged:)
                                                     name:KNOTIFICATION_LOGINCHANGE
                                                   object:nil];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
}


/**
 退出当前播放中的语音聊天室
 */
- (void)exitCurrentVoiceRoom {
    [[SYVoiceChatRoomManager sharedManager] forceDismissCurrentVoiceChatRoom];
}

/**
 登陆状态发生变化通知

 @param sender notic
 */
- (void)loginStatusChanged:(id)sender {
    // 请求个人用户信息
    NSNotification *noti = (NSNotification *)sender;
    BOOL login = [noti.object boolValue];
    if (login || ![NSString sy_isBlankString:[SYSettingManager accessToken]]) {//登陆
//        [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
//
//        }];
    }
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    if (self.displayLoginVC.presentedViewController) {
        [self.displayLoginVC.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (UIViewController *)chatHomeListVC {
    SYVoiceRoomHomeVC *voiceRoomHomeVC = [[SYVoiceRoomHomeVC alloc] init];
#ifdef ShiningSdk
    NSString *titile = [NSBundle sy_localizedStringForKey:@"title.chatroom" value:@"ChatRoom"];
#else
    NSString *titile = NSLocalizedString(@"title.chatroom", @"ChatRoom");
#endif
    voiceRoomHomeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:titile
                                                                image:[[UIImage imageNamed_sy:@"tabbar_chatroom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                        selectedImage:[[UIImage imageNamed_sy:@"tabbar_chatroomHL"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    return voiceRoomHomeVC;
}

- (UIViewController *)BeeMainViewController {
    CommonNavigationController *navigationController = nil;
    if (gMainController == nil) {
        MainViewController *mainController = [[MainViewController alloc] init];
        [IMGlobalVariables setGlobalMainController:mainController];

        navigationController = [[CommonNavigationController alloc] initWithRootViewController:mainController];
    } else {
        navigationController  = (CommonNavigationController *)gMainController.navigationController;
        if (!navigationController) {
            navigationController = [[CommonNavigationController alloc] initWithRootViewController:gMainController];
        }
    }
    return navigationController;
}



- (void)jumpShiningHomeTab {
    [ShiningSdkManager letvAutoLogin];
}

- (void)jumpVoiceRoomWihtRoomId:(NSString *)roomId {
    [ShiningSdkManager letvAutoLogin];
    [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:roomId from:SYVoiceChatRoomFromTagLetvList];
}

#ifdef ShiningSdk
- (void)jumpVoiceRoomWihtRoomId:(NSString *)roomId from:(LetvFromTag)from {
    [ShiningSdkManager letvAutoLogin];
    NSInteger fm = from;
    [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:roomId from:fm];

}


- (void)jumpVoiceRoomWihtRoomId:(NSString *)roomId from:(LetvFromTag)from report:(NSDictionary *)info {
    [ShiningSdkManager letvAutoLogin];
    NSInteger fm = from;
    [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:roomId from:fm reportInfo:info];
}
#endif

- (void)jumpShiningWebViewWithURL:(NSString *)url {
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }

    SYWebViewController *webVC = [[SYWebViewController alloc] initWithURL:url];
    SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:webVC];
    navi.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [vc presentViewController:navi animated:YES completion:nil];
}


- (void)jumpShiningAppMainView:(UIViewController *)parentVC {
    if (!parentVC) {
        return;
    }
    UIViewController *vc = [self BeeMainViewController];
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [parentVC presentViewController:vc animated:YES completion:^{
        [[SYVoiceChatRoomManager sharedManager] forceUpdateCurrentFloatBallToFront];
    }];
}


- (void)exitShiningAppMainView:(void (^ __nullable)(void))completion {
    if (gMainController) {
        [gMainController.navigationController dismissViewControllerAnimated:NO completion:completion];
    }else{
        if (completion) {
            completion();
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"exitShiningAppMainView" object:nil];
}


- (void)backHanlder {
#ifdef ShiningSdk
    [self exitShiningAppMainView:nil];
#endif
}

/**
 静默登录弹窗

 @param vc vcController
 */
- (void)showLetvAutoLoginPopWidown:(UIViewController *)vc {
    self.displayLoginVC = vc;
     if (self.popupWindow) {
         [self.popupWindow removeFromSuperview];
         self.popupWindow = nil;
     }
     UIWindow *window = [[UIApplication sharedApplication] keyWindow];
     self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
     self.popupWindow.delegate = self;
     self.popupWindow.tag = 90987;
    NSString *numberString = self.le_mobile;
    if (self.le_mobile && self.le_mobile.length > 4) {
        numberString = [self.le_mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
     [self.popupWindow updatePopUpWindowswithMainTitle:@"您已获得乐视视频授权" withSubTitle:@"可直接登录" withContentText:numberString withContentLogo:self.le_avatarUrl withBottomText:@"登录即同意《乐聊用户服务协议》" withBtnTexts:@[@"一键授权登录",@"手机号登录>>"] withBtnTextColors:@[[UIColor sy_colorWithHexString:@"#FFFFFF"],[UIColor sy_colorWithHexString:@"#0B0B0B"]]];
     [window addSubview:self.popupWindow];
     [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(window);
     }];
}



#pragma SYPopUpWindowsDelegate
- (void)autoLoginWithLetv:(void (^)(BOOL isSuccess))task {
    //乐视视频登录Bee语音
    [[SYUserServiceAPI sharedInstance] requestThirdLoginSignup:self.ssotk platForm:ThirdPlatFormLetv success:^(id  _Nullable response) {
        NSDictionary *data = response;
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSInteger codeValue = [code integerValue];
            if (codeValue != 0) {
                NSString *errorInfo = @"其它错误";
                if (codeValue == 2023) {//未绑定手机号
                    errorInfo = @"未绑定手机号";
                }else if(codeValue == 1004) {//环信注册或者查询出错
                    errorInfo = @"环信注册或者查询出错";
                }else if(codeValue == 3002) {//第三方用户信息获取失败
                    errorInfo = @"第三方用户信息获取失败";
                }
                NSLog(@"sy:error-----%@, 切换到手机验证码登陆。",errorInfo);
                NSString *errMsg = @"登录失败";
#ifdef UseSettingTestDevEnv
                errMsg = [NSString stringWithFormat:@"登录失败:%@",errorInfo];
#endif
                [SYToastView showToast:errMsg];
                if (task) {
                    task(NO);
                }
            }else{
                NSDictionary *dict = [data objectForKey:@"data"];
                NSString *mobile = [dict objectForKey:@"mobile"];
                NSString *avatar_imgurl = [dict objectForKey:@"avatar_imgurl"];
                NSString *username = [dict objectForKey:@"username"];
                if (![NSString sy_isBlankString:mobile]) {
                    self.le_mobile = mobile;
                }
                if (![NSString sy_isBlankString:avatar_imgurl]) {
                    self.le_avatarUrl = avatar_imgurl;
                }
                if (![NSString sy_isBlankString:username]) {
                    self.le_username = username;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SYNotification_UpdateUserInfo" object:nil];
                if (task) {
                    task(YES);
                }
            }
        }
    } failure:^(NSError * _Nullable error) {
        NSString *errMsg = @"登录失败";
        if (error.code == 2007) {
            errMsg = @"您的账号已被禁止登录，请联系客服解决";
        }
#ifdef UseSettingTestDevEnv
        errMsg = [NSString stringWithFormat:@"%@:%@",errMsg,error];
#endif
        [SYToastView showToast:errMsg];
        if (task) {
            task(NO);
        }
    }];
}

/**
 静默登陆
 */
- (void)handlePopUpWindowsMidBtnClickEvent {
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络连接中断，请检查网络"];
        return;
    }
    if ([NSString sy_isBlankString:self.ssotk]) {
        NSLog(@"error-----ssotk is nil");
        [self handlePopUpWindowsBottomRightBtnClickEvent];
        return;
    }
    [self autoLoginWithLetv:^(BOOL isSuccess) {

    }];
}

- (void)handlePopUpWindowsBottomRightBtnClickEvent {
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    if (self.displayLoginVC) {
        if (![NSString sy_isBlankString:[[UserProfileManager sharedInstance] getTempAccessToken]]) {
            //绑定手机号登陆
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYNotification_CloseHezi" object:nil];
            SYLoginViewController *controller = [SYLoginViewController new];
            SYNavigationController *loginNavi = [[SYNavigationController alloc] initWithRootViewController:controller];
            loginNavi.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.displayLoginVC presentViewController:loginNavi animated:YES completion:^{
                NSLog(@"加载完成");
            }];
        }else {
            if ([ShiningSdkManager shareShiningSdkManager].delegate && [[ShiningSdkManager shareShiningSdkManager].delegate respondsToSelector:@selector(didLoginWithLetv:callBack:)]) {
                [[ShiningSdkManager shareShiningSdkManager].delegate didLoginWithLetv:@{@"nav":self.displayLoginVC} callBack:^(BOOL isSucess) {
                    if (isSucess) {
                        [[UserProfileManager sharedInstance] setFromLoginPage:YES];
                    }
                    if (isSucess && [NSString sy_isBlankString:[SYSettingManager accessToken]]) {
                        //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SYNotification_UpdateUserInfo" object:nil];
                    }
                }];
            }
        }
    }else{
        NSLog(@"error-----displayLoginVC is nil");
    }
}


/**
 用户协议
 */
- (void)handlePopUpWindowsBottomTextClickEvent {
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    if (self.displayLoginVC) {
        if (![SYNetworkReachability isNetworkReachable]) {
            [SYToastView showToast:@"网络连接中断，请检查网络"];
            return;
        }
//        SYWebViewController *webView = [[SYWebViewController alloc] initWithURL:@"https://mp-cdn.le.com/web/doc/le/user_agreement"];
        SYWebViewController *webView = [[SYWebViewController alloc] initWithURL:@"https://mp-cdn.le.com/web/doc/be/user_agreement"];
        [self.displayLoginVC.navigationController pushViewController:webView animated:YES];
    }
}


#pragma ShiningSdkProtocol
- (void)loginSuccess:(NSString *)ssotk le_mobile:(NSString *)moblie avatarUrl:(NSString *)url username:(NSString *)name {
    if (![NSString sy_isBlankString:self.ssotk] &&
        ![self.ssotk isEqualToString:ssotk]) {
        [self clearLetvInfo];
        if (![NSString sy_isBlankString:[SYSettingManager accessToken]]) {
            __weak typeof(self) weakSelf = self;
            [[UserProfileManager sharedInstance] logOut:^(BOOL isSucess) {
                weakSelf.ssotk = ssotk;
                weakSelf.le_mobile = moblie;
                weakSelf.le_avatarUrl = url;
                weakSelf.le_username = name;
                [ShiningSdkManager letvAutoLogin];
            }];
        }else{
            self.ssotk = ssotk;
            self.le_mobile = moblie;
            self.le_avatarUrl = url;
            self.le_username = name;
            [ShiningSdkManager letvAutoLogin];
        }
    }else {
        self.ssotk = ssotk;
        self.le_mobile = moblie;
        self.le_avatarUrl = url;
        self.le_username = name;
        [ShiningSdkManager letvAutoLogin];
    }

}
- (void)logOut {
    [self clearLetvInfo];
    if (![NSString sy_isBlankString:[SYSettingManager accessToken]]) {
        [[UserProfileManager sharedInstance] logOut];
    }
}

- (void)clearLetvInfo {
    self.ssotk = nil;
    self.le_mobile = nil;
    self.le_avatarUrl = nil;
    self.le_username = nil;
    [[UserProfileManager sharedInstance] setTempAccessToken:@""];
}


- (void)setLetvAppCroupInfo:(NSString *)ssotk le_mobile:(NSString *)moblie avatarUrl:(NSString *)url username:(NSString *)name {
    if (!self.groupDefault) {
        self.groupDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.letv.iphone.client"];
    }
    [self.groupDefault setObject:[NSString sy_safeString:ssotk] forKey:@"le_ssotk"];
    [self.groupDefault setObject:[NSString sy_safeString:url] forKey:@"le_avatarUrl"];
    [self.groupDefault setObject:[NSString sy_safeString:moblie] forKey:@"le_mobile"];
    [self.groupDefault setObject:[NSString sy_safeString:name] forKey:@"le_username"];
}


- (void)clearLetvAppGroupInfo {
    if (!self.groupDefault) {
        self.groupDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.letv.iphone.client"];
    }
    [self.groupDefault removeObjectForKey:@"le_ssotk"];
    [self.groupDefault removeObjectForKey:@"le_avatarUrl"];
    [self.groupDefault removeObjectForKey:@"le_mobile"];
    [self.groupDefault removeObjectForKey:@"le_username"];
}


- (void)setBeeAppCroupInfo:(NSString *)ssotk {
    if (!self.groupDefault) {
        self.groupDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.letv.iphone.client"];
    }
    [self.groupDefault setObject:[NSString sy_safeString:ssotk] forKey:@"bee_ssotk"];
}

- (void)clearBeeAppGroupInfo {
    [self.groupDefault removeObjectForKey:@"bee_ssotk"];
}


- (void)setLetvDeviceId:(NSString *)did {
    self.le_did = did;
}

+ (BOOL)isLetvLogin {
    if (![NSString sy_isBlankString:[ShiningSdkManager shareShiningSdkManager].ssotk] &&
        ![NSString sy_isBlankString:[ShiningSdkManager shareShiningSdkManager].le_mobile] &&
        [NSString sy_isBlankString:[[UserProfileManager sharedInstance] getTempAccessToken]]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isLetvLoginWithMail {
    if (![NSString sy_isBlankString:[ShiningSdkManager shareShiningSdkManager].ssotk] &&
        [NSString sy_isBlankString:[ShiningSdkManager shareShiningSdkManager].le_mobile]) {
        return YES;
    }
    return NO;
}


+ (NSString *)le_ssotk {
    return [ShiningSdkManager shareShiningSdkManager].ssotk;
}

+ (NSString *)le_mobile {
    return [ShiningSdkManager shareShiningSdkManager].le_mobile;
}



/**
 获取乐视 用户头像

 @return 头像url
 */
+ (NSString *)le_avatarUrl  {
    return [ShiningSdkManager shareShiningSdkManager].le_avatarUrl;
}



/**
 获取乐视 用户名

 @return 用户名
 */
+ (NSString *)le_username {
    return [ShiningSdkManager shareShiningSdkManager].le_username;
}


/**
 获取乐视 设备id

 @return 设备id
 */
+ (NSString *)le_did {
    return [ShiningSdkManager shareShiningSdkManager].le_did;
}


+ (void)checkLetvAutoLogin:(UIViewController *)showLoginVC {
    [self checkLetvAutoLogin:showLoginVC finishBlock:nil];
}

+ (void)checkLetvAutoLogin:(UIViewController *)showLoginVC
               finishBlock:(void(^ __nullable)(BOOL))finishBlock {
    if (!showLoginVC) {
        NSLog(@"error-------checkLetvAutoLogin 必须有登陆载体VC");
        return;
    }
#ifdef ShiningSdk
    if ([self isLetvLogin]) {
        [[ShiningSdkManager shareShiningSdkManager] showLetvAutoLoginPopWidown:showLoginVC];
    } else {
        if (![SYNetworkReachability isNetworkReachable]) {
            [SYToastView showToast:@"网络连接中断，请检查网络"];
            if (finishBlock) {
                finishBlock(NO);
            }
            return;
        }
        if (![NSString sy_isBlankString:[[UserProfileManager sharedInstance] getTempAccessToken]]) {
            //绑定手机号登陆
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYNotification_CloseHezi" object:nil];
            SYLoginViewController *controller = [SYLoginViewController new];
            [showLoginVC presentViewController:controller animated:YES completion:^{
                NSLog(@"加载完成");
            }];
            controller.cancelBlock = ^{
                if (finishBlock) {
                    finishBlock(NO);
                }
            };
        } else {
            if ([self isLetvLoginWithMail] ) {
                [[ShiningSdkManager shareShiningSdkManager] autoLoginWithLetv:^(BOOL isSuccess) {
                    if (![NSString sy_isBlankString:[[UserProfileManager sharedInstance] getTempAccessToken]]) {
                        //绑定手机号登陆
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SYNotification_CloseHezi" object:nil];
                        SYLoginViewController *controller = [SYLoginViewController new];
                        [showLoginVC presentViewController:controller animated:YES completion:^{
                            NSLog(@"加载完成");
                        }];
                        controller.cancelBlock = ^{
                            if (finishBlock) {
                                finishBlock(NO);
                            }
                        };
                    }
                    if (!isSuccess) {
                        if (finishBlock) {
                            finishBlock(NO);
                        }
                    }
                }];
            }else {
                if ([ShiningSdkManager shareShiningSdkManager].delegate && [[ShiningSdkManager shareShiningSdkManager].delegate respondsToSelector:@selector(didLoginWithLetv:callBack:)]) {
                    [[ShiningSdkManager shareShiningSdkManager].delegate didLoginWithLetv:@{@"nav":showLoginVC} callBack:^(BOOL isSucess) {
                        if (isSucess) {
                            [[UserProfileManager sharedInstance] setFromLoginPage:YES];
                        }
                        if (isSucess && [NSString sy_isBlankString:[SYSettingManager accessToken]]) {
                            //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SYNotification_UpdateUserInfo" object:nil];
                        }
                        if (finishBlock) {
                            finishBlock(isSucess);
                        }
                    }];
                }
            }
        }
    }
#else
    if ([NSString sy_isBlankString:[SYSettingManager accessToken]]) {
        //绑定手机号登陆
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SYNotification_CloseHezi" object:nil];
        SYLoginViewController *controller = [SYLoginViewController new];
        SYNavigationController *loginNavi = [[SYNavigationController alloc] initWithRootViewController:controller];
        loginNavi.modalPresentationStyle = UIModalPresentationFullScreen;
        [showLoginVC presentViewController:loginNavi animated:YES completion:^{
            NSLog(@"加载完成");
        }];
        controller.cancelBlock = ^{
            if (finishBlock) {
                finishBlock(NO);
            }
        };
    }
#endif
}


/**
 乐视视频 静默登陆 (乐视视频已经登陆 并且闪音没有登录的情况下才触发)
 */
+ (void)letvAutoLogin {
    if (([self isLetvLogin] || [self isLetvLoginWithMail])
        && [NSString sy_isBlankString:[SYSettingManager accessToken]]
        && [NSString sy_isBlankString:[[UserProfileManager sharedInstance] getTempAccessToken]]) {
        [[ShiningSdkManager shareShiningSdkManager] autoLoginWithLetv:^(BOOL isSuccess) {

        }];
    }
}


+ (void)voiceHomeAutoLogin:(UIViewController *)showVC {
    if (([self isLetvLogin] || [self isLetvLoginWithMail])
        && [NSString sy_isBlankString:[SYSettingManager accessToken]]
        && [NSString sy_isBlankString:[[UserProfileManager sharedInstance] getTempAccessToken]]) {
        [[ShiningSdkManager shareShiningSdkManager] autoLoginWithLetv:^(BOOL isSuccess) {
             UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
            if (![NSString sy_isBlankString:[SYSettingManager accessToken]] &&
                ![NSString sy_isBlankString:user.userid] &&
                ![[UserProfileManager sharedInstance] getIsFromLoginPage]) {
                [[UserProfileManager sharedInstance] checkNextNeedInfo:showVC];
            }
        }];
    }else {
        UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
        if (![NSString sy_isBlankString:[SYSettingManager accessToken]] && ![NSString sy_isBlankString:user.userid] &&
            ![[UserProfileManager sharedInstance] getIsFromLoginPage]) {
            [[UserProfileManager sharedInstance] checkNextNeedInfo:showVC];
        }
    }
}


+ (void)clearLetvAccountInfo {
    [[ShiningSdkManager shareShiningSdkManager] clearLetvInfo];
}



//+ (void)

@end
