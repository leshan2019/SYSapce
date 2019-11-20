//
//  SYPersonHomepageViewModel.m
//  Shining
//
//  Created by 杨玄 on 2019/4/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageViewModel.h"
#import "SYUserServiceAPI.h"
#import "SYDistrictProvider.h"
#import "SYSignProvider.h"
#import "SYUserAttentionModel.h"
#import "SYVoiceChatNetManager.h"
#import "SYGiftNetManager.h"
#import "SYUserDynamicModel.h"

@interface SYPersonHomepageViewModel ()

@property (nonatomic, strong) UserProfileEntity *userModel;             // 用户基本信息model
@property (nonatomic, strong) SYUserAttentionModel *attentionModel;     // 用户关注和粉丝model
@property (nonatomic, strong) SYChatRoomModel *roomModel;              // 用户所在的房间model
@property (nonatomic, strong) NSArray *photoArr;
@property (nonatomic, strong) SYVoiceChatNetManager *netManager;
@property (nonatomic, strong) SYGiftUserListModel *fansModel;           // 主播粉丝贡献榜

@end

@implementation SYPersonHomepageViewModel

- (void)dealloc {
    NSLog(@"释放SYPersonHomepageViewModel");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userModel = nil;
        self.attentionModel = nil;
        self.roomModel = nil;
    }
    return self;
}

#pragma mark - PublicMethod

- (void)requestHomepageDataWithUserId:(NSString *)userId success:(getHomepageDataSuccess)success {
    if ([NSString sy_isBlankString:userId]) {
        success(NO);
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[SYUserServiceAPI sharedInstance] requestOtherUserInfo:userId success:^(id  _Nullable response) {
        UserProfileEntity *userModel = (UserProfileEntity *)response;
        weakSelf.userModel = userModel;
        if (userModel) {
            success(YES);
        } else {
            success(NO);
        }
    } failure:^(NSError * _Nullable error) {
        weakSelf.userModel = nil;
        success(NO);
    }];
}

- (void)requestHomepageAttentionAndFansCountWithUserId:(NSString *)userId succes:(getAttentionCountSuccess)success {
    if ([NSString sy_isBlankString:userId]) {
        success(NO);
        return;
    }
    __weak typeof(self) weakSelf = self;

    [[SYUserServiceAPI sharedInstance] requestUserAttentionAndFansCountWithUserid:userId success:^(id  _Nullable response) {
        SYUserAttentionModel *attentionModel = (SYUserAttentionModel *)response;
        weakSelf.attentionModel = attentionModel;
        if (attentionModel) {
            success(YES);
        } else {
            success(NO);
        }
    } failure:^(NSError * _Nullable error) {
        weakSelf.attentionModel = nil;
        success(NO);
    }];

}

- (void)requestHomepageUserIfHasInChatRoomWithUserId:(NSString *)userId success:(getIfInRoomSuccess)success {
    if ([NSString sy_isBlankString:userId]) {
        success(NO);
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.netManager requestUserIfHasEnterChatRoomWithUserId:userId success:^(id  _Nullable response) {
        SYChatRoomModel *model = (SYChatRoomModel *)response;
        weakSelf.roomModel = model;
        success(YES);
    } failure:^(NSError * _Nullable error) {
        weakSelf.roomModel = nil;
        success(YES);
    }];
}

