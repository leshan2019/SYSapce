//
//  SYVoiceChatNetManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatNetManager.h"
//#import <YYModel/YYModel.h>

@interface SYVoiceChatNetManager ()

@property (nonatomic, strong) NSString *baseURL;

@end

@implementation SYVoiceChatNetManager

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef UseSettingTestDevEnv
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"http://test.api.svoice.le.com/room/";
        }else {
            _baseURL = @"http://api.svoice.le.com/room/";
        }
#else
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"http://test.api.svoice.le.com/room/";
        }else {
            _baseURL = @"https://api-svoice.le.com/room/";
        }
#endif
    }
    return self;
}

- (void)requestChannelListWithPage:(NSInteger)page
                        categoryId:(NSInteger)categoryId
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/list"];
    [self commonGETRequestWithURL:url parameters:@{@"page":@(page), @"cid": @(categoryId)} success:^(NSDictionary *data) {
        if (data) {
            SYVoiceRoomListModel *listModel = [SYVoiceRoomListModel yy_modelWithDictionary:data];
            if (success) {
                success(listModel);
            }
        }
    } failure:failure];
}

- (void)requestHomeFocusListWithSuccess:(SuccessBlock)success
                                failure:(FailureBlock)failure
                                categoryType:(FirstCategoryType)type {
    NSString *url = [self.baseURL stringByAppendingString:@"room/home-focus"];
    NSString*positionValue = [NSString stringWithFormat:@"%ld",(long)type];
    [self commonGETRequestWithURL:url parameters:@{@"position":positionValue} success:^(NSDictionary *data) {
        if (data) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[SYRoomHomeFocusModel class]
                                                        json:data];
            if (success) {
                success(array);
            }
        }
    } failure:failure];
}

// 聊天室首页
- (void)requestHomeChannelListWithCategoryId:(NSInteger)categoryId
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure  {
    NSString *url = [self.baseURL stringByAppendingString:@"room/home"];
    [self commonGETRequestWithURL:url parameters:@{@"cid": @(categoryId)} success:^(NSDictionary *data) {
        if (data) {
            SYVoiceRoomHomeListModel *listModel = [SYVoiceRoomHomeListModel yy_modelWithDictionary:data];
            if (success) {
                success(listModel);
            }
        }
    } failure:failure];
}

- (void)requestMyChannelListWithPage:(NSInteger)page
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/my"];
    [self commonGETRequestWithURL:url parameters:@{@"page":@(page)} success:^(NSDictionary *data) {
        if (data) {
            SYVoiceRoomListModel *listModel = [SYVoiceRoomListModel yy_modelWithDictionary:data];
            if (success) {
                success(listModel);
            }
        }
    } failure:failure];
}

- (void)requestJoinChannelWithChannelID:(NSString *)channelID
                                    uid:(NSString *)uid
                               password:(NSString *)password
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    if (!channelID) {
        if (failure) {
            failure(nil);
        }
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"rid":channelID?:@"", @"uid": uid?:@""}];
    if (password.length > 0) {
        [param setObject:password forKey:@"password"];
    }
    if ([NSString sy_isBlankString:uid]) {
        [param setObject:@(1) forKey:@"guest"];
        NSString *deviceId = [SYSettingManager deviceUUID];
        if (deviceId) {
            [param setObject:deviceId forKey:@"devid"];
        }
    }
    NSString *url = [self.baseURL stringByAppendingString:@"room/join"];
    [self commonGETRequestWithURL:url
                       parameters:param
                          success:^(NSDictionary *data) {
                              if (data) {
                                  SYVoiceRoomJoinModel *joinModel = [SYVoiceRoomJoinModel yy_modelWithDictionary:data];
                                  if (success) {
                                      success(joinModel);
                                  }
                              }
                          } failure:failure];
}

- (void)requestChannelInfoWithChannelID:(NSString *)channelID
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    if (!channelID) {
        if (failure) {
            failure(nil);
        }
    }
    NSString *url = [self.baseURL stringByAppendingString:@"room/info"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID}
                          success:^(NSDictionary *data) {
                              if (data) {
                                  SYChatRoomModel *roomModel = [SYChatRoomModel yy_modelWithDictionary:data];
                                  if (success) {
                                      success(roomModel);
                                  }
                              }
                          } failure:failure];
}

