//
//  SYVoiceRoomExpressionViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VoiceRoomExpressionCountPerRow 5
#define VoiceRoomExpressionCountPerPage 10

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomExpressionViewModel : NSObject

- (void)requestExpressionListWithBlock:(void(^)(BOOL))block;

- (NSInteger)expressionPageCount;
- (NSInteger)expressionCountWithPage:(NSInteger)page;

- (NSInteger)expressionIdWithPage:(NSInteger)page index:(NSInteger)index;
- (NSString *)expressionNameWithPage:(NSInteger)page index:(NSInteger)index;
- (NSString *)expressionIconWithPage:(NSInteger)page index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
