//
//  LetvLBZManager.m
//  LetvIphoneClient
//
//  Created by leeco on 2018/4/27.
//  Copyright © 2018年 LeEco. All rights reserved.
//

#import "LetvLBZManager.h"
//
#import <LetvLBZ/LBZComponent.h>

//
@interface LetvLBZManager ()

@property (nonatomic, weak) UIViewController*controller;
@property (nonatomic, strong) NSString*token;

@end
//
@implementation LetvLBZManager
+ (LetvLBZManager*) shareInstance {
    static LetvLBZManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once (&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)interLbzViewControllerWithSdkTargetURL:(NSString *)urlStr andUserTicket:(NSString *)ticket andUid:(NSString *)uid reginTicketHandler:(ShanYinRegainTicketHandler)reginTicketHandler PayHandler:(ShanYinPayHandler)PayHandler currentViewController:(UIViewController *)currentVc{
    if (![NSString sy_isBlankString:urlStr]&&![NSString sy_isBlankString:ticket]) {
        self.webUrlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.controller = currentVc;
//        [self resetManagerValus];
        if ([SYNetworkReachability isNetworkReachable]) {
            BOOL isLogin = ![NSString sy_isBlankString:[SYSettingManager accessToken]];
            if (isLogin) {
                [self interLbzWithToken:@"" orTicket:ticket andUid:uid reginTicketHandler:reginTicketHandler PayHandler:PayHandler];
            }
            else {
                [self interLbzWithToken:@"" orTicket:@"" andUid:@"" reginTicketHandler:nil PayHandler:nil];
            }
        }else {
            [self interLbzWithToken:@"lbz_noNet" orTicket:@"" andUid:@"" reginTicketHandler:nil PayHandler:nil ];
        }
    }
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
#ifdef LT_IOS8_TRANSFORM
    if (LTAPI_IS_ALLOWED(8.0)&&!LTAPI_IS_ALLOWED(8.3)) {
        LetvIphoneClientAppDelegate *appDelegate = (LetvIphoneClientAppDelegate *)[UIApplication sharedApplication].delegate;
        resultVC = [self _topViewController:appDelegate.letvNavigationController];
    }else
#endif
    {
        resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    }
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

-(void)interLbzWithToken:(NSString*)tk orTicket:(NSString*)ticket andUid:(NSString*)shyUid reginTicketHandler:(ShanYinRegainTicketHandler)reginTicketHandler PayHandler:(ShanYinPayHandler)PayHandler{
    BOOL isTest = YES;
    [[LBZManager sharedLBZManager] configurationVersions:!isTest andUrl:self.webUrlStr];
    //
    NSString*uid=@"用户的uid";//[SettingManager alreadyLoginUserID];

    LBZHomeViewController*lbzVC=[[LBZHomeViewController alloc]initWithLbzHomeAccessToken:tk];
    lbzVC.letv_uid=uid;

    if (![NSString sy_isBlankString:ticket]){
        lbzVC = [[LBZHomeViewController alloc]initWithLbzHomeTicket:ticket];
        lbzVC.letv_uid = shyUid;
    }

    LBZNavigationViewController * nav = [[LBZNavigationViewController alloc] initWithRootViewController:lbzVC];
    //
    lbzVC.webViewUrl=self.webUrlStr;
    UIViewController*topVc=[self topViewController];
    NSLog(@"leLbz----最上层vc：%@",topVc);

    if ([topVc isKindOfClass:[LBZHomeViewController class]]) {
        LBZHomeViewController*tmp=(LBZHomeViewController*)topVc;
        [tmp reloadWebView:self.webUrlStr];

    }else{
        [self.controller presentViewController:nav animated:YES completion:^{
            NSLog(@"presentViewController 弹出了");
        }];
    }
    //
    __weak typeof(self) weakSelf = self;
    [lbzVC registerShanInPayTicket:ticket Handler:^(id data, PayResponseCallback responseCallback) {
        //调起乐聊支付页
        ShanYinPayResponseCallback payResponseCallback = ^(NSString* orderId,BOOL payResult){
            LBZPayType result = payResult?LBZPaySuccess:LBZPayFail;
            responseCallback(@"",orderId,result);
        };
        PayHandler(@{@"nav":nav},payResponseCallback);
    }];
    
    [lbzVC registerReauthorizationHandler:^(id data, ReauthorizationResponseCallback responseCallback) {

        
            if (![NSString sy_isBlankString:ticket]){
                //从乐聊获取新的ticket
                ShanYinRegainTicketResponseCallback regainTicketResponseCallback = ^(NSString* newTicket){
                     responseCallback(newTicket);
                };
                reginTicketHandler(@{@"nav":nav},regainTicketResponseCallback);
                
            }
    }];
}
-(void)logoutLBZwhenLogoutLetvAccount {
    [[LBZManager sharedLBZManager] loginOut];
}
-(void)loginSuccess {
    NSLog(@"登录成功--delegate");
}





@end
