//
//  SYCreateLivingRoomViewModel.h
//  Shining
//
//  Created by yangxuan on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCreateLivingRoomViewModel : NSObject

- (void)requestCategoryListWithBlock:(void(^)(BOOL success))block;

- (void)requestValidContent:(NSString *)content
                      block:(void(^)(BOOL success))block;

- (void)requestValidateImageData:(NSData *)data
                           block:(void(^)(BOOL success))block;

- (NSInteger)categoryCount;
- (NSString *)categoryStringAtIndex:(NSInteger)index;
- (NSArray *)micCountArrayAtIndex:(NSInteger)index;
- (NSInteger)categoryIDAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
