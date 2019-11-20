//
//  SYVoiceRoomGift.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGift.h"

@implementation SYVoiceRoomGift

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"randomGiftId": @"from"
             };
}

@end
