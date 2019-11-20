//
//  SYCommentViewModel.h
//  Shining
//
//  Created by yangxuan on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCommentViewModel : NSObject

// 请求评论列表
- (void)requestDynamicCommentListData:(NSString *)momentId
                                 page:(NSInteger)page
                              success:(void(^)(BOOL))success
                              failure:(void(^)(void))failure;

// 发送文字鉴黄
- (void)requestValidText:(NSString *)text
                 success:(void(^)(BOOL))success;

// 发送评论
- (void)requestSendComment:(NSString *)momentId
                   content:(NSString *)content
                   success:(void(^)(BOOL))success;

// 删除评论
- (void)requestDeleteComment:(NSString *)commentId
                    momentid:(NSString *)momentId
                     success:(void(^)(BOOL))success;

// 获取当前页码
- (NSInteger)getCurrentPages;

// 获取总评论数
- (NSInteger)getTotalComments;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (NSString *)avatar:(NSIndexPath *)indexPath;
- (NSString *)name:(NSIndexPath *)indexPath;
- (NSString *)gender:(NSIndexPath *)indexPath;
- (NSInteger) age:(NSIndexPath *)indexPath;
- (NSString *)title:(NSIndexPath *)indexPath;
- (NSString *)time:(NSIndexPath *)indexPath;
- (NSString *)userId:(NSIndexPath *)indexPath;
- (NSString *)commentId:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
