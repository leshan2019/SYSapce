//
//  SYVipLevelModel.m
//  Shining
//
//  Created by 杨玄 on 2019/7/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVipLevelModel.h"

@implementation SYVipLevelModel

@end

@implementation SYVipLevelListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYVipLevelModel class]};
}

@end
