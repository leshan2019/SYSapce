//
//  SYWalletNetWorkManager.h
//  Shining
//
//  Created by letv_lzb on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYNetCommonManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYWalletNetWorkManager : SYNetCommonManager

- (void)requestWallet:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 我的钱包list

 @param success success block
 @param failure failure block
 */
- (void)requestWalletList:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 蜜糖收入list

 @param page 当前页
 @param num 每页的条数
 @param success success block
 @param failure failure block
 */
- (void)requestShineIncomeList:(NSInteger)page pageNum:(NSInteger)num success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 蜜糖消费list

 @param page 当前页
 @param num 每页的条数
 @param success success block
 @param failure failure block
 */
- (void)requestShineConsumeList:(NSInteger)page pageNum:(NSInteger)num success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 金币消耗list

 @param page 当前页
 @param num 每页的条数
 @param success success block
 @param failure failure block
 */
- (void)requestCoinConsumeList:(NSInteger)page pageNum:(NSInteger)num success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 金币收入list

 @param page 当前页
 @param num 每页的条数
 @param success success block
 @param failure failure block
 */
- (void)requestCoinIncomeList:(NSInteger)page pageNum:(NSInteger)num success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 乐缤果 充值套餐list

 @param success success block
 @param failure failure block
 */
- (void)requestLebzCoinPackageList:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 lepay充值套餐list

 @param success success block
 @param failure failure block
 */
- (void)requestLepayCoinPackageList:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 红包转账功能

 @param success success block
 @param failure failure block
 */
- (void)requestRedPackageTransferToUser:(NSString *)userid amount:(NSString *)acount  success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  聊天室内发送群红包api
 */
- (void)requestSendGroupRedPacketWithRoomid:(NSString *)roomId
                                     amount:(NSString *)amount
                                       nums:(NSString *)nums
                                    success:(SuccessBlock)success
                                    failure:(FailureBlock)failure;

/**
 *  聊天室内群红包列表api
 */
- (void)requestRoomGroupRedPacketListWithRoomid:(NSString *)roomId
                                        success:(SuccessBlock)success
                                        failure:(FailureBlock)failure;

/**
 *  聊天室内抢红包api
 */
- (void)requestGetGroupRedPacketResult:(NSString *)roomId
                           redPacketId:(NSString *)redPacketId
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;


@end

NS_ASSUME_NONNULL_END
