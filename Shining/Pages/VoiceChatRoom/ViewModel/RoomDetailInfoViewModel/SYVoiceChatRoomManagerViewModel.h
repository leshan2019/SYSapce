//
//  SYVoiceChatRoomManagerViewModel.h
//  Shining
//
//  Created by 杨玄 on 2019/3/14.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceChatRoomManagerViewModelDelegate <NSObject>

// 获取管理员列表回调
- (void)getAdministerListDataSuccess:(BOOL)success withDataCount:(NSInteger)count;
// 添加管理员回调
- (void)addAdministerSuccess:(BOOL)success uid:(NSString *)uid errorCode:(NSInteger)errorCode;
// 删除管理员回调
- (void)deleteAdministerSuccess:(BOOL)success uid:(NSString *)uid errorCode:(NSInteger)errorCode;

@end

@interface SYVoiceChatRoomManagerViewModel : NSObject

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, weak) id <SYVoiceChatRoomManagerViewModelDelegate> delegate;

// 管理员列表
- (void)requestAdministerListWithChannelID:(NSString *)channelID page:(NSInteger)page;

// 添加管理员
- (void)requestAddAdministerWithChannelID:(NSString *)channelID
                                      uid:(NSString *)uid;
// 删除管理员
- (void)requestDeleteAdministerWithChannelID:(NSString *)channelID
                                         uid:(NSString *)uid;

// 接口是否已经请求下来数据
- (BOOL)hasAdministerListData;
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
