//
//  SYVipPrivilegeModel.m
//  Shining
//
//  Created by 杨玄 on 2019/7/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVipPrivilegeModel.h"

@implementation SYVipPrivilegeModel

@end

@implementation SYVipPrivilegeListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYVipPrivilegeModel class]};
}
@end
