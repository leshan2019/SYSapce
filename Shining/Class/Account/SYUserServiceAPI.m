//
//  SYUserServiceAPI.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/10.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYUserServiceAPI.h"
#import "UserProfileManager.h"
#import "SYVipPrivilegeModel.h"
#import "SYVipLevelModel.h"

static SYUserServiceAPI *sharedInstance = nil;

@interface SYUserServiceAPI()
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) SYNetCommonManager *networkManager;
@end

@implementation SYUserServiceAPI

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef UseSettingTestDevEnv
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"http://test.api.svoice.le.com/ucenter/";
        }else {
            _baseURL = @"http://api.svoice.le.com/ucenter/";
        }
#else
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"http://test.api.svoice.le.com/ucenter/";
        }else {
            _baseURL = @"https://api-svoice.le.com/ucenter/";
        }
#endif
        _networkManager = [[SYNetCommonManager alloc]init];
    }
    return self;
}

- (void)requestLoginSignup:(NSString *)mobile
                     vcode:(NSString *)vcode
                 tempToken:(NSString *)token
                    vendor:(NSInteger)vendor
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure {
    NSString *aesEncrptPhoneNum = [mobile sy_aci_encryptWithAES];
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"signup"];
    [_networkManager GET:url parameters:@{@"mobile":aesEncrptPhoneNum,
                                          @"vcode":vcode,
                                          @"accesstoken":token,
                                          @"vendor":@(vendor),
                                          @"pcode":SHANYIN_PCODE,
                                          @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                NSDictionary *dict = [data objectForKey:@"data"];
                NSString *token = [dict objectForKey:@"accesstoken"];
                [SYSettingManager setAccessToken:token];
                NSLog(@"token: %@",token);
                if (success) {
                    success(dict);
                }
            }else{
                NSString *errMsg = [data objectForKey:@"message"];
                NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:[code integerValue] userInfo:@{NSLocalizedDescriptionKey:[NSString sy_isBlankString:errMsg]?@"系统开了点小差儿，请稍后再试哦～":errMsg}];
                if (failure) {
                    failure(err);
                };
            }
            
        }
    } failure:failure];
}
//请求验证码
- (void)requestVcode:(NSString *)phoneNum
{
    NSString *aesEncrptPhoneNum = [phoneNum sy_aci_encryptWithAES];
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"sendsms"];
    [_networkManager GET:url parameters:@{@"mobile":[NSString sy_safeString:aesEncrptPhoneNum],
                                          @"pcode":SHANYIN_PCODE,
                                          @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        
    } failure:nil];
}

//验证accessToken接口
- (void)vertifyAccessToken:(NSString *)token
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"validate"];
    [_networkManager GET:url parameters:@{
        @"accesstoken":token,
        @"pcode":SHANYIN_PCODE,
        @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            
        }
    } failure:failure];
}




//乐视静默登录
- (void)requestLetvLoginSignup:(NSString *)ssotk
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"letvsso"];
    [_networkManager GET:url parameters:@{
        @"ssotk":ssotk,
        @"pcode":SHANYIN_PCODE,
        @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                NSDictionary *dict = [data objectForKey:@"data"];
                NSString *token = [dict objectForKey:@"accesstoken"];
                [SYSettingManager setAccessToken:token];
                NSString *em_password = [dict objectForKey:@"em_password"];
                NSString *em_username = [dict objectForKey:@"em_username"];
                [[UserProfileManager sharedInstance]login:em_username Password:em_password VC:nil];
                if (success) {
                    success(data);
                }
            }else{
                if (failure) {
                    failure(nil);
                };
            }
            
        }
    } failure:failure];
}

//第三方登录接口
- (void)requestThirdLoginSignup:(NSString *)ssotk
                       platForm:(ThridPlatFormType)platForm
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"oauth/implicit/%d",platForm]];
    [_networkManager GET:url parameters:@{@"acstk":ssotk,
                                          @"pcode":SHANYIN_PCODE,
                                          @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        NSString *code = [data objectForKey:@"code"];
        if ([code integerValue] == 0) {
            NSDictionary *dict = [data objectForKey:@"data"];
            NSNumber *need_mobile = [dict objectForKey:@"need_mobile"];
            NSNumber *need_info = [dict objectForKey:@"need_info"];
            NSString *token = [dict objectForKey:@"accesstoken"];
            if (![need_mobile boolValue]) {//已经绑定了手机号
                [SYSettingManager setAccessToken:token];
                NSString *em_password = [dict objectForKey:@"em_password"];
                NSString *em_username = [dict objectForKey:@"em_username"];
                [[UserProfileManager sharedInstance]login:em_username Password:em_password VC:nil];
                [[UserProfileManager sharedInstance] setTempAccessToken:@""];
            }else {//没有绑定手机号
                [[UserProfileManager sharedInstance] setTempAccessToken:token];
            }
            [[UserProfileManager sharedInstance] setNeedInfo:[need_info boolValue]];
            [[UserProfileManager sharedInstance] setNeedMobile:[need_mobile boolValue]];
        }
        if (success) {
            success(data);
        }
    } failure:failure];
}

