//
//  SYCreateRoomCategoryModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateRoomCategoryModel.h"

@implementation SYCreateRoomCategoryModel

@end

@implementation SYCreateRoomCategorySectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [SYCreateRoomCategoryModel class]
             };
}

@end
