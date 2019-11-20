//
//  SYShiningSdk.m
//  Shining
//
//  Created by letv_lzb on 2019/11/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYShiningSdk.h"
#import "Shining.pch"
#import "SYConfigManager.h"
#import "SYDistrictProvider.h"
#import "SYBGMProvider.h"
#import "SYSigleCase.h"
#import "EMDemoOptions.h"
#import "ChatHelper.h"
#import "SYUserServiceAPI.h"
#import "SYWebConnectonManager.h"
#import "SYAudioPlayerManager.h"
#import "WXConstant.h"
#import "WXApi.h"

@implementation SYShiningSdk

SYSingleCaseM(SYShiningSdk);



+ (void)load {
    __block id observer =
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIApplicationDidFinishLaunchingNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
        [[SYShiningSdk shareSYShiningSdk] easemobApplication:note.object didFinishLaunchingWithOptions:note.userInfo];
         [[NSNotificationCenter defaultCenter] removeObserver:observer];
     }];
}


+ (void)setup {
    [SYSettingManager setVerifyIdentityPageShowed:NO];
    [SYConfigManager requestConfig];
    [SYDistrictProvider.shared install];
    [[SYBGMProvider shared] install];
    [SYNetworkReachability startMonitoring];
    [WXApi registerApp:/*@"wxc8583422c914bd95"*/kWXAppid];

    [[SYAudioPlayerManager shareSYAudioPlayerManager] setup];
}

- (void)registerNotification {
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
}

- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions];
    EMDemoOptions *demoOptions = [EMDemoOptions sharedOptions];
    if (demoOptions.isAutoLogin){
        gIsInitializedSDK = YES;
        [[EMClient sharedClient] initializeSDKWithOptions:[demoOptions toOptions]];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}


- (void)loginStateChange:(NSNotification *)notification {
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
    }else {//登录失败加载登录页面控制器
        [[UserProfileManager sharedInstance] clearParse];
        [[UserProfileManager sharedInstance] removeUserProfile];
    }
    //自有通道简历webSocket 连接
    [[SYWebConnectonManager sharedManager] startConnect];
}

@end
