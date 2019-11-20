//
//  SYLeaderBoardViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLeaderBoardViewModel.h"
#import "SYGiftInfoManager.h"

@interface SYLeaderBoardViewModel ()

@property (nonatomic, strong) SYGiftUserListModel *listModel;

@end

@implementation SYLeaderBoardViewModel

- (instancetype)initWithViewChannelID:(NSString *)channelID
                                 type:(SYLeaderBoardViewType)type {
    self = [super init];
    if (self) {
        _channelID = channelID;
        _type = type;
    }
    return self;
}

- (void)requestDataListWithTimeRange:(SYGiftTimeRange)range
                               block:(void(^)(BOOL success))block {
    SYGiftNetManager *netManager = [[SYGiftNetManager alloc] init];
    __weak typeof(self) weakSelf = self;
    void (^success)(id res) = ^(id res) {
        if ([res isKindOfClass:[SYGiftUserListModel class]]) {
            weakSelf.listModel = (SYGiftUserListModel *)res;
            if (block) {
                block(YES);
            }
        }
    };
    if (self.type == SYLeaderBoardViewTypeIncome) {
        [netManager requestIncomeListWithChannelID:self.channelID
                                             range:range
                                           success:^(id  _Nullable response) {
                                               success(response);
                                           } failure:^(NSError * _Nullable error) {
                                               if (block) {
                                                   block(NO);
                                               }
                                           }];
    } else {
        [netManager requestOutcomeListWithChannelID:self.channelID
                                              range:range
                                            success:^(id  _Nullable response) {
                                                success(response);
                                            } failure:^(NSError * _Nullable error) {
                                                if (block) {
                                                    block(NO);
                                                }
                                            }];
    }
}

- (NSInteger)rowCount {
    return [self.listModel.list count];
}

- (NSString *)userIDAtIndex:(NSInteger)index {
    return [self userAtIndex:index].id;
}

- (NSString *)usernameAtIndex:(NSInteger)index {
    return [self userAtIndex:index].name;
}

- (NSInteger)userAgeAtIndex:(NSInteger)index {
    return [SYUtil ageWithBirthdayString:[self userAtIndex:index].birthday];
}

- (NSInteger)userVipLevelAtIndex:(NSInteger)index {
    return [self userAtIndex:index].level;
}

- (NSInteger)userBroadcasterLevelAtIndex:(NSInteger)index {
    return [self userAtIndex:index].streamer_level;
}

- (NSInteger)userIsBroadcasterAtIndex:(NSInteger)index {
    if (self.type == SYLeaderBoardViewTypeOutcome) {
        return 0;
    }
    return [self userAtIndex:index].is_streamer;
}

- (BOOL)isGirlAtIndex:(NSInteger)index {
    return ![[self userAtIndex:index].gender isEqualToString:@"male"];
}

- (NSString *)genderAtIndex:(NSInteger)index {
    return [self userAtIndex:index].gender;
}

- (NSString *)avatarAtIndex:(NSInteger)index {
    return [self userAtIndex:index].avatar;
}

- (NSString *)sumStringAtIndex:(NSInteger)index {
    NSInteger sum = [self userAtIndex:index].sum;
    NSString *value = (self.type == SYLeaderBoardViewTypeIncome) ? @"蜜糖" : @"蜜豆";
    return [NSString stringWithFormat:@"%ld%@",(long)sum, value];
}

- (NSString *)avatarBoxAtIndex:(NSInteger)index {
    NSInteger avatarId = [self userAtIndex:index].avatarbox;
    return [[SYGiftInfoManager sharedManager] avatarBoxURLWithPropId:avatarId];
}

- (SYVoiceRoomUserModel *)userAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self.listModel.list count]) {
        SYVoiceRoomUserModel *user = self.listModel.list[index];
        return user;
    }
    return nil;
}

@end