- (void)requestRoomPasswordWithChannelId:(NSString *)channelId success:(SuccessBlock)success failure:(FailureBlock)failure {
    if (!channelId) {
        if (failure) {
            failure(nil);
        }
    }
    NSString *url = [self.baseURL stringByAppendingString:@"room/password"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelId}
                          success:^(NSDictionary *data) {
                              if (data) {
                                  if (success) {
                                      success([data objectForKey:@"password"]);
                                  }
                              }
                          } failure:failure];
}

- (void)requestRolesListWithChannelID:(NSString *)channelID
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure {
    if (!channelID) {
        if (failure) {
            failure(nil);
        }
    }
    NSString *url = [self.baseURL stringByAppendingString:@"room/roles"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID}
                          success:^(NSDictionary *data) {
                              if (data) {
                                  SYVoiceRoomPlayerListModel *listModel = [SYVoiceRoomPlayerListModel yy_modelWithDictionary:data];
                                  if (success) {
                                      success(listModel);
                                  }
                              }
                          } failure:failure];
}

- (void)requestLeaveChannelWithChannelID:(NSString *)channelID
                                     uid:(NSString *)uid
                                 isGuest:(BOOL)isGuest
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure {
    if (!channelID || !uid) {
        if (failure) {
            failure(nil);
        }
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"rid":channelID, @"uid":uid}];
    if (isGuest) {
        [param setObject:@"1" forKey:@"guest"];
        NSString *deviceId = [SYSettingManager deviceUUID];
        if (deviceId) {
            [param setObject:deviceId forKey:@"devid"];
        }
    }
    NSString *url = [self.baseURL stringByAppendingString:@"room/leave"];
    [self commonGETRequestWithURL:url
                       parameters:param
                          success:success
                          failure:failure];
}

// 排麦
- (void)requestApplyMicWithChannelID:(NSString *)channelID
                                 uid:(NSString *)uid
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"31"}
                          success:success
                          failure:failure];
}
// 取消排麦
- (void)requestCancelApplyMicWithChannelID:(NSString *)channelID
                                       uid:(NSString *)uid
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"32"}
                          success:success
                          failure:failure];
}
// 确认某人上麦
- (void)requestConfirmMicWithChannelID:(NSString *)channelID
                                   uid:(NSString *)uid
                              position:(NSInteger)position
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    if (!channelID || !uid || position < 0) {
        if (failure) {
            failure(nil);
        }
    }
    
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"21", @"position": @(position)}
                          success:success
                          failure:failure];
}
// 踢某人下麦
- (void)requestKickMicWithChannelID:(NSString *)channelID
                                uid:(NSString *)uid
                           position:(NSInteger)position
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"22", @"position": @(position)}
                          success:success
                          failure:failure];
}

// 确认主持人上麦
- (void)requestConfirmHostWithChannelID:(NSString *)channelID
                                    uid:(NSString *)uid
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"11"}
                          success:success
                          failure:failure];
}

// 踢下主持人
- (void)requestKickHostWithChannelID:(NSString *)channelID
                                 uid:(NSString *)uid
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"12"}
                          success:success
                          failure:failure];
}

// 静音某个麦位
- (void)requestMuteMicWithChannelID:(NSString *)channelID
                                uid:(NSString *)uid
                           position:(NSInteger)position
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"23", @"position": @(position)}
                          success:success
                          failure:failure];
}
// 取消某个麦位静音
- (void)requestCancelMuteMicWithChannelID:(NSString *)channelID
                                      uid:(NSString *)uid
                                 position:(NSInteger)position
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"24", @"position": @(position)}
                          success:success
                          failure:failure];
}

- (void)requestMuteHostMicWithChannelID:(NSString *)channelID
                                    uid:(NSString *)uid
                               position:(NSInteger)position
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"13", @"position": @(position)}
                          success:success
                          failure:failure];
}

- (void)requestCancelMuteHostMicWithChannelID:(NSString *)channelID
                                          uid:(NSString *)uid
                                     position:(NSInteger)position
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/do"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"14", @"position": @(position)}
                          success:success
                          failure:failure];
}

- (void)requestForbidUserChatWithChannelID:(NSString *)channelID
                                       uid:(NSString *)uid
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/disable"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"11"}
                          success:success
                          failure:failure];
}

- (void)requestCancelForbidUserChatWithChannelID:(NSString *)channelID
                                             uid:(NSString *)uid
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/disable"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"12"}
                          success:success
                          failure:failure];
}

