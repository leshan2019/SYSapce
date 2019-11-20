//
//  SYRoomGroupRedpacketModel.h
//  Shining
//
//  Created by yangxuan on 2019/9/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYRoomGroupRedpacketModel : NSObject

@property (nonatomic, strong) NSString *redbag_id;      // 红包id
@property (nonatomic, strong) NSString *room_id;        // 房间id
@property (nonatomic, strong) NSString *owner_id;       // 发送者id
@property (nonatomic, strong) NSString *owner_name;     // 发送者name
@property (nonatomic, strong) NSString *owner_avatar;   // 发送者头像
@property (nonatomic, assign) NSInteger redbag_amount;  // 红包总蜜豆数
@property (nonatomic, assign) NSInteger redbag_nums;    // 红包数量
@property (nonatomic, assign) NSInteger start_time;     // 开始时间unix时间戳
// 开始时间离现在的秒数，为负数表明红包可以抢
@property (nonatomic, assign) NSInteger start_time_now_diff; // 3分钟倒计时
@property (nonatomic, strong) NSString *create_time;    // 红包创建时间

@end

@interface SYRoomGroupRedpacketGetUserModel : NSObject

@property (nonatomic, strong) NSString *log_id;
@property (nonatomic, strong) NSString *redbag_id;          // 红包id
@property (nonatomic, strong) NSString *receiver_userid;    // 抢红包人id
@property (nonatomic, strong) NSString *receiver_username;  // 抢红包人name
@property (nonatomic, strong) NSString *receiver_useravatar;// 抢红包人avatar
@property (nonatomic, assign) NSInteger coins;              // 抢到蜜豆数
@property (nonatomic, strong) NSString *create_time;        // 创建时间

@end

@interface SYRoomGroupRedpacketGetResultModel : NSObject

@property (nonatomic, strong) NSString *owner_id;       // 红包创建人id
@property (nonatomic, strong) NSString *owner_name;     // 红包创建人name
@property (nonatomic, strong) NSString *owner_avatar;   // 红包创建人avatar
@property (nonatomic, assign) NSInteger result;         // 抢红包结果：0 - 没抢到  1 - 抢到了
@property (nonatomic, assign) NSInteger coins;          // 抢到的蜜豆数
@property (nonatomic, assign) NSInteger redbag_nums;    // 剩余的红包数
@property (nonatomic, strong) NSArray *list;            // 其他抢到红包的人

@end

