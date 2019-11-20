//
//  ShiningSdkManager.h
//  ShiningSdk
//
//  Created by letv_lzb on 2019/4/10.
//  Copyright © 2019 leshan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYSigleCase.h"
#ifdef ShiningSdk
#import <LetvMobileInterfaces/LetvMobileInterfaces.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@protocol ShiningSdkManager <NSObject>

/**
 调起乐视视频登录界面

 @param options 可选参数
 */
- (void)didLoginWithLetv:(NSDictionary *)options;

- (void)didLoginWithLetv:(NSDictionary *)options callBack:(void(^)(BOOL))finishBlock;

- (void)didLogOutWithLetv:(NSDictionary *)options callBack:(void(^)(BOOL))finishBlock;

@end

#ifdef ShiningSdk
@interface ShiningSdkManager : NSObject<ShiningSdkProtocol>
#else
@interface ShiningSdkManager : NSObject
#endif
SYSingleCaseH(ShiningSdkManager)


@property (nonatomic, weak)id<ShiningSdkManager> delegate;

/*
 * 闪音聊天室首页（乐视视频定制）

 @return vc
 */
+ (UIViewController *)getHomeListVC;


/// 获取bee语音独立app
+ (UIViewController *)getBeeMainVC;


/**
 同步用户登录信息

 @param ssotk ssotk
 @param mobile 手机号
 @param url 头像
 @param name 用户名
 */
+ (void)setLoginSuccess:(NSString *)ssotk mobile:(NSString *)mobile avatarUrl:(NSString *)url username:(NSString *)name;


/**
 同步乐视视频 设备id

 @param did 乐视视频 设备id
 */
+ (void)setLetvDid:(NSString *)did;


/**
 同步letv退出登陆
 */
+ (void)setLetvLoginOut;


/**
 乐视视频是否已经登陆(手机号登陆)

 @return 是否登陆
 */
+ (BOOL)isLetvLogin;


/**
 获取乐视 ssotk

 @return ssotk
 */
+ (NSString *)le_ssotk;

/**
 获取乐视 手机号

 @return 手机号
 */
+ (NSString *)le_mobile;



/**
 获取乐视 用户头像

 @return 头像url
 */
+ (NSString *)le_avatarUrl;



/**
 获取乐视 用户名

 @return 用户名
 */
+ (NSString *)le_username;

/**
 获取乐视 设备id

 @return 设备id
 */
+ (NSString *)le_did;

/**
 乐视视频sdk 检测登陆状态

 @param showLoginVC login载体VC
 */
+ (void)checkLetvAutoLogin:(UIViewController *)showLoginVC;

+ (void)checkLetvAutoLogin:(UIViewController *)showLoginVC
               finishBlock:(void(^ _Nullable )(BOOL))finishBlock;


/**
 聊天室首页登录转态检测（是否需要弹完善信息）

 @param showVC vc载体
 */
+ (void)voiceHomeAutoLogin:(UIViewController *)showVC;


/**
 乐视视频静默登录(自动触发)
 */
+ (void)letvAutoLogin;


/**
 乐视视频是否已经登陆(非手机号登陆)

 @return 是否登陆
 */
+ (BOOL)isLetvLoginWithMail;


/**
 清除乐视账户信息
 */
+ (void)clearLetvAccountInfo;


/**
 设置闪音登陆信息 到groups

 @param ssotk ssotk
 */
- (void)setBeeAppCroupInfo:(NSString *)ssotk;

/**
 清除groups 闪音登陆信息
 */
- (void)clearBeeAppGroupInfo;

- (void)exitShiningAppMainView:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