- (void)requestForbidUserEnterWithChannelID:(NSString *)channelID
                                        uid:(NSString *)uid
                                    success:(SuccessBlock)success
                                    failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/disable"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"21"}
                          success:success
                          failure:failure];
}

- (void)requestCancelForbidUserEnterWithChannelID:(NSString *)channelID
                                              uid:(NSString *)uid
                                          success:(SuccessBlock)success
                                          failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/disable"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid,
                                    @"do":@"22"}
                          success:success
                          failure:failure];
}

// 开启房间
- (void)requestOpenChannelWithChannelID:(NSString *)channelID
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/open"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID}
                          success:success
                          failure:failure];
}

- (void)requestCloseChannelWithChannelID:(NSString *)channelID
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/close"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID}
                          success:success
                          failure:failure];
}

- (void)requestForbidChatUserListWithChannelID:(NSString *)channelID
                                          page:(NSInteger)page
                                       success:(SuccessBlock)success
                                       failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/disable-list"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"page":@(page),
                                    @"do":@"10"}
                          success:^(NSDictionary *data) {
                              if (data) {
                                  SYVoiceRoomUserListModel *listModel = [SYVoiceRoomUserListModel yy_modelWithDictionary:data];
                                  if (success) {
                                      success(listModel);
                                  }
                              }
                          }
                          failure:failure];
}

- (void)requestForbidEnterUserListWithChannelID:(NSString *)channelID
                                           page:(NSInteger)page
                                        success:(SuccessBlock)success
                                        failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/disable-list"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"page":@(page),
                                    @"do":@"20"}
                          success:^(NSDictionary *data) {
                              if (data) {
                                  SYVoiceRoomUserListModel *listModel = [SYVoiceRoomUserListModel yy_modelWithDictionary:data];
                                  if (success) {
                                      success(listModel);
                                  }
                              }
                          }
                          failure:failure];
}

// 加入管理员
- (void)requestAddAdministerWithChannelID:(NSString *)channelID
                                      uid:(NSString *)uid
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/adminer-add"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid}
                          success:success
                          failure:failure];
}

// 删除管理员
- (void)requestDeleteAdministerWithChannelID:(NSString *)channelID
                                         uid:(NSString *)uid
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/adminer-delete"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"uid":uid}
                          success:success
                          failure:failure];
}

- (void)requestAdministerListWithChannelID:(NSString *)channelID
                                      page:(NSInteger)page
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/adminer-list"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelID, @"page":@(page)}
                          success:^(NSDictionary *data) {
                              if (data) {
                                  SYVoiceRoomUserListModel *listModel = [SYVoiceRoomUserListModel yy_modelWithDictionary:data];
                                  if (success) {
                                      success(listModel);
                                  }
                              }
                          }
                          failure:failure];
}

- (void)requestUserStatusWithChannelID:(NSString *)channelID
                                   uid:(NSString *)uid
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/user-status"];
    NSString *token = [SYSettingManager accessToken];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"rid":channelID, @"uid":uid}];
    if ([NSString sy_isBlankString:token]) {
        [param setObject:@(1) forKey:@"guest"];
    }
    [self commonGETRequestWithURL:url
                       parameters:param
                          success:^(NSDictionary *data) {
                              if (data) {
                                  SYVoiceRoomUserStatusModel *model = [SYVoiceRoomUserStatusModel yy_modelWithDictionary:data];
                                  if (success) {
                                      success(model);
                                  }
                              }
                          }
                          failure:failure];
}

// 在线用户列表
- (void)requestVoiceRoomOnlineListWithChannelId:(NSString *)channelId page:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/online-user"];
    [self commonGETRequestWithURL:url
                       parameters:@{ @"rid":channelId,
                                     @"page":@(page) }
                          success:^(NSDictionary *data) {
                              if (data) {
                                  SYVoiceRoomOnlineListModel *model = [SYVoiceRoomOnlineListModel yy_modelWithDictionary:data];
                                  if (success) {
                                      success(model);
                                  }
                              }
                          }
                          failure:failure];
}

