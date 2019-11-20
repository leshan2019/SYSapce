//
//  SYUserModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYUserModel.h"

@implementation SYUserModel

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"uid" : @"id",
             @"username" : @"name",
             @"accessToken" : @"token",
             @"agoraToken" : @"TokenZb",
             };
}

@end
