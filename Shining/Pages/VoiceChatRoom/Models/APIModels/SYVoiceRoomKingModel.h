//
//  SYVoiceRoomKingModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomKingModel : NSObject

@property (nonatomic, assign) NSInteger gift_price;
@property (nonatomic, assign) long send_timestamp;
@property (nonatomic, assign) long current_timestamp;
@property (nonatomic, strong) SYVoiceRoomUserModel *userinfo;

@end

NS_ASSUME_NONNULL_END