// 创建房间
- (void)requestCreateChannelWithChannelName:(NSString *)name
                                   greeting:(NSString *)greeting
                                       desc:(NSString *)desc
                                       icon:(NSString *)icon
                                   iconFile:(NSData *)iconFile
                                icon169File:(NSData *)icon169File
                                   category:(NSInteger)category
                                  micConfig:(NSString *)micConfig
                                       lock:(NSInteger)lock
                                   password:(NSString *)password
                                 background:(NSInteger)background
                                    success:(SuccessBlock)success
                                    failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"room/create?pcode=%@&version=%@", SHANYIN_PCODE, SHANYIN_VERSION];
    [self commonPOSTRequestWithURL:url
                        parameters:@{@"name": name?:@"",
                                     @"greeting": greeting?:@"",
                                     @"desc": desc?:@"",
                                     @"icon": icon?:@"",
                                     @"category": @(category),
                                     @"micConfig": micConfig?:@"",
                                     @"lock": @(lock),
                                     @"password": password?:@"",
                                     @"background": @(background)
                                     }
         constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
             [formData appendPartWithFileData:iconFile
                                         name:@"icon_file"
                                     fileName:@"avatar.png"
                                     mimeType:@"image/jpeg"];
//             [formData appendPartWithFileData:icon169File
//                                         name:@"pic_w16h9_file"
//                                     fileName:@"avatar169.png"
//                                     mimeType:@"image/jpeg"];
         }
                           success:success
                           failure:failure];
}

// 更改房间信息
- (void)requestUpdateChannelInfoWithChannelID:(NSString *)channelID
                                         name:(NSString *)name
                                     greeting:(NSString *)greeting
                                         desc:(NSString *)desc
                                         icon:(NSString *)icon
                                     iconFile:(NSData *)iconFile
                                iconFile_16_9:(nonnull NSData *)iconFile_16_9
                              backgroundImage:(NSNumber *)background
                                      success:(nonnull SuccessBlock)success
                                      failure:(nonnull FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"room/update?pcode=%@&version=%@", SHANYIN_PCODE, SHANYIN_VERSION];
    [self commonPOSTRequestWithURL:url
                        parameters:@{@"name": name?:@"",
                                     @"greeting": greeting?:@"",
                                     @"desc": desc?:@"",
                                     @"icon": icon?:@"",
                                     @"rid": channelID?:@"",
                                     @"background":background?:@""
                                     }
         constructingBodyWithBlock:^(id<AFMultipartFormData>formData) {
             if (iconFile.length > 0) {
                 [formData appendPartWithFileData:iconFile
                                             name:@"icon_file"
                                         fileName:@"avatar.png"
                                         mimeType:@"image/jpeg"];
             }
             if (iconFile_16_9.length > 0) {
                 [formData appendPartWithFileData:iconFile_16_9
                                             name:@"pic_w16h9_file"
                                         fileName:@"avatar.png"
                                         mimeType:@"image/jpeg"];
             }
         } success:success failure:failure];
}

- (void)requestUpdateRoomPasswordWithChannelId:(NSString *)channelId lock:(NSInteger)lock password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingFormat:@"room/update?pcode=%@&version=%@", SHANYIN_PCODE, SHANYIN_VERSION];
    [self commonPOSTRequestWithURL:url parameters:@{@"rid": channelId?:@"",
                                                    @"lock": @(lock),
                                                    @"password": password?:@""
                                                    } success:success failure:failure];
}

