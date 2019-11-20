//
//  AppDelegate.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Flutter/Flutter.h>
#import "WXApi.h"
//#import "SYLoginManager.h"
#import "CWStatusBarNotification.h"
#import "SYPopUpWindows.h"

@interface AppDelegate : /*FlutterAppDelegate*/NSObject <UIApplicationDelegate,SYPopUpWindowsDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) CWStatusBarNotification *statusBarNotification;
@property (nonatomic, strong) NSUserDefaults *groupDefault;
@property (nonatomic, copy) NSString *keyString;
//@property (nonatomic,strong) FlutterEngine *flutterEngine;
//@property (nonatomic, strong) SYLoginManager *loginManager;

@property (nonatomic, strong) SYPopUpWindows *popupWindow;      // 各种弹窗

@end

