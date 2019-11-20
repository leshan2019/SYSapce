//
//  SYGiftNetManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGiftNetManager.h"

@interface SYGiftNetManager ()

@property (nonatomic, strong) NSString *baseURL;

@end

@implementation SYGiftNetManager

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

- (void)requestAllGiftListWithSuccess:(SuccessBlock)success
                              failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"gift/list"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token, @"all": @"1"}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftListModel *list = [SYGiftListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestGiftListWithSuccess:(SuccessBlock)success
                           failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"gift/list"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftListModel *list = [SYGiftListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestPropListWithCategory_id:(NSInteger)categoryId
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure{
    
    NSString *url = [self.baseURL stringByAppendingFormat:@"prop/list"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token,@"category_id":@(categoryId)}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYPropListModel *list = [SYPropListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestGiftBagListWithSuccess:(SuccessBlock)success
                              failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"giftbag/list"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftListModel *list = [SYGiftListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestMyPropListWithCategory_id:(NSInteger)categoryId
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"prop"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token,@"category_id":@(categoryId)}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYPropListModel *list = [SYPropListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestPurchasePropWithPropId:(NSInteger)propId
                                price:(NSInteger)price
                             duration:(NSInteger)duration
                            rcvuserid:(NSString *)userId
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"prop/buy"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    NSDictionary *parameters = @{@"accesstoken": token, @"propid":@(propId), @"price": @(price), @"duration": @(duration)};
    if (userId.length > 0) {
        parameters = @{@"accesstoken": token, @"propid":@(propId), @"price": @(price), @"duration": @(duration), @"rcvuserid": userId};
    }
    [self commonGETRequestWithURL:url
                       parameters:parameters
                          success:^(id  _Nullable response) {
                              if (success) {
                                  success(response);
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestSendGiftWithGiftID:(NSInteger)giftID
                           userID:(NSString *)userID
                        channelID:(NSString *)channelID
                           number:(NSInteger)number
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"gift/send"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token, @"userid": [NSString sy_safeString:userID], @"giftid": @(giftID), @"roomid": [NSString sy_safeString:channelID], @"giftnum": @(number)}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftModel *model = [SYGiftModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(model);
                                  }
                              } else {
                                  if (success) {
                                      success(response);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestMultiSendGiftWithGiftID:(NSInteger)giftID
                                 users:(NSString *)users
                             channelID:(NSString *)channelID
                                number:(NSInteger)number
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"gift/multisend"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token, @"users": [NSString sy_safeString:users], @"giftid": @(giftID), @"roomid": [NSString sy_safeString:channelID], @"giftnum": @(number)}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  NSArray *list = response[@"list"];
                                  NSArray *giftArray = [NSArray yy_modelArrayWithClass:[SYGiftModel class]
                                                                                  json:list];
                                  if (success) {
                                      success(giftArray);
                                  }
                              } else {
                                  if (success) {
                                      success(response);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestSendBagGiftWithGiftID:(NSInteger)giftID
                              userID:(NSString *)userID
                           channelID:(NSString *)channelID
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"giftbag/send"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token, @"userid": [NSString sy_safeString:userID], @"giftid": @(giftID), @"roomid": [NSString sy_safeString:channelID]}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftModel *model = [SYGiftModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(model);
                                  }
                              } else {
                                  if (success) {
                                      success(response);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestMultiSendBagGiftWithGiftID:(NSInteger)giftID
                                    users:(NSString *)users
                                channelID:(NSString *)channelID
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"giftbag/multisend"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token, @"users": [NSString sy_safeString:users], @"giftid": @(giftID), @"roomid": [NSString sy_safeString:channelID]}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  NSArray *list = response[@"list"];
                                  NSArray *giftArray = [NSArray yy_modelArrayWithClass:[SYGiftModel class]
                                                                                  json:list];
                                  if (success) {
                                      success(giftArray);
                                  }
                              } else {
                                  if (success) {
                                      success(response);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestWalletWithSuccess:(SuccessBlock)success
                         failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"wallet"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYWalletModel *wallet = [SYWalletModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(wallet);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestIncomeListWithChannelID:(NSString *)channelID
                                 range:(SYGiftTimeRange)range
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    if ([NSString sy_isBlankString:channelID]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSString *url = [self.baseURL stringByAppendingFormat:@"room/%@/topstreamer/income/%@", channelID, [self rangeStringWithRange:range]];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftUserListModel *list = [SYGiftUserListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  success(error);
                              }
                          }];
}

- (void)requestOutcomeListWithChannelID:(NSString *)channelID
                                  range:(SYGiftTimeRange)range
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    if ([NSString sy_isBlankString:channelID]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSString *url = [self.baseURL stringByAppendingFormat:@"room/%@/topuser/outcome/%@", channelID, [self rangeStringWithRange:range]];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftUserListModel *list = [SYGiftUserListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  success(error);
                              }
                          }];
}

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
                  NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                       code:[code integerValue]
                                                   userInfo:nil];
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

- (NSString *)rangeStringWithRange:(SYGiftTimeRange)range {
    NSString *rangeString = @"";
    switch (range) {
        case SYGiftTimeRangeDaily:
        {
            rangeString = @"daily";
        }
            break;
        case SYGiftTimeRangeWeekly:
        {
            rangeString = @"weekly";
        }
            break;
        case SYGiftTimeRangeTotal:
        {
            rangeString = @"total";
        }
            break;
        default:
            break;
    }
    return rangeString;
}

- (void)requestDanmuListWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"danmu/list"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYDanmuListModel *list = [SYDanmuListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestDanmuSendWithUserId:(NSString *)userId danmuId:(NSInteger)danmuId roomId:(NSString *)roomId word:(NSString *)word success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"danmu/send"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token,
                                    @"userid": [NSString sy_safeString:userId],
                                    @"danmuid": @(danmuId),
                                    @"roomid": [NSString sy_safeString:roomId],
                                    @"word": [NSString sy_safeString:word]
                                    }
                          success:^(id  _Nullable response) {
                              if (success) {
                                  success(response);
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestGetCoinWithSuccess:(SuccessBlock)success
                          failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"spcevent/getcoin"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if (success) {
                                  success(response);
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}


// 采蜜
- (void)requestBeeWithRoomId:(NSString *)roomId
                    smashnum:(NSInteger)num
                    bucketid:(NSInteger)bucketid
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure{
    NSString *url = [self.baseURL stringByAppendingFormat:@"game/honey/collect/%@",@(num)];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token,
                                    @"roomid": [NSString sy_safeString:roomId],
                                    @"bucketid":@(bucketid)
                                    }
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftListModel *list = [SYGiftListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

// 采蜜 礼物列表
- (void)requestBeeWithRoomId:(NSString *)roomId
                     pagenum:(NSInteger)num
                    pagesize:(NSInteger)size
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure{
    NSString *url = [self.baseURL stringByAppendingFormat:@"game/honey/list"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token,
                                    @"roomid": [NSString sy_safeString:roomId],
                                    @"pagenum": @(num),
                                    @"pagesize": @(size)
                                    }
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftListModel *list = [SYGiftListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}


- (void)requestLoginGiftListWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"loginevent/gift/list"];
    [self commonGETRequestWithURL:url
                       parameters:@{}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftListModel *list = [SYGiftListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list.list);
                                  }
                              } else {
                                  if (failure) {
                                      failure(nil);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestLoginGiftGetWithSuccess:(SuccessBlock)success {
    NSString *url = [self.baseURL stringByAppendingFormat:@"loginevent/gift/get"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if (success) {
                                  success(@(1));    // code = 0, 首次领取成功了，弹窗提示领取成功
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (success) {
                                  success(@(0));    // code = 4022, 已经领取过，不在提示弹窗
                              }
                          }];
}

- (void)requestBroadcasterFansContributionListWithid:(NSString *)userId range:(SYGiftTimeRange)range pageNum:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure {
    if ([NSString sy_isBlankString:userId]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    if (page < 0) {
        page = 1;
    }
    NSString *url = [self.baseURL stringByAppendingFormat:@"streamer/%@/topfans/%@", userId, [self rangeStringWithRange:range]];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"pagenum": @(page),@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYGiftUserListModel *list = [SYGiftUserListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(list);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestDayTaskListWithSuccess:(SuccessBlock)success
                              failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingFormat:@"dailytask/list"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  if (success) {
                                      success(response);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestDayTaskRewardWithTaskId:(NSString *)taskid
                                finish:(void(^)(BOOL))finishBlock
{
    NSString *url = [self.baseURL stringByAppendingFormat:@"dailytask/reward"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self GET:url
   parameters:@{@"accesstoken": token,
                @"task_id": [NSString sy_safeString:taskid],
                @"pcode" :SHANYIN_PCODE,
                @"version":SHANYIN_VERSION
                }
      success:^(id  _Nullable response) {
          if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
              NSNumber *code = response[@"code"];
              if ([code integerValue] == 0) {
                  if (finishBlock) {
                      finishBlock(YES);
                  }
              }else{
                  if (finishBlock) {
                      finishBlock(NO);
                  }
              }
          }else{
              if (finishBlock) {
                  finishBlock(NO);
              }
          }
      } failure:^(NSError * _Nullable error) {
          if (finishBlock) {
              finishBlock(NO);
          }
      }];
}

- (void)dailyTaskLog:(NSInteger)task_type
{
    NSString *url = [self.baseURL stringByAppendingFormat:@"dailytask/log"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self GET:url
   parameters:@{@"accesstoken": token,
                @"task_type": @(task_type),
                @"pcode" :SHANYIN_PCODE,
                @"version":SHANYIN_VERSION
                }
      success:^(id  _Nullable response) {
         
      } failure:^(NSError * _Nullable error) {
          
      }];
}

- (void)dailyTaskLog:(NSInteger)task_type
          withGiftId:(NSInteger)giftId
         withGiftNum:(NSInteger)giftNum
{
    NSString *url = [self.baseURL stringByAppendingFormat:@"dailytask/log"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self GET:url
   parameters:@{@"accesstoken": token,
                @"task_type": @(task_type),
                @"giftid":@(giftId),
                @"giftnum":@(giftNum),
                @"pcode" :SHANYIN_PCODE,
                @"version":SHANYIN_VERSION
                }
      success:^(id  _Nullable response) {
          
      } failure:^(NSError * _Nullable error) {
          
      }];
}

- (void)requestMyIncomeWithSuccess:(SuccessBlock)success
                           failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingFormat:@"wallet/shine/incomesum"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    [self commonGETRequestWithURL:url
                       parameters:@{@"accesstoken": token}
                          success:^(id  _Nullable response) {
                              if (success) {
                                  success(response);
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(nil); 
                              }
                          }];
}
@end
