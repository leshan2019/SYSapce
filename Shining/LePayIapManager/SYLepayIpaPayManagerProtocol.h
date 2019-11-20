//
//  LetvH5PayManagerProtocol.h
//  Shining
//
//  Created by letv_lzb on 2019/3/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

/**
 *  H5支付结果Code
 */
typedef NS_ENUM(NSUInteger, SY_PayResultType) {
    SY_PayResult_Success = 200,                 //支付成功
    SY_PayResult_Failed_Auth = 300,             //支付失败 - 鉴权 - 获取SKProduct失败
    SY_PayResult_Failed_NoOrderId = 400,        //支付失败 - 下单失败
    SY_PayResult_Failed_Cancel = 500,           //支付失败 - 用户取消
    SY_PayResult_Failed_other = 600,            //支付失败 - 其他原因
};

typedef void(^SYIapBuyBlock)(SY_PayResultType code, NSDictionary* resultDic);

@protocol SYLepayIpaPayManagerProtocol

/**
 *  Tag:是否正在支付
 */
@property (nonatomic, assign) BOOL isPaying;

/**
 *  购买H5收银台套餐
 *  params:
 1.orderInfo:购买套餐信息
 2.finishBlock:购买结果回调
 */
- (void)buyVipProduct:(NSMutableDictionary *)orderInfo andFinishBlock:(SYIapBuyBlock)resultBlock;

@end
