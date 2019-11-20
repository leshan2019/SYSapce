//
//  SYVoiceRoomPKListModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/7/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomPKListModel.h"

@implementation SYVoiceRoomPKListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"salesDetails": [SYVoiceRoomPKModel class]};
}

@end
