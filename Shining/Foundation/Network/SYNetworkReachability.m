//
//  SYNetworkReachability.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/27.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYNetworkReachability.h"

NSString * const SYNetworkingReachabilityDidChangeNotification = @"com.shanyin.iphone.reachability.change";

@implementation SYNetworkReachability

+ (instancetype)sharedInstance {
    static SYNetworkReachability *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SYNetworkReachability new];
    });
    return instance;
}

+ (void)startMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance]
                                             selector:@selector(changed:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
}

+ (BOOL)isNetworkReachable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isNetworkWifiReachable {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (BOOL)isNetworkWWANReachable {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

- (void)changed:(id)sender {
    NSNotification *noti = (NSNotification *)sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:SYNetworkingReachabilityDidChangeNotification
                                                        object:noti.object];
}

@end
