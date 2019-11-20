//
//  SYSearchModel.m
//  Shining
//
//  Created by 杨玄 on 2019/9/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSearchModel.h"

@implementation SYSearchModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data": [UserProfileEntity class]};
}

@end
