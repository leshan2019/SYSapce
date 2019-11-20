//
//  SYVoiceRoomHomeListModel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomHomeListModel.h"

@implementation SYVoiceRoomHomeListModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"maunal": [SYVoiceRoomHomeManualModel class],
             @"focus": [SYVoiceRoomHomeFocusModel class]};
}

@end
