//
//  SYVoiceChatNetManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNetCommonManager.h"
#import "SYVoiceRoomListModel.h"
#import "SYVoiceRoomPlayerListModel.h"
#import "SYVoiceRoomJoinModel.h"
#import "SYVoiceRoomUserStatusModel.h"
#import "SYVoiceRoomUserListModel.h"
#import "SYVoiceRoomUserRightModel.h"
#import "SYCreateRoomCategoryModel.h"
#import "SYVoiceRoomOnlineListModel.h"
#import "SYVoiceRoomHomeListModel.h"
#import "SYVoiceRoomOperationModel.h"
#import "SYRoomHomeFocusModel.h"
#import "SYVoiceRoomPKListModel.h"
#import "SYVoiceRoomExpression.h"
#import "SYVoiceRoomKingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatNetManager : SYNetCommonManager

// 房间列表
- (void)requestChannelListWithPage:(NSInteger)page
                        categoryId:(NSInteger)categoryId
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure;

- (void)requestHomeFocusListWithSuccess:(SuccessBlock)success
                                failure:(FailureBlock)failure
                                categoryType:(FirstCategoryType)type;

// 聊天室首页
- (void)requestHomeChannelListWithCategoryId:(NSInteger)categoryId
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure;

// 我的房间列表
- (void)requestMyChannelListWithPage:(NSInteger)page
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;

// 进入房间
- (void)requestJoinChannelWithChannelID:(NSString *)channelID
                                    uid:(NSString *)uid
                               password:(NSString *)password
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;
// 房间信息
- (void)requestChannelInfoWithChannelID:(NSString *)channelID
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;
// 得到角色列表
- (void)requestRolesListWithChannelID:(NSString *)channelID
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure;

// 离开房间
- (void)requestLeaveChannelWithChannelID:(NSString *)channelID
                                     uid:(NSString *)uid
                                 isGuest:(BOOL)isGuest
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure;
// 排麦
- (void)requestApplyMicWithChannelID:(NSString *)channelID
                                 uid:(NSString *)uid
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;
// 取消排麦
- (void)requestCancelApplyMicWithChannelID:(NSString *)channelID
                                       uid:(NSString *)uid
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure;
// 确认某人上麦
- (void)requestConfirmMicWithChannelID:(NSString *)channelID
                                   uid:(NSString *)uid
                              position:(NSInteger)position
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;
// 踢某人下麦
- (void)requestKickMicWithChannelID:(NSString *)channelID
                                uid:(NSString *)uid
                           position:(NSInteger)position
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure;
// 确认主持人上麦
- (void)requestConfirmHostWithChannelID:(NSString *)channelID
                                    uid:(NSString *)uid
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;
// 踢下主持人
- (void)requestKickHostWithChannelID:(NSString *)channelID
                                 uid:(NSString *)uid
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;

// 静音某个麦位
- (void)requestMuteMicWithChannelID:(NSString *)channelID
                                uid:(NSString *)uid
                           position:(NSInteger)position
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure;
// 取消某个麦位静音
- (void)requestCancelMuteMicWithChannelID:(NSString *)channelID
                                      uid:(NSString *)uid
                                 position:(NSInteger)position
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure;
// 静音主持人
- (void)requestMuteHostMicWithChannelID:(NSString *)channelID
                                    uid:(NSString *)uid
                               position:(NSInteger)position
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;
// 取消静音主持人
- (void)requestCancelMuteHostMicWithChannelID:(NSString *)channelID
                                          uid:(NSString *)uid
                                     position:(NSInteger)position
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure;
// 禁言
- (void)requestForbidUserChatWithChannelID:(NSString *)channelID
                                       uid:(NSString *)uid
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure;
// 取消禁言
- (void)requestCancelForbidUserChatWithChannelID:(NSString *)channelID
                                             uid:(NSString *)uid
                                         success:(SuccessBlock)success
                                         failure:(FailureBlock)failure;
// 禁入
- (void)requestForbidUserEnterWithChannelID:(NSString *)channelID
                                        uid:(NSString *)uid
                                    success:(SuccessBlock)success
                                    failure:(FailureBlock)failure;
// 取消禁入
- (void)requestCancelForbidUserEnterWithChannelID:(NSString *)channelID
                                              uid:(NSString *)uid
                                          success:(SuccessBlock)success
                                          failure:(FailureBlock)failure;
