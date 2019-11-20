//
//  SYGiftUserListModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/30.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGiftUserListModel.h"

@implementation SYGiftUserListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYVoiceRoomUserModel class]};
}

@end
