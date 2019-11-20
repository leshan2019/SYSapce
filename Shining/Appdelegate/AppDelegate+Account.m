//
//  AppDelegate+Account.m
//  Shining
//
//  Created by 杨玄 on 2019/3/27.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "AppDelegate+Account.h"
//#import <Flutter/Flutter.h>
//#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import "EMDemoOptions.h"
#import "MBProgressHUD.h"
#import "IMGlobalVariables.h"
#import "ChatHelper.h"
#import "CommonNavigationController.h"
#import "UserProfileManager.h"
//#import "FlientViewController.h"
//#import "FlutterManager.h"
#import "SYUserServiceAPI.h"
#import "SYLoginViewController.h"
//#import "HeziSDK.h"
#import "SYGiftNetManager.h"
#import "SYLoginGiftBagView.h"
#import "ShiningSdkManager.h"

@implementation AppDelegate (Account)

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
               otherConfig:(NSDictionary *)otherConfig
{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions];
    EMDemoOptions *demoOptions = [EMDemoOptions sharedOptions];
    if (demoOptions.isAutoLogin){
        gIsInitializedSDK = YES;
        [[EMClient sharedClient] initializeSDKWithOptions:[demoOptions toOptions]];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        /*语音版下掉
        [self requestLoginGiftBags];
         */
    }
}

#pragma mark - 登录礼包列表数据

// 请求登录礼包列表
- (void)requestLoginGiftBags {
    __weak typeof(self) weakSelf = self;
    SYGiftNetManager *giftManager = [SYGiftNetManager new];
    [giftManager requestLoginGiftListWithSuccess:^(id  _Nullable response) {
        NSArray *gifts = (NSArray *)response;
        [weakSelf showLoginGiftPopupWindow:gifts];
    } failure:^(NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

- (void)showLoginGiftPopupWindow:(NSArray *)gifts {
    for (UIView *view in [self.window subviews]) {
        if (view.tag == 894567) {
            [view removeFromSuperview];
        }
    }
    SYLoginGiftBagView *giftView = [[SYLoginGiftBagView alloc] initWithFrame:self.window.bounds withBlock:^{
        CommonNavigationController *nav = (CommonNavigationController *)self.window.rootViewController;
        UIViewController *topVC = nav.topViewController;
        [ShiningSdkManager checkLetvAutoLogin:topVC];
    }];
    giftView.tag = 894567;
    [giftView updateGiftBags:gifts];
    [self.window addSubview:giftView];
}

#pragma mark - 登录礼包领取成功弹窗

// 请求登录礼包是否领取成功
- (void)requestUserHasGetLoginGiftBags {
    __weak typeof(self) weakSelf = self;
    SYGiftNetManager *giftManager = [SYGiftNetManager new];
    NSString *accessToken = [SYSettingManager accessToken];
    if (accessToken.length > 0) {
        [giftManager requestLoginGiftGetWithSuccess:^(id  _Nullable response) {
            if ([response integerValue] == 1) {
                [weakSelf showHasGetLoginGiftWindow];
            }
        }];
    }
}

- (void)showHasGetLoginGiftWindow {
    if (self.popupWindow) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
    UIWindow *window = self.window;
    self.popupWindow = [[SYPopUpWindows alloc] initWithFrame:CGRectZero];
    self.popupWindow.delegate = self;
     [self.popupWindow updatePopUpWindowsWithType:SYPopUpWindowsType_Single withMainTitle:@"恭喜您，礼包领取成功！请在礼物->背包中查看～" withSubTitle:nil withBtnTexts:@[@"我知道了"] withBtnTextColors:@[RGBACOLOR(11, 11, 11, 1)]];
    [window addSubview:self.popupWindow];
    [self.popupWindow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}

#pragma mark - SYPopUpWindowsDelegate

- (void)handlePopUpWindowsMidBtnClickEvent {
    if (self.popupWindow && self.popupWindow.superview) {
        [self.popupWindow removeFromSuperview];
        self.popupWindow = nil;
    }
}

#pragma mark - 登录状态变更通知回调

- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    //登录成功加载主窗口控制器
    if (loginSuccess) {
        ChatHelper *demoHelper = [ChatHelper shareHelper];
        [[UserProfileManager sharedInstance] initParse];

        // 请求个人用户信息
        [[SYUserServiceAPI sharedInstance] requestUserInfoWithSuccess:^(BOOL success) {
            if (success) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_USERINFOREADY object:nil];
            }
        }];

        [[SYUserServiceAPI sharedInstance] requestLebzTicket:^(id  _Nullable response) {
            NSLog(@"乐缤果 ticter is %@",response);
        } failure:^(NSError * _Nullable error) {

        }];

        [demoHelper asyncGroupFromServer];
        [demoHelper asyncConversationFromDB];
        [demoHelper asyncPushOptions];

        /*语音版下掉
        // 登录成功后，判断是否登录礼包领取成功
        [self requestUserHasGetLoginGiftBags];
         */

    }else {//登录失败加载登录页面控制器
//        if (gMainController) {
//            [gMainController.navigationController popToRootViewControllerAnimated:NO];
//        }
//        [IMGlobalVariables setGlobalMainController:nil];
//
////        FlientViewController *controller = [[FlutterManager shareManager]initialLogin_FlutterViewController];
//        SYLoginViewController *controller = [SYLoginViewController new];
//        navigationController = [[CommonNavigationController alloc] initWithRootViewController:controller];
//
//        [[UINavigationBar appearance] setTitleTextAttributes:
//         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];

        [[UserProfileManager sharedInstance] clearParse];
        [[UserProfileManager sharedInstance] removeUserProfile];
//        self.window.rootViewController = navigationController;
//        [GeneratedPluginRegistrant registerWithRegistry: controller];
    }
    //自有通道简历webSocket 连接
    [[SYWebConnectonManager sharedManager] startConnect];
}



- (void)checkLetvClientLogin {
    if (!self.groupDefault) {
        self.groupDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.letv.iphone.client"];
        self.keyString = @"group.com.letv.iphone.client.token";
    }
    NSString *token = [self.groupDefault objectForKey:self.keyString];
    if (![NSString sy_isBlankString:token]) {

    }
}


@end
