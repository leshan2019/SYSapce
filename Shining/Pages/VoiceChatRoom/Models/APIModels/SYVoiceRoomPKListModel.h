//
//  SYVoiceRoomPKListModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/7/3.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomPKModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomPKListModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, assign) NSInteger status; // 0 关闭；1 开启
@property (nonatomic, assign) NSInteger unixMsno; // 毫秒时间戳
@property (nonatomic, strong) NSArray *salesDetails; // 收到礼物的用户列表
@property (nonatomic, strong) NSString *maxBeansUserId; // 最大蜜豆持有者

@end

NS_ASSUME_NONNULL_END
