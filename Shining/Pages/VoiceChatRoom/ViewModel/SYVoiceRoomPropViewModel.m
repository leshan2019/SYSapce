//
//  SYVoiceRoomPropViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/30.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomPropViewModel.h"
#import "SYGiftNetManager.h"
#import "SYUserServiceAPI.h"

@interface SYVoiceRoomPropViewModel ()

@property (nonatomic, assign) NSInteger propType;
@property (nonatomic, strong) SYPropListModel *propListModel;
@property (nonatomic, strong) SYPropListModel *myPropListModel;
@property (nonatomic, strong) UserProfileEntity *userModel;
@property (nonatomic, strong) NSMutableArray *propListArray;

@end

@implementation SYVoiceRoomPropViewModel

- (instancetype)initWithPropType:(NSInteger)propType {
    self = [super init];
    if (self) {
        _propListArray = [NSMutableArray new];
        _propType = propType;
        _userModel = [UserProfileEntity getUserProfileEntity];
    }
    return self;
}

- (void)requestPropListWithSuccess:(void(^)(BOOL success))success {
    SYGiftNetManager *netManager = [[SYGiftNetManager alloc] init];
    [netManager requestPropListWithCategory_id:self.propType
                                       success:^(id  _Nullable response) {
                                           if ([response isKindOfClass:[SYPropListModel class]]) {
                                               self.propListModel = (SYPropListModel *)response;
                                               [self requestMyPropsWithPropType:self.propType
                                                                        success:success];
                                           }
                                       } failure:^(NSError * _Nullable error) {
                                           if (success) {
                                               success(NO);
                                           }
                                       }];
}

- (void)requestMyPropsWithPropType:(NSInteger)propType
                           success:(void(^)(BOOL success))success {
    SYGiftNetManager *netManager = [[SYGiftNetManager alloc] init];
    [netManager requestMyPropListWithCategory_id:propType
                                         success:^(id  _Nullable response) {
                                             self.myPropListModel = (SYPropListModel *)response;
                                             [self.propListArray removeAllObjects];
                                             NSMutableArray *propList = [NSMutableArray arrayWithArray:self.propListModel.list];
                                             for (SYPropModel *propModel in self.myPropListModel.list) {
                                                 SYPropModel *_prop = [self propModelWithPropId:propModel.propid];
                                                 if (_prop) {
                                                     [self.propListArray addObject:_prop];
                                                     [propList removeObject:_prop];
                                                 }
                                             }
                                             [self.propListArray addObjectsFromArray:propList];
                                             if (success) {
                                                 success(YES);
                                             }
                                         } failure:^(NSError * _Nullable error) {
                                             if (success) {
                                                 success(NO);
                                             }
                                         }];
}

- (void)requestUsePropAtIndex:(NSInteger)index
                      success:(void(^)(BOOL success))success {
    NSInteger propId = [self propModelAtIndex:index].propid;
    if (self.propType == 1) {
        // 头像
        [[SYUserServiceAPI sharedInstance] requestUserApplyPropAvatarBoxWithPropId:propId
                                                                           success:^(id  _Nullable response) {
                                                                               self.userModel.avatarbox = propId;
                                                                               if (success) {
                                                                                   success(YES);
                                                                               }
                                                                           } failure:^(NSError * _Nullable error) {
                                                                               if (success) {
                                                                                   success(NO);
                                                                               }
                                                                           }];
    } else {
        // 座驾
        [[SYUserServiceAPI sharedInstance] requestUserApplyPropVehicleWithPropId:propId
                                                                         success:^(id  _Nullable response) {
                                                                             self.userModel.vehicle = propId;
                                                                             if (success) {
                                                                                 success(YES);
                                                                             }
                                                                         } failure:^(NSError * _Nullable error) {
                                                                             if (success) {
                                                                                 success(NO);
                                                                             }
                                                                         }];
    }
}

- (void)requestCancelPropWithSuccess:(void(^)(BOOL success))success {
    if (self.propType == 1) {
        // 头像
        [[SYUserServiceAPI sharedInstance] requestUserCancelPropAvatarBoxWithSuccess:^(id  _Nullable response) {
                                                                               self.userModel.avatarbox = 0;
                                                                               if (success) {
                                                                                   success(YES);
                                                                               }
                                                                           } failure:^(NSError * _Nullable error) {
                                                                               if (success) {
                                                                                   success(NO);
                                                                               }
                                                                           }];
    } else {
        // 座驾
        [[SYUserServiceAPI sharedInstance] requestUserCancelPropVehicleWithSuccess:^(id  _Nullable response) {
                                                                             self.userModel.vehicle = 0;
                                                                             if (success) {
                                                                                 success(YES);
                                                                             }
                                                                         } failure:^(NSError * _Nullable error) {
                                                                             if (success) {
                                                                                 success(NO);
                                                                             }
                                                                         }];
    }
}

