//
//  SYChildProtectManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/31.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//
/*
#import "SYChildProtectManager.h"
#import "ShiningSdkManager.h"
#import "SYAdolescentModelWindow.h"
#import "SYIDCardAuthenticationVC.h"
#import "SYAdolescentModelVC.h"

#define kChildProtectLoginTag 3232
#define kChildProtectVerifyTag 3233

@interface SYChildProtectManager () <UIAlertViewDelegate>

@property (nonatomic, weak) UINavigationController *defaultNavi;
@property (nonatomic, weak) UINavigationController *navi;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation SYChildProtectManager

+ (instancetype)sharedInstance {
    static SYChildProtectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [SYChildProtectManager new];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _defaultNavi = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    }
    return self;
}

- (BOOL)needChildProtectWithNavigationController:(UINavigationController *)navi {
    if (!navi) {
        navi = self.defaultNavi;
    }
    self.navi = navi;
    // 根据未成年认证等级决定是否可以进入房间
    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
    BOOL logined = (user.userid) ? YES : NO;
    SYUserMode mode = (SYUserMode)user.auth_model;

//     这里写一下逻辑：
//     1. 防控等级0：已登录的，没有确定模式的必须弹窗，弹几次窗没有限制；青少年模式，不予进入；成人模式准予进入。
//     未登录弹未登录窗，弹几次窗也没有限制。
//     2. 防控等级1：没有确定模式的，只弹一次窗，且可以跳过；青少年模式，也只弹一次窗，且可以跳过；成人模式准予进入。
//     3. 防控等级2：就是没有防控。随便进入。

    if ([SYSettingManager childIdentity] == SYChildIdentityLevelHigh) {
        if (logined) {
            if (mode == SYUserModeUnknown) {
                // 必须弹窗
                [self popWindowWithAdolescentModelType:SYAdolescentModelType_Strict
                                  navigationController:navi];
                return YES;
            } else if (mode == SYUserModeTeenager) {
                if (self.alertView) {
                    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
                    self.alertView = nil;
                }
                // 弹引导认证框
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"青少年模式无法使用该功能"
                                                                    message:@"身份认证成年后，可开启正常模式"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"去认证", nil];
                alertView.tag = kChildProtectVerifyTag;
                [alertView show];
                self.alertView = alertView;
                return YES;
            } else if (mode == SYUserModeAdult) {
                // 给予通过
            } else {
                [SYToastView showToast:@"未获取到认证模式信息"];
                return YES;
            }
        } else {
            // 弹引导登录框
            if (self.alertView) {
                [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
                self.alertView = nil;
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"进入房间需要先登录，以及进行身份验证"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"去登录", nil];
            alertView.tag = kChildProtectLoginTag;
            [alertView show];
            self.alertView = alertView;
            return YES;
        }
    } else if ([SYSettingManager childIdentity] == SYChildIdentityLevelLow) {
        if (logined) {
            if (mode != SYUserModeAdult && ![SYSettingManager verifyIdentityPageShowed]) {
                [SYSettingManager setVerifyIdentityPageShowed:YES];
                // 弹窗（可跳过弹窗）
                [self popWindowWithAdolescentModelType:SYAdolescentModelType_Normal
                                  navigationController:navi];
                return YES;
            }
        }
    }
    return NO;
}

- (void)popWindowWithAdolescentModelType:(SYAdolescentModelType)type
                    navigationController:(UINavigationController *)navi {
    SYAdolescentModelWindow *window = [SYAdolescentModelWindow createSYAdolescentModelWindowWithType:type Authen:^{
        // 去认证
        SYIDCardAuthenticationVC *vc = [SYIDCardAuthenticationVC new];
        [navi pushViewController:vc animated:YES];
    } AdolescentModel:^{
        // 不认证，进入青少年模式
        SYAdolescentModelVC *vc = [SYAdolescentModelVC new];
        [navi pushViewController:vc animated:YES];
    } TempraryAuthen:^{
        // 暂不认证
        // todo:默认已满18岁
    }];
    [[[UIApplication sharedApplication] keyWindow] addSubview:window];
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.alertView = nil;
    if (alertView.tag == kChildProtectVerifyTag) {
        if (buttonIndex == 1) {
            // 去认证页面
            SYIDCardAuthenticationVC *vc = [SYIDCardAuthenticationVC new];
            [self.navi pushViewController:vc animated:YES];
        }
    } else if (alertView.tag == kChildProtectLoginTag) {
        if (buttonIndex == 1) {
            UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            if (vc.presentedViewController) {
                vc = vc.presentedViewController;
            }
            [ShiningSdkManager checkLetvAutoLogin:vc];
        }
    }
}

@end
 */
