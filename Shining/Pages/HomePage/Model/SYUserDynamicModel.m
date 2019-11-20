//
//  SYUserDynamicModel.m
//  Shining
//
//  Created by yangxuan on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYUserDynamicModel.h"

@implementation SYUserDynamicModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"userinfo" : [UserProfileEntity class] };
}

@end

@implementation SYUserDynamicListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [SYUserDynamicModel class] };
}

@end

@implementation SYUserCommentModel

@end

@implementation SYUserCommentListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [SYUserCommentModel class] };
}

@end


