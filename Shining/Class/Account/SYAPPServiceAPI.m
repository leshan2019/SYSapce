//
//  SYAPPServiceAPI.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYAPPServiceAPI.h"
#import "SYSearchModel.h"

static SYAPPServiceAPI *app_sharedInstance = nil;

@interface SYAPPServiceAPI()
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) SYNetCommonManager *networkManager;
@end

@implementation SYAPPServiceAPI
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        app_sharedInstance = [[self alloc] init];
    });
    return app_sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef UseSettingTestDevEnv
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"http://test.api.svoice.le.com/app/";
        }else {
            _baseURL = @"http://api.svoice.le.com/app/";
        }
#else
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"http://test.api.svoice.le.com/app/";
        }else {
            _baseURL = @"https://api-svoice.le.com/app/";
        }
#endif
        _networkManager = [[SYNetCommonManager alloc]init];
    }
    return self;
}

- (void)requestSystemMsgList:(void(^)(NSArray * _Nullable))success
                     failure:(FailureBlock)failure
{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"message/list"];
    [self.networkManager GET:url
                  parameters:@{
                               @"accesstoken": accessToken,
                               @"pcode":SHANYIN_PCODE,
                               @"version":SHANYIN_VERSION
                               }
                     success:^(NSDictionary *data){
                         if (data) {
                             NSString *code = [data objectForKey:@"code"];
                             if ([code integerValue] == 0) {
                                 NSDictionary *dataDict = [data objectForKey:@"data"];
                                 NSArray *list = [dataDict objectForKey:@"list"];
                                 if (success) {
                                     success(list);
                                 }
                             }else{
                                 if (failure) {
                                     failure(nil);
                                 };
                             }
                         }
                     }
                     failure:failure];
}


- (void)requestValidateImage:(NSData *)imageData success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"imgcheck"];
    NSString *accessToken = [SYSettingManager accessToken];
    [self.networkManager POST:url
                   parameters:@{
                                @"pcode":SHANYIN_PCODE,
                                @"version":SHANYIN_VERSION
                                }
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageData.length > 0) {
            [formData appendPartWithFileData:imageData
                                        name:@"img_file"
                                    fileName:@"image.png"
                                    mimeType:@"image/jpeg"];
        }
    }
                      success:^(id response) {
                          if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
                              NSNumber *code = response[@"code"];
                              NSDictionary *result = [response objectForKey:@"data"];
                              if ([code integerValue] == 0) {
                                  if (success) {
                                      success(result);
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
                      }
                      failure:^(NSError * _Nullable error) {
                          if (failure) {
                              failure(nil);
                          }
                      }];
}

- (void)requestSystemConfigWithSuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"config"];
    [self.networkManager GET:url
                  parameters:@{
                               @"pcode":SHANYIN_PCODE,
                               @"version":SHANYIN_VERSION,
                               @"did":[NSString sy_safeString:[SYSettingManager smAntiDeviceId]]
                               }
                     success:^(NSDictionary *data){
                         if (data) {
                             NSString *code = [data objectForKey:@"code"];
                             if ([code integerValue] == 0) {
                                 NSDictionary *dict = data[@"data"];
                                 if ([dict isKindOfClass:[NSDictionary class]]) {
                                     if (success) {
                                         success(dict[@"list"]);
                                     }
                                 } else {
                                     if (failure) {
                                         failure(nil);
                                     };
                                 }
                             }else{
                                 if (failure) {
                                     failure(nil);
                                 };
                             }
                         }
                     }
                     failure:failure];
}

- (void)requestSearchUserWithKeyword:(NSString *)keyword success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    if ([NSString sy_isBlankString:keyword]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"search/SearchUserinfo"];
    [self.networkManager GET:url
                  parameters:@{
                               @"keywords":keyword,
                               @"accesstoken": accessToken,
                               @"pcode":SHANYIN_PCODE,
                               @"version":SHANYIN_VERSION
                               }
                     success:^(NSDictionary *data){
                         if (data) {
                             SYSearchModel *model = [SYSearchModel yy_modelWithDictionary:data];
                             if (model.code == 0) {
                                 if (success) {
                                     success(model.data);
                                 }
                             } else {
                                 if (failure) {
                                     failure(nil);
                                 };
                             }
                         }
                     }
                     failure:failure];
}

