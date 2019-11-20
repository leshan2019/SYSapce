//
//  SYVoiceChatRoomForbidChatViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/3/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomForbidChatViewModel.h"
#import "SYVoiceChatNetManager.h"

@interface SYVoiceChatRoomForbidChatViewModel ()

@property (nonatomic, strong) SYVoiceChatNetManager *netManager;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, assign) NSInteger currentPage;            // 当前页数
@property (nonatomic, assign) NSInteger totalPage;              // 总页数

@end

@implementation SYVoiceChatRoomForbidChatViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSources = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 禁言列表

- (void)requestForbidChatUserListWithChannelID:(NSString *)channelID page:(NSInteger)page success:(GetForbidChatListSuccess)success {
    page = 1;
    self.currentPage = 1;
    self.totalPage = 1;
    __weak typeof(self)weakSelf = self;
    [self.netManager requestForbidChatUserListWithChannelID:channelID page:page success:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYVoiceRoomUserListModel class]]) {
            SYVoiceRoomUserListModel *model = (SYVoiceRoomUserListModel *)response;
            weakSelf.dataSources = [NSMutableArray arrayWithArray:model.data];

            if (weakSelf.dataSources && weakSelf.dataSources.count > 0) {
                weakSelf.currentPage = model.page;
                weakSelf.totalPage = model.pageCount;
                success(YES, weakSelf.dataSources.count);
            } else {
                success(NO, 0);
            }
        }
    } failure:^(NSError * _Nullable error) {
        success(NO, 0);
    }];
}

- (void)requestMoreForbidChatUserListWithChannelId:(NSString *)channelId success:(GetForbidChatListSuccess)success {
    if (self.currentPage >= self.totalPage) {
        success(NO, 0);
    } else {
        self.currentPage ++;
        __weak typeof(self)weakSelf = self;
        [self.netManager requestForbidChatUserListWithChannelID:channelId page:self.currentPage success:^(id  _Nullable response) {
            if ([response isKindOfClass:[SYVoiceRoomUserListModel class]]) {
                SYVoiceRoomUserListModel *model = (SYVoiceRoomUserListModel *)response;
                if (model.data.count > 0) {
                    weakSelf.currentPage = model.page;
                    weakSelf.totalPage = model.pageCount;
                    [weakSelf.dataSources addObjectsFromArray:model.data];
                    success(YES, weakSelf.dataSources.count);
                } else {
                    weakSelf.currentPage --;
                    success(NO, 0);
                }
            }
        } failure:^(NSError * _Nullable error) {
            weakSelf.currentPage --;
            success(NO, 0);
        }];
    }
}

#pragma mark - 删除禁言人

- (void)requestCancelForbidUserChatWithChannelID:(NSString *)channelID withUid:(NSString *)uid withIndexPath:(NSIndexPath *)indexPath success:(DeleteForbidChatListSuccess)success {
    __weak typeof(self)weakSelf = self;
    [self.netManager requestCancelForbidUserChatWithChannelID:channelID uid:uid success:^(id  _Nullable response) {
        NSInteger row = indexPath.row;
        if (row < weakSelf.dataSources.count) {
            [weakSelf.dataSources removeObjectAtIndex:row];
            success(YES);
        } else {
            success(NO);
        }
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];
}

#pragma mark -

- (BOOL)hasMoreData {
    if (self.currentPage < self.totalPage) {
        return YES;
    }
    return NO;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if (_dataSources && _dataSources.count > 0 )
        return _dataSources.count;
    return 0;
}

- (NSString *)headIconUrlWithIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomUserModel *model = [self _findModelWithIndexPath:indexPath];
    if (model) {
        return model.avatar;
    }
    return @"";
}

- (NSString *)nameWithIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomUserModel *model = [self _findModelWithIndexPath:indexPath];
    if (model) {
        return model.name;
    }
    return @"";
}

- (NSString *)userIdWithIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomUserModel *model = [self _findModelWithIndexPath:indexPath];
    if (model) {
        return model.id;
    }
    return @"";
}

- (NSString *)bestIdWithIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomUserModel *model = [self _findModelWithIndexPath:indexPath];
    if (model) {
        return model.bestid;
    }
    return @"0";
}

- (NSString *)genderWithIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomUserModel *model = [self _findModelWithIndexPath:indexPath];
    if (model) {
        return model.gender;
    }
    return @"unknown";
}

- (NSInteger)ageWithIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomUserModel *model = [self _findModelWithIndexPath:indexPath];
    if (model) {
        NSInteger age = [SYUtil ageWithBirthdayString:model.birthday];
        return age;
    }
    return 0;
}

- (BOOL)showSpaceLineWithIndexPath:(NSIndexPath *)indexPath {
    if (_dataSources && _dataSources.count > 0 && indexPath.row == _dataSources.count - 1) {
        return NO;
    }
    return YES;
}

#pragma mark - PrivateMethod

- (SYVoiceRoomUserModel *)_findModelWithIndexPath:(NSIndexPath*)indexPath {
    if (_dataSources && _dataSources.count > 0 && indexPath.row < _dataSources.count ) {
        SYVoiceRoomUserModel *model = _dataSources[indexPath.row];
        return model;
    }
    return nil;
}

- (SYVoiceChatNetManager *)netManager {
    if (!_netManager) {
        _netManager = [SYVoiceChatNetManager new];
    }
    return _netManager;
}

@end
