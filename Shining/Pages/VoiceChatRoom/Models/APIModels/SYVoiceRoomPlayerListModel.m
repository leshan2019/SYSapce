//
//  SYVoiceRoomPlayerListModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomPlayerListModel.h"
//#import <YYModel/YYModel.h>

@implementation SYVoiceRoomPlayerListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
             @"jockeyList": [SYVoiceRoomPlayerModel class],
             @"playList": [SYVoiceRoomPlayerModel class],
             @"waitList": [SYVoiceRoomPlayerModel class]
             };
}

@end
