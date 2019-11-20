//
//  SYConfigManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/6/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYConfigManager : NSObject

// 请求开机接口
+ (void)requestConfig;

//开机广告图
+ (void)requestLaunchAdData:(void (^)(BOOL success, id response))complete;

@end

NS_ASSUME_NONNULL_END
