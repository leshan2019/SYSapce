//
//  AppDelegate+Push.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/21.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

//#import <Flutter/Flutter.h>
//#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

#import "AppDelegate+Push.h"
#import "EMDemoOptions.h"
#import "MBProgressHUD.h"
#import "IMGlobalVariables.h"
#import "ChatHelper.h"
#import "CommonNavigationController.h"
#import "UserProfileManager.h"
#import "EMAlertController.h"
//#import "FlientViewController.h"
#import "WXApiRequestHandler.h"
#import "WXConstant.h"
#import "SYUserServiceAPI.h"
#import "SYDistrictProvider.h"
#import "AppDelegate.h"
#import "SYStatusBarNotificationView.h"
#import "ShiningSdkManager.h"
#import "SYVoiceChatRoomManager.h"
#import "SYWebViewController.h"
#import "SYNavigationController.h"

@implementation AppDelegate (Push)

#pragma mark - DeviceToken


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [SYToastView showToast:@"FailToRegisterForRemoteNotifications"];
}

#pragma mark - RemoteNotification - Version < 10

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (gMainController) {
        [gMainController jumpToChatList];
    }
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - LocalNotification - Version < 10

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (gMainController) {
        [gMainController didReceiveLocalNotification:notification];
    }
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 10) {//当前系统小于10,接收本地通知  ios9 点击/接收都是这个回调
        //应用在前台后台运行时收到本地推送
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if ([[notification.userInfo objectForKey:@"key"] isEqualToString:@"systreamerpush"]) {
            // 跳转至下载页
#ifdef ShiningSdk
            [[ShiningSdkManager shareShiningSdkManager] jumpVoiceRoomWihtRoomId:[NSString sy_safeString:[notification.userInfo objectForKey:@"roomid"]] from:LetvFromTagLocalPush];
#else
            [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:[NSString sy_safeString:[notification.userInfo objectForKey:@"roomid"]] from:SYVoiceChatRoomFromTagLocalPush];
#endif
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __OSX_AVAILABLE(10.14) {
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
    NSDictionary *userInfo = notification.request.content.userInfo;
    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __OSX_AVAILABLE(10.14) __TVOS_PROHIBITED {
    if (gMainController) {
        [gMainController didReceiveUserNotification:response.notification];
    }
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSString *key = [userInfo objectForKey:@"key"];
    if (![NSString sy_empty:key]
        && [key isKindOfClass:[NSString class]]
        && [key isEqualToString:@"systreamerpush"]) {
        // 跳转至下载页
#ifdef ShiningSdk
        [[ShiningSdkManager shareShiningSdkManager] jumpVoiceRoomWihtRoomId:[NSString sy_safeString:[userInfo objectForKey:@"roomid"]] from:LetvFromTagLocalPush];
#else
        [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:[NSString sy_safeString:[userInfo objectForKey:@"roomid"]] from:SYVoiceChatRoomFromTagLocalPush];
#endif
        completionHandler();
        // iOS10移除通知方法
        NSString *identifier =  response.notification.request.identifier;
        if(![NSString sy_empty:identifier]){
            [center removeDeliveredNotificationsWithIdentifiers:@[response.notification.request.identifier]];
        }
        return;
    }
    completionHandler();
}

#pragma mark - Private

- (void)easemobApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didReceiveRemoteNotification:userInfo];
}


/**
 注册push相关信息

 @param dic 
 */
- (void)registerPushNotification:(NSDictionary *)dic {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        if (@available(iOS 10.0, *)) {//ios 10以上 --mark
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            //判断当前注册状态
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                        if (granted) {
                            [[UIApplication sharedApplication] registerForRemoteNotifications];
                        }
                    }];
                }
            }];
        } else {
            UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
        }

        [[UIApplication sharedApplication] registerForRemoteNotifications]; // 注册远程通知, 获取token
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
    }
}


/**
 获取关注列表中的主播正在主播的列表 并触发本地通知
 */
- (void)checkFollowListLocalNotification {
    // 获取关注列表
    __weak typeof(self) weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestFollowOrFansList:YES success:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYUserListModel class]]) {
            NSMutableArray *list = [NSMutableArray new];
            SYUserListModel *listModel = (SYUserListModel *)response;
            [listModel.Users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UserProfileEntity *user = obj;
                if (user.is_streamer == 1 && user.streamer_roomid > 0) {
                    [list addObject:user];
                }
            }];
            if (list.count > 0) {
                int num = arc4random_uniform(list.count);
                UserProfileEntity *user = [list objectAtIndex:num];
                [weakSelf sendStreamerLocalNotification:user];
            }
        }
    } failure:^(NSError * _Nullable error) {
    }];
}


