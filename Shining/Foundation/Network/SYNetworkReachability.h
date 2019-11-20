//
//  SYNetworkReachability.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/27.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nonnull const SYNetworkingReachabilityDidChangeNotification;

NS_ASSUME_NONNULL_BEGIN

@interface SYNetworkReachability : NSObject

+ (void)startMonitoring;

+ (BOOL)isNetworkReachable;

+ (BOOL)isNetworkWifiReachable;

+ (BOOL)isNetworkWWANReachable;

@end

NS_ASSUME_NONNULL_END
