//
//  SYDanmuListModel.m
//  Shining
//
//  Created by 杨玄 on 2019/4/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYDanmuListModel.h"
#import "SYDanmuModel.h"

@implementation SYDanmuListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYDanmuModel class]};
}

@end
