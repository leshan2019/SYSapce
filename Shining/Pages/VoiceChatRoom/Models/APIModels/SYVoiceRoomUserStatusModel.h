//
//  SYVoiceRoomUserStatusModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceRoomUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomUserStatusModel : NSObject

@property (nonatomic, assign) NSInteger disJoin; // 1禁入，0非禁入
@property (nonatomic, assign) NSInteger disSay; // 1禁言，0非禁言
@property (nonatomic, assign) NSInteger hasCare; // 1已关注，0未关注
@property (nonatomic, strong) SYVoiceRoomUserModel *userInfo;

@end

NS_ASSUME_NONNULL_END
