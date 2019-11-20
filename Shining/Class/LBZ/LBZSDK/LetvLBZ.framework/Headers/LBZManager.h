//
//  LBZManager.h
//  LetvLBZ
//
//  Created by yangjinyang on 2018/3/14.
//  Copyright © 2018年 yangjinyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void (^LBZPushSucceed)(NSString * result);

@interface LBZManager : NSObject
@property (nonatomic, strong) WKWebView *LBZWebView;

+ (instancetype)sharedLBZManager;

/*
- (void)pushHomeViewController:(id)viewController
                     withToken:(NSString *)token
              completionHandle:(LBZPushSucceed)succeed;
*/
/**
 *配置当前版本是测试环境OR正式环境
 */
- (void)configurationVersions:(BOOL)isFormal andUrl:(NSString*)urlStr;
/**
 *第三方退出登录的时候需要调用loginOut
 */
- (void)loginOut;

@end