- (void)requestOAuthWXLogin:(NSString *)code
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure
{
    NSString *url = [self.baseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"oauth/authcode/1"]];
    [_networkManager GET:url parameters:@{@"code":code,
                                          @"pcode":SHANYIN_PCODE,
                                          @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        
        if (success) {
            success(data);
        }
    } failure:failure];
}

- (void)vertifyAcessToken:(void(^)(BOOL))finishBlock
{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        if (finishBlock) {
            finishBlock(NO);
        }
        return;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"validate"];
    
    [_networkManager GET:url parameters:@{@"accesstoken":accessToken,
                                          @"pcode":SHANYIN_PCODE,
                                          @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                NSDictionary *dict = [data objectForKey:@"data"];
                BOOL isNormal = NO;
                if (![NSObject sy_empty:dict]) {
                    NSNumber * status = data[@"status"];
                    isNormal = ![status boolValue];
                }
                if(finishBlock){
                    finishBlock(isNormal);
                }
            }else{
                if(finishBlock){
                    finishBlock(NO);
                }
            }
            
        }
    } failure:^(NSError *error){
        if(finishBlock){
            finishBlock(NO);
        }
    }];
}

- (void)requestVerifyIDCardsResult:(SuccessBlock)success {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"usercert"];
    [_networkManager GET:url parameters:@{@"accesstoken":accessToken,
                                          @"pcode":SHANYIN_PCODE,
                                          @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        NSNumber *codeNum = [data objectForKey:@"code"];
        if ([codeNum integerValue] == 0) {
            success([data objectForKey:@"data"]);
        } else {
            success(nil);
        }
    } failure:^(NSError *error){
        success(nil);
    }];
}

- (void)requestModifyUserAuthModelToAdolescentModel:(SuccessBlock)success {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    NSString *url = [self.baseURL stringByAppendingFormat:@"userinfo/auth?accesstoken=%@&pcode=%@&version=%@",accessToken, SHANYIN_PCODE, SHANYIN_VERSION];
    [_networkManager POST:url parameters:@{} success:^(id  _Nullable response) {
        NSDictionary *responseDic = (NSDictionary *)response;
        NSNumber *codeNum = [responseDic objectForKey:@"code"];
        if ([codeNum integerValue] == 0) {
            success([responseDic objectForKey:@"data"]);
        } else {
            success(nil);
        }
    } failure:^(NSError * _Nullable error) {
        success(nil);
    }];
}

- (void)requestIDCardAuthenTicationIdCardNum:(NSString *)idcard name:(NSString *)name faceScore:(NSString *)score success:(SuccessBlock)success {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"usercertV2"];
    [_networkManager GET:url parameters:@{@"accesstoken":accessToken,
                                          @"cardName":[NSString sy_safeString:name],
                                          @"cardId":[NSString sy_safeString:idcard],
                                          @"score":[NSString sy_safeString:score],
                                          @"pcode":SHANYIN_PCODE,
                                          @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        NSNumber *codeNum = [data objectForKey:@"code"];
        if ([codeNum integerValue] == 0) {
            success([data objectForKey:@"data"]);
        } else {
            success(nil);
        }
    } failure:^(NSError *error){
        success(nil);
    }];
}

