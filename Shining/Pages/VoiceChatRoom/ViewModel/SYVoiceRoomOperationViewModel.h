//
//  SYVoiceRoomOperationViewModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SYVoiceRoomOperationTypeLink = 1,
    SYVoiceRoomOperationTypeLBZ,
    SYVoiceRoomOperationTypeBee,
    SYVoiceRoomOperationTypeCheckIn,
    SYVoiceRoomOperationTypeEnd,
} SYVoiceRoomOperationType;

@class SYVoiceRoomOperationModel;

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomOperationViewModel : NSObject

- (instancetype)initWithOperation:(SYVoiceRoomOperationModel *)operation;

- (SYVoiceRoomOperationType)operationType;

- (NSString *)webURL;

- (NSString *)iconURL;

- (NSString *)title;

- (NSInteger)position;

@end

NS_ASSUME_NONNULL_END
