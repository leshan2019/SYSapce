//
//  LepaySDK.h
//  LepaySDK
//
//  Created by zhangwenhan on 15/12/21.
//  Copyright © 2015年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LPSLepayIapProductModel.h"

@class SKPaymentQueue;
@class SKPayment;
@class SKProduct;

typedef NS_ENUM(NSInteger, LepayPlatformType) {
    LepayPlatformType_Unknown,
    LepayPlatformType_Online,                     //线上
    LepayPlatformType_Test                       //测试环境
};

typedef NS_ENUM(NSInteger , LepayResultStatus){
    LepayResultDefault = 0,
    LepayResultSuccess = 1,                 //支付成功
    LepayResultFail = 2,                    //支付失败
    LepayResultProcess = 3,                 //支付结果确认中
    LepayResultCancel = 4,                  //支付取消
    LepayResultGestureRecognizerCancel = 5, //手势滑动POP取消支付
    LepayResultIsPaid = 6                   //订单已支付
};

typedef void(^ LepayCompletionBlock)(LepayResultStatus result, NSString *message);

typedef NS_ENUM(NSInteger , LepayLanguageType){
    LepayLanguageTraditionalChinese = 0,//繁体中文
    LepayLanguageEngilish = 1, //英语
    LepayLanguageSimplifiedChinese = 2//简体中文
};

typedef NS_ENUM(NSInteger , LepayLocaleType){
    LepayLocaleDefault = 0,//大陆
    LepayLocaleAmerica = 1,//美国
    LepayLocaleHongKong = 2,//香港
    LepayLocaleIndia = 3,    //印度
};

//! 定义整个购买过程状态
typedef NS_ENUM(NSInteger, LePayIapProcessStatus) {
    Lepay_Iap_ProcessStatus_Idle = 0,
    Lepay_Iap_ProcessStatus_ProductListProcessing = 1,
    Lepay_Iap_ProcessStatus_SKProductListProcessing = 2,
    Lepay_Iap_ProcessStatus_PaymentOrderProcessing = 4,
    Lepay_Iap_ProcessStatus_AppPurchaseProcessing = 8,
    Lepay_Iap_ProcessStatus_PaymentVerifyProcessing =16,
    Lepay_Iap_ProcessStatus_ProductPreListProcessing = 32,           //前置接口
    Lepay_Iap_ProcessStatus_SKProductProcessing = 64            //点播时的请求
};

//!定义iap中返回的block
typedef void(^resultBlock)(BOOL success, LePayIapProcessStatus status, NSDictionary *dic);

#define LepayLocaleGet @[@"unknow",@"us",@"hk",@"india"]

#define LepayLocaleStringGet(type) ([LepayLocaleGet objectAtIndex:type])

static NSString * const kLepaySDKForeignPay = @"kLepaySDKForeignPay";

//! iap回调委托
@protocol LPSLepayIAPManagerDelegate <NSObject>

@optional

- (void)lePayIapProcessResult:(BOOL)bSucc Status:(LePayIapProcessStatus)status MsgInfo:(NSDictionary*)msgDic;
- (void)lePayIapProcessStatus:(LePayIapProcessStatus)status;


@end

// iap promoting in appstore 回调
@protocol LPSLepayIAPPromotingDelegate <NSObject>
@optional
- (BOOL)lePayIapPromotingStart:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product;
@end


@class SKProduct;

@interface LepaySDK : NSObject


/*
 *  @brief  SDK当前版本
 */
+ (NSString*)lepaySDKVersion;


/**
 *  //是否需要SDK展示支付成功弹出框
 *
 *  @param show YES-展示 NO-不展示 默认为YES
 */
+ (void)showPaySuccess:(BOOL)show;

/**
 *  设置sdk导航栏标题颜色
 *
 *  @param color deafult blackColor
 */
+ (void)setNavigationTitleColor:(UIColor *)color;

/**
 *  是否需要sdk自己pop,默认为YES，如果设置成NO，除手势pop返回LepayResultGestureRecognizerCancel，所有情况sdk都不会POP
 *
 *  @param need deafult is YES
 */
+ (void)needSDKpop:(BOOL)need;


/**
 *  是否需要sdk展示订单详情，默认是YES
 *
 *  @param need deafult is YES
 */
