//
//  SYCoinPackageListModel.m
//  Shining
//
//  Created by letv_lzb on 2019/3/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCoinPackageListModel.h"
#import "SYCoinPackageModel.h"


@implementation SYCoinPackageListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYCoinPackageModel class]};
}

@end