- (void)requestUserChannelRightWithSuccess:(SuccessBlock)success
                                   failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/can-create"];
    [self commonGETRequestWithURL:url
                       parameters:@{}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYVoiceRoomUserRightModel *model = [SYVoiceRoomUserRightModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(model);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestUserCreateRoomTypeWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"live/type"];
    [self commonGETRequestWithURL:url
                       parameters:@{}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSArray class]]) {
                                  NSArray *listModelArr = [NSArray yy_modelArrayWithClass:[SYRoomCreateTypeModel class] json:response];
                                  if (success) {
                                      success(listModelArr);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestVoiceRoomCategoryListWithSuccess:(SuccessBlock)success
                                        failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/category"];
    [self commonGETRequestWithURL:url
                       parameters:@{}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSArray class]]) {
                                  NSArray *arr = [NSArray yy_modelArrayWithClass:[SYCreateRoomCategoryModel class]
                                                                            json:response];
                                  if (success) {
                                      success(arr);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestRoomNewCategoryListWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/categoryV2"];
    [self commonGETRequestWithURL:url
                       parameters:@{}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSArray class]]) {
                                  NSArray *listArr = [NSArray yy_modelArrayWithClass:[SYCreateRoomCategorySectionModel class] json:response];
                                  if (success) {
                                      success(listArr);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestVoiceRoomOperationWithSuccess:(SuccessBlock)success
                                     failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/multoperation"];
    [self commonGETRequestWithURL:url
                       parameters:@{}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSArray class]]) {
                                  NSArray *responseArr = (NSArray *)response;
                                  NSMutableArray *finalArr = [NSMutableArray array];
                                  NSArray *tempArr = nil;
                                  for (int i = 0; i < responseArr.count; i++) {
                                      tempArr =[responseArr objectAtIndex:i];
                                      if (tempArr && tempArr.count > 0) {
                                          [finalArr addObject:[NSArray yy_modelArrayWithClass:[SYVoiceRoomOperationModel class]
                                                                                         json:tempArr]];
                                      }
                                  }
                                  if (success) {
                                      success(finalArr);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestVoiceRoomPostWithSuccess:(SuccessBlock)success
                                failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/notice"];
    [self commonGETRequestWithURL:url
                       parameters:@{}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  NSDictionary *dict = (NSDictionary *)response;
                                  NSString *content = dict[@"content"];
                                  if (success) {
                                      success(content);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestUserIfHasEnterChatRoomWithUserId:(NSString *)uid success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingPathComponent:@"/room/userjoind"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"uid":uid}
                          success:^(NSDictionary *data) {
                              if (data) {
                                  SYChatRoomModel *roomModel = [SYChatRoomModel yy_modelWithDictionary:data];
                                  if (success) {
                                      success(roomModel);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestNewVoiceEngineTokenWithChannelId:(NSString *)channelId
                                            uid:(NSInteger)uid
                                        success:(SuccessBlock)success
                                        failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/token"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelId?:@"", @"uid":@(uid)}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  NSString *token = response[@"mtToken"];
                                  if (success) {
                                      success(token);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestHeartBeatWithChannelId:(NSString *)channelId
                                  uid:(NSString *)uid
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/heartbeat"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelId?:@"", @"uid":uid?:@""}
                          success:^(id  _Nullable response) {
                              if (success) {
                                  success(nil);
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

// =============== PK ===============

- (void)requestStartPKWithChannelId:(NSString *)channelId
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/session/create"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelId?:@""}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYVoiceRoomPKListModel *pkList = [SYVoiceRoomPKListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(pkList);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestStopPKWithPKId:(NSInteger)pkId
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/session/close"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"sid":@(pkId)}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYVoiceRoomPKListModel *pkList = [SYVoiceRoomPKListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(pkList);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestPKInfoWithChannelId:(NSString *)channelId
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/session/last"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelId?:@""}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYVoiceRoomPKListModel *pkList = [SYVoiceRoomPKListModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(pkList);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

- (void)requestExpressionListWithSuccess:(SuccessBlock)success
                                 failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/emoticons"];
    [self commonGETRequestWithURL:url
                       parameters:@{}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSArray class]]) {
                                  NSArray *list = [NSArray yy_modelArrayWithClass:[SYVoiceRoomExpression class]
                                                                             json:response];
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

- (void)requestRoomKingWithChannelId:(NSString *)channelId
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure {
    NSString *url = [self.baseURL stringByAppendingString:@"room/boss"];
    [self commonGETRequestWithURL:url
                       parameters:@{@"rid":channelId?:@""}
                          success:^(id  _Nullable response) {
                              if ([response isKindOfClass:[NSDictionary class]]) {
                                  SYVoiceRoomKingModel *boss = [SYVoiceRoomKingModel yy_modelWithDictionary:response];
                                  if (success) {
                                      success(boss);
                                  }
                              }
                          } failure:^(NSError * _Nullable error) {
                              if (failure) {
                                  failure(error);
                              }
                          }];
}

#pragma mark -

- (void)commonGETRequestWithURL:(NSString *)url
                     parameters:(NSDictionary *)parameters
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:SHANYIN_PCODE forKey:@"pcode"];
    [dict setObject:SHANYIN_VERSION forKey:@"version"];
    NSString *token = [SYSettingManager accessToken]?:@"";
    if (token.length > 0) {
        [dict setObject:token forKey:@"accesstoken"];
    }
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
       } failure:^(NSError * _Nullable error) {
           if (failure) {
               failure(nil);
           }
       }];
}

@end
