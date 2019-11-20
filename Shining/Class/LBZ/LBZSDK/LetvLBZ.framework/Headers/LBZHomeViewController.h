//
//  LBZHomeViewController.h
//  LetvLBZ
//
//  Created by yangjinyang on 2018/3/9.
//  Copyright © 2018年 yangjinyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


typedef enum
{
    LBZWechatTimeline, ///微信朋友圈
    LBZWechatSession,  ///微信 好友
    LBZSinaWeibo,      ///微博
    
}LBZShareType;

typedef enum
{
    LBZPayFail,      ///失败
    LBZPaySuccess,   ///成功
    
}LBZPayType;


//分享block事件
typedef void (^ShareResponseCallback)(LBZShareType shareType,BOOL isShareContent);
typedef void (^ShareHandler)(id data, ShareResponseCallback responseCallback);

//支付block事件
typedef void (^PayResponseCallback)(NSString *orderId,NSString *LBZOrderId,LBZPayType payType);
typedef void (^PayHandler)(id data, PayResponseCallback responseCallback);

//重新授权block事件
typedef void (^ReauthorizationResponseCallback)(NSString *accessToken);
typedef void (^ReauthorizationHandler)(id data, ReauthorizationResponseCallback responseCallback);


@interface LBZHomeViewController : UIViewController
//乐视视频UID
@property (nonatomic, strong) NSString *letv_uid;
//
@property (nonatomic, strong) NSString *webViewUrl;
@property (nonatomic, strong) WKWebView *webView;

-(void)reloadWebView:(NSString*)url;
/**
 *初始化
 *@param accessToken  用户登录的时候生成的accessToken
 *@return instancetype
 */
- (instancetype)initWithLbzHomeAccessToken:(NSString *)accessToken;

/**
 直接传ticket进入乐必中
 @param ticket 外部获取的ticket
 @return instancetype
 */
- (instancetype)initWithLbzHomeTicket:(NSString *)ticket;
/**
 *分享功能
 *@param handler 返回的block
 */
- (void)registerShareHandler:(ShareHandler)handler;

/**
 *支付功能
 *@param uid 第三方的用户id
 *@param handler 返回的block
 */
- (void)registerPayUid:(NSString *)uid
               Handler:(PayHandler)handler;
/**
 *闪音支付功能
 *@param ticket 第三方的用户ticket
 *@param handler 返回的block
 */
- (void)registerShanInPayTicket:(NSString *)ticket
                        Handler:(PayHandler)handler;
/**
 *重新授权 accessToken
 *@param handler 返回的block
 */
- (void)registerReauthorizationHandler:(ReauthorizationHandler)handler;


/**
 *  退出HOME
 */
- (void)goToBack;

@end
