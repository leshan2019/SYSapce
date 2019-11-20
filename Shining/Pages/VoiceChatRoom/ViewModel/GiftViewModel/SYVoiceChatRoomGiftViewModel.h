//
//  SYVoiceChatRoomGiftViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kShiningGiftBagSupported [SYSettingManager voiceroomGiftBagEnable]

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatRoomGiftViewModel : NSObject

- (void)requestGiftListWithBlock:(void(^)(BOOL success))block;
// 获取礼物背包
- (void)requestGiftBagListWithBlock:(void(^)(BOOL success))block;

- (void)requestSendGiftToUser:(NSString *)uid
                       giftID:(NSInteger)giftID
                    channelID:(NSString *)channelID
                       number:(NSInteger)number
                        block:(void(^)(BOOL success, NSArray<NSDictionary *>* giftArray, NSInteger errorCode))block;

- (void)requestSendBagGiftToUser:(NSString *)uid
                          giftID:(NSInteger)giftID
                       channelID:(NSString *)channelID
                           block:(void(^)(BOOL success, NSArray<NSDictionary *>* giftArray, NSInteger errorCode))block;

- (void)requestWalletWithBlock:(void(^)(BOOL success))block;

- (NSInteger)giftGroupCount;
- (NSString *)giftGroupNameWithGroupIndex:(NSInteger)groupIndex;
- (NSInteger)giftCountAtGroupIndex:(NSInteger)groupIndex;
- (NSString *)giftNameAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)giftIconAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)giftPriceAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)giftPriceStringAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)giftIDAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)giftLevelAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)giftLevelStringAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)giftCategoryIdAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)giftBagGiftNumAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)giftMinusNumAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)giftIsMutiSendAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)walletCoinAmount;

@end

NS_ASSUME_NONNULL_END