- (void)requestSoundMatch:(void(^)(NSArray * _Nullable))success
                  failure:(FailureBlock)failure
{
    NSString *accessToken = [SYSettingManager accessToken];
//    accessToken = @"7b1706ca8a27c13a0dae757777d1f19b8d963d3d5b4629fd99a4cb13c05b8ae5b70f1b3bec1c19af876f1bfb15b2a63f1ad8f8ac9b3838536e8b653906634471fddf023b5a4bee0c4dbb994b71806b1d";
    if ([NSString sy_isBlankString:accessToken]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"soundtone/match"];
    [self.networkManager GET:url
                  parameters:@{
                               @"accesstoken": accessToken,
                               @"pcode":SHANYIN_PCODE,
                               @"version":SHANYIN_VERSION
                               }
                     success:^(NSDictionary *data){
                         if (data) {
                             NSString *code = [data objectForKey:@"code"];
                             if ([code integerValue] == 0) {
                                 NSDictionary *dataDict = [data objectForKey:@"data"];
                                 NSArray *list = [dataDict objectForKey:@"list"];
                                 if (success) {
                                     success(list);
                                 }
                             }else{
                                 NSString *errMsg = [data objectForKey:@"message"];
                                 NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:[code integerValue] userInfo:@{NSLocalizedDescriptionKey:[NSString sy_isBlankString:errMsg]?@"系统开了点小差儿，请稍后再试哦～":errMsg}];
                                 if (failure) {
                                     failure(err);
                                 };
                             }
                         }
                     }
                     failure:failure];

}
/////////////
//声鉴题词版
-(void)requestVoiceCardWordsListWithSuccess:(SuccessBlock)success
                                    failure:(FailureBlock)failure{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"soundtone/word"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *listDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                
                if (success) {
                    success(listDic);
                }
            }else{
                if (failure) {
                    failure(nil);
                };
            }
        } else {
            if (failure) {
                failure(nil);
            };
        }
    }
                     failure:failure];
}
//提交声鉴
-(void)uploadVoiceCardWithWordId:(NSString*)wordid
                         Success:(SuccessBlock)success
                         failure:(FailureBlock)failure{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"soundtone"];
    NSString *urll = [url stringByAppendingFormat:@"?accesstoken=%@&pcode=%@&version=%@&wordid=%@",accessToken, SHANYIN_PCODE, SHANYIN_VERSION,wordid];
    [self.networkManager POST:urll
                   parameters:@{
//                       @"accesstoken": accessToken,
//                       @"pcode":SHANYIN_PCODE,
//                       @"version":SHANYIN_VERSION,
//                       @"wordid":@(wordid.integerValue)
                   }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *listDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(listDic);
                }
            }else{
                if (failure) {
                    failure(nil);
                };
            }
        } else {
            if (failure) {
                failure(nil);
            };
        }
    }
                     failure:failure];
    
}
//查询声鉴结果
-(void)requestVoiceCardResultWithSuccess:(SuccessBlock)success
                                 failure:(FailureBlock)failure{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"soundtone"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *listDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(listDic);
                }
            }else{
                if (failure) {
                    failure(nil);
                };
            }
        } else {
            if (failure) {
                failure(nil);
            };
        }
    }
                     failure:failure];
}
//声鉴个人名片（增加userid可查询他人）
-(void)requestVoiceCardWithUserId:(NSString*)userid
                          Success:(SuccessBlock)success
                          failure:(FailureBlock)failure{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"soundtone/user"];
    NSDictionary* params = @{
        @"accesstoken": accessToken,
        @"pcode":SHANYIN_PCODE,
        @"version":SHANYIN_VERSION
    };
    if (![NSString sy_isBlankString:userid]) {
        params = @{
            @"accesstoken": accessToken,
            @"pcode":SHANYIN_PCODE,
            @"version":SHANYIN_VERSION,
            @"userid":userid
        };
    }
    [self.networkManager GET:url
                  parameters:params
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *listDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(listDic);
                }
            }else{
                if (failure) {
                    failure(nil);
                };
            }
        } else {
            if (failure) {
                failure(nil);
            };
        }
    }
                     failure:failure];
}

//保存个人声鉴题词版
-(void)saveVoiceCardWithWithWordId:(NSString*)wordid Success:(SuccessBlock)success
                           failure:(FailureBlock)failure{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"soundtone/word"];
    NSDictionary* params = @{
        @"accesstoken": accessToken,
        @"pcode":SHANYIN_PCODE,
        @"version":SHANYIN_VERSION,
        @"wordid":wordid
    };
    
    [self.networkManager GET:url
                  parameters:params
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *listDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(listDic);
                }
            }else{
                if (failure) {
                    failure(nil);
                };
            }
        } else {
            if (failure) {
                failure(nil);
            };
        }
    }
                     failure:failure];
}
//用户匹配
-(void)requestVoiceCardOtherUserWithSuccess:(SuccessBlock)success
                                    failure:(FailureBlock)failure{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"soundtone/match"];
    NSDictionary* params = @{
        @"accesstoken": accessToken,
        @"pcode":SHANYIN_PCODE,
        @"version":SHANYIN_VERSION
    };
    
    [self.networkManager GET:url
                  parameters:params
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *listDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(listDic);
                }
            }else{
                if (failure) {
                    failure(nil);
                };
            }
        } else {
            if (failure) {
                failure(nil);
            };
        }
    }
                     failure:failure];
}



- (void)requestLaunchAdConfigWithSuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"startup"];
    [self.networkManager GET:url
                  parameters:@{
                               @"pcode":SHANYIN_PCODE,
                               @"version":SHANYIN_VERSION,
                               @"platform":@"02"
                               }
                     success:^(NSDictionary *data){
                         if (data) {
                             NSString *code = [data objectForKey:@"code"];
                             if ([code integerValue] == 0) {
                                 NSDictionary *dict = data[@"data"];
                                 if ([dict isKindOfClass:[NSDictionary class]]) {
                                     if (success) {
                                         success(dict);
                                     }
                                 } else {
                                     if (failure) {
                                         failure(nil);
                                     };
                                 }
                             }else{
                                 if (failure) {
                                     failure(nil);
                                 };
                             }
                         }
                     }
                     failure:failure];
}

@end