+ (void)needSDKShowOrderInfo:(BOOL)need;

/**
 *  修改支付中心首页标题（默认为支付中心）
 *
 *  @param title
 */
+ (void)changePaymentCenterTitle:(NSString *)title;


/**
 *  国内支付接口
 *
 *  @param viewController  viewController
 *  @param tradeInfoDic    支付订单信息（详情见文档）
 *  @param schemeStr       1、国内支付传 微信AppId wx****** 2、国外支付传 kLepaySDKForeignPay
 *  @param showPaySuccess  支持成功后是否在SDK内展示弹出框
 *  @param completionBlock 支付结果回调
 */
+ (void)createPayViewController:(UIViewController *)viewController
                    LeTradeInfo:(NSDictionary *)tradeInfoDic
                     fromScheme:(NSString *)schemeStr
                       callback:(LepayCompletionBlock)completionBlock;

+ (BOOL)handleOpenURL:(NSURL *)url;



#pragma mark - iap
/************  以下为iap内购流程  ************/
/*
 *  @brief  iap功能当前版本
 */
+ (NSString*)iapVersion;

#pragma mark - 老接口（泛影视类）

/*
 * @brief  根据业务线、本地化参数和代理获取产品list
 * @param  业务线
 * @param  本地化类型
 * @param  回调delegate
 * @return void类型 （数据返回后异步代理回调）
 */
+ (void)requestProductListModelWithBusinessLine:(NSString*)bizLine
                                      LocalType:(LepayLocaleType)localType
                                       Delegate:(id<LPSLepayIAPManagerDelegate>)delegate;

/*
 *  @brief  获取前置产品list（注：1、有此业务才调用；2、调用前提必须先调全量接口，否则抛异常；3、全量和前置接口的数据都异步返回，业务方需去同步）
 *  @return void
 */
+ (void)requestProductPreList;

/*
 * @brief   通过各条业务线的消费中心返回的订单信息向支付中心请求支付订单并向app store发起购买
 *  @param  paraDic
    参数名                     是否必须            说明                  提供方
    version                     Y               版本号                 业务方（虽有默认值，但建议从业务方server取，不要写死）
    service                     Y               服务标识                业务方
    merchant_business_id        Y               业务线id               业务方
    user_id                     Y               用户id                 业务方
    user_name                   N               用户名                 业务方
    notify_url                  Y               接收交易成功通知的url    业务方
    call_back_url               N               支付成功跳转url         业务方
    merchant_no                 Y               商户订单号              业务方
    out_trade_no                Y               商户订单流水号           业务方
    price                       Y               交易金额                业务方
    currency                    Y               币种                   业务方
    pay_expire                  N               交易自动关闭时间(分)     业务方（默认1天，从server那边取）
    product_id                  Y               商品id                 业务方
    product_name                Y               商品名称                业务方
    product_desc                Y               商品描述                业务方
    product_urls                N               商品图片地址             业务方
    timestamp                   Y               时间戳                  业务方
    key_index                   Y               秘钥索引                业务方（默认1，从业务方server取）
    input_charset               Y               字符编码                业务方（默认UTF-8，从业务方server取）
    app_id                      N               appid                 N/A
    ip                          Y               客户端ip               业务方
    sign                        Y               签名                  业务方（业务方server返回的sign）
    sign_type                   Y               签名方式               业务方(对签名进行md5)
 */
+ (void)buyProduct:(NSDictionary *)productOrderDic;


//! 在delegate通知成功后，在这获取productListModel数据
+ (LPSLepayIapProductListModel*)getLPSLepayIapProductListModel;

//! 在回调后，获取productPreListModel数据（前置接口数据需要  收到全量和前置接口都完成的代理才能去取）
+ (LPSLepayIapProductListPreModel*)getLPSLepayIapProductPreListModel;

/*
 *  @brief  开放给外部调用（前提还得先调  会员类型的“获取产品list的接口” 或者 点播的“配置秘钥接口”）
 */
+ (void)handleInterruptionTransactionIfExist;

#pragma mark - 老接口 -- 点播/直播 （泛影视类）
/*
 *  @brief  配置点播的基本信息  -- 视频单片点播 added 2016.7.7 （视频直播同点播处理一致 -- 2016.9.1）
 *  @param  共享秘钥    NSString类型
 *  @param  本地化类型
 *  @param  回调delegate
 */
