//
//  SYPropModel.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPropModel.h"

@implementation SYPropModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"pricelist": [SYPropPriceModel class]};
}

@end
