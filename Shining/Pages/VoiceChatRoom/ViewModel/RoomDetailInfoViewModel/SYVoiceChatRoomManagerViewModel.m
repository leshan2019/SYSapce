//
//  SYVoiceChatRoomManagerViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/3/14.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomManagerViewModel.h"
#import "SYVoiceChatNetManager.h"

@interface SYVoiceChatRoomManagerViewModel ()

@property (nonatomic, strong) SYVoiceChatNetManager *netManager;
@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation SYVoiceChatRoomManagerViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - 请求管理员列表数据

- (void)requestAdministerListWithChannelID:(NSString *)channelID page:(NSInteger)page {
    __weak __typeof(self)weakSelf = self;
    [self.netManager requestAdministerListWithChannelID:channelID page:page success:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYVoiceRoomUserListModel class]]) {
            SYVoiceRoomUserListModel *model = (SYVoiceRoomUserListModel *)response;
            weakSelf.dataSources = [NSMutableArray arrayWithArray:model.data];
            if (weakSelf.dataSources) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getAdministerListDataSuccess:withDataCount:)]) {
                    [weakSelf.delegate getAdministerListDataSuccess:YES withDataCount:weakSelf.dataSources.count];
                }
            } else {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getAdministerListDataSuccess:withDataCount:)]) {
                    [weakSelf.delegate getAdministerListDataSuccess:false withDataCount:0];
                }
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getAdministerListDataSuccess:withDataCount:)]) {
            [weakSelf.delegate getAdministerListDataSuccess:false withDataCount:0];
        }
    }];
}

#pragma mark - 添加&删除管理员

- (void)requestAddAdministerWithChannelID:(NSString *)channelID uid:(NSString *)uid {
    __weak __typeof(self)weakSelf = self;
    [self.netManager requestAddAdministerWithChannelID:channelID uid:uid success:^(id  _Nullable response) {
        [weakSelf requestAdministerListWithChannelID:self.channelId page:1];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addAdministerSuccess:uid:errorCode:)]) {
            [weakSelf.delegate addAdministerSuccess:YES uid:uid errorCode:0];
        }
    } failure:^(NSError * _Nullable error) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addAdministerSuccess:uid:errorCode:)]) {
            [weakSelf.delegate addAdministerSuccess:NO uid:uid errorCode:error.code];
        }
    }];
}

- (void)requestDeleteAdministerWithChannelID:(NSString *)channelID uid:(NSString *)uid {
    __weak __typeof(self)weakSelf = self;
    [self.netManager requestDeleteAdministerWithChannelID:channelID uid:uid success:^(id  _Nullable response) {
        [weakSelf requestAdministerListWithChannelID:self.channelId page:1];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(deleteAdministerSuccess:uid:errorCode:)]) {
            [weakSelf.delegate deleteAdministerSuccess:YES uid:uid errorCode:0];
        }
    } failure:^(NSError * _Nullable error) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(deleteAdministerSuccess:uid:errorCode:)]) {
            [weakSelf.delegate deleteAdministerSuccess:NO uid:uid errorCode:error.code];
        }
    }];
}

#pragma mark - PrivateMethod

- (SYVoiceRoomUserModel *)_findModelWithIndexPath:(NSIndexPath*)indexPath {
    if (_dataSources && _dataSources.count > 0 && indexPath.row < _dataSources.count ) {
        SYVoiceRoomUserModel *model = _dataSources[indexPath.row];
        return model;
    }
    return nil;
}

#pragma mark - Public

- (BOOL)hasAdministerListData {
    if (self.dataSources && self.dataSources.count > 0) {
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

- (SYVoiceChatNetManager *)netManager {
    if (!_netManager) {
        _netManager = [SYVoiceChatNetManager new];
    }
    return _netManager;
}

@end
