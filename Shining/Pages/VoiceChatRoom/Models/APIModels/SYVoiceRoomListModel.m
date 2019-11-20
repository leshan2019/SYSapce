//
//  SYVoiceRoomListModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomListModel.h"
//#import <YYModel/YYModel.h>

@implementation SYVoiceRoomListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data": [SYChatRoomModel class]};
}

@end
