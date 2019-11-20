//
//  WXApiManager.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/3.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol WXApiManagerDelegate <NSObject>

@optional
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;
- (void)managerDidRecvSendMessageToWXResponse:(SendMessageToWXResp *)response;

@end

@interface WXApiManager : NSObject<WXApiDelegate>
@property (nonatomic, assign) id<WXApiManagerDelegate> delegate;

+ (instancetype)sharedManager;
@end

