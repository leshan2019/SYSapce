//
//  SYLiveRoomFansViewInfoModel.h
//  Shining
//
//  Created by leeco on 2019/11/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SYLiveRoomFansViewInfoTopListModel;
@class SYLiveRoomFansViewInfoPricingListModel;
@class SYLiveRoomFansViewTaskInfoModel;
@class SYLiveRoomFansViewMemberModel;
@class SYLiveRoomFansViewMemberListModel;
@class SYLiveRoomFansViewTaskModel;
NS_ASSUME_NONNULL_BEGIN

@interface SYLiveRoomFansViewInfoModel : NSObject<YYModel>
@property(nonatomic,strong)NSString*id;//真爱团ID
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*image;
@property(nonatomic,strong)NSString*number;
@property(nonatomic,strong)NSString*level;
@property(nonatomic,strong)NSString*status;//用户开通真爱团状态，1开通。0，没有开通
@property(nonatomic,strong)NSString*expired;//过期时间
@property(nonatomic,strong)NSArray<SYLiveRoomFansViewInfoTopListModel*>*top_list;//真爱团粉丝前三用于渲染进入接口
@property(nonatomic,strong)NSArray<SYLiveRoomFansViewInfoPricingListModel*>*pricing_list;//套餐列表
@end
@interface SYLiveRoomFansViewInfoTopListModel : NSObject
@property(nonatomic,strong)NSString*avatar_imgurl;

@end
@interface SYLiveRoomFansViewInfoPricingListModel : NSObject
@property(nonatomic,strong)NSString*name;
@end
@interface SYLiveRoomFansViewLevelInfoModel : NSObject<YYModel>
@property(nonatomic,strong)NSString*level;//当前等级
@property(nonatomic,strong)NSString*gift_unlock;//解锁礼物说明
@property(nonatomic,strong)NSArray<SYLiveRoomFansViewTaskInfoModel*>*task_list;//任务列表
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*uid;
@property(nonatomic,strong)NSString*avatar_image;
@property(nonatomic,strong)NSString*close_score;
@property(nonatomic,strong)NSString*next_level_score;
@property(nonatomic,strong)NSString*expired_time;

@end
@interface SYLiveRoomFansViewTaskInfoModel : NSObject
@property(nonatomic,strong)NSString*id;
@property(nonatomic,strong)NSString*task_type;//任务类型 1-观看直播任务 2-公屏评论任务 3-关注主播任务 4-分享直播间任务 5-打赏任务
@property(nonatomic,strong)NSString*complete_criteria;//完成任务需要的数量
@property(nonatomic,strong)NSString*rewards;//奖励
@property(nonatomic,strong)NSString*icon;//任务icon
@property(nonatomic,strong)NSString*name;//任务名称
@property(nonatomic,strong)NSString*complete_num;//当前完成数量
@property(nonatomic,strong)NSString*status;
@property(nonatomic,strong)NSString*action;//动作类型
@property(nonatomic,strong)NSString*des;//副标题
@end
////
@interface SYLiveRoomFansViewMemberListModel : NSObject<YYModel>
@property(nonatomic,strong)NSString*id;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*image;
@property(nonatomic,strong)NSString*nmuber;
@property(nonatomic,strong)NSString*jifen;
@property(nonatomic,strong)SYLiveRoomFansViewMemberModel*fansinfo;
@property(nonatomic,strong)NSArray<SYLiveRoomFansViewMemberModel*>*fans_list;
@end
@interface SYLiveRoomFansViewMemberModel : NSObject
@property(nonatomic,strong)NSString*uid;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*avatar_image;
@property(nonatomic,strong)NSString*close_score;
@property(nonatomic,strong)NSString*rank;
@property(nonatomic,strong)NSString*expired_time;
@property(nonatomic,strong)NSString*level;
@property(nonatomic,strong)NSString*next_level_score_left;
@property(nonatomic,strong)NSString*next_level_score;
@end
//
//@interface SYLiveRoomFansViewLevelModel : NSObject<YYModel>
//@property(nonatomic,strong)NSString*name;
//@property(nonatomic,strong)NSString*uid;
//@property(nonatomic,strong)NSString*avatar_image;
//@property(nonatomic,strong)NSString*level;
//@property(nonatomic,strong)NSString*close_score;
//@property(nonatomic,strong)NSString*next_level_score;
//@property(nonatomic,strong)NSString*expired_time;
//@property(nonatomic,strong)NSString*gift_unlock;
//@property(nonatomic,strong)NSArray<SYLiveRoomFansViewTaskModel*>*task_list;
//@end
//@interface SYLiveRoomFansViewTaskModel : NSObject
//@property(nonatomic,strong)NSString*id;
//@property(nonatomic,strong)NSString*task_type;
//@property(nonatomic,strong)NSString*complete_criteria;
//@property(nonatomic,strong)NSString*rewards;
//@property(nonatomic,strong)NSString*icon;
//@property(nonatomic,strong)NSString*name;
//@property(nonatomic,strong)NSString*complete_num;
//@property(nonatomic,strong)NSString*status;
//@property(nonatomic,strong)NSString*action;
//@property(nonatomic,strong)NSString*des;
//@end
NS_ASSUME_NONNULL_END
