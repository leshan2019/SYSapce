//
//  SYGiftListModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGiftListModel.h"

@implementation SYGiftListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYGiftModel class]};
}

@end