- (void)requestUserInfoWithSuccess:(void (^)(BOOL success))success {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        if (success) {
            success(NO);
        }
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"userinfo/verify"];
    
    [_networkManager GET:url parameters:@{@"accesstoken":accessToken,
                                          @"pcode":SHANYIN_PCODE,
                                          @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                NSDictionary *dict = [data objectForKey:@"data"];
                if (![NSObject sy_empty:dict]) {
                    [UserProfileEntity saveUserProfileEntity:dict];
                }
                UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
                if (userInfo.status_flag == 1 ) {
                    // 用户处于封禁状态，直接强制退出
                    [SYToastView showToast:@"您已被封禁，将要被强制退出"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[UserProfileManager sharedInstance] logOut];
                    });
                }
                success(YES);
            } else {
                if ([code integerValue] == 2021){
                    //性别资料未补全，打回登录页
                    [SYToastView showToast:@"未完善信息"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                }
                success(NO);
            }
        } else {
            success(NO);
        }
    } failure:^(NSError *error){
        success(NO);
    }];
}

- (void)updateUserInfoWithOriginAvatarUrl:(NSString *)avatarUrl withChangedAvatarImageFile:(NSData *)avatarFile withUserName:(NSString *)username withGender:(NSString *)gender withSignature:(NSString *)signature withBirthday:(NSString *)birthday withDistrictiD:(NSString *)districtId success:(nonnull void (^)(NSInteger))success {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    NSString *url = [self.baseURL stringByAppendingFormat:@"userinfo?accesstoken=%@&pcode=%@&version=%@",accessToken, SHANYIN_PCODE, SHANYIN_VERSION];
    NSDictionary *tempParaDic = @{
        @"username":[NSString sy_safeString:username],
        @"gender":[NSString sy_safeString:gender],
        @"signature":[NSString sy_safeString:signature],
        @"birthday":[NSString sy_safeString:birthday],
        @"residence_place":[NSString sy_safeString:districtId]
    };
    NSMutableDictionary *paradic = [NSMutableDictionary dictionaryWithDictionary:tempParaDic];
    if (![NSString sy_isBlankString:avatarUrl]) {
        [paradic setObject:[NSString sy_safeString:avatarUrl] forKey:@"avatar_imgurl"];
    }
    [self.networkManager POST:url
                   parameters:paradic
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (avatarFile.length > 0) {
            [formData appendPartWithFileData:avatarFile
                                        name:@"avatar_imgurl_file"
                                    fileName:@"avatar.jpg"
                                    mimeType:@"image/jpeg"];
        }
    }
                      success:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
            NSNumber *code = response[@"code"];
            if (success) {
                success([code integerValue]);
            }
        } else {
            if (success) {
                success(400);
            }
        }
    }
                      failure:^(NSError * _Nullable error) {
        if (success) {
            success(400);
        }
    }];
}


- (void)requestUpdateUserExtraInfoWithPhotoUrl1:(NSString *)photoUrl1 photoData1:(NSData *)photoData1 photoUrl2:(NSString *)photoUrl2 photoData2:(NSData *)photoData2 photoUrl3:(NSString *)photoUrl3 photoData3:(NSData *)photoData3 voiceUrl:(NSString *)voiceUrl voiceData:(NSData *)voiceData voiceDuration:(NSInteger)voiceDuration success:(void (^)(BOOL))success {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    NSString *url = [self.baseURL stringByAppendingFormat:@"userinfo/ext?accesstoken=%@&pcode=%@&version=%@",accessToken, SHANYIN_PCODE, SHANYIN_VERSION];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if (![NSString sy_isBlankString:photoUrl1]) {
        [paraDic setValue:photoUrl1 forKey:@"photo_imgurl1"];
    }
    if (![NSString sy_isBlankString:photoUrl2]) {
        [paraDic setValue:photoUrl2 forKey:@"photo_imgurl2"];
    }
    if (![NSString sy_isBlankString:photoUrl3]) {
        [paraDic setValue:photoUrl3 forKey:@"photo_imgurl3"];
    }
    if (![NSString sy_isBlankString:voiceUrl]) {
        [paraDic setValue:voiceUrl forKey:@"voice_url"];
    }
    [paraDic setValue:@(voiceDuration) forKey:@"voice_duration"];
    [self.networkManager POST:url
                   parameters:paraDic
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (photoData1.length > 0) {
            [formData appendPartWithFileData:photoData1
                                        name:@"photo_imgurl1_file"
                                    fileName:@"photo1.jpg"
                                    mimeType:@"image/jpeg"];
        }
        if (photoData2.length > 0) {
            [formData appendPartWithFileData:photoData2
                                        name:@"photo_imgurl2_file"
                                    fileName:@"photo2.jpg"
                                    mimeType:@"image/jpeg"];
        }
        if (photoData3.length > 0) {
            [formData appendPartWithFileData:photoData3
                                        name:@"photo_imgurl3_file"
                                    fileName:@"photo3.jpg"
                                    mimeType:@"image/jpeg"];
        }
        if (voiceData.length > 0) {
            [formData appendPartWithFileData:voiceData
                                        name:@"voice_url_file"
                                    fileName:@"voice.mp3"
                                    mimeType:@"application/octet-stream"];
        }
    }
                      success:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
            NSNumber *code = response[@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(YES);
                }
            } else {
                if (success) {
                    success(NO);
                }
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    }
                      failure:^(NSError * _Nullable error) {
        if (success) {
            success(NO);
        }
    }];
}

