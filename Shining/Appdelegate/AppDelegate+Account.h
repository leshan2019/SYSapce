//
//  AppDelegate+Account.h
//  Shining
//
//  Created by 杨玄 on 2019/3/27.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Account)

- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
               otherConfig:(NSDictionary *)otherConfig;

- (void)checkLetvClientLogin;

@end

NS_ASSUME_NONNULL_END
