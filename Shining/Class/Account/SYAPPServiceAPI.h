//
//  SYAPPServiceAPI.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SYAPPServiceAPI : NSObject

+ (instancetype)sharedInstance;

/**
 系统消息列表
 */
- (void)requestSystemMsgList:(void(^)(NSArray * _Nullable))success
                     failure:(FailureBlock)failure;

// 图片鉴黄
- (void)requestValidateImage:(NSData *_Nonnull)imageData
                     success:(SuccessBlock _Nonnull )success
                     failure:(FailureBlock _Nonnull )failure;

- (void)requestSystemConfigWithSuccess:(SuccessBlock)success
                               failure:(FailureBlock)failure;

/**
 *  根据用户id或者用户名搜索用户
 */
- (void)requestSearchUserWithKeyword:(NSString *_Nonnull)keyword
                             success:(SuccessBlock _Nonnull )success
                             failure:(FailureBlock _Nonnull )failure;

/**
 *  声鉴用户匹配
 */
- (void)requestSoundMatch:(void(^)(NSArray * _Nullable))success
                  failure:(FailureBlock)failure;
///////////////
//声鉴题词版
-(void)requestVoiceCardWordsListWithSuccess:(SuccessBlock _Nonnull)success
                                    failure:(FailureBlock _Nonnull)failure;
//提交声鉴
-(void)uploadVoiceCardWithWordId:(NSString *_Nonnull)wordid
                         Success:(SuccessBlock _Nonnull)success
                          failure:(FailureBlock _Nonnull)failure;
//查询声鉴结果
-(void)requestVoiceCardResultWithSuccess:(SuccessBlock _Nonnull)success
                                 failure:(FailureBlock)failure;
//声鉴个人名片（增加userid可查询他人）
-(void)requestVoiceCardWithUserId:(NSString *_Nonnull)userid
                          Success:(SuccessBlock _Nonnull)success
                          failure:(FailureBlock _Nonnull)failure;
//保存个人声鉴题词版
-(void)saveVoiceCardWithWithWordId:(NSString *_Nonnull)wordid
                           Success:(SuccessBlock _Nonnull)success
                        failure:(FailureBlock _Nonnull)failure;
//用户匹配
-(void)requestVoiceCardOtherUserWithSuccess:(SuccessBlock _Nonnull)success
                                    failure:(FailureBlock _Nonnull)failure;

//开机广告图
- (void)requestLaunchAdConfigWithSuccess:(SuccessBlock)success
                                 failure:(FailureBlock)failure;

@end