- (void)verifyUserIDCardsWithRealName:(NSString *)realName withIDCards:(NSString *)idcards withIDCardFrontPic:(NSData *)frontPic withIDCardBackPic:(NSData *)backPic withIDCardHandPic:(NSData *)handPic success:(nonnull void (^)(BOOL))success{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    NSString *url = [self.baseURL stringByAppendingFormat:@"usercert?accesstoken=%@&pcode=%@&version=%@",accessToken, SHANYIN_PCODE, SHANYIN_VERSION];
    [self.networkManager POST:url
                   parameters:@{
                       @"realname":[NSString sy_safeString:realName],
                       @"idcard_num":[NSString sy_safeString:idcards]
                   }
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:frontPic
                                    name:@"idcard_frontpic"
                                fileName:@"frontpic.png"
                                mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:backPic
                                    name:@"idcard_backpic"
                                fileName:@"backpic.png"
                                mimeType:@"image/jpeg"];
        [formData appendPartWithFileData:handPic
                                    name:@"idcard_withuser"
                                fileName:@"user.png"
                                mimeType:@"image/jpeg"];
    }
                      success:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]] && response[@"code"]) {
            NSNumber *code = response[@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(YES);
                }
            } else {
                if (success) {
                    success(NO);
                }
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    }
                      failure:^(NSError * _Nullable error) {
        if (success) {
            success(NO);
        }
    }];
}

- (void)requestFollowOrFansList:(BOOL)isFollowYesOrFansNO
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        if (failure) {
            failure(nil);
        };
        return;
    }
    NSString *urlParamsStr = isFollowYesOrFansNO?@"concern/list":@"concern/list/by";
    
    NSString *url = [self.baseURL stringByAppendingString:urlParamsStr];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *users = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                SYUserListModel *list = [SYUserListModel yy_modelWithDictionary:users];
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


- (void)requestFollowUserWithUid:(NSString *)uid
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken] ||
        [NSString sy_isBlankString:uid]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingString:@"concern/add"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"userid": uid,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(@(0));
                }
            }else{
                if ([code integerValue] == 2018) {
                    if (success) { // 2018,您已关注了此用户
                        success(@(2018));
                    }
                } else {
                    if (failure) {
                        failure(nil);
                    };
                }
            }
        }
    }
                     failure:failure];
}

- (void)requestCancelFollowUserWithUid:(NSString *)uid
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken] ||
        [NSString sy_isBlankString:uid]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingString:@"concern/delete"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"userid": uid,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(nil);
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

- (void)requestOtherUserInfo:(NSString *)uid
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure
{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"userinfo/%@",uid]];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *userDict = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                UserProfileEntity *entity = [UserProfileEntity yy_modelWithDictionary:userDict];
                if (success) {
                    success(entity);
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

- (void)requestUserAttentionAndFansCountWithUserid:(NSString *)uid success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"concern/total/%@",uid]];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *dataDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                SYUserAttentionModel *attentionModel = [SYUserAttentionModel yy_modelWithDictionary:dataDic];
                if (success) {
                    success(attentionModel);
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

- (void)requestIsFollowed:(NSString *)uid
              finishBlock:(void(^)(BOOL))finishBlock {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken] ||
        [NSString sy_isBlankString:uid]) {
        if (finishBlock) {
            finishBlock(NO);
        }
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingString:@"concern/confirm"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"userid": uid,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (finishBlock) {
                    finishBlock(YES);
                }
            }else{
                if (finishBlock) {
                    finishBlock(NO);
                }
            }
            
        }
    }
                     failure:nil];
}



- (void)requestLebzTicket:(SuccessBlock)success
                  failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"lebz/ticket"];
    
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *userDict = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(userDict);
                }
            }else{
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                     failure:failure];
}

