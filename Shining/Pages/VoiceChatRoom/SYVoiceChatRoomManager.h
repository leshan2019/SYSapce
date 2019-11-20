//
//  SYVoiceChatRoomManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYVoiceChatRoomFromTagEnum.h"

@class SYVoiceChatRoomVC;
@class SYLiveRoomVC;

NS_ASSUME_NONNULL_BEGIN

@interface SYVoiceChatRoomManager : NSObject

@property (nonatomic, strong, readonly) NSString *channelID;
@property (nonatomic, assign) SYVoiceChatRoomFromTag fromTag;
@property (nonatomic, strong) NSDictionary *reportInfo;

+ (instancetype)sharedManager;

- (void)presentVoiceChatRoom:(SYVoiceChatRoomVC *)vc;
- (void)presentLiveRoom:(SYLiveRoomVC *)vc;

- (void)presentCurrentVoiceChatRoom;

//- (void)appWillTerminate;

//- (void)presentAnotherRoomWithRoomId:(NSString *)roomId;

- (void)forceDismissCurrentVoiceChatRoom; // 强制退出当前聊天室

- (void)tryToEnterVoiceChatRoomWithRoomId:(NSString *)roomId; // 尝试进入房间，带房间上锁弹出输入密码逻辑
- (void)tryToEnterVoiceChatRoomWithRoomId:(NSString *)roomId from:(SYVoiceChatRoomFromTag)fromTag;
- (void)tryToEnterVideoChatRoomWithRoomId:(NSString *)roomId from:(SYVoiceChatRoomFromTag)fromTag;
/**
 尝试进入房间，

 @param roomId 房间id
 @param fromTag 点击来源
 @param info 数据上报info
 */
- (void)tryToEnterVoiceChatRoomWithRoomId:(NSString *)roomId from:(SYVoiceChatRoomFromTag)fromTag reportInfo:(NSDictionary *)info;

// 打开直播房间，并且支持上下滑动切换房间
- (void)tryToEnterLiveRoomWithRoomId:(NSString *)roomId
                      liveRoomIDList:(NSArray *)liveRoomIDList
                          categoryID:(NSInteger)categoryID;

- (void)forceUpdateCurrentFloatBallToFront; // 强制更新当前浮球到最上层

@end

NS_ASSUME_NONNULL_END
