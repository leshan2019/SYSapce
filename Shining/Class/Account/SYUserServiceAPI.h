//
//  SYUserServiceAPI.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/10.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYUserListModel.h"
#import "SYUserAttentionModel.h"
#import "SYGuestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYUserServiceAPI : NSObject

+ (instancetype)sharedInstance;

- (void)requestLoginSignup:(NSString *)mobile
                     vcode:(NSString *)vcode
                 tempToken:(NSString *)token
                    vendor:(NSInteger)vendor
                   success:(SuccessBlock)success
                   failure:(FailureBlock)failure;

- (void)requestVcode:(NSString *)phoneNum;

//乐视静默登录
- (void)requestLetvLoginSignup:(NSString *)ssotk
                       success:(SuccessBlock)success
                       failure:(FailureBlock)failure;
//第三方登录
- (void)requestThirdLoginSignup:(NSString *)ssotk
                       platForm:(ThridPlatFormType)platForm
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;
//OAuth2第三方登录授权码接口(微信）
- (void)requestOAuthWXLogin:(NSString *)code
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure;
//验证token
- (void)vertifyAcessToken:(void(^)(BOOL))finishBlock;

// 获取当前用户信息
- (void)requestUserInfoWithSuccess:(void (^)(BOOL success))success;

// 更新当前用户信息
- (void)updateUserInfoWithOriginAvatarUrl:(NSString *)avatarUrl
               withChangedAvatarImageFile:(NSData *)avatarFile
                             withUserName:(NSString *)username
                               withGender:(NSString *)gender
                            withSignature:(NSString *)signature
                             withBirthday:(NSString *)birthday
                           withDistrictiD:(NSString *)districtId
                                  success:(void (^)(NSInteger code)) success;

// 上传用户身份证信息
- (void)verifyUserIDCardsWithRealName:(NSString *)realName
                          withIDCards:(NSString *)idcards
                   withIDCardFrontPic:(NSData *)frontPic
                    withIDCardBackPic:(NSData *)backPic
                    withIDCardHandPic:(NSData *)handPic
                              success:(void (^)(BOOL)) success;

// 获取身份证认证结果 - 1.6接口百度faceSDK，不用这个老流程的接口了
- (void)requestVerifyIDCardsResult:(SuccessBlock)success;

// sy - 1.7 - 修改用户认证状态为青少年模式
- (void)requestModifyUserAuthModelToAdolescentModel:(SuccessBlock)success;

// 人脸认证结果上传服务器
- (void)requestIDCardAuthenTicationIdCardNum:(NSString *)idcard
                                        name:(NSString *)name
                                   faceScore:(NSString *)score
                                     success:(SuccessBlock)success;

// 关注/粉丝列表
- (void)requestFollowOrFansList:(BOOL)isFollowYesOrFansNO
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;

// 上传个人的形象照+视频+声音
- (void)requestUpdateUserExtraInfoWithPhotoUrl1:(NSString *)photoUrl1
                                     photoData1:(NSData *)photoData1
                                      photoUrl2:(NSString *)photoUrl2
                                     photoData2:(NSData *)photoData2
                                      photoUrl3:(NSString *)photoUrl3
                                     photoData3:(NSData *)photoData3
                                       voiceUrl:(NSString *)voiceUrl
                                      voiceData:(NSData *)voiceData
                                  voiceDuration:(NSInteger)voiceDuration
                                        success:(void (^)(BOOL)) success;

// 关注列表
- (void)requestFollowListWithSuccess:(SuccessBlock)success
                             failure:(FailureBlock)failure;

// 关注用户
- (void)requestFollowUserWithUid:(NSString *)uid
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;

// 取消关注
- (void)requestCancelFollowUserWithUid:(NSString *)uid
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;
// 获取他人用户信息
- (void)requestOtherUserInfo:(NSString *)uid
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;

// 获取用户的关注和粉丝数
- (void)requestUserAttentionAndFansCountWithUserid:(NSString *)uid
                                           success:(SuccessBlock)success
                                           failure:(FailureBlock)failure;

//确认是否关注过
- (void)requestIsFollowed:(NSString *)uid
              finishBlock:(void(^)(BOOL))finishBlock;


/**
 获取lebz tikcet
 */
- (void)requestLebzTicket:(SuccessBlock)success
                  failure:(FailureBlock)failure;

