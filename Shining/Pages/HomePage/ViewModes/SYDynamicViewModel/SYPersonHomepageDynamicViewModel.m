//
//  SYPersonHomepageDynamicViewModel.m
//  Shining
//
//  Created by yangxuan on 2019/10/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageDynamicViewModel.h"
#import "SYUserDynamicModel.h"
#import "SYUserServiceAPI.h"

@interface SYPersonHomepageDynamicViewModel ()

// 动态数据源
@property (nonatomic, strong) NSMutableArray *dynamicListArr;
@property (nonatomic, assign) NSInteger currentPage;            // 当前展示的是第几页

// 当前登录用户的userid
@property (nonatomic, strong) NSString *currentUserId;

@end

@implementation SYPersonHomepageDynamicViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
        self.currentUserId = userInfo.userid;
        self.currentPage = 0;
        self.dynamicListArr = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Request

- (void)requestHomepageUserDynamicListData:(NSString *)userId page:(NSInteger)page success:(void (^)(BOOL))success failure:(void (^)(void))failure {
    if ([NSString sy_isBlankString:userId]) {
        failure();
        return;
    }
    [[SYUserServiceAPI sharedInstance] requestUserDynamicListDataWithUserId:userId page:page success:^(id  _Nullable response) {
        SYUserDynamicListModel *listModel = [SYUserDynamicListModel yy_modelWithJSON:response];
        NSArray *listArr = listModel.list;
        if (listArr && listArr.count > 0) {
            if (page == 1) {
                self.currentPage = 1;
                [self.dynamicListArr removeAllObjects];
            } else {
                self.currentPage += 1;
            }
            [self.dynamicListArr addObjectsFromArray:listArr];
            if (success) {
                success(YES);   // 刷新数据
            }
        } else {
            if (page == 1) {
                [self.dynamicListArr removeAllObjects];
            }
            if (success) {
                success(NO);    // 暂无数据
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (page == 1) {
            [self.dynamicListArr removeAllObjects];
        }
        if (failure) {
            failure();
        }
    }];
}

// 删除动态
- (void)requestHomepageDeleteDynamic:(NSString *)momentId success:(void (^)(BOOL))success {
    [[SYUserServiceAPI sharedInstance] requestDeleteActivity:momentId success:^(BOOL deleteSuccess) {
        if (deleteSuccess) {
            [self deleteDynamicData:momentId];
            if (success) {
                success(YES);
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    }];
}

- (void)requestHomepageSquareListWithPage:(NSInteger)page
                                  success:(void(^)(BOOL))success
                                  failure:(void(^)(void))failure {
    [[SYUserServiceAPI sharedInstance] requestDynamicSquareWithPage:page
                                                            success:^(id  _Nullable response) {
        
        NSArray *listArr = [NSArray yy_modelArrayWithClass:[SYUserDynamicModel class]
                                                      json:response];
        if (listArr && listArr.count > 0) {
            if (page == 1) {
                self.currentPage = 1;
                [self.dynamicListArr removeAllObjects];
            } else {
                self.currentPage += 1;
            }
            [self.dynamicListArr addObjectsFromArray:listArr];
            if (success) {
                success(YES);   // 刷新数据
            }
        } else {
            if (page == 1) {
                [self.dynamicListArr removeAllObjects];
            }
            if (success) {
                success(NO);    // 暂无数据
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (page == 1) {
            [self.dynamicListArr removeAllObjects];
        }
        if (failure) {
            failure();
        }
    }];
}

- (void)requestDynamicClickLikeWithLike:(BOOL)like momentId:(NSString *)momentId userId:(NSString *)userId success:(void (^)(BOOL))success {
    [[SYUserServiceAPI sharedInstance] requestDynamicClickLikeWithLike:like momentId:momentId success:^(BOOL result) {
        if (success) {
            success(result);
        }
        if (result) {
            [self updateDynamicLike:like momentId:momentId userId:userId];
        }
    }];
}

- (void)requestAttentionUserWithUserid:(NSString *)userId momentId:(NSString *)momentId success:(void (^)(BOOL))block {
    if ([NSString sy_isBlankString:userId]) {
        block(NO);
        return;
    }
    [[SYUserServiceAPI sharedInstance] requestFollowUserWithUid:userId success:^(id  _Nullable response) {
        [self updateDynamicConcern:YES userId:userId momentId:momentId];
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}

- (void)requestConcernListWithPage:(NSInteger)page success:(void (^)(BOOL))success failure:(void (^)(void))failure {
    [[SYUserServiceAPI sharedInstance] requestDynamicConcernListDataWithPage:page success:^(id  _Nullable response) {
        NSArray *listArr = [NSArray yy_modelArrayWithClass:[SYUserDynamicModel class]
                                                      json:response];
        if (listArr && listArr.count > 0) {
            if (page == 1) {
                self.currentPage = 1;
                [self.dynamicListArr removeAllObjects];
            } else {
                self.currentPage += 1;
            }
            [self.dynamicListArr addObjectsFromArray:listArr];
            if (success) {
                success(YES);   // 刷新数据
            }
        } else {
            if (page == 1) {
                [self.dynamicListArr removeAllObjects];
            }
            if (success) {
                success(NO);    // 暂无数据
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (page == 1) {
            [self.dynamicListArr removeAllObjects];
        }
        if (failure) {
            failure();
        }
    }];
}

#pragma mark - Private

// 删除动态model
- (void)deleteDynamicData:(NSString *)momentId {
    if (self.dynamicListArr.count > 0) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.dynamicListArr];
        SYUserDynamicModel *model = nil;
        for (int i = 0; i < tempArr.count; i++) {
            model = [tempArr objectAtIndex:i];
            if ([model.momentsid isEqualToString:momentId]) {
                [self.dynamicListArr removeObject:model];
                break;
            }
        }
    }
}

// 更新数据源中是否点赞字段 - like
- (void)updateDynamicLike:(BOOL)like momentId:(NSString *)momentid userId:(NSString *)userId {
    if (self.dynamicListArr.count > 0) {
        SYUserDynamicModel *model = nil;
        for (int i = 0; i < self.dynamicListArr.count; i++) {
            model = [self.dynamicListArr objectAtIndex:i];
            if ([model.momentsid isEqualToString:momentid] && [model.userid isEqualToString:userId]) {
                model.like = like;
                NSInteger num = model.like_quantity;
                if (like) {
                    num += 1;
                } else {
                    num -= 1;
                    if (num < 0) {
                        num = 0;
                    }
                }
                model.like_quantity = num;
                break;
            }
        }
    }
}

// 更新数据源中是否关注字段 - is_concern
- (void)updateDynamicConcern:(BOOL)isConcern userId:(NSString *)userId momentId:(NSString *)momentid {
    if (self.dynamicListArr.count > 0) {
        SYUserDynamicModel *model = nil;
        for (int i = 0; i < self.dynamicListArr.count; i++) {
            model = [self.dynamicListArr objectAtIndex:i];
            if ([model.momentsid isEqualToString:momentid] && [model.userid isEqualToString:userId]) {
                model.is_concern = isConcern;
                break;
            }
        }
    }
}

#pragma mark - Public

- (void)updateLoginUserId:(NSString *)userid {
    self.currentUserId = userid;
}

// 更新数据源中评论个数
- (void)updateDynamicCommentNum:(NSInteger)num momentId:(NSString *)momentId userId:(NSString *)userId {
    if (self.dynamicListArr.count > 0) {
        SYUserDynamicModel *model = nil;
        for (int i = 0; i < self.dynamicListArr.count; i++) {
            model = [self.dynamicListArr objectAtIndex:i];
            if ([model.momentsid isEqualToString:momentId] && [model.userid isEqualToString:userId]) {
                model.comment_quantity = num;
                break;
            }
        }
    }
}

- (NSInteger)getCurrentPages {
    return self.currentPage;
}

- (NSInteger)getTotalDataCount {
    return self.dynamicListArr.count;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if (self.dynamicListArr) {
        return self.dynamicListArr.count;
    }
    return 0;
}

- (SYUserDynamicModel *)modelWithIndexPath:(NSIndexPath *)indexPath {
    id model = [self.dynamicListArr objectAtIndex:indexPath.item];
    if (model && [model isKindOfClass:[SYUserDynamicModel class]]) {
        return model;
    }
    return nil;
}

- (NSString *)momentId:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.momentsid;
    }
    return @"";
}

- (NSString *)userId:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.userid;
    }
    return @"";
}

- (NSString *)avatar:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.userinfo.avatar_imgurl;
    }
    return @"";
}

- (NSString *)name:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.userinfo.username;
    }
    return @"";
}