- (void)requestPurchasePropAtIndex:(NSInteger)index
                        priceIndex:(NSInteger)priceIndex
                           success:(void(^)(BOOL success, NSInteger errorCode))success {
    NSInteger propId = [self propModelAtIndex:index].propid;
    NSArray *priceList = [self propPriceListAtIndex:index];
    if (priceIndex >= 0 && priceIndex < priceList.count) {
        SYPropPriceModel *price = [priceList objectAtIndex:priceIndex];
        SYGiftNetManager *netManager = [[SYGiftNetManager alloc] init];
        [netManager requestPurchasePropWithPropId:propId
                                            price:price.price
                                         duration:price.duration
                                        rcvuserid:@""
                                          success:^(id  _Nullable response) {
                                              if (success) {
                                                  success(YES, 0);
                                              }
                                          } failure:^(NSError * _Nullable error) {
                                              if (success) {
                                                  success(NO, error.code);
                                              }
                                          }];
    } else {
        if (success) {
            success(NO, 9999);
        }
    }
}

- (void)requestPurchaseGiftToFriend:(NSString *)userId atIndex:(NSInteger)index priceIndex:(NSInteger)priceIndex success:(void (^)(BOOL, NSInteger))success {
    NSInteger propId = [self propModelAtIndex:index].propid;
    NSArray *priceList = [self propPriceListAtIndex:index];
    if (priceIndex >= 0 && priceIndex < priceList.count) {
        SYPropPriceModel *price = [priceList objectAtIndex:priceIndex];
        SYGiftNetManager *netManager = [[SYGiftNetManager alloc] init];
        [netManager requestPurchasePropWithPropId:propId
                                            price:price.price
                                         duration:price.duration
                                        rcvuserid:[NSString sy_safeString:userId]
                                          success:^(id  _Nullable response) {
                                              if (success) {
                                                  success(YES, 0);
                                              }
                                          } failure:^(NSError * _Nullable error) {
                                              if (success) {
                                                  success(NO, error.code);
                                              }
                                          }];
    } else {
        if (success) {
            success(NO, 9999);
        }
    }
}

- (void)checkIsMyPropsWithPropAtIndex:(NSInteger)index
                                block:(void(^)(BOOL isMine, BOOL isUse, BOOL vip, NSString *expireTime))block {
    SYPropModel *prop = [self propModelAtIndex:index];
    BOOL vip = (prop.vip_level > 0);
    if (prop) {
        BOOL isMine = NO;
        NSString *expireTime = @"30天";
        if ([prop.pricelist count] > 0) {
            SYPropPriceModel *priceModel = prop.pricelist[0];
            expireTime = [NSString stringWithFormat:@"%ld天", (long)priceModel.duration];
        }
        if (prop.vip_level > 0) {
            expireTime = @"永久";
        }
        BOOL isUse = NO;
        for (SYPropModel *propModel in self.myPropListModel.list) {
            if (propModel.propid == prop.propid) {
                isMine = YES;
                if (prop.vip_level <= 0) {
                    expireTime = propModel.expire_string;
                }
                if (self.propType == 1) {
                    isUse = (self.userModel.avatarbox == propModel.propid);
                } else {
                    isUse = (self.userModel.vehicle == propModel.propid);
                }
                break;
            }
        }
        if (block) {
            block(isMine, isUse, vip, expireTime);
        }
    } else {
        if (block) {
            block(NO, NO, vip, @"30天");
        }
    }
}

- (NSInteger)propCount {
    return [self.propListArray count];
}

- (NSString *)propNameAtIndex:(NSInteger)index {
    return [self propModelAtIndex:index].name;
}

- (NSInteger)propPriceAtIndex:(NSInteger)index {
    SYPropModel *model = [self propModelAtIndex:index];
    if (model && [model.pricelist count] > 0) {
        SYPropPriceModel *price = model.pricelist[0];
        return price.price;
    }
    return 0;
}

- (NSString *)propIconAtIndex:(NSInteger)index {
    return [self propModelAtIndex:index].icon;
}

- (NSInteger)propVipLevelAtIndex:(NSInteger)index {
    return [self propModelAtIndex:index].vip_level;
}

- (NSArray <SYPropPriceModel *>*)propPriceListAtIndex:(NSInteger)index {
    return [self propModelAtIndex:index].pricelist;
}

- (NSInteger )propIdAtIndex:(NSInteger)index {
    return [self propModelAtIndex:index].propid;
}

#pragma mark - private

- (SYPropModel *)propModelAtIndex:(NSInteger)index {
    if (index >= 0 && index < [self propCount]) {
        return [self.propListArray objectAtIndex:index];
    }
    return nil;
}

- (SYPropModel *)propModelWithPropId:(NSInteger)propId {
    for (SYPropModel *propModel in self.propListModel.list) {
        if (propModel.propid == propId) {
            return propModel;
            break;
        }
    }
    return nil;
}

- (BOOL)isUserSelf:(NSString *)userId {
    if (self.userModel) {
        return [self.userModel.userid isEqualToString:userId];
    }
    return NO;
}

@end
