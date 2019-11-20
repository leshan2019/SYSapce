//
//  AppDelegate+Push.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/21.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Push)<UNUserNotificationCenterDelegate>

- (void)registerPushNotification:(NSDictionary *)dic;
/**
 获取关注列表中的主播正在主播的列表 并触发本地通知
 */
- (void)checkFollowListLocalNotification;
@end

NS_ASSUME_NONNULL_END
