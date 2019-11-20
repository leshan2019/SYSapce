//
//  SYPersonHomepageDynamicViewModel.h
//  Shining
//
//  Created by yangxuan on 2019/10/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYPersonHomepageDynamicViewModel : NSObject

// 请求个人动态列表
- (void)requestHomepageUserDynamicListData:(NSString *)userId
                                      page:(NSInteger)page
                                   success:(void(^)(BOOL))success
                                   failure:(void(^)(void))failure;

// 删除个人动态
- (void)requestHomepageDeleteDynamic:(NSString *)momentId
                             success:(void(^)(BOOL))success;

// 请求广场动态列表
- (void)requestHomepageSquareListWithPage:(NSInteger)page
                                  success:(void(^)(BOOL))success
                                  failure:(void(^)(void))failure;

// 点赞和取消点赞
- (void)requestDynamicClickLikeWithLike:(BOOL)like
                               momentId:(NSString *)momentId
                                 userId:(NSString *)userId
                                success:(void (^)(BOOL))success;

// 关注
- (void)requestAttentionUserWithUserid:(NSString *)userId
                              momentId:(NSString *)momentId
                               success:(void(^)(BOOL success))block;

// 请求关注动态列表
- (void)requestConcernListWithPage:(NSInteger)page
                           success:(void(^)(BOOL))success
                           failure:(void(^)(void))failure;

// 获取当前页数
- (NSInteger)getCurrentPages;

// 更新数据源的评论个数
- (void)updateDynamicCommentNum:(NSInteger)num momentId:(NSString *)momentId userId:(NSString *)userId;

// 获取所有数据count
- (NSInteger)getTotalDataCount;

// 更新当前登录的用户id
- (void)updateLoginUserId:(NSString *)userid;

// cell相关
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

// momentId
- (NSString *)momentId:(NSIndexPath *)indexPath;
// userId
- (NSString *)userId:(NSIndexPath *)indexPath;
// avatar
- (NSString *)avatar:(NSIndexPath *)indexPath;
// name
- (NSString *)name:(NSIndexPath *)indexPath;
// gender
- (NSString *)gender:(NSIndexPath *)indexPath;
// age
- (NSInteger)age:(NSIndexPath *)indexPath;
// delete
- (BOOL)canDeleteDynamic:(NSIndexPath *)indexPath;
// content
- (NSString *)title:(NSIndexPath *)indexPath;
// photos
- (NSArray *)photoArr:(NSIndexPath *)indexPath;
// videos - todo方案未定
- (NSDictionary *)videoDic:(NSIndexPath *)indexPath;
// location
- (NSString *)location:(NSIndexPath *)indexPath;
// createTime
- (NSString *)time:(NSIndexPath *)indexPath;
// hasClickLikeBtn
- (BOOL)hasClickLike:(NSIndexPath *)indexPath;
// likeNum
- (NSInteger)likeNum:(NSIndexPath *)indexPath;
// commentNum
- (NSInteger)commentNum:(NSIndexPath *)indexPath;

- (BOOL)hasConcern:(NSIndexPath *)indexPath;

- (NSInteger)streamerRoomId:(NSIndexPath *)indexPath;

- (UserProfileEntity *)userModel:(NSIndexPath *)indexPath;

- (BOOL)showGreetBtn:(NSIndexPath *)indexPath;

- (BOOL)isUserSelf:(NSIndexPath *)indexPath;

@end

