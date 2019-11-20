//
//  SYVoiceRoomModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYChatRoomModel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *picW16h9;
@property (nonatomic, assign) NSInteger background;     // 房间背景 : 1,2,3,4代表本地写死的四张背景图
@property (nonatomic, assign) NSInteger role;           //  1 房主，2 管理员
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *greeting;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, assign) NSInteger status;         // 0开，1关
@property (nonatomic, assign) NSInteger concurrentUser; // 房间人数
@property (nonatomic, assign) NSInteger score;          // 热度
@property (nonatomic, assign) NSInteger lock;           // 密码锁 : 1-加锁 0-不加锁
@property (nonatomic, strong) NSString *micConfig;      // 麦位配置
@property (nonatomic, strong) NSString *categoryName;   // 类型名称
@property (nonatomic, assign) NSInteger category;       // 类型id
@property (nonatomic, strong) SYVoiceRoomUserModel *userInfo; // 房主信息
@property (nonatomic, strong) NSString *groupId;        // 环信群组id
@property (nonatomic, strong) NSString *categoryColor;  // 类型颜色
@property (nonatomic, strong) NSString *iconOnlineLeft;


@end

NS_ASSUME_NONNULL_END
