//
//  SYVoiceRoomPropViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/30.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPropPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomPropViewModel : NSObject

@property (nonatomic, assign, readonly) NSInteger propType;

- (instancetype)initWithPropType:(NSInteger)propType; // propType, 1=头像框，2=座驾

- (void)requestPropListWithSuccess:(void(^)(BOOL success))success;

- (void)requestUsePropAtIndex:(NSInteger)index
                      success:(void(^)(BOOL success))success;

- (void)requestCancelPropWithSuccess:(void(^)(BOOL success))success;

- (void)requestPurchasePropAtIndex:(NSInteger)index
                        priceIndex:(NSInteger)priceIndex
                           success:(void(^)(BOOL success, NSInteger errorCode))success;

// 赠送好友头像框或者坐骑
- (void)requestPurchaseGiftToFriend:(NSString *)userId
                            atIndex:(NSInteger)index
                         priceIndex:(NSInteger)priceIndex
                            success:(void(^)(BOOL success, NSInteger errorCode))success;;

- (void)checkIsMyPropsWithPropAtIndex:(NSInteger)index
                                block:(void(^)(BOOL isMine, BOOL isUse, BOOL vip, NSString *expireTime))block;

- (NSInteger)propCount;
- (NSString *)propNameAtIndex:(NSInteger)index;
- (NSString *)propIconAtIndex:(NSInteger)index;

- (NSInteger)propPriceAtIndex:(NSInteger)index;
- (NSInteger)propVipLevelAtIndex:(NSInteger)index;
- (NSInteger )propIdAtIndex:(NSInteger)index;
- (NSArray <SYPropPriceModel *>*)propPriceListAtIndex:(NSInteger)index;

- (BOOL)isUserSelf:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
