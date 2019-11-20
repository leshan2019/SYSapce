//
//  SYWalletNetWorkManager.h
//  Shining
//
//  Created by letv_lzb on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYNetCommonManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLepayIpaNetWorkManager : SYNetCommonManager


/**
 lepay支付下单接口

 @param packageID 支付套餐id apple
 @param success success block
 @param failure failure block
 */
- (void)sendRechargeOrder:(NSString *)packageID roomId:(NSString *)roomId
                  success:(SuccessBlock)success failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
