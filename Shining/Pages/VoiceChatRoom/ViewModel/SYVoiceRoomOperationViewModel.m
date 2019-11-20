//
//  SYVoiceRoomOperationViewModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomOperationViewModel.h"
#import "SYVoiceRoomOperationModel.h"

@interface SYVoiceRoomOperationViewModel ()

@property (nonatomic, strong) SYVoiceRoomOperationModel *operation;

@end

@implementation SYVoiceRoomOperationViewModel

- (instancetype)initWithOperation:(SYVoiceRoomOperationModel *)operation {
    self = [super init];
    if (self) {
        _operation = operation;
    }
    return self;
}

- (SYVoiceRoomOperationType)operationType {
    return (SYVoiceRoomOperationType)self.operation.type;
}

- (NSString *)webURL {
    return self.operation.jumplink;
}

- (NSString *)iconURL {
    return self.operation.image;
}

- (NSString *)title {
    return self.operation.title;
}

- (NSInteger)position {
    return self.operation.position;
}

@end