// 过滤掉敏感词
- (void)requestFilterText:(NSString *)text uid:(NSString *)uid
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure;

// 验证是否含有敏感词
- (void)requestValidateText:(NSString *)text
                    success:(SuccessBlock)success
                    failure:(FailureBlock)failure;

- (void)requestUserApplyPropAvatarBoxWithPropId:(NSInteger)propId
                                        success:(SuccessBlock)success
                                        failure:(FailureBlock)failure;

- (void)requestUserApplyPropVehicleWithPropId:(NSInteger)propId
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure;

- (void)requestUserCancelPropAvatarBoxWithSuccess:(SuccessBlock)success
                                          failure:(FailureBlock)failure;

- (void)requestUserCancelPropVehicleWithSuccess:(SuccessBlock)success
                                        failure:(FailureBlock)failure;

/**
 系统消息列表
 */
- (void)requestSystemMsgList:(void(^)(NSArray * _Nullable))success
                     failure:(FailureBlock)failure;

// 获取guestId，获取环信账号密码
- (void)requestGuestAccountWithSuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure;

// 获取会员等级
- (void)requestVipLevelWithSuccess:(SuccessBlock)success
                           failure:(FailureBlock)failure;

// 获取会员权益
- (void)requestVipPrivilegeWithSuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure;
// 发布动态
- (void)requestSendActivityText:(NSString *)text
                      imageURLs:(NSArray <NSData *>*)imageURLs
                          video:(NSData *)videoFile
                     videoCover:(NSData *)videoCover
                       location:(NSString *)location
                       progress:(void(^)(CGFloat))progress
                        success:(SuccessBlock)success
                        failure:(FailureBlock)failure;

// 删除动态
- (void)requestDeleteActivity:(NSString *)momentId
                      success:(void(^)(BOOL))success;

// 请求用户的动态列表数据
- (void)requestUserDynamicListDataWithUserId:(NSString *)userId
                                        page:(NSInteger)page
                                     success:(SuccessBlock)success
                                     failure:(FailureBlock)failure;

// 请求动态的评论列表
- (void)requestDynamicCommentListWithMomentId:(NSString *)momentId
                                         page:(NSInteger)page
                                     pageSize:(NSInteger)pageSize
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure;

// 点赞和取消点赞
- (void)requestDynamicClickLikeWithLike:(BOOL)like
                               momentId:(NSString *)momentId
                                success:(void (^)(BOOL))success;

// 发送评论
- (void)requestDynamicAddCommentWithMomentId:(NSString *)momentId
                                     content:(NSString *)content
                                     success:(void (^)(BOOL))success;

// 删除评论
- (void)requestDynamicDeleteCommentWithCommentId:(NSString *)commentId
                                        momentId:(NSString *)momentId
                                         success:(void (^)(BOOL))success;

// 动态广场
- (void)requestDynamicSquareWithPage:(NSInteger)page
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;

// 动态关注
- (void)requestDynamicConcernListDataWithPage:(NSInteger)page
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure;

//更新用户属性，榜单隐身为toplist_invisible
- (void)updateUserProperty:(NSString *)propertyName isOpen:(BOOL)isOpen success:(void (^)(BOOL))success;
- (void)requestUserPropertyValue:(NSString *)propertyName sucess:(void (^)(BOOL))sucess failure:(FailureBlock)failure;
//真爱团相关接口
//真爱团基本信息
- (void)requestFansViewInfoWithUid:(NSString *)uid
                       andAnchorid:(NSString *)anchorid
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure;
//真爱团 团成员列表
- (void)requestFansViewMemberListWithAnchorid:(NSString *)anchorid
                                      success:(SuccessBlock)success
                                      failure:(FailureBlock)failure;
//开通、续费真爱团
- (void)openFansRightWithUid:(NSString *)uid
                 andAnchorid:(NSString *)anchorid
                  fansloveid:(NSString *)fansloveid
                   pricetype:(NSString *)pricetype
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;
//用户真爱团等级信息
- (void)requestFansViewLevelWithUid:(NSString *)uid
                        andAnchorid:(NSString *)anchorid
                            success:(SuccessBlock)success
                            failure:(FailureBlock)failure;
//修改团名称
- (void)editFansGroupNameWithGroupId:(NSString *)groupId
                         andAnchorid:(NSString *)anchorid
                                name:(NSString *)name
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
