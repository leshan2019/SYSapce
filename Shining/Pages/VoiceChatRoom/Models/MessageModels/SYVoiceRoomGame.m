//
//  SYVoiceRoomGame.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGame.h"

@implementation SYVoiceRoomGame

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"type": @"id",
             @"value": @"result"
             };
}

@end