// 开启房间
- (void)requestOpenChannelWithChannelID:(NSString *)channelID
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;
// 关闭房间
- (void)requestCloseChannelWithChannelID:(NSString *)channelID
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure;

// 禁言列表
- (void)requestForbidChatUserListWithChannelID:(NSString *)channelID
                                          page:(NSInteger)page
                                       success:(SuccessBlock)success
                                       failure:(FailureBlock)failure;
// 禁入列表
- (void)requestForbidEnterUserListWithChannelID:(NSString *)channelID
                                           page:(NSInteger)page
                                        success:(SuccessBlock)success
                                        failure:(FailureBlock)failure;
// 加入管理员
- (void)requestAddAdministerWithChannelID:(NSString *)channelID
                                      uid:(NSString *)uid
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure;

// 删除管理员
- (void)requestDeleteAdministerWithChannelID:(NSString *)channelID
                                         uid:(NSString *)uid
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure;

// 管理员列表
- (void)requestAdministerListWithChannelID:(NSString *)channelID
                                      page:(NSInteger)page
                                   success:(SuccessBlock)success
                                   failure:(FailureBlock)failure;

// 请求用户在房间的状态
- (void)requestUserStatusWithChannelID:(NSString *)channelID
                                   uid:(NSString *)uid
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;

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
                                    failure:(FailureBlock)failure;

// 更改房间信息
- (void)requestUpdateChannelInfoWithChannelID:(NSString *)channelID
                                         name:(NSString *)name
                                     greeting:(NSString *)greeting
                                         desc:(NSString *)desc
                                         icon:(NSString *)icon
                                     iconFile:(NSData *)iconFile
                                iconFile_16_9:(NSData *)iconFile_16_9
                              backgroundImage:(NSNumber *__nullable)background
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure;

// 更改房间密码
- (void)requestUpdateRoomPasswordWithChannelId:(NSString *)channelId
                                          lock:(NSInteger)lock
                                      password:(NSString *)password
                                       success:(SuccessBlock)success
                                       failure:(FailureBlock)failure;

// 请求房间密码
- (void)requestRoomPasswordWithChannelId:(NSString *)channelId
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure;

// 用户创建房间权限
- (void)requestUserChannelRightWithSuccess:(SuccessBlock)success
                                   failure:(FailureBlock)failure;

// 用户创建房间类型
- (void)requestUserCreateRoomTypeWithSuccess:(SuccessBlock)success
                                     failure:(FailureBlock)failure;

// API_DEPRECATED("Use - requestRoomNewCategoryList instead",1.7)
- (void)requestVoiceRoomCategoryListWithSuccess:(SuccessBlock)success
                                        failure:(FailureBlock)failure;

// 房间类型 -（包含直播房和语音房）
- (void)requestRoomNewCategoryListWithSuccess:(SuccessBlock)success
                                      failure:(FailureBlock)failure;

// 聊天室 - 在线用户人数
- (void)requestVoiceRoomOnlineListWithChannelId:(NSString *)channelId
                                           page:(NSInteger)page
                                        success:(SuccessBlock)success
                                        failure:(FailureBlock)failure;

// 聊天室 - 运营位
- (void)requestVoiceRoomOperationWithSuccess:(SuccessBlock)success
                                     failure:(FailureBlock)failure;

- (void)requestVoiceRoomPostWithSuccess:(SuccessBlock)success
                                failure:(FailureBlock)failure;

// 判断用户是否在聊天室内
- (void)requestUserIfHasEnterChatRoomWithUserId:(NSString *)uid
                                        success:(SuccessBlock)success
                                        failure:(FailureBlock)failure;

- (void)requestNewVoiceEngineTokenWithChannelId:(NSString *)channelId
                                            uid:(NSInteger)uid
                                        success:(SuccessBlock)success
                                        failure:(FailureBlock)failure;

// 心跳
- (void)requestHeartBeatWithChannelId:(NSString *)channelId
                                  uid:(NSString *)uid
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure;

// =============== PK ===============

- (void)requestStartPKWithChannelId:(NSString *)channelId
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure;

- (void)requestStopPKWithPKId:(NSInteger)pkId
                      success:(SuccessBlock)success
                      failure:(FailureBlock)failure;

- (void)requestPKInfoWithChannelId:(NSString *)channelId
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure;

- (void)requestExpressionListWithSuccess:(SuccessBlock)success
                                 failure:(FailureBlock)failure;

- (void)requestRoomKingWithChannelId:(NSString *)channelId
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
