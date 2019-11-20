//
//  SYVoiceChatRoomGiftViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomGiftViewModel.h"
#import "SYGiftNetManager.h"
#import "SYGiftInfoManager.h"

@interface SYVoiceChatRoomGiftViewModel ()

@property (nonatomic, strong) NSMutableArray *giftGroupArray;
@property (nonatomic, strong) SYGiftListModel *listModel;
@property (nonatomic, strong) SYWalletModel *walletModel;
@property (nonatomic, strong) SYPropListModel *propListModel;

@end

@implementation SYVoiceChatRoomGiftViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _giftGroupArray = [NSMutableArray new];
    }
    return self;
}

- (void)requestGiftListWithBlock:(void(^)(BOOL success))block {
    [[SYGiftInfoManager sharedManager] fetchGiftListWithSuccess:^(SYGiftListModel * _Nonnull list) {
        [self.giftGroupArray removeAllObjects];
        NSMutableDictionary *giftDict = [NSMutableDictionary new];
        for (SYGiftModel *giftModel in list.list) {
            NSInteger categoryId = giftModel.category_id;
            if (categoryId != 2 && categoryId != 5) {
                categoryId = 1; // 除了VIP礼物和真爱团礼物就是常规礼物
            }
            SYGiftListModel *listModel = [giftDict objectForKey:@(categoryId)];
            if (!listModel) {
                listModel = [SYGiftListModel new];
                NSArray *giftArray = [NSArray new];
                listModel.list = giftArray;
                [giftDict setObject:listModel forKey:@(categoryId)];
                listModel.categroyName = giftModel.category_name;
            }
            NSMutableArray *arr = [NSMutableArray arrayWithArray:listModel.list];
            [arr addObject:giftModel];
            listModel.list = arr;
        }
        NSArray *keys = [[giftDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSNumber *categoryId1 = (NSNumber *)obj1;
            NSNumber *categoryId2 = (NSNumber *)obj2;
            if ([categoryId1 integerValue] > [categoryId2 integerValue]) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        for (NSNumber *categoryId in keys) {
            [self.giftGroupArray addObject:[giftDict objectForKey:categoryId]];
        }
        
        if (kShiningGiftBagSupported) {
            [[SYGiftInfoManager sharedManager] fetchGiftBagListWithSuccess:^(SYGiftListModel * _Nonnull list) {
                if ([list isKindOfClass:[SYGiftListModel class]]) {
                    SYGiftListModel *listModel = (SYGiftListModel *)list;
                    listModel.categroyName = @"背包";
                    [self.giftGroupArray insertObject:listModel atIndex:0];
                }
                if (block) {
                    block(YES);
                }
            } failure:^(NSError * _Nonnull error) {
                SYGiftListModel *listModel = [SYGiftListModel new];
                listModel.categroyName = @"背包";
                [self.giftGroupArray insertObject:listModel atIndex:0];
                if (block) {
                    block(YES);
                }
            }];
        } else {
            if (block) {
                block(YES);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (block) {
            block(NO);
        }
    }];
}

- (void)requestGiftBagListWithBlock:(void(^)(BOOL success))block {
    if (kShiningGiftBagSupported) {
        [[SYGiftInfoManager sharedManager] fetchGiftBagListWithSuccess:^(SYGiftListModel * _Nonnull list) {
            if ([list isKindOfClass:[SYGiftListModel class]]) {
                if ([self.giftGroupArray count] > 0) {
                    SYGiftListModel *listModel = (SYGiftListModel *)list;
                    listModel.categroyName = @"背包";
                    [self.giftGroupArray replaceObjectAtIndex:0 withObject:listModel];
                }
            }
            if (block) {
                block(YES);
            }
        } failure:^(NSError * _Nonnull error) {
            if (block) {
                block(NO);
            }
        }];
    } else {
        if (block) {
            block(NO);
        }
    }
}

- (void)requestPropListWithBlock:(void(^)(BOOL success))block {
    [[SYGiftInfoManager sharedManager] fetchPropListWithCategory_id:2 success:^(SYPropListModel * _Nonnull list) {
        self.propListModel = list;
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nonnull error) {
        if (block) {
            block(NO);
        }
    }];
}


- (void)requestSendGiftToUser:(NSString *)uid
                       giftID:(NSInteger)giftID
                    channelID:(NSString *)channelID
                       number:(NSInteger)number
                        block:(void(^)(BOOL success, NSArray<NSDictionary *>* giftArray, NSInteger errorCode))block {
    SYGiftNetManager *netManager = [SYGiftNetManager new];
    NSArray *uidArray = [uid componentsSeparatedByString:@","];
    if ([uidArray count] > 1) {
        [netManager requestMultiSendGiftWithGiftID:giftID
                                             users:uid
                                         channelID:channelID
                                            number:number
                                           success:^(id  _Nullable response) {
                                               if ([response isKindOfClass:[NSArray class]]) {
                                                   NSMutableArray *dictArray = [NSMutableArray new];
                                                   for (SYGiftModel *giftModel in (NSArray *)response) {
                                                       [dictArray addObject:@{@"userId": giftModel.userid?:@"", @"giftId": @(giftModel.giftid), @"nums": @(giftModel.nums)}];
                                                   }
                                                   if (block) {
                                                       block(YES, dictArray, 0);
                                                   }
                                               } else {
                                                   if (block) {
                                                       block(NO, nil, 0);
                                                   }
                                               }
                                           } failure:^(NSError * _Nullable error) {
                                               if (block) {
                                                   block(NO, nil, error.code);
                                               }
                                           }];
    } else {
        [netManager requestSendGiftWithGiftID:giftID
                                       userID:uid
                                    channelID:channelID
                                       number:number
                                      success:^(id  _Nullable response) {
                                          if ([response isKindOfClass:[SYGiftModel class]]) {
                                              SYGiftModel *gift = (SYGiftModel *)response;
                                              if (block) {
                                                  block(YES, @[@{@"userId": uid, @"giftId": @(gift.giftid), @"nums": @(gift.nums)}], 0);
                                              }
                                          } else {
                                              if (block) {
                                                  block(YES, @[@{@"userId": uid, @"giftId": @(giftID), @"nums": @(number)}], 0);
                                              }
                                          }
                                      } failure:^(NSError * _Nullable error) {
                                          if (block) {
                                              block(NO, nil, error.code);
                                          }
                                      }];
    }
}

- (void)requestSendBagGiftToUser:(NSString *)uid
                          giftID:(NSInteger)giftID
                       channelID:(NSString *)channelID
                           block:(void(^)(BOOL success, NSArray<NSDictionary *>* giftArray, NSInteger errorCode))block {
    SYGiftNetManager *netManager = [SYGiftNetManager new];
    NSArray *uidArray = [uid componentsSeparatedByString:@","];
    if ([uidArray count] > 1) {
        [netManager requestMultiSendBagGiftWithGiftID:giftID
                                                users:uid
                                            channelID:channelID
                                              success:^(id  _Nullable response) {
                                                  if ([response isKindOfClass:[NSArray class]]) {
                                                      NSMutableArray *dictArray = [NSMutableArray new];
                                                      for (SYGiftModel *giftModel in (NSArray *)response) {
                                                          [dictArray addObject:@{@"userId": giftModel.userid?:@"", @"giftId": @(giftModel.giftid)}];
                                                      }
                                                      if (block) {
                                                          block(YES, dictArray, 0);
                                                      }
                                                  } else {
                                                      if (block) {
                                                          block(NO, nil, 0);
                                                      }
                                                  }
                                              } failure:^(NSError * _Nullable error) {
                                                  if (block) {
                                                      block(NO, nil, error.code);
                                                  }
                                              }];
    } else {
        [netManager requestSendBagGiftWithGiftID:giftID
                                          userID:uid
                                       channelID:channelID
                                         success:^(id  _Nullable response) {
                                             if ([response isKindOfClass:[SYGiftModel class]]) {
                                                 SYGiftModel *gift = (SYGiftModel *)response;
                                                 if (block) {
                                                     block(YES, @[@{@"userId": uid, @"giftId": @(gift.giftid)}], 0);
                                                 }
                                             } else {
                                                 if (block) {
                                                     block(YES, @[@{@"userId": uid, @"giftId": @(giftID)}], 0);
                                                 }
                                             }
                                         } failure:^(NSError * _Nullable error) {
                                             if (block) {
                                                 block(NO, nil, error.code);
                                             }
                                         }];
    }
}

- (void)requestWalletWithBlock:(void(^)(BOOL success))block {
    SYGiftNetManager *netManager = [SYGiftNetManager new];
    [netManager requestWalletWithSuccess:^(id  _Nullable response) {
        if ([response isKindOfClass:[SYWalletModel class]]) {
            self.walletModel = (SYWalletModel *)response;
        }
        if (block) {
            block(YES);
        }
    } failure:^(NSError * _Nullable error) {
        if (block) {
            block(NO);
        }
    }];
}

- (NSInteger)giftGroupCount {
    return [self.giftGroupArray count];
}

- (NSString *)giftGroupNameWithGroupIndex:(NSInteger)groupIndex {
    if (groupIndex >= 0 && groupIndex < [self.giftGroupArray count]) {
        SYGiftListModel *listModel = [self.giftGroupArray objectAtIndex:groupIndex];
        NSString *name = listModel.categroyName;
//        if ([NSString sy_isBlankString:name]) {
        if (kShiningGiftBagSupported) {
            if (groupIndex == 1) {
                name = @"礼物";
            } else if (groupIndex == 2) {
                name = @"VIP礼物";
            } else if (groupIndex == 3) {
                name = @"真爱团";
            }
        } else {
            if (groupIndex == 0) {
                name = @"礼物";
            } else if (groupIndex == 1) {
                name = @"VIP礼物";
            } else if (groupIndex == 2) {
                name = @"真爱团";
            }
        }
//        }
        return name;
    }
    return @"";
}

- (NSInteger)giftCountAtGroupIndex:(NSInteger)groupIndex {
    if (groupIndex >= 0 && groupIndex < [self.giftGroupArray count]) {
        SYGiftListModel *listModel = [self.giftGroupArray objectAtIndex:groupIndex];
        return [listModel.list count];
    }
    return 0;
}

- (NSString *)giftNameAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return gift.name;
    }
    return @"";
}

- (NSString *)giftIconAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return gift.icon;
    }
    return @"";
}
- (NSInteger)giftPriceAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return gift.price;
    }
    return 0;
}
- (NSString *)giftPriceStringAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return [NSString stringWithFormat:@"%ld蜜豆", (long)gift.price];
    }
    return @"";
}

