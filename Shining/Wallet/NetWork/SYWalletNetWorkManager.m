//
//  SYWalletNetWorkManager.m
//  Shining
//
//  Created by letv_lzb on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYWalletNetWorkManager.h"
#import "SYWalletListModel.h"
#import "SYMyWalletModel.h"
//#import <YYModel/YYModel.h>
#import "SYSettingManager.h"
#import "SYShineDetailIncomeListModel.h"
#import "SYCoinDetailListModel.h"
#import "SYCoinPackageListModel.h"

@interface SYWalletNetWorkManager ()

@property (nonatomic, strong) NSString *baseURL;

@end

@implementation SYWalletNetWorkManager


- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef UseSettingTestDevEnv
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"http://test.api.svoice.le.com/sales/";
        }else {
            _baseURL = @"http://api.svoice.le.com/sales/";
        }
#else
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"http://test.api.svoice.le.com/sales/";
        }else {
            _baseURL = @"https://api-svoice.le.com/sales/";
        }
#endif
    }
    return self;
}

- (void)requestWallet:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"wallet"];
    [self commonGETRequestWithURL:url parameters:@{@"accesstoken":[SYSettingManager accessToken]} success:^(NSDictionary *data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSNumber *coin = data[@"coin_amount"];
            if (success) {
                success(coin);
            }
        }else{
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}

/**
 金币消耗list

 @param page 当前页
 @param num 每页的条数
 @param success success block
 @param failure failure block
 */
- (void)requestCoinConsumeList:(NSInteger)page pageNum:(NSInteger)num success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingString:@"wallet/coin/outcome"];
    [self commonGETRequestWithURL:url parameters:@{@"accesstoken":[SYSettingManager accessToken],@"pagenum":@(page),@"pagesize":@(num)} success:^(NSDictionary *data) {
        if (data) {
            SYCoinDetailListModel* listModel = [SYCoinDetailListModel yy_modelWithDictionary:data];
            if (success) {
                success(listModel);
            }
        }else{
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}


/**
 金币收入list

 @param page 当前页
 @param num 每页的条数
 @param success success block
 @param failure failure block
 */
- (void)requestCoinIncomeList:(NSInteger)page pageNum:(NSInteger)num success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingString:@"wallet/coin/income"];
    [self commonGETRequestWithURL:url parameters:@{@"accesstoken":[SYSettingManager accessToken],@"pagenum":@(page),@"pagesize":@(num)} success:^(NSDictionary *data) {
        if (data) {
            SYCoinDetailListModel* listModel = [SYCoinDetailListModel yy_modelWithDictionary:data];
            if (success) {
                success(listModel);
            }
        }else{
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}


/**
 蜜糖收入list

 @param page 当前页
 @param num 每页的条数
 @param success success block
 @param failure failure block
 */
- (void)requestShineIncomeList:(NSInteger)page pageNum:(NSInteger)num success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingString:@"wallet/shine/income"];
    [self commonGETRequestWithURL:url parameters:@{@"accesstoken":[SYSettingManager accessToken],@"pagenum":@(page),@"pagesize":@(num)} success:^(NSDictionary *data) {
        if (data) {
            SYShineDetailIncomeListModel* listModel = [SYShineDetailIncomeListModel yy_modelWithDictionary:data];
            if (success) {
                success(listModel);
            }
        }else{
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}




/**
 蜜糖消费list

 @param page 当前页
 @param num 每页的条数
 @param success success block
 @param failure failure block
 */
- (void)requestShineConsumeList:(NSInteger)page pageNum:(NSInteger)num success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingString:@"wallet/shine/outcome"];
    [self commonGETRequestWithURL:url parameters:@{@"accesstoken":[SYSettingManager accessToken],@"pagenum":@(page),@"pagesize":@(num)} success:^(NSDictionary *data) {
        if (data) {
            SYShineDetailIncomeListModel* listModel = [SYShineDetailIncomeListModel yy_modelWithDictionary:data];
            if (success) {
                success(listModel);
            }
        }else{
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}


/**
 我的钱包list

 @param success success block
 @param failure failure block
 */
- (void)requestWalletList:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingString:@"wallet"];
    [self commonGETRequestWithURL:url parameters:@{@"accesstoken":[SYSettingManager accessToken]} success:^(NSDictionary *data) {
        if (data) {
            SYMyWalletModel *model = [SYMyWalletModel new];
            model.number = [NSString stringWithFormat:@"%@",[data objectForKey:@"coin_amount"]];
            model.type = 1;
            model.descrip = @"用于在聊天室中购买礼物～";

            SYMyWalletModel *model2 = [SYMyWalletModel new];
            model2.number = [NSString stringWithFormat:@"%@",[data objectForKey:@"shine_amount"]];
            model2.type = 2;
            model2.descrip = @"查看收到的礼物明细哦～";

            SYWalletListModel *listModel = [SYWalletListModel new];
            listModel.data = [NSArray arrayWithObjects:model,model2, nil];
            if (success) {
                success(listModel);
            }
        }else{
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}



/**
 乐缤果 充值套餐list

 @param success success block
 @param failure failure block
 */
- (void)requestLebzCoinPackageList:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingString:@"recharge/list/lebz"];
    [self commonGETRequestWithURL:url parameters:@{@"accesstoken":[SYSettingManager accessToken]} success:^(NSDictionary *data) {
        if (data) {
            SYCoinPackageListModel *listModel = [SYCoinPackageListModel yy_modelWithDictionary:data];
            if (success) {
                success(listModel);
            }
        }else{
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}

/**
 lepay充值套餐list

 @param success success block
 @param failure failure block
 */
- (void)requestLepayCoinPackageList:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingString:@"recharge/list/lepay"];
    [self commonGETRequestWithURL:url parameters:@{@"accesstoken":[SYSettingManager accessToken]} success:^(NSDictionary *data) {
        if (data) {
            SYCoinPackageListModel *listModel = [SYCoinPackageListModel yy_modelWithDictionary:data];
            if (success) {
                success(listModel);
            }
        }else{
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}



- (void)requestRedPackageTransferToUser:(NSString *)userid amount:(NSString *)acount  success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"/wallet/coin/redbag"];
    [self GET:url parameters:@{@"accesstoken":[SYSettingManager accessToken],@"userid":[NSString sy_safeString:userid],@"amount":[NSString sy_safeString:acount],@"pcode":SHANYIN_PCODE,@"version":SHANYIN_VERSION}
      success:^(id  _Nullable response) {
          if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
            if (success) {
                success(response);
            }
          } else {
              if (failure) {
                  failure(nil);
              }
          }
      } failure:failure];
}

- (void)requestSendGroupRedPacketWithRoomid:(NSString *)roomId amount:(NSString *)amount nums:(NSString *)nums success:(SuccessBlock)success failure:(FailureBlock)failure {
    if ([NSString sy_isBlankString:roomId]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSString *domainStr = [NSString stringWithFormat:@"room/%@/redbag/create",roomId];
    NSString *url = [self.baseURL stringByAppendingString:domainStr];
    NSDictionary *parameter = @{@"accesstoken":[SYSettingManager accessToken],
                                @"amount":[NSString sy_safeString:amount],
                                @"nums":[NSString sy_safeString:nums],
                                @"pcode":SHANYIN_PCODE,
                                @"version":SHANYIN_VERSION
                                };
    [self GET:url parameters:parameter success:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
            if (success) {
                success(response);
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}

- (void)requestRoomGroupRedPacketListWithRoomid:(NSString *)roomId success:(SuccessBlock)success failure:(FailureBlock)failure {
    if ([NSString sy_isBlankString:roomId]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSString *domainStr = [NSString stringWithFormat:@"room/%@/redbag/list",roomId];
    NSString *url = [self.baseURL stringByAppendingString:domainStr];
    NSDictionary *parameter = @{@"accesstoken":[SYSettingManager accessToken],
                                @"pcode":SHANYIN_PCODE,
                                @"version":SHANYIN_VERSION
                                };
    [self GET:url parameters:parameter success:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
            NSDictionary *dic = (NSDictionary *)response;
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            NSDictionary *data = [dic objectForKey:@"data"];
            if (code == 0) {
                if (success) {
                    success(data);
                }
            } else {
                if (failure) {
                    failure(nil);
                }
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}

- (void)requestGetGroupRedPacketResult:(NSString *)roomId redPacketId:(NSString *)redPacketId success:(SuccessBlock)success failure:(FailureBlock)failure {
    if ([NSString sy_isBlankString:roomId] || [NSString sy_isBlankString:redPacketId]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSString *domainStr = [NSString stringWithFormat:@"room/%@/redbag/get",roomId];
    NSString *url = [self.baseURL stringByAppendingString:domainStr];
    NSDictionary *parameter = @{@"accesstoken":[SYSettingManager accessToken],
                                @"redbagid":redPacketId,
                                @"pcode":SHANYIN_PCODE,
                                @"version":SHANYIN_VERSION
                                };
    [self GET:url parameters:parameter success:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
            NSDictionary *dic = (NSDictionary *)response;
            NSInteger code = [[dic objectForKey:@"code"] integerValue];
            NSDictionary *data = [dic objectForKey:@"data"];
            if (code == 0) {
                if (success) {
                    success(data);
                }
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"" code:code userInfo:nil];
                if (failure) {
                    failure(error);
                }
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:failure];
}


#pragma common method

- (void)commonGETRequestWithURL:(NSString *)url
                     parameters:(NSDictionary *)parameters
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:SHANYIN_PCODE forKey:@"pcode"];
    [dict setObject:SHANYIN_VERSION forKey:@"version"];
    [self GET:url parameters:dict
      success:^(id  _Nullable response) {
          if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
              NSNumber *code = response[@"code"];
              if ([code integerValue] == 0) {
                  NSDictionary *data = response[@"data"];
                  if (success) {
                      success(data?:response);
                  }
              } else {
                  if (failure) {
                      failure(nil);
                  }
              }
          } else {
              if (failure) {
                  failure(nil);
              }
          }
      } failure:failure];
}

- (void)commonPOSTRequestWithURL:(NSString *)url
                      parameters:(NSDictionary *)parameters
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure {
    [self POST:url parameters:parameters
       success:^(id  _Nullable response) {
           if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
               NSNumber *code = response[@"code"];
               if ([code integerValue] == 0) {
                   NSDictionary *data = response[@"data"];
                   if (success) {
                       success(data?:response);
                   }
               } else {
                   if (failure) {
                       failure(nil);
                   }
               }
           } else {
               if (failure) {
                   failure(nil);
               }
           }
       } failure:failure];
}

- (void)commonPOSTRequestWithURL:(NSString *)url
                      parameters:(NSDictionary *)parameters
       constructingBodyWithBlock:(void(^)(id <AFMultipartFormData>))block
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure {
    [self POST:url
    parameters:parameters
constructingBodyWithBlock:block
       success:^(id  _Nullable response) {
           if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
               NSNumber *code = response[@"code"];
               if ([code integerValue] == 0) {
                   NSDictionary *data = response[@"data"];
                   if (success) {
                       success(data?:response);
                   }
               } else {
                   if (failure) {
                       failure(nil);
                   }
               }
           } else {
               if (failure) {
                   failure(nil);
               }
           }
       } failure:^(NSError * _Nullable error) {
           if (failure) {
               failure(nil);
           }
       }];
}





@end

