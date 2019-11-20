//
//  AppDelegate.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "AppDelegate.h"
#import <Hyphenate/Hyphenate.h>
#import "AppDelegate+Account.h"
#import "AppDelegate+Push.h"
#import "IMGlobalVariables.h"
#import <UserNotifications/UserNotifications.h>
#import <Parse/Parse.h>
//#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
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
#import "SYConfigManager.h"
//#import "HeziSDKManager.h"
//#import <AipOcrSdk/AipOcrSdk.h>
//#import <IDLFaceSDK/IDLFaceSDK.h>
//#import "NetAccessModel.h"
//#import "SmAntiFraud.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "SYNavigationController.h"

@interface AppDelegate ()
@property(nonatomic,strong)NSString *em_username;
@property(nonatomic,strong)NSString *em_password;
@end

@implementation AppDelegate

#pragma mark - Appdelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SYSettingManager setVerifyIdentityPageShowed:NO];
    [SYConfigManager requestConfig];
    [SYDistrictProvider.shared install];
    [[SYBGMProvider shared] install];
    [SYNetworkReachability startMonitoring];
    [self initRootViewController];
//    [self initLaunchAdView];
    // TODO。
    [self parseApplication:application didFinishLaunchingWithOptions:launchOptions];

    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    [WXApi registerApp:/*@"wxc8583422c914bd95"*/kWXAppid];

    [[SYAudioPlayerManager shareSYAudioPlayerManager] setup];
    
    [[SYGiftInfoManager sharedManager] updateGiftList];

    [self registerPushNotification:launchOptions];

//    [[SYVoiceRoomEMManager sharedInstance] start];
/*
    //umeng sdk
#ifdef UseSettingTestDevEnv
    [UMConfigure initWithAppkey:@"5d0dced54ca357cfeb000b97" channel:nil];
    [MobClick setCrashReportEnabled:YES];
    [UMConfigure setLogEnabled:YES];//设置打开日志
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
#else
    [UMConfigure initWithAppkey:@"5d2e823d4ca357db8c0009b4" channel:nil];
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
#endif
    if ([SYSettingManager syIsTestApi]) {
        [[HeziSDKManager sharedInstance] configureKey:@"703b876743e818c87ab273b0b0e39c7a"];

    }else{
        [[HeziSDKManager sharedInstance] configureKey:@"abf5cae5f707f5377b258f17f7800409"];
    }
    // 针对私有化部署的用户需要设置私有化的域名，域名后需要有'/'
    //[[HeziSDKManager sharedInstance] configureServerDomain:@"https://emma.mydomain.com/"];
    [[HeziSDKManager sharedInstance] openDebug:NO];
    // 设置导航栏样式
//    [[HeziSDKManager sharedInstance] setNavigationBarBackgroundImage:[UIImage imageNamed:@"anniu01"]];
    [[HeziSDKManager sharedInstance]setNavigationBarBackgroundColor:[UIColor sy_colorWithHexString:@"#F5F6F7"]];
    [[HeziSDKManager sharedInstance]setNavigationTinterColor:[UIColor blackColor]];
    //初始化
    [[HeziSDKManager sharedInstance] initialize];
    [[HeziSDKManager sharedInstance]initializeAnalysis];

    // 人脸和身份证识别SDK授权
    [self sy_Face_IdCard_Authentication];

    [self sy_SMSDK_Authentiacation];
 */
    
    [self sy_AMap_setup];

    [self.window makeKeyAndVisible];

//    [self checkFollowListLocalNotification];



    return YES;
//    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


- (void)initRootViewController {
    SYVoiceRoomHomeVC *voiceRoomHomeVC = [[SYVoiceRoomHomeVC alloc] init];
    self.window.rootViewController = voiceRoomHomeVC;
}



- (void)initLaunchAdView {
    SYLaunchAdViewController *launchAdVC = [[SYLaunchAdViewController alloc] init];
    [self.window.rootViewController addChildViewController:launchAdVC];
    [self.window.rootViewController.view addSubview:launchAdVC.view];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //活动盒子 解析 url
//    [[HeziSDKManager sharedInstance]dealWithUrl:url];
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //活动盒子 解析 url
//    [[HeziSDKManager sharedInstance]dealWithUrl:url];
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
//    [[SYVoiceChatRoomManager sharedManager] appWillTerminate];
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

// 高德地图
- (void)sy_AMap_setup {
    [AMapServices sharedServices].apiKey = SY_AMAP_APPKEY;
}

@end
