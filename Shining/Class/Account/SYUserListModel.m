//
//  SYUserListModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYUserListModel.h"

@implementation SYUserListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"Users": [UserProfileEntity class]};
}

@end
