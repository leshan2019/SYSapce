//
//  SYPersonHomepageFansViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/9/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageFansViewModel.h"
#import "SYGiftInfoManager.h"

@interface SYPersonHomepageFansViewModel ()

// 存放所有page的数据
@property (nonatomic, strong)NSMutableArray *pagesArr;

@end

@implementation SYPersonHomepageFansViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pagesArr = [NSMutableArray array];
    }
    return self;
}

- (void)requestFansContributionData:(SYGiftTimeRange)range page:(NSInteger)page success:(void (^)(BOOL))success failure:(nonnull void (^)())failure{
    if ([NSString sy_isBlankString:self.userId]) {
        success(NO);
        return;
    }
    if (page == 1) {
        [self.pagesArr removeAllObjects];
    }
    SYGiftNetManager *manager = [SYGiftNetManager new];
    [manager requestBroadcasterFansContributionListWithid:self.userId range:range pageNum:page  success:^(id  _Nullable response) {
        SYGiftUserListModel *model = (SYGiftUserListModel *)response;
        if (model.list && model.list.count > 0) {
            [self.pagesArr addObjectsFromArray:model.list];
            success(YES);   // 刷新数据
        } else {
            success(NO);    // 不用刷新，直接提示无更多数据
        }
    } failure:^(NSError * _Nullable error) {
        failure();          // 提示网络请求失败
    }];
}

- (NSInteger)numberOfItems {
    return self.pagesArr.count;
}

- (NSString *)userIDAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    if (model) {
        return model.id;
    }
    return @"";
}

- (NSString *)usernameAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    if (model) {
        return model.name;
    }
    return @"";
}

- (NSInteger)userAgeAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    return [SYUtil ageWithBirthdayString:model.birthday];
}

- (NSInteger)userVipLevelAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    if (model) {
        return model.level;
    }
    return 0;
}

- (NSInteger)userBroadcasterLevelAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    if (model) {
        return model.streamer_level;
    }
    return 0;
}

- (NSInteger)userIsBroadcasterAtIndex:(NSInteger)index {
    return 0;
}

- (BOOL)isGirlAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    if (model) {
        return ![model.gender isEqualToString:@"male"];
    }
    return NO;
}

- (NSString *)genderAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    if (model) {
        return model.gender;
    }
    return @"";
}

- (NSString *)avatarAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    if (model) {
        return model.avatar;
    }
    return @"";
}

- (NSString *)sumStringAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    if (model) {
        return [NSString stringWithFormat:@"%ld蜜豆",model.sum];
    }
    return @"";
}
- (NSString *)avatarBoxAtIndex:(NSInteger)index {
    SYVoiceRoomUserModel *model = [self.pagesArr objectAtIndex:index];
    if (model) {
        return [[SYGiftInfoManager sharedManager] avatarBoxURLWithPropId:model.avatarbox];
    }
    return @"";
}

@end
