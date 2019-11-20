//
//  SYPropListModel.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPropListModel.h"

@implementation SYPropListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYPropModel class]};
}
@end