- (void)requestFilterText:(NSString *)text uid:(NSString *)uid
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"filter"];
    
    NSString *accessToken = [SYSettingManager accessToken];
    [self.networkManager GET:url
                  parameters:@{
                      @"sentence": text?:@"",
                      @"accesstoken": accessToken?:@"",
                      @"uid": uid?:@"0",
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSInteger code = [[data objectForKey:@"code"] integerValue];
            NSDictionary *dataDic = [data objectForKey:@"data"];
            BOOL validate = [[dataDic objectForKey:@"validate"] boolValue];
            NSString *text = [dataDic objectForKey:@"text"];
            if (code == 0 && (validate == YES || text.length > 0)) {
                if (success) {
                    success(text);
                }
            }else{
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                     failure:failure];
}

- (void)requestValidateText:(NSString *)text
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"filter/validate"];
    
    NSString *accessToken = [SYSettingManager accessToken];
    [self.networkManager GET:url
                  parameters:@{
                      @"sentence": text?:@"",
                      @"accesstoken": accessToken?:@"",
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSNumber *result = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(result);
                }
            }else{
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                     failure:failure];
}

- (void)requestUserApplyPropAvatarBoxWithPropId:(NSInteger)propId
                                        success:(SuccessBlock)success
                                        failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"userprop/avatarbox"];
    
    NSString *accessToken = [SYSettingManager accessToken];
    [self.networkManager GET:url
                  parameters:@{
                      @"propid": @(propId),
                      @"accesstoken": accessToken?:@"",
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(nil);
                }
            }else{
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                     failure:failure];
}

- (void)requestUserApplyPropVehicleWithPropId:(NSInteger)propId
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"userprop/vehicle"];
    
    NSString *accessToken = [SYSettingManager accessToken];
    [self.networkManager GET:url
                  parameters:@{
                      @"propid": @(propId),
                      @"accesstoken": accessToken?:@"",
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(nil);
                }
            }else{
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                     failure:failure];
}

- (void)requestUserCancelPropAvatarBoxWithSuccess:(SuccessBlock)success
                                          failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"userprop/avatarbox/cancel"];
    
    NSString *accessToken = [SYSettingManager accessToken];
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken?:@"",
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(nil);
                }
            }else{
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                     failure:failure];
}

- (void)requestUserCancelPropVehicleWithSuccess:(SuccessBlock)success
                                        failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"userprop/vehicle/cancel"];
    
    NSString *accessToken = [SYSettingManager accessToken];
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken?:@"",
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(nil);
                }
            }else{
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                     failure:failure];
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
                NSArray *list = [data objectForKey:@"list"];
                if (success) {
                    success(list);
                }
            }else{
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                     failure:failure];
}

// 获取guestId，获取环信账号密码
- (void)requestGuestAccountWithSuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    NSString *guestId = [SYSettingManager guestId];
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"userinfo/guest"];
    [self.networkManager GET:url
                  parameters:@{
                      @"guestid": guestId?:@"",
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                NSDictionary *model = [data objectForKey:@"data"];
                SYGuestModel *guest = [SYGuestModel yy_modelWithDictionary:model];
                if (![NSString sy_isBlankString:guest.guestid]) {
                    [SYSettingManager setGuestId:guest.guestid];
                }
                if (success) {
                    success(guest);
                }
            }else{
                if (failure) {
                    failure(nil);
                }
            }
        }
    }
                     failure:failure];
}