+ (void)configShareSecrect:(NSString*)shareSecrect
                 LocalType:(LepayLocaleType)localType
                  Delegate:(id<LPSLepayIAPManagerDelegate>)delegate;

/*
 *  @brief  获取指定的skProduct（单片/直播） -- 视频单片点播 added 2016.7.7  （视频直播同点播处理一致 -- 2016.9.1）
 *  @param  产品id NSString类型
 */
+ (void)requestSKProductWithProductIdSet:(NSArray*)array;

/*
 *  @brief  直接购买单片 -- 视频单片点播 added 2016.7.7  （视频直播同点播处理一致 -- 2016.9.1）
 *  @param  NSDictionary类型，业务方传递的订单信息
 *  @param  产品对象，SKProduct类型
 */
+ (void)buyProduct:(NSDictionary *)productOrderDic withSKProduct:(SKProduct*)skProduct;

/*
 *  @brief  在delegate得到通知后，在这里获取skProduct对象
 */
+ (NSArray*)getSKProducts;



#pragma mark - v2接口（除泛影视其他）


+ (void)requestProductListV2withMemberId:(NSString*)memberId
                             CountryCode:(NSString*)countryCode
                                Delegate:(id<LPSLepayIAPManagerDelegate>)delegate;

/*
 *  @brief  v2新增设置代理和共享秘钥的接口（以支持业务方独立获取到productlist后，直接调用buyProduct:接口）
 *  @param  shareSecrect    apple的共享秘钥，用于后续支付验证使用
 *  @param  countryCode     地区码
 *  @param  delegate    回调代理
 */
+ (void)configV2ShareSecrect:(NSString*)shareSecrect CountryCode:(NSString*)countryCode Delegate:(id<LPSLepayIAPManagerDelegate>)delegate;


/*
 *  @brief  通过消费中心返回的订单信息和SKProduct向支付中心请求支付订单（v2接口中用于直接购买）
 *  @param  NSDictionary类型，业务方传递的订单信息（订阅新增字段isquick）
 *  @param  SKProduct   app store返回的产品对象
 */
+ (void)buyProductV2:(NSDictionary *)productOrderDic withSKProduct:(SKProduct*)skProduct;


/*
 *  @brief  海外支付，通过消费中心返回的订单信息和SKProduct向支付中心请求支付订单（v2接口中用于直接购买）
 *  @param  token 海外支付服务器下单返回的token
 *  @param  lepayOrderNo 海外支付服务器下单返回的lepayOrderNo
 *  @param  SKProduct   app store返回的产品对象
 */

+ (void)buyProductV2WithToken:(NSString *)token lepayOrderNo:(NSString *)lepayOrderNo SKProduct:(SKProduct*)skProduct;


/*
 *  @beief  v2接口获取返回的数据（同样在delegate通知成功后去获取）
 *  @return id类型（v2接口返回json，v1返回的是mode对象）
 */
+ (id)getLepayIapProductListV2;

/*
 *  @brief  v2接口获取产品的价格及本地化信息（从app store返回）
 *  @return NSDictionary 字典类型 @{@"com.letv.iphone.client.hk.svip.3month":@{@"price":@"100",@"pricelocale":priceLocale}}
 */
+ (NSDictionary*)getLepayIapSKLiteProductDicV2;


/*
 *  @brief  提供给业务方主动调用的处理中断的方法
 *  @return void
 */
+ (void)handleInterruptionTransactionIfExistV2;

/*
 *  @brief  处理订阅自动续费（暂时只支持国内）
 *
 *  @subscriptionDic
     请求参数:
     参数名                  含义          是否必传   备注
     merchant_business_id   业务线          是
     timestamp              时间戳          是	  long类型，当前时间的毫秒数
     service                服务标识戳       是     lepay.app.api.show.cashier
     sign                   签名            是
 *
 *  @return void
 */
+ (void)handleSubscriptionTransaction:(NSDictionary *)subscriptionDic;

/* 业务方需要自己设置是测试环境还是线上环境 */
+(void)registerPlatform:(LepayPlatformType)platform;


+ (void)setIAPPromotingInAppStoreDelegate:(id<LPSLepayIAPPromotingDelegate>)delegate;

@end
