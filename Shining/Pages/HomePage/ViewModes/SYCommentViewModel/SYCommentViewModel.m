//
//  SYCommentViewModel.m
//  Shining
//
//  Created by yangxuan on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCommentViewModel.h"
#import "SYUserServiceAPI.h"
#import "SYUserDynamicModel.h"

@interface SYCommentViewModel ()

@property (nonatomic, strong) NSMutableArray *commentListArr;   // 评论列表数据
@property (nonatomic, assign) NSInteger currentPage;            // 当前展示的是第几页
@property (nonatomic, assign) NSInteger totalCommentNum;        // 总评论数

@end

@implementation SYCommentViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentPage = 0;
        self.commentListArr = [NSMutableArray array];
    }
    return self;
}

- (void)requestDynamicCommentListData:(NSString *)momentId page:(NSInteger)page success:(void (^)(BOOL))success failure:(nonnull void (^)(void))failure {
    if ([NSString sy_isBlankString:momentId]) {
        failure();
        return;
    }
    [[SYUserServiceAPI sharedInstance] requestDynamicCommentListWithMomentId:momentId page:page pageSize:10 success:^(id  _Nullable response) {
        SYUserCommentListModel *listModel = [SYUserCommentListModel yy_modelWithJSON:response];
        NSArray *listArr = listModel.list;
        if (listArr && listArr.count > 0) {
            self.totalCommentNum = listModel.count;
            if (page == 1) {
                self.currentPage = 1;
                [self.commentListArr removeAllObjects];
            } else {
                self.currentPage += 1;
            }
            [self.commentListArr addObjectsFromArray:listArr];
            if (success) {
                success(YES);   // 刷新数据
            }
        } else {
            if (success) {
                success(NO);    // 暂无更多数据
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (failure) {
            failure();
        }
    }];
}

- (void)requestValidText:(NSString *)text success:(void (^)(BOOL))success {
    [[SYUserServiceAPI sharedInstance] requestValidateText:text success:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            if (success) {
                success([response[@"validate"] boolValue]);
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (success) {
            success(NO);
        }
    }];
}

- (void)requestSendComment:(NSString *)momentId content:(NSString *)content success:(void (^)(BOOL))success {
    [[SYUserServiceAPI sharedInstance] requestDynamicAddCommentWithMomentId:momentId content:content success:success];
}

- (void)requestDeleteComment:(NSString *)commentId momentid:(nonnull NSString *)momentId success:(void (^)(BOOL))success {
    [[SYUserServiceAPI sharedInstance] requestDynamicDeleteCommentWithCommentId:commentId momentId:momentId success:^(BOOL deleteSuccess) {
        if (deleteSuccess) {
            if (success) {
                [self removeCurrentComment:commentId];
                self.totalCommentNum -= 1;
                if (self.totalCommentNum <= 0) {
                    self.totalCommentNum = 0;
                }
                success(YES);
            }
        } else {
            if (success) {
                success(NO);
            }
        }
    }];
}

- (void)removeCurrentComment:(NSString *)commentId {
    if (self.commentListArr.count > 0) {
        NSArray *tempArr = [self.commentListArr mutableCopy];
        SYUserCommentModel *model;
        for (int i = 0; i < tempArr.count; i++) {
            model = [tempArr objectAtIndex:i];
            if ([model.commentid isEqualToString:commentId]) {
                [self.commentListArr removeObject:model];
                break;
            }
        }
    }
}
    
- (NSInteger)getCurrentPages {
    return self.currentPage;
}

- (NSInteger)getTotalComments {
    return self.totalCommentNum;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.commentListArr.count;
}

- (SYUserCommentModel *)model:(NSIndexPath *)indexPath {
    SYUserCommentModel *model = [self.commentListArr objectAtIndex:indexPath.item];
    return model;
}

- (NSString *)avatar:(NSIndexPath *)indexPath {
    SYUserCommentModel *model = [self model:indexPath];
    if (model) {
        return model.avatar_imgurl;
    }
    return @"";
}

- (NSString *)name:(NSIndexPath *)indexPath {
    SYUserCommentModel *model = [self model:indexPath];
    if (model) {
        return model.username;
    }
    return @"";
}

- (NSString *)gender:(NSIndexPath *)indexPath {
    SYUserCommentModel *model = [self model:indexPath];
    if (model) {
        return model.gender;
    }
    return @"";
}

- (NSInteger) age:(NSIndexPath *)indexPath {
    SYUserCommentModel *model = [self model:indexPath];
    if (model) {
        return [model.birthday integerValue];
    }
    return 0;
}

- (NSString *)title:(NSIndexPath *)indexPath {
    SYUserCommentModel *model = [self model:indexPath];
    if (model) {
        return model.content;
    }
    return @"";
}

- (NSString *)time:(NSIndexPath *)indexPath {
    SYUserCommentModel *model = [self model:indexPath];
    if (model) {
        return model.create_time;
    }
    return @"";
}

- (NSString *)userId:(NSIndexPath *)indexPath {
    SYUserCommentModel *model = [self model:indexPath];
    if (model) {
        return model.userid;
    }
    return @"";
}

- (NSString *)commentId:(NSIndexPath *)indexPath {
    SYUserCommentModel *model = [self model:indexPath];
    if (model) {
        return model.commentid;
    }
    return @"";
}

@end