/**
 发送主播开播本地通知

 @param user 主播信息
 */
- (void)sendStreamerLocalNotification:(UserProfileEntity *)user {
    if (!user || [NSString sy_isBlankString:user.streamer_roomname] || [NSString sy_isBlankString:user.username]) {
        return;
    }
    NSString *body = [NSString stringWithFormat:@"%@正在%@直播间直播，点击进入直播间观看",[NSString sy_safeString:user.username],[NSString sy_safeString:user.streamer_roomname]];
    NSString *roomid = [NSString stringWithFormat:@"%ld",(long)user.streamer_roomid];
    NSDictionary *userInfo =  @{@"key":@"systreamerpush",@"roomid":roomid};
    NSInteger timeInteval = 5;
    BOOL pushON = YES;
    if (@available(iOS 10.0, *)) {
        //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
            pushON = NO;
        }
    }
    if (@available(iOS 10.0, *) && pushON) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];

        content.sound = [UNNotificationSound defaultSound];
        //        content.title = @"开播提醒";
        content.body = body;
        content.userInfo = userInfo;
        NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:timeInteval] timeIntervalSinceNow];

        // 3.触发模式
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];

        // 4.设置UNNotificationRequest
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"systreamerpush" content:content trigger:trigger];

        // 5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        }];
    }else {
        if (nil == self.statusBarNotification) {
            self.statusBarNotification = [CWStatusBarNotification new];
            // set default blue color (since iOS 7.1, default window tintColor is black)
            self.statusBarNotification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
            self.statusBarNotification.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
            self.statusBarNotification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
            self.statusBarNotification.notificationStyle = CWNotificationStyleNavigationBarNotification;
            self.statusBarNotification.multiline = YES;
        }
        __weak typeof(self) weakSelf = self;
        self.statusBarNotification.notificationTappedBlock = ^{
            [weakSelf.statusBarNotification dismissNotification];
#ifdef ShiningSdk
            [[ShiningSdkManager shareShiningSdkManager] jumpVoiceRoomWihtRoomId:roomid from:LetvFromTagLocalPush];
#else
            [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:[NSString sy_safeString:roomid] from:SYVoiceChatRoomFromTagLocalPush];
#endif
        };
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInteval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SYStatusBarNotificationView *customView = [SYStatusBarNotificationView new];
            [customView bindDataWithTitle:@"" body:body];
            [weakSelf.statusBarNotification displayNotificationWithView:customView forDuration:timeInteval completion:^{
                customView.backView.backgroundColor = [UIColor clearColor];
                [customView.backView sy_addBlurWithFrame:customView.backView.bounds];
            }];
        });
    }
}


#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    
}


#pragma mark Universal Links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webUrl = userActivity.webpageURL;
        [self handleUniversalLink:webUrl]; // 转化为App路由
    }
    return YES;
}


- (void)handleUniversalLink:(NSURL *)webUrl {
    NSURLComponents *components = [NSURLComponents componentsWithURL:webUrl resolvingAgainstBaseURL:YES];
    NSString *path = components.path;
    NSMutableDictionary *param = [NSMutableDictionary new];
    if ([path hasSuffix:@"/unlink"]) {
        NSInteger action = 0;
        for (NSURLQueryItem *item in components.queryItems) {
            if ([item.name isEqualToString:@"action"]) {
                action = [item.value integerValue];
            }else {
                [param setValue:item.value forKey:item.name];
            }
        }
        switch (action) {
            case 1: {//调起App首页
                if (gMainController) {
                    [gMainController jumpToVoiceRoomHome];
                }
            }
                break;
            case 2: {//调起直播房间
               [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:[param objectForKey:@"roomid"] from:SYVoiceChatRoomFromTagH5Share];
            }
                break;
            case 3: {//调起webView 打开url
                UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                while (vc.presentedViewController) {
                    vc = vc.presentedViewController;
                }
                SYWebViewController *webVC = [[SYWebViewController alloc] initWithURL:[param objectForKey:@"url"]];
                SYNavigationController *navi = [[SYNavigationController alloc] initWithRootViewController:webVC];
                navi.modalPresentationStyle = UIModalPresentationFullScreen;
                [vc presentViewController:navi animated:YES completion:nil];
            }
                break;
            default:
                break;
        }


    }
}

@end
