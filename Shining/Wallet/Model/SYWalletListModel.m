//
//  SYWalletModel.m
//  Shining
//
//  Created by letv_lzb on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYWalletListModel.h"

@implementation SYWalletListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"data": [SYMyWalletModel class]};
}

@end
