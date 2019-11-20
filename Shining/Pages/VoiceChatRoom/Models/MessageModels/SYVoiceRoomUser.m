//
//  SYVoiceRoomUser.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomUser.h"

@implementation SYVoiceRoomUser

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"uid": @"userid",
             @"phone": @"mobile",
             @"icon": @"avatar_imgurl",
             @"avatarBox": @"avatarbox"
             };
}

@end