- (void)requestVipLevelWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"level"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *vipListDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                SYVipLevelListModel *model = [SYVipLevelListModel yy_modelWithDictionary:vipListDic];
                if (success) {
                    success(model);
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

- (void)requestVipPrivilegeWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"vipright"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *vipListDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                SYVipPrivilegeListModel *model = [SYVipPrivilegeListModel yy_modelWithDictionary:vipListDic];
                if (success) {
                    success(model);
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

// 发布动态
- (void)requestSendActivityText:(NSString *)text
                      imageURLs:(NSArray <NSData *>*)imageURLs
                          video:(nonnull NSData *)videoFile
                     videoCover:(nonnull NSData *)videoCover
                       location:(NSString *)location
                       progress:(nonnull void (^)(CGFloat))progress
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure {
    
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        failure(nil);
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"moment/usermomentV2"];
    url = [url stringByAppendingFormat:@"?accesstoken=%@&pcode=%@&version=%@", accessToken, SHANYIN_PCODE, SHANYIN_VERSION];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action": @"add"}];
    if (![NSString sy_isBlankString:text]) {
        [params setObject:text
                   forKey:@"content"];
    }
    if (![NSString sy_isBlankString:location]) {
        [params setObject:location
                   forKey:@"position"];
    }
    [self.networkManager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        if ([imageURLs count] > 0) {
            NSData *imageData;
            NSString *name;
            NSString *fileName;
            for (int i = 0; i < [imageURLs count]; i ++) {
                imageData = [imageURLs objectAtIndex:i];
                name = [NSString stringWithFormat:@"pic%ld",(long)i+1];
                fileName = [NSString stringWithFormat:@"pic%ld.jpg",(long)i+1];
                [formData appendPartWithFileData:imageData
                                            name:name
                                        fileName:fileName
                                        mimeType:@"image/jpeg"];
            }
        }
        if (videoFile.length > 0) {
            [formData appendPartWithFileData:videoFile name:@"video" fileName:@"video.mp4" mimeType:@""];
        }
        if (videoCover.length > 0) {
            [formData appendPartWithFileData:videoCover name:@"video_cover" fileName:@"video_cover.jpg" mimeType:@"image/ipeg"];
        }
    } progress:^(NSProgress * _Nonnull pro) {
        if (progress) {
            progress(pro.fractionCompleted);
        }
    } success:^(id  _Nullable data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(nil);
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
    } failure:failure];
}

// 删除动态
- (void)requestDeleteActivity:(NSString *)momentId success:(void (^)(BOOL))success {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        success(NO);
        return;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"moment/usermomentV2"];
    url = [url stringByAppendingFormat:@"?accesstoken=%@&pcode=%@&version=%@",accessToken, SHANYIN_PCODE, SHANYIN_VERSION];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"action": @"del"}];
    if (![NSString sy_isBlankString:momentId]) {
        [params setObject:momentId
                   forKey:@"momentid"];
    }
    [self.networkManager POST:url
                   parameters:params
                      success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(YES);
                }
            }else{
                if (success) {
                    success(NO);
                }
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (success) {
            success(NO);
        }
    }];
}

- (void)requestUserDynamicListDataWithUserId:(NSString *)userId page:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        failure(nil);
        return;
    }
    if (page <= 0) {
        page = 1;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"moment/momentlist"];
    [self.networkManager GET:url
                  parameters:@{
                      @"momentlistUserid":userId,
                      @"page":[NSString stringWithFormat:@"%ld",page],
                      @"pageSize":@"10",
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSArray *listArr = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(listArr);
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

- (void)requestDynamicCommentListWithMomentId:(NSString *)momentId page:(NSInteger)page pageSize:(NSInteger)pageSize success:(SuccessBlock)success failure:(FailureBlock)failure {
    if (!momentId && momentId.length < 0) {
        failure(nil);
        return;
    }
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    if (page <= 0) {
        page = 1;
    }
    if (pageSize <= 0) {
        pageSize = 10;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"moment/commentlist"];
    [self.networkManager GET:url
                  parameters:@{
                      @"momentid":momentId,
                      @"page":[NSString stringWithFormat:@"%ld",page],
                      @"pageSize":[NSString stringWithFormat:@"%ld",pageSize],
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

- (void)requestDynamicClickLikeWithLike:(BOOL)like momentId:(NSString *)momentId success:(void (^)(BOOL))success {
    if (!momentId && momentId.length < 0) {
        success(NO);
        return;
    }
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        return;
    }
    NSString *likeStr = like ? @"like" : @"dislike";
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"moment/momentlike"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"momentid":momentId,
                      @"action":likeStr,
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSNumber *resultData = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if (like) {
                    if ([resultData integerValue] == 3) {
                        if (success) {
                            success(YES);
                        }
                    } else if ([resultData integerValue] == 4) {
                        if (success) {
                            success(NO);
                        }
                    }
                } else {
                    if ([resultData integerValue] == 5) {
                        if (success) {
                            success(YES);
                        }
                    } else if ([resultData integerValue] == 6) {
                        if (success) {
                            success(NO);
                        }
                    }
                }
            }else{
                if (success) {
                    success(NO);
                };
            }
        } else {
            if (success) {
                success(NO);
            };
        }
    }
                     failure:^(NSError * _Nullable error) {
        if (success) {
            success(NO);
        }
    }];
}

