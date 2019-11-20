//
//  SYGameJSApi.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/5/31.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYGameJSApi.h"
#import "dsbridge.h"
#import "SYTestWebViewController.h"
#import "SYMyCoinViewController.h"
#import "SYVoiceChatRoomManager.h"
#import "SYWebViewController.h"

@interface SYGameJSApi(){
    NSTimer * timer ;
    void(^hanlder)(id value,BOOL isComplete);
    int value;
//    UIViewController *_currentVC;
    NSString *roomID;
}

@property (nonatomic, weak) UIViewController *currentVC;

@end

@implementation SYGameJSApi

- (instancetype)initWithWebVC:(UIViewController *)vc andRoomId:(NSString *)roomId {
    self = [super init];
    if (self) {
        _currentVC = vc;
        roomID = roomId;
    }
    return self;
}

- (void) getTokenAsync:(NSString *) args : (JSCallback)completionHandler
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"token": [SYSettingManager accessToken]} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    completionHandler(jsonString,YES);
}

- (void) getAppInfoAsync:(NSString *) args : (JSCallback)completionHandler
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"pcode": SHANYIN_PCODE, @"version":SHANYIN_VERSION} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    completionHandler(jsonString,YES);
}

- (void) getCurrentRoomAsync:(NSString *) args : (JSCallback)completionHandler
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"id": roomID} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    completionHandler(jsonString,YES);
}

- (void) sendMsgAsync:(NSString *) args : (JSCallback)completionHandler
{
    completionHandler(args,YES);
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SYGameJSAPI_playGameMsg" object:args];

    
}


- (NSString *) openRechargeWin: (NSDictionary *) msg
{
    //TODO:打开支付页
    if ([_currentVC isKindOfClass:[SYWebViewController class]]) {
        SYWebViewController *sourceVC = (SYWebViewController *)_currentVC;

        NSInteger price = 1;
        if (msg && [msg isKindOfClass:[NSDictionary class]]) {
            NSNumber *priOb = [msg objectForKey:@"price"];
            if ([priOb integerValue] > 0) {
                price = [priOb integerValue];
            }
        }
        __weak typeof(sourceVC) weakVC = sourceVC;
        SYMyCoinViewController *vc = [[SYMyCoinViewController alloc] initWithSelectPrice:price];
        vc.resultBlock = ^{
            [weakVC rechargeCallbackMethod];
        };
        [_currentVC.navigationController pushViewController:vc animated:YES];

    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"err": @(0),@"msg":@""} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *) openLoginWin: (NSString *) msg {
    if ([_currentVC isKindOfClass:[SYWebViewController class]]) {
        SYWebViewController *sourceVC = (SYWebViewController *)_currentVC;
        [sourceVC checkLogin];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"err": @(0),@"msg":@""} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *) openUserWin: (NSDictionary *) dict {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"err": @(0),@"msg":@""} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *token = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:token]) {
        [self openLoginWin:nil];
        return jsonString;
    }
    
    NSString *uidString = dict[@"uid"];
    NSInteger uid = [uidString integerValue];
    if (uid > 0) {
        if ([_currentVC isKindOfClass:[SYWebViewController class]]) {
            SYWebViewController *sourceVC = (SYWebViewController *)_currentVC;
            [sourceVC openUserPageWithUid:[NSString stringWithFormat:@"%@", @(uid)]];
        }
    }
    return jsonString;
}

- (NSString *) getCoinAsync: (NSString *) param : (JSCallback)completionHandler {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"err": @(0),@"msg":@"success"} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString *token = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:token]) {
        [self openLoginWin:nil];
        return jsonString;
    }
    
    if ([_currentVC isKindOfClass:[SYWebViewController class]]) {
        SYWebViewController *sourceVC = (SYWebViewController *)_currentVC;
        [sourceVC receiveBeansWithBlock:^(BOOL success, NSInteger errorCode) {
            if (completionHandler) {
                if (success) {
                    completionHandler(jsonString,YES);
                } else {
                    NSInteger err = (errorCode == 4022 || errorCode == 4023) ? 2 : 1;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"err": @(err),@"msg":@"failed"} options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *jsonString;
                    if (jsonData) {
                        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    }
                    completionHandler(jsonString,YES);
                }
            }
        }];
    }
    
    return jsonString;
}

- (NSString *) openWebView: (NSDictionary *) msg
{
    BOOL isSucess = YES;
    NSString *resultMsg = @"";
    if (![NSObject sy_empty:msg] && [msg isKindOfClass:[NSDictionary class]]) {
        NSString *urlString = [msg objectForKey:@"url"];
        NSString *title = [msg objectForKey:@"title"];
        if (![NSString sy_isBlankString:urlString]) {
            SYWebViewController *vc = [[SYWebViewController alloc]initWithURL:urlString andTitle:title andRoomId:@"10001"];
            [_currentVC.navigationController pushViewController:vc animated:YES];
        }
    }else{
        isSucess = NO;
        resultMsg = @"msg为空或者class类型不匹配";
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"err": isSucess?@(0):@(1),@"msg":resultMsg} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSDictionary *) openRoom: (NSDictionary *) msg : (JSCallback)completionHandler
{
    if (![NSObject sy_empty:msg] && [msg isKindOfClass:[NSDictionary class]]) {
        NSString *roomId = [msg objectForKey:@"roomId"];
        if (![NSString sy_isBlankString:roomId]) {
            [[SYVoiceChatRoomManager sharedManager]tryToEnterVoiceChatRoomWithRoomId:roomId];
        }
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"err":@(0),@"msg":@"success"} options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString;
    if (jsonData) {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    if (completionHandler) {
        completionHandler(jsonString, YES);
    }
    return msg;
}


- ( void )callProgress:(NSDictionary *) args :(JSCallback)completionHandler
{
    value=10;
    hanlder=completionHandler;
    timer =  [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(onTimer:)
                                            userInfo:nil
                                             repeats:YES];
}

-(void)onTimer:t{
    if(value!=-1){
        hanlder([NSNumber numberWithInt:value--],NO);
    }else{
        hanlder(0,YES);
        [timer invalidate];
    }
}

/**
 * Note: This method is for Fly.js
 * In browser, Ajax requests are sent by browser, but Fly can
 * redirect requests to native, more about Fly see  https://github.com/wendux/fly
 * @param requestInfo passed by fly.js, more detail reference https://wendux.github.io/dist/#/doc/flyio-en/native
 */
-(void)onAjaxRequest:(NSDictionary *) requestInfo  :(JSCallback)completionHandler{
    
}
@end
