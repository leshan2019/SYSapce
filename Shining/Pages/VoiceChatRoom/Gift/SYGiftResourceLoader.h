//
//  SYGiftResourceLoader.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYGiftResourceLoader : NSObject

+ (void)downloadAnimationResourceWithGiftID:(NSInteger)giftID
                                     zipURL:(NSString *)zipURL;

+ (void)downloadAnimationResourceWithPropID:(NSInteger)propID
                                     zipURL:(NSString *)zipURL;

+ (void)downloadAnimationResourceWithExpressionID:(NSInteger)giftID
                                           zipURL:(NSString *)zipURL;

+ (NSArray <UIImage *>*)giftAnimationImagesWithGiftID:(NSInteger)giftID;

+ (NSArray *)randomGiftSVGAsWithGiftID:(NSInteger)giftID;

+ (NSString *)giftSVGAWithGiftID:(NSInteger)giftID ;

+ (NSString *)propSVGAWithPropID:(NSInteger)propID;

+ (NSString *)giftAnimationAudioEffectWithGiftID:(NSInteger)giftID;

+ (NSArray <UIImage *>*)expressionAnimationImagesWithExpressionID:(NSInteger)expressionID;

@end

NS_ASSUME_NONNULL_END
