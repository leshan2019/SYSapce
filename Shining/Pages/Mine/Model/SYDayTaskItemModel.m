//
//  SYDayTaskItemModel.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/9/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYDayTaskItemModel.h"

@implementation SYDayTaskItemModel
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
             @"taskId" : @"id",
             @"currentProgress" : @"complete_num",
             @"title" : @"name",
             @"allProgress" : @"complete_criteria",
             @"iconUrl" : @"icon",
             @"subTitle":@"rewards"
             };
}

@end