- (NSInteger)giftIDAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return gift.giftid;
    }
    return 0;
}

- (NSInteger)giftLevelAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return gift.vip_level;
    }
    return 0;
}

- (NSString *)giftLevelStringAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift.category_id != 2) {
        return nil;
    }
    if (gift) {
        return [NSString stringWithFormat:@"%ld级", gift.vip_level];
    }
    return nil;
}

- (NSInteger)giftCategoryIdAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return gift.category_id;
    }
    return 0;
}

- (NSInteger)giftBagGiftNumAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return gift.nums;
    }
    return 0;
}

- (NSInteger)giftMinusNumAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return gift.minusNum;
    }
    return 0;
}

- (BOOL)giftIsMutiSendAtIndexPath:(NSIndexPath *)indexPath {
    SYGiftModel *gift = [self giftModelAtIndexPath:indexPath];
    if (gift) {
        return gift.multisend;
    }
    return YES;
}

- (NSInteger)walletCoinAmount {
    return self.walletModel.coin_amount;
}

#pragma mark -

- (SYGiftModel *)giftModelAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger groupIndex = indexPath.section;
    if (groupIndex >= 0 && groupIndex < [self.giftGroupArray count]) {
        SYGiftListModel *listModel = [self.giftGroupArray objectAtIndex:groupIndex];
        NSInteger item = indexPath.item;
        if (item >= 0 && item < [listModel.list count]) {
            return [listModel.list objectAtIndex:item];
        }
    }
    return nil;
}

@end
