//
//  SYVoiceRoomBoonModel.h
//  Shining
//
//  Created by yangxuan on 2019/9/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomBoonModel : NSObject

@property (nonatomic, strong) SYVoiceRoomUser *user;// 谁发的群红包
@property (nonatomic, assign) NSInteger count;      // 领取的蜜豆数

@end

@interface SYVoiceRoomBoomEmptyModel : NSObject

@property (nonatomic, strong) NSString *redbag_id;  // 红包id
@property (nonatomic, strong) NSString *room_id;    // 房间id
@property (nonatomic, strong) NSString *owner_id;   // 红包发送者

@end

NS_ASSUME_NONNULL_END
