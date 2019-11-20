//
//  SYVoiceRoomForbiddenUserListModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomUserListModel.h"

@implementation SYVoiceRoomUserListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data": [SYVoiceRoomUserModel class]};
}

@end