- (void)requestDynamicAddCommentWithMomentId:(NSString *)momentId content:(NSString *)content success:(void (^)(BOOL))success {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        success(NO);
        return;
    }
    NSString *url = [self.baseURL stringByAppendingFormat:@"moment/usercomment?accesstoken=%@&pcode=%@&version=%@",accessToken, SHANYIN_PCODE, SHANYIN_VERSION];
    NSDictionary *postParams = @{
        @"action":@"add",
        @"momentid":momentId,
        @"content":content
    };
    
    [self.networkManager POST:url parameters:postParams success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(YES);
                }
            }else{
                if (success) {
                    success(NO);
                }
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (success) {
            success(NO);
        }
    }];
}

- (void)requestDynamicDeleteCommentWithCommentId:(NSString *)commentId momentId:(nonnull NSString *)momentId success:(void (^)(BOOL))success {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        success(NO);
        return;
    }
    NSString *url = [self.baseURL stringByAppendingFormat:@"moment/usercomment?accesstoken=%@&pcode=%@&version=%@",accessToken, SHANYIN_PCODE, SHANYIN_VERSION];
    NSDictionary *postParams = @{
        @"action":@"del",
        @"commentid":commentId,
        @"momentid":momentId
    };
    [self.networkManager POST:url parameters:postParams success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(YES);
                }
            }else{
                if (success) {
                    success(NO);
                }
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (success) {
            success(NO);
        }
    }];
}

- (void)requestDynamicSquareWithPage:(NSInteger)page
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"moment/square"];
    [self.networkManager GET:url
                  parameters:@{
                      @"pagenum":[NSString stringWithFormat:@"%ld",(long)page],
                      @"pagesize":@"10",
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *_data = [data objectForKey:@"data"];
            NSArray *listArr = nil;
            if ([_data isKindOfClass:[NSDictionary class]]) {
                listArr = [_data objectForKey:@"list"];
            }
            if ([code integerValue] == 0) {
                if (success) {
                    success(listArr);
                }
            }else if ([code integerValue] == 1002){
                // 广场和关注接口，没数据，code提示1002，太特么恶心了
                if (success) {
                    success(@[]);
                }
            } else {
                if (failure) {
                    failure(nil);
                }
            }
            
        } else {
            if (failure) {
                failure(nil);
            };
        }
    }
                     failure:failure];
}

- (void)requestDynamicConcernListDataWithPage:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        failure(nil);
        return;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"moment/concern"];
    [self.networkManager GET:url
                  parameters:@{
                      @"pagenum":[NSString stringWithFormat:@"%ld",(long)page],
                      @"pagesize":@"10",
                      @"accesstoken": accessToken,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *_data = [data objectForKey:@"data"];
            NSArray *listArr = nil;
            if ([_data isKindOfClass:[NSDictionary class]]) {
                listArr = [_data objectForKey:@"list"];
            }
            if ([code integerValue] == 0) {
                if (success) {
                    success(listArr);
                }
            } else if ([code integerValue] == 1002){
                // 广场和关注接口，没数据，code提示1002，太特么恶心了
                if (success) {
                    success(@[]);
                }
            } else{
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

- (void)updateUserProperty:(NSString *)propertyName isOpen:(BOOL)isOpen success:(void (^)(BOOL))success
{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        success(NO);
        return;
    }
    NSString *url = [self.baseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"user/%@?accesstoken=%@&pcode=%@&version=%@", propertyName,accessToken, SHANYIN_PCODE, SHANYIN_VERSION]];
    
    NSDictionary *postParams = @{
        @"value":@(isOpen?1:0)
    };
    [self.networkManager POST:url
                   parameters:postParams
                      success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success(YES);
                }
            }else{
                if (success) {
                    success(NO);
                }
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (success) {
            success(NO);
        }
    }];
}

