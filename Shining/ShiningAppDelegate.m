//
//  ShiningAppDelegate.m
//  LetvShiningModule
//
//  Created by letv_lzb on 2019/4/20.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import "ShiningAppDelegate.h"
//#import <FlutterPluginRegistrant/FlutterPluginRegistrant-umbrella.h>
#import <Hyphenate/Hyphenate.h>
#import "IMGlobalVariables.h"
#import <UserNotifications/UserNotifications.h>
#import <Parse/Parse.h>
#import "SYAudioPlayerManager.h"
#import "SYLaunchAdViewController.h"
#import "WXApiManager.h"
#import "SYDistrictProvider.h"
#import "SYDistrict.h"
#import "SYSignProvider.h"
#import "SYGiftInfoManager.h"
#import "SYVoiceChatRoomManager.h"
#import "WXConstant.h"
#import "SYBGMProvider.h"
#import "EMDemoOptions.h"
#import "ChatHelper.h"
#import "SYUserServiceAPI.h"
#import "UserProfileManager.h"
//#import "FlientViewController.h"
//#import "FlutterManager.h"
#import "ShiningSdkManager.h"
#import "NSString+SYHTTPExtensions.h"
//#import <UMCommon/UMCommon.h>
#import "SYConfigManager.h"
#import "CWStatusBarNotification.h"
#import "SYStatusBarNotificationView.h"
#import "UIView+CWStatus.h"
//#import "HeziSDKManager.h"
//#import <AipOcrSdk/AipOcrSdk.h>
//#import <IDLFaceSDK/IDLFaceSDK.h>
//#import "NetAccessModel.h"
//#import "SmAntiFraud.h"

@interface ShiningAppDelegate ()
@property (nonatomic,strong) CWStatusBarNotification *statusBarNotification;
@end

@implementation ShiningAppDelegate


- (instancetype)initWithDelegate:(id<ShiningSdkManager>)delegate {
    self = [super init];
    if (self) {
        [ShiningSdkManager shareShiningSdkManager].delegate = delegate;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bootingFinishNotificationRecieved:)
                                                     name:@"BootingShowFinishedNotification"
                                                   object:nil];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SYSettingManager setVerifyIdentityPageShowed:NO];
    [SYConfigManager requestConfig];
    [SYDistrictProvider.shared install];
    [[SYBGMProvider shared] install];
    [SYNetworkReachability startMonitoring];
    // TODO。
    [self parseApplication:application didFinishLaunchingWithOptions:launchOptions];

    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];

//    [WXApi registerApp:/*@"wxc8583422c914bd95"*/kWXAppid];

    [[SYAudioPlayerManager shareSYAudioPlayerManager] setup];

    [[SYGiftInfoManager sharedManager] updateGiftList];

    [[SYVoiceRoomEMManager sharedInstance] start];
    //umeng sdk
//#ifdef UseSettingTestDevEnv
//    [UMConfigure setLogEnabled:YES];//设置打开日志
//    [UMConfigure initWithAppkey:@"5d0dced54ca357cfeb000b97" channel:nil];
//#else
//    [UMConfigure initWithAppkey:@"5c6e098eb465f55538001358" channel:nil];
//#endif
//#ifdef UseSettingTestDevEnv
//    NSString* deviceID =  [UMConfigure deviceIDForIntegration];
//    if ([deviceID isKindOfClass:[NSString class]]) {
//        NSLog(@"服务器端成功返回deviceID : %@",deviceID);
//    }else {
//        NSLog(@"服务器端还没有返回deviceID");
//    }
//#endif
//    if ([SYSettingManager syIsTestApi]) {
//        [[HeziSDKManager sharedInstance] configureKey:@"703b876743e818c87ab273b0b0e39c7a"];
//
//    }else{
//        [[HeziSDKManager sharedInstance] configureKey:@"abf5cae5f707f5377b258f17f7800409"];
//    }
//    // 针对私有化部署的用户需要设置私有化的域名，域名后需要有'/'
//    //[[HeziSDKManager sharedInstance] configureServerDomain:@"https://emma.mydomain.com/"];
//    [[HeziSDKManager sharedInstance] openDebug:YES];
//    // 设置导航栏样式
//    [[HeziSDKManager sharedInstance]setNavigationBarBackgroundColor:[UIColor sy_colorWithHexString:@"#F5F6F7"]];
//    [[HeziSDKManager sharedInstance]setNavigationTinterColor:[UIColor blackColor]];
//    //初始化
//    [[HeziSDKManager sharedInstance] initialize];
//    [[HeziSDKManager sharedInstance]initializeAnalysis];

    // 人脸和身份证识别SDK授权
    [self sy_Face_IdCard_Authentication];

    [self sy_SMSDK_Authentiacation];

    return YES;
//    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}



- (void)bootingFinishNotificationRecieved:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BootingShowFinishedNotification" object:nil];
    [self checkFollowListLocalNotification];
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
            [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:roomid from:SYVoiceChatRoomFromTagLocalPush];
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

#pragma mark - Private

