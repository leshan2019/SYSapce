//
//  SYGiftNetManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYNetCommonManager.h"
#import "SYGiftListModel.h"
#import "SYWalletModel.h"
#import "SYGiftUserListModel.h"
#import "SYDanmuListModel.h"
#import "SYPropListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SYGiftTimeRangeDaily = 0,
    SYGiftTimeRangeWeekly,
    SYGiftTimeRangeTotal,
} SYGiftTimeRange;

@interface SYGiftNetManager : SYNetCommonManager

- (void)requestAllGiftListWithSuccess:(SuccessBlock)success
                              failure:(FailureBlock)failure;

- (void)requestGiftListWithSuccess:(SuccessBlock)success
                           failure:(FailureBlock)failure;
//道具列表 categoryId:1 头像框 2坐骑
- (void)requestPropListWithCategory_id:(NSInteger)categoryId
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;

- (void)requestGiftBagListWithSuccess:(SuccessBlock)success
                              failure:(FailureBlock)failure;

// 我拥有的道具列表
- (void)requestMyPropListWithCategory_id:(NSInteger)categoryId
                                 success:(SuccessBlock)success
                                 failure:(FailureBlock)failure;

- (void)requestPurchasePropWithPropId:(NSInteger)propId
                                price:(NSInteger)price
                             duration:(NSInteger)duration
                            rcvuserid:(NSString *)userId
                              success:(SuccessBlock)success
                              failure:(FailureBlock)failure;

- (void)requestSendGiftWithGiftID:(NSInteger)giftID
                           userID:(NSString *)userID
                        channelID:(NSString *)channelID
                           number:(NSInteger)number
                          success:(SuccessBlock)success
                          failure:(FailureBlock)failure;

- (void)requestMultiSendGiftWithGiftID:(NSInteger)giftID
                                 users:(NSString *)users
                             channelID:(NSString *)channelID
                                number:(NSInteger)number
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;

- (void)requestSendBagGiftWithGiftID:(NSInteger)giftID
                              userID:(NSString *)userID
                           channelID:(NSString *)channelID
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;

- (void)requestMultiSendBagGiftWithGiftID:(NSInteger)giftID
                                    users:(NSString *)users
                                channelID:(NSString *)channelID
                                  success:(SuccessBlock)success
                                  failure:(FailureBlock)failure;

- (void)requestWalletWithSuccess:(SuccessBlock)success
                         failure:(FailureBlock)failure;

- (void)requestIncomeListWithChannelID:(NSString *)channelID
                                 range:(SYGiftTimeRange)range
                               success:(SuccessBlock)success
                               failure:(FailureBlock)failure;

- (void)requestOutcomeListWithChannelID:(NSString *)channelID
                                  range:(SYGiftTimeRange)range
                                success:(SuccessBlock)success
                                failure:(FailureBlock)failure;

// 请求弹幕类型列表
- (void)requestDanmuListWithSuccess:(SuccessBlock)success
                            failure:(FailureBlock)failure;

// 发送弹幕
- (void)requestDanmuSendWithUserId:(NSString *)userId
                           danmuId:(NSInteger)danmuId
                            roomId:(NSString *)roomId
                              word:(NSString *)word
                           success:(SuccessBlock)success
                           failure:(FailureBlock)failure;

- (void)requestGetCoinWithSuccess:(SuccessBlock)success
                          failure:(FailureBlock)failure;

// 采蜜
- (void)requestBeeWithRoomId:(NSString *)roomId
                    smashnum:(NSInteger)num
                    bucketid:(NSInteger)bucketid
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;

// 采蜜 礼物列表
- (void)requestBeeWithRoomId:(NSString *)roomId
                     pagenum:(NSInteger)num
                    pagesize:(NSInteger)size
                     success:(SuccessBlock)success
                     failure:(FailureBlock)failure;

// 登录送礼物列表接口
- (void)requestLoginGiftListWithSuccess:(SuccessBlock)success
                             failure:(FailureBlock)failure;

// 登录送礼物领取接口
- (void)requestLoginGiftGetWithSuccess:(SuccessBlock)success;

// 1.7 主播个人粉丝贡献榜
- (void)requestBroadcasterFansContributionListWithid:(NSString *)userId
                                               range:(SYGiftTimeRange)range
                                             pageNum:(NSInteger)page
                                             success:(SuccessBlock)success
                                             failure:(FailureBlock)failure;

//每日任务列表
- (void)requestDayTaskListWithSuccess:(SuccessBlock)success
                              failure:(FailureBlock)failure;

- (void)requestDayTaskRewardWithTaskId:(NSString *)taskid
                                finish:(void(^)(BOOL))finishBlock;

- (void)dailyTaskLog:(NSInteger)task_type;

- (void)dailyTaskLog:(NSInteger)task_type
          withGiftId:(NSInteger)giftId
         withGiftNum:(NSInteger)giftNum;

//我的蜜糖收入
- (void)requestMyIncomeWithSuccess:(SuccessBlock)success
                           failure:(FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
