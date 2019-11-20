//
//  SYLepayIpaPayManager.h
//  shining
//
//  Created by lzb_letv on 2019/03/27.
//  Copyright © 2018年 LeEco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYLepayIpaPayManagerProtocol.h"
#import "SYCoinPackageModel.h"


#define APP_IAP_SHARESECRET @"86ac67af9737467cb4529e4cb473823e"

/**
 *  支付收银台购买会员套餐 - （IAP支付）
 *  流程：传参->客户端验证->客户端下单->客户端IAP支付->客户端反馈支付结果反馈
 */
@interface SYLepayIpaPayManager : NSObject<SYLepayIpaPayManagerProtocol>

/**
 *  Tag:是否正在支付
 */
@property (nonatomic, assign) BOOL isPaying;


/**
 初始化方法

 @param ParentVC ParentVC
 @return return self
 */
- (instancetype)initWithToastParentVC:(UIViewController *)ParentVC;

/**
 *  购买收银台套餐
 *  params:
        1.orderInfo:购买套餐信息
        2.finishBlock:购买结果回调
 */
- (void)buyVipProduct:(NSMutableDictionary *)orderInfo andFinishBlock:(SYIapBuyBlock)resultBlock;



@end

