//
//  SYCoinDetailListModel.m
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCoinDetailListModel.h"
#import "SYCoinDetailModel.h"

@implementation SYCoinDetailListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYCoinDetailModel class]};
}
@end
