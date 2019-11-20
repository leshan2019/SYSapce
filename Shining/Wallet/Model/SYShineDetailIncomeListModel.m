//
//  SYShineDetailIncomeListModel.m
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYShineDetailIncomeListModel.h"
#import "SYShineDetailIncomeModel.h"

@implementation SYShineDetailIncomeListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYShineDetailIncomeModel class]};
}
@end
