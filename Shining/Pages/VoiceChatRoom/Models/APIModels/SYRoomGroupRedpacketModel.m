//
//  SYRoomGroupRedpacketModel.m
//  Shining
//
//  Created by yangxuan on 2019/9/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYRoomGroupRedpacketModel.h"

@implementation SYRoomGroupRedpacketModel

@end

@implementation SYRoomGroupRedpacketGetUserModel

@end

@implementation SYRoomGroupRedpacketGetResultModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"list": [SYRoomGroupRedpacketGetUserModel class]};
}

@end


