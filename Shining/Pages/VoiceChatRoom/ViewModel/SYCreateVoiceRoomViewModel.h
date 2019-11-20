//
//  SYCreateVoiceRoomViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCreateVoiceRoomViewModel : NSObject

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
