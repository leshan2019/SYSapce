//
//  SYVoiceRoomJoinModel.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/7.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYChatRoomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceRoomJoinModel : NSObject

@property (nonatomic, strong) NSString *userId; // 游客模式下用户id
@property (nonatomic, strong) NSString *xlToken;
@property (nonatomic, strong) NSString *mtToken;
@property (nonatomic, strong) NSString *rtmToken; // 声网实时消息token
@property (nonatomic, assign) NSInteger identity; // identity: 1 房主，2 管理员，0 听众
@property (nonatomic, assign) NSInteger disJoin; // 1禁入，0非禁入
@property (nonatomic, assign) NSInteger disSay; // 1禁言，0非禁言
@property (nonatomic, assign) NSInteger roomStatus; // 1关闭，0开启
@property (nonatomic, strong) SYChatRoomModel *roomInfo;
@property (nonatomic, strong) UserProfileEntity *userInfo;

@end

NS_ASSUME_NONNULL_END
