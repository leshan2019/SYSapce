//
//  SYVoiceRoomOnlineListModel.m
//  Shining
//
//  Created by 杨玄 on 2019/4/24.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomOnlineListModel.h"

@implementation SYVoiceRoomOnlineListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data": [SYVoiceRoomUserModel class]};
}

@end
