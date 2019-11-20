//
//  SYVoiceChatRoomForbidChatViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/3/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GetForbidChatListSuccess)(BOOL success,NSInteger pageSize);
typedef void(^DeleteForbidChatListSuccess)(BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatRoomForbidChatViewModel : NSObject

@property (nonatomic, copy) NSString *channelId;

// 获取禁言列表
- (void)requestForbidChatUserListWithChannelID:(NSString *)channelID
                                          page:(NSInteger)page
                                       success:(GetForbidChatListSuccess)success;

// 获取更多禁言数据
- (void)requestMoreForbidChatUserListWithChannelId:(NSString *)channelId
                                           success:(GetForbidChatListSuccess)success;

// 取消禁言
- (void)requestCancelForbidUserChatWithChannelID:(NSString *)channelID
                                         withUid:(NSString *)uid
                                   withIndexPath:(NSIndexPath *)indexPath
                                         success:(DeleteForbidChatListSuccess)success;

- (BOOL)hasMoreData;

// cell数据
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (NSString *)headIconUrlWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)nameWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)userIdWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)bestIdWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)genderWithIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)ageWithIndexPath:(NSIndexPath *)indexPath;
- (BOOL)showSpaceLineWithIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
