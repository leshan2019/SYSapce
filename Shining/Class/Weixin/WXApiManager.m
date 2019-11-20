//
//  WXApiManager.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/3.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "WXApiManager.h"

@implementation WXApiManager

+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(managerDidRecvSendMessageToWXResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp*)resp;
            [self.delegate managerDidRecvSendMessageToWXResponse:messageResp];
        }
    }
}

- (void)onReq:(BaseReq *)req{
    
}
@end
