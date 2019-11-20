//
//  SYVoiceRoomUserModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomUserModel.h"

@implementation SYVoiceRoomUserModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"id": @"userid",
             @"name": @"username",
             @"phone": @"mobile",
             @"avatar": @"avatar_imgurl",
             };
}

@end
