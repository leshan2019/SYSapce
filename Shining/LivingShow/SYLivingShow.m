//
//  SYLivingShow.m
//  Shining
//
//  Created by Zhang Qigang on 2019/9/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//
/*
#import <TuSDK/TuSDK.h>
#import <PLMediaStreamingKit/PLMediaStreamingKit.h>
#import "SYLivingShow.h"

@implementation SYLivingShow
+ (instancetype) shared {
    static SYLivingShow* _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (void) initStreaming {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef UseSettingTestDevEnv
        [TuSDK setLogLevel: lsqLogLevelDEBUG];
#else 
        [TuSDK setLogLevel: lsqLogLevelERROR];
#endif
        NSDictionary* bundleKeyMap = @{
            @"com.letv.bee.iphone.client": @"d074d3d9d10e9c51-00-3pohs1",
            @"com.shanyin.iphone.enterprise.client": @"2908866b9c3294a9-00-3pohs1",
            @"com.letv.iphone.client": @"59c513a34b48b9f8-00-3pohs1",
            @"com.letv.iphone.enterprise.client": @"fbb6d6f7b166e1b1-00-3pohs1",
        };
        NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSString* key = bundleKeyMap[bundleId];
        if (key.length) {
            [TuSDK initSdkWithAppKey: key devType: bundleId];
        } else {
            NSLog(@"无法初始化图图 SDK!!!");
        }

        [PLStreamingEnv initEnv];

#ifdef UseSettingTestDevEnv
        [PLStreamingEnv setLogLevel:PLStreamLogLevelDebug];
#else
        [PLStreamingEnv setLogLevel:PLStreamLogLevelError];
#endif
    });
}
@end
*/
