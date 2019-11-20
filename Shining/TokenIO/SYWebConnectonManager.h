//
//  SYWebConnectonManager.h
//  Shining
//
//  Created by letv_lzb on 2019/10/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SYWebConnectionNotification     @"SYWebConnectionNotification"


NS_ASSUME_NONNULL_BEGIN

@interface SYWebConnectonManager : NSObject

/**
 sigle

 @return id
 */
+ (instancetype)sharedManager;


/**
 建立连接
 */
- (void)startConnect;


/**
 断开连接
 */
- (void)stopConnect;


/**
 发送命令

 @param command 命令载体
 */
- (void)sendCommand:(TokenCommand *)command;


/**
 加入房间

 @param channelId 房间id
 */
- (void)userJoinChannel:(NSString *)channelId;

/**
 离开房间

 @param channelId 房间id
 */
- (void)userLeaveChannel:(NSString *)channelId;

@end

NS_ASSUME_NONNULL_END