- (void)requestHomepageUserFansContributionListWithUserId:(NSString *)userId success:(getFansContributionSuccess)success {
    if ([NSString sy_isBlankString:userId]) {
        success(NO);
        return;
    }
    SYGiftNetManager *manager = [SYGiftNetManager new];
    [manager requestBroadcasterFansContributionListWithid:userId range:SYGiftTimeRangeTotal pageNum:1  success:^(id  _Nullable response) {
        if (response) {
            self.fansModel = (SYGiftUserListModel *)response;
            success(YES);
        } else {
            success(NO);
        }
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];
}

// 用户model
- (UserProfileEntity *)getHomepageUserModel {
    return self.userModel;
}

- (SYChatRoomModel *)getUserEnterRoomModel {
    return self.roomModel;
}

- (NSArray *)getPhotoWallPhotoArr {
    NSString *avatar = self.userModel.avatar_imgurl;
    NSString *photo1 = self.userModel.photo_imgurl1;
    NSString *photo2 = self.userModel.photo_imgurl2;
    NSString *photo3 = self.userModel.photo_imgurl3;
    NSMutableArray *photoArr = [NSMutableArray array];
    if (![NSString sy_isBlankString:photo1] ) {
        [photoArr addObject:photo1];
    }
    if (![NSString sy_isBlankString:photo2] ) {
        [photoArr addObject:photo2];
    }
    if (![NSString sy_isBlankString:photo3] ) {
        [photoArr addObject:photo3];
    }
    if (photoArr.count > 0) {
        return photoArr;
    }
    [photoArr addObject:[NSString sy_safeString:avatar]];
    return [NSArray arrayWithArray:photoArr];
}

// 关注数
- (NSInteger)getUserAttentionCount {
    if (self.attentionModel) {
        return self.attentionModel.concern_total;
    }
    return 0;
}

// 粉丝数
- (NSInteger)getUserFansCount {
    if (self.attentionModel) {
        return self.attentionModel.fans_total;
    }
    return 0;
}

// 是否在房间中
- (BOOL)getUserIfEnterRoom {
    if (self.roomModel) {
        return YES;
    }
    return NO;
}

- (NSString *)getUserEnterRoomIcon {
    if (self.roomModel) {
        return self.roomModel.icon;
    }
    return @"";
}

- (NSString *)getUserEnterRoomName {
    if (self.roomModel) {
        return self.roomModel.name;
    }
    return @"";
}

// 用户坐标
- (NSString *)getUserLocation {
    SYDistrict *district = [[SYDistrictProvider shared] districtOfId:[self.userModel.residence_place integerValue]];
    if ([NSObject sy_empty:district]) {
        return @"保密";
    }
    return [NSString stringWithFormat:@"%@%@",district.provinceName,district.districtName];
}

// 用户星座
- (NSString *)getUserConstellation {
    NSString *sign = [[SYSignProvider shared] signOfDateString:self.userModel.birthday];
    if ([NSString sy_isBlankString:sign]) {
        sign = @"保密";
    }
    return sign;
}

// 关注
- (void)requestAttentionUserWithUserid:(NSString *)userId
                               success:(attentionUserSuccess)success {
    if ([NSString sy_isBlankString:userId]) {
        success(NO);
        return;
    }
    [[SYUserServiceAPI sharedInstance] requestFollowUserWithUid:userId success:^(id  _Nullable response) {
        success(YES);
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];
}

// 取消关注
- (void)requestCancelAttentionUserWithUserid:(NSString *)userId
                                     success:(attentionUserSuccess)success {
    if ([NSString sy_isBlankString:userId]) {
        success(NO);
        return;
    }
    [[SYUserServiceAPI sharedInstance] requestCancelFollowUserWithUid:userId success:^(id  _Nullable response) {
        success(YES);
    } failure:^(NSError * _Nullable error) {
        success(NO);
    }];
}

// 是否已经关注过用户
- (void)requestAttentionUserBefore:(NSString *)userId
                           success:(attentionUserBefore)success {
    if ([NSString sy_isBlankString:userId]) {
        success(NO);
        return;
    }
    [[SYUserServiceAPI sharedInstance] requestIsFollowed:userId finishBlock:^(BOOL attention) {
        success(attention);
    }];
}

- (NSArray *)fansContributionList {
    if (self.fansModel) {
        NSArray *list = [self.fansModel.list mutableCopy];
        if (list.count > 3) {
            return [list subarrayWithRange:NSMakeRange(0, 3)];
        }
        return list;
    }
    return nil;
}

#pragma mark - Lazyload

- (SYVoiceChatNetManager *)netManager {
    if (!_netManager) {
        _netManager = [SYVoiceChatNetManager new];
    }
    return _netManager;
}

@end