- (void)requestUserPropertyValue:(NSString *)propertyName sucess:(void (^)(BOOL))sucess failure:(FailureBlock)failure
{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken]) {
        failure(nil);
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingPathComponent:[NSString stringWithFormat:@"user/%@", propertyName]];
    
    [self.networkManager GET:url parameters:@{
        @"accesstoken": accessToken,
        @"pcode":SHANYIN_PCODE,
        @"version":SHANYIN_VERSION
    } success:^(NSDictionary *data) {
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            NSDictionary *dataDic = [data objectForKey:@"data"];
            if ([code integerValue] == 0) {
                if(dataDic && [dataDic isKindOfClass:[NSDictionary class]]){
                    NSNumber *value = [dataDic objectForKey:@"value"];
                    if(sucess){
                        sucess([value integerValue] != 0);
                    }
                }
            }else{
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
//真爱团相关接口
//真爱团基本信息
- (void)requestFansViewInfoWithUid:(NSString *)uid
                       andAnchorid:(NSString *)anchorid
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken] ||
        [NSString sy_isBlankString:uid]||
        [NSString sy_isBlankString:anchorid]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingString:@"fanslove/fanslove"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"uid": uid,
                      @"anchorid":anchorid,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success([data objectForKey:@"data"]);
                }
            }else{
                failure(nil);
            }
        }
    }
                     failure:failure];
}
//真爱团 团成员列表
- (void)requestFansViewMemberListWithAnchorid:(NSString *)anchorid
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken] ||
        [NSString sy_isBlankString:anchorid]) {
        failure(nil);
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingString:@"fanslove/fanslist"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"anchorid":anchorid,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success([data objectForKey:@"data"]);
                }
            }else{
                failure(nil);
            }
        }
    }
                     failure:failure];
}
//开通、续费真爱团
- (void)openFansRightWithUid:(NSString *)uid
                 andAnchorid:(NSString *)anchorid
                  fansloveid:(NSString *)fansloveid
                   pricetype:(NSString *)pricetype
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure{
    
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken] ||
        [NSString sy_isBlankString:uid]||
        [NSString sy_isBlankString:anchorid]||
        [NSString sy_isBlankString:fansloveid]||
        [NSString sy_isBlankString:pricetype]) {
        failure(nil);
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingString:@"fanslove/purchaseservice"];
    NSString *finalUrl = [NSString stringWithFormat:@"%@?accesstoken=%@&pcode=%@&version=%@",url,accessToken,SHANYIN_PCODE,SHANYIN_VERSION];
    [self.networkManager POST:finalUrl
                   parameters:@{
                       @"fansloveid": fansloveid,
                       @"anchorid":anchorid,
                       @"uid":uid,
                       @"pricetype":pricetype
                   }
                      success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success([data objectForKey:@"data"]);
                }
            }else{
                failure(nil);
            }
        }
    }
                      failure:failure];
}
//用户真爱团等级信息
- (void)requestFansViewLevelWithUid:(NSString *)uid
                       andAnchorid:(NSString *)anchorid
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure {
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken] ||
        [NSString sy_isBlankString:uid]||
        [NSString sy_isBlankString:anchorid]) {
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingString:@"fanslove/userscore"];
    
    [self.networkManager GET:url
                  parameters:@{
                      @"accesstoken": accessToken,
                      @"userid": uid,
                      @"id":anchorid,
                      @"pcode":SHANYIN_PCODE,
                      @"version":SHANYIN_VERSION
                  }
                     success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success([data objectForKey:@"data"]);
                }
            }else{
                failure(nil);
            }
        }
    }
                     failure:failure];
}
//修改团名称
- (void)editFansGroupNameWithGroupId:(NSString *)groupId
                         andAnchorid:(NSString *)anchorid
                                name:(NSString *)name
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure{
    NSString *accessToken = [SYSettingManager accessToken];
    if ([NSString sy_isBlankString:accessToken] ||
        [NSString sy_isBlankString:groupId]||
        [NSString sy_isBlankString:anchorid]||
        [NSString sy_isBlankString:name]) {
        failure(nil);
        return;
    }
    
    NSString *url = [self.baseURL stringByAppendingString:@"fanslove/editname"];
    NSString *finalUrl = [NSString stringWithFormat:@"%@?accesstoken=%@&pcode=%@&version=%@",url,accessToken,SHANYIN_PCODE,SHANYIN_VERSION];
    [self.networkManager POST:finalUrl
                   parameters:@{
                       @"name": name,
                       @"anchorid":anchorid,
                       @"id":groupId
                   }
                      success:^(NSDictionary *data){
        if (data) {
            NSString *code = [data objectForKey:@"code"];
            if ([code integerValue] == 0) {
                if (success) {
                    success([data objectForKey:@"data"]);
                }
            }else{
                failure(nil);
            }
        }
    }
                      failure:failure];
    
}
@end
