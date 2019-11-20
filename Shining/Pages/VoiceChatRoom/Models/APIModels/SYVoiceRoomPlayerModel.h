//
//  SYVoiceRoomPlayer.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomPlayerModel : NSObject

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) NSInteger role;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *createdAt;
@property (nonatomic, strong) NSString *updatedAt;
@property (nonatomic, strong) SYVoiceRoomUserModel *userInfo; // 聊天室玩家信息

@end

NS_ASSUME_NONNULL_END