- (void)parseApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse enableLocalDatastore];

    // Initialize Parse.
    //    [Parse setApplicationId:@"UUL8TxlHwKj7ZXEUr2brF3ydOxirCXdIj9LscvJs"
    //                  clientKey:@"B1jH9bmxuYyTcpoFfpeVslhmLYsytWTxqYqKQhBJ"];

    // change Parse server
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration>  _Nonnull configuration) {
        configuration.applicationId = @"UUL8TxlHwKj7ZXEUr2brF3ydOxirCXdIj9LscvJs";
        configuration.clientKey = @"B1jH9bmxuYyTcpoFfpeVslhmLYsytWTxqYqKQhBJ";
        configuration.server = @"http://parse.easemob.com/parse/";
    }]];


    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];


    // setup ACL
    PFACL *defaultACL = [PFACL ACL];

    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];

    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}


/**
 account

 @param application application
 @param launchOptions lauchOptions
 @param otherConfig config
 */
- (void)easemobApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
               otherConfig:(NSDictionary *)otherConfig {
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions];
    EMDemoOptions *demoOptions = [EMDemoOptions sharedOptions];
    NSString *ssotk = [launchOptions objectForKey:@"ssotk"];
    NSString *mobile = [launchOptions objectForKey:@"le_mobile"];
    NSString *url = [launchOptions objectForKey:@"le_avatarUrl"];
    NSString *name = [launchOptions objectForKey:@"le_username"];
    NSString *did = [launchOptions objectForKey:@"le_did"];
    [ShiningSdkManager setLoginSuccess:ssotk mobile:mobile avatarUrl:url username:name];
    [ShiningSdkManager setLetvDid:did];
    //设置app groups 共享信息
//    [[ShiningSdkManager shareShiningSdkManager] setLetvAppCroupInfo:ssotk le_mobile:mobile avatarUrl:url username:name];
    if (demoOptions.isAutoLogin){
        gIsInitializedSDK = YES;
        [[EMClient sharedClient] initializeSDKWithOptions:[demoOptions toOptions]];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];

    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

#pragma mark - 登录状态变更通知回调

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
        if (![NSString sy_isBlankString:[SYSettingManager accessToken]]) {
            [[ShiningSdkManager shareShiningSdkManager] setBeeAppCroupInfo:[SYSettingManager accessToken]];
        }
        [demoHelper asyncGroupFromServer];
        [demoHelper asyncConversationFromDB];
        [demoHelper asyncPushOptions];
    } else {//登录失败加载登录页面控制器
        [[ShiningSdkManager shareShiningSdkManager] clearBeeAppGroupInfo];
        [[UserProfileManager sharedInstance] clearParse];
        [[UserProfileManager sharedInstance] removeUserProfile];
    }
}





#pragma push -------


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    [super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
    });
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
//    [super application:application didFailToRegisterForRemoteNotificationsWithError:error];
    [SYToastView showToast:@"FailToRegisterForRemoteNotifications"];
}

#pragma mark - RemoteNotification - Version < 10

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    [super application:application didReceiveRemoteNotification:userInfo];
    if (gMainController) {
        [gMainController jumpToChatList];
    }
    [self easemobApplication:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - LocalNotification - Version < 10

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    [super application:application didReceiveLocalNotification:notification];
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
#endif
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}


- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
API_AVAILABLE(ios(9.0)){
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return NO;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler
{
    return NO;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^) (UIBackgroundFetchResult))completionHandler
{

}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{

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

#pragma mark - EMPushManagerDelegateDevice

// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *title = [NSBundle sy_localizedStringForKey:@"apns.content" value:@"Apns content"];
    NSString *ok = [NSBundle sy_localizedStringForKey:@"ok" value:@"OK"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:str
                                                   delegate:nil
                                          cancelButtonTitle:ok
                                          otherButtonTitles:nil];
    [alert show];

}


#pragma mark - **人脸&身份证识别SDK授权**

- (void)sy_Face_IdCard_Authentication {
//    // 人脸识别鉴权
//    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
//    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
//    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
//    NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
//
//    // 身份证识别鉴权
//    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:OCR_LICENSE_NAME ofType:OCR_LICENSE_SUFFIX];
//    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
//    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
//
//    // 获取人脸认证accesstoken
//    [[NetAccessModel sharedInstance] getAccessTokenWithAK:FACE_API_KEY SK:FACE_SECRET_KEY];
}

/**
 数美设备指纹sdk 初始化
 */
- (void)sy_SMSDK_Authentiacation {
//    NSString *DEBUG_ORG = @"qqY2PcauFergTG98BpNH";//传入organization，不要传入accessKey.
//    SmOption *option = [[SmOption alloc] init];
//    [option setOrganization:DEBUG_ORG ];
//    [option setChannel:@"appstore"];// 传入渠道标识
//
//    [[SmAntiFraud shareInstance] create:option];
    // 注意！！获取deviceId，这个接口在需要使用deviceId时地方调用。
    //    NSString* deviceId = [[SmAntiFraud shareInstance] getDeviceId];

}


@end
