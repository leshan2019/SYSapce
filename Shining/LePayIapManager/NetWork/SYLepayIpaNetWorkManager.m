//
//  SYWalletNetWorkManager.m
//  Shining
//
//  Created by letv_lzb on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLepayIpaNetWorkManager.h"

@interface SYLepayIpaNetWorkManager ()

@property (nonatomic, strong) NSString *baseURL;

@end

@implementation SYLepayIpaNetWorkManager


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

/**
 lepay支付下单接口

 @param packageID 支付套餐id apple
 @param success success block
 @param failure failure block
 */
- (void)sendRechargeOrder:(NSString *)packageID
                   roomId:(NSString *)roomId
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure
{

    NSString *url = [self.baseURL stringByAppendingString:@"recharge/order"];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"accesstoken":[SYSettingManager accessToken],
                                                                                 @"pay_mode":@(4),
                                                                                 @"third_pay_mode":@(3),
                                                                                 @"recharge_package_id":packageID}];
    if (roomId) {
        [param setObject:roomId forKey:@"room_id"];
    } else {
        [param setObject:@"0" forKey:@"room_id"];
    }
    [self commonGETRequestWithURL:url parameters:param success:^(NSDictionary *data) {
        if (data) {
            if (success) {
                success(data);
            }
        }else{
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

