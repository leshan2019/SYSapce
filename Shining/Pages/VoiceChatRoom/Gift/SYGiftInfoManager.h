//
//  SYGiftInfoManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/27.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYGiftListModel.h"
#import "SYPropListModel.h"
#import "SYVoiceRoomExpression.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftInfoManager : NSObject

+ (instancetype)sharedManager;

- (void)updateGiftList;

- (void)fetchAllGiftListWithSuccess:(nullable void(^)(SYGiftListModel *list))success
                            failure:(nullable void(^)(NSError *error))failure;

- (void)fetchGiftListWithSuccess:(nullable void(^)(SYGiftListModel *list))success
                         failure:(nullable void(^)(NSError *error))failure;

- (void)fetchPropListWithCategory_id:(NSInteger)categoryId
                             success:(void(^)(SYPropListModel *list))success
                             failure:(void(^)(NSError *error))failure;

- (void)fetchGiftBagListWithSuccess:(nullable void(^)(SYGiftListModel *list))success
                            failure:(nullable void(^)(NSError *error))failure;

- (SYGiftModel *)giftWithGiftID:(NSInteger)giftID;

- (NSString *)avatarBoxURLWithPropId:(NSInteger)propId;

- (NSArray <UIImage *>*)giftAnimationImagesWithGiftID:(NSInteger)giftID;

- (NSArray *)randomGiftSVGAsWithGiftID:(NSInteger)giftID;

- (NSString *)giftSVGAWithGiftID:(NSInteger)giftID;

- (NSString *)propSVGAWithPropID:(NSInteger)propID;

- (NSString *)giftAnimationAudioEffectWithGiftID:(NSInteger)giftID;

- (SYVoiceRoomExpression *)expressionWithExpressionID:(NSInteger)expressionID;

- (NSArray <UIImage *>*)expressionAnimationImagesWithExpressionID:(NSInteger)expressionID;

@end

NS_ASSUME_NONNULL_END
