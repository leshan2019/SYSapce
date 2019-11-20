//
//  SYVoiceChatRoomForbidEnterViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/3/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GetForbidEnterListSuccess)(BOOL success,NSInteger pageSize);
typedef void(^DeleteForbidEnterListSuccess)(BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatRoomForbidEnterViewModel : NSObject

@property (nonatomic, copy) NSString *channelId;

// 禁入列表
- (void)requestForbidEnterUserListWithChannelID:(NSString *)channelID
                                           page:(NSInteger)page
                                        success:(GetForbidEnterListSuccess)success;

// 获取更多禁言数据
- (void)requestMoreForbidEnterUserListWithChannelId:(NSString *)channelId
                                           success:(GetForbidEnterListSuccess)success;

// 取消禁入
- (void)requestCancelForbidUserEnterWithChannelID:(NSString *)channelID
                                          withUid:(NSString *)uid
                                    withIndexPath:(NSIndexPath *)indexPath
                                          success:(DeleteForbidEnterListSuccess)success;

- (BOOL)hasMoreData;

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
