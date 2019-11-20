//
//  SYLiveRoomFansViewInfoModel.m
//  Shining
//
//  Created by leeco on 2019/11/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansViewInfoModel.h"

@implementation SYLiveRoomFansViewInfoModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"top_list": [SYLiveRoomFansViewInfoTopListModel class],
             @"pricing_list":[SYLiveRoomFansViewInfoPricingListModel class]};
}
@end
@implementation SYLiveRoomFansViewInfoTopListModel

@end
@implementation SYLiveRoomFansViewInfoPricingListModel
@end
@implementation SYLiveRoomFansViewLevelInfoModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"task_list": [SYLiveRoomFansViewTaskInfoModel class]
             };
}
@end
@implementation SYLiveRoomFansViewTaskInfoModel
@end
@implementation SYLiveRoomFansViewMemberListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{@"fansinfo": [SYLiveRoomFansViewMemberModel class],
             @"fans_list":[SYLiveRoomFansViewMemberModel class]};
}
@end

@implementation SYLiveRoomFansViewMemberModel
@end
//
//@implementation SYLiveRoomFansViewLevelModel
//+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
//    return @{@"task_list": [SYLiveRoomFansViewTaskModel class]
//             };
//}
//@end
//@implementation SYLiveRoomFansViewTaskModel
//@end