- (NSString *)gender:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.userinfo.gender;
    }
    return @"";
}

- (NSInteger)age:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return [SYUtil ageWithBirthdayString:model.userinfo.birthday];
    }
    return 0;
}

- (BOOL)canDeleteDynamic:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        NSString *userId = model.userid;
        return [userId isEqualToString:self.currentUserId];
    }
    return NO;
}

- (NSString *)title:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.content;
    }
    return @"";
}

- (NSArray *)photoArr:(NSIndexPath *)indexPath {
    NSMutableArray *photoArr = [NSMutableArray array];
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        if (model.pic_1.length > 0) {
            [photoArr addObject:model.pic_1];
        }
        if (model.pic_2.length > 0) {
            [photoArr addObject:model.pic_2];
        }
        if (model.pic_3.length > 0) {
            [photoArr addObject:model.pic_3];
        }
        if (model.pic_4.length > 0) {
            [photoArr addObject:model.pic_4];
        }
        if (model.pic_5.length > 0) {
            [photoArr addObject:model.pic_5];
        }
        if (model.pic_6.length > 0) {
            [photoArr addObject:model.pic_6];
        }
        if (model.pic_7.length > 0) {
            [photoArr addObject:model.pic_7];
        }
        if (model.pic_8.length > 0) {
            [photoArr addObject:model.pic_8];
        }
        if (model.pic_9.length > 0) {
            [photoArr addObject:model.pic_9];
        }
    }
    return photoArr;
}

- (NSDictionary *)videoDic:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model && model.video.length > 0 && model.video_cover.length > 0) {
        return @{SYDynamicVideoUrl: model.video,
                 SYDynamicVideoCover: model.video_cover
        };
    }
    return nil;
}

- (NSString *)location:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.position;
    }
    return @"";
}

- (NSString *)time:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.create_time;
    }
    return @"";
}

- (BOOL)hasClickLike:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.like;
    }
    return NO;
}

- (NSInteger)likeNum:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.like_quantity;
    }
    return 0;
}

- (NSInteger)commentNum:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.comment_quantity;
    }
    return 0;
}

- (BOOL)hasConcern:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.is_concern;
    }
    return NO;
}

- (NSInteger)streamerRoomId:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.streamer_roomid;
    }
    return 0;
}

- (UserProfileEntity *)userModel:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model) {
        return model.userinfo;
    }
    return nil;
}

- (BOOL)showGreetBtn:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model && [model.userid isEqualToString:self.currentUserId]) {
        return NO;
    }
    return YES;
}

- (BOOL)isUserSelf:(NSIndexPath *)indexPath {
    SYUserDynamicModel *model = [self modelWithIndexPath:indexPath];
    if (model && [model.userid isEqualToString:self.currentUserId]) {
        return YES;
    }
    return NO;
}

@end
