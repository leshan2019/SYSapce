//
//  SYGiftInfoManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/27.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGiftInfoManager.h"
#import "SYGiftNetManager.h"
#import "SYGiftResourceLoader.h"
#import "SYVoiceChatNetManager.h"

@interface SYGiftInfoManager ()

@property (nonatomic, strong) SYGiftListModel *listModel;
@property (nonatomic, strong) SYPropListModel *propListModel;
@property (nonatomic, strong) SYPropListModel *avatarBoxListModel;
@property (nonatomic, strong) NSArray *expressionList;

@end

@implementation SYGiftInfoManager

+ (instancetype)sharedManager {
    static SYGiftInfoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SYGiftInfoManager alloc] init];
    });
    return manager;
}

- (void)updateGiftList {
    [self fetchAllGiftListWithSuccess:nil
                              failure:nil];
    [self fetchPropListWithCategory_id:2 success:nil failure:nil];
    [self fetchPropListWithCategory_id:1 success:nil failure:nil];
    [self fetchExpressionList];
}

- (void)fetchAllGiftListWithSuccess:(nullable void(^)(SYGiftListModel *list))success
                            failure:(nullable void(^)(NSError *error))failure {
    __weak typeof(self) weakSelf = self;
    SYGiftNetManager *netManager = [SYGiftNetManager new];
    [netManager requestAllGiftListWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYGiftListModel class]]) {
            weakSelf.listModel = (SYGiftListModel *)response;
            if (success) {
                success(weakSelf.listModel);
            }
            [weakSelf handleGiftResources];
        }
    } failure:^(NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)fetchGiftListWithSuccess:(void(^)(SYGiftListModel *list))success
                         failure:(void(^)(NSError *error))failure {
    SYGiftNetManager *netManager = [SYGiftNetManager new];
    [netManager requestGiftListWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYGiftListModel class]]) {
            SYGiftListModel *giftList = (SYGiftListModel *)response;
            if (success) {
                success(giftList);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)fetchGiftBagListWithSuccess:(nullable void(^)(SYGiftListModel *list))success
                            failure:(nullable void(^)(NSError *error))failure {
    SYGiftNetManager *netManager = [SYGiftNetManager new];
    [netManager requestGiftBagListWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYGiftListModel class]]) {
            if (success) {
                success(response);
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)fetchPropListWithCategory_id:(NSInteger)categoryId
                             success:(void(^)(SYPropListModel *list))success
                             failure:(void(^)(NSError *error))failure {
    __weak typeof(self) weakSelf = self;
    SYGiftNetManager *netManager = [SYGiftNetManager new];
    [netManager requestPropListWithCategory_id:categoryId success:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYPropListModel class]]) {
            if (categoryId == 1) {
                weakSelf.avatarBoxListModel = (SYPropListModel *)response;
            } else {
                weakSelf.propListModel = (SYPropListModel *)response;
            }
            if (success) {
                success((SYPropListModel *)response);
            }
            if (categoryId == 2) {
                [weakSelf handPropResources];
            }
        }
    } failure:^(NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];

}

- (void)fetchExpressionList {
    __weak typeof(self) weakSelf = self;
    SYVoiceChatNetManager *netManager = [SYVoiceChatNetManager new];
    [netManager requestExpressionListWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSArray class]]) {
            weakSelf.expressionList = (NSArray *)response;
            [weakSelf handleExpressionResources];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}

- (SYGiftModel *)giftWithGiftID:(NSInteger)giftID {
    SYGiftModel *ret = nil;
    if (self.listModel) {
        for (SYGiftModel *gift in self.listModel.list) {
            if (gift.giftid == giftID) {
                ret = gift;
                break;
            }
        }
    }
    return ret;
}

- (SYVoiceRoomExpression *)expressionWithExpressionID:(NSInteger)expressionID {
    SYVoiceRoomExpression *ret = nil;
    if (self.expressionList) {
        for (SYVoiceRoomExpression *expression in self.expressionList) {
            if (expression.id == expressionID) {
                ret = expression;
                break;
            }
        }
    }
    return ret;
}

- (NSString *)avatarBoxURLWithPropId:(NSInteger)propId {
    NSString *ret = @"";
    if (self.avatarBoxListModel) {
        for (SYPropModel *propModel in [self.avatarBoxListModel.list copy]) {
            if (propModel.propid == propId) {
                ret = propModel.icon;
            }
        }
    }
    return ret;
}

- (NSArray <UIImage *>*)giftAnimationImagesWithGiftID:(NSInteger)giftID {
    return [SYGiftResourceLoader giftAnimationImagesWithGiftID:giftID];
}

- (NSString *)giftAnimationAudioEffectWithGiftID:(NSInteger)giftID {
    return [SYGiftResourceLoader giftAnimationAudioEffectWithGiftID:giftID];
}

- (NSArray *)randomGiftSVGAsWithGiftID:(NSInteger)giftID {
    return [SYGiftResourceLoader randomGiftSVGAsWithGiftID:giftID];
}

- (NSString *)giftSVGAWithGiftID:(NSInteger)giftID{
    return [SYGiftResourceLoader giftSVGAWithGiftID:giftID];
}

- (NSString *)propSVGAWithPropID:(NSInteger)propID{
    return [SYGiftResourceLoader propSVGAWithPropID:propID];
}

- (NSArray <UIImage *>*)expressionAnimationImagesWithExpressionID:(NSInteger)expressionID {
    return [SYGiftResourceLoader expressionAnimationImagesWithExpressionID:expressionID];
}

- (void)handleGiftResources {
    for (SYGiftModel *gift in self.listModel.list) {
        [SYGiftResourceLoader downloadAnimationResourceWithGiftID:gift.giftid
                                                           zipURL:gift.animation];
    }
}

- (void)handPropResources {
    for (SYPropModel *prop in self.propListModel.list) {
        [SYGiftResourceLoader downloadAnimationResourceWithPropID:prop.propid
                                                           zipURL:prop.animation];
    }
}

- (void)handleExpressionResources {
    for (SYVoiceRoomExpression *expression in self.expressionList) {
        [SYGiftResourceLoader downloadAnimationResourceWithExpressionID:expression.id
                                                                 zipURL:expression.animation];
    }
}

@end
