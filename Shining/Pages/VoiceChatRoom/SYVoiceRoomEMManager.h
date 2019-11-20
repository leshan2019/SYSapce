//
//  SYVoiceRoomEMManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/5/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SYVoiceRoomEMMessageTypeGroup, // 群聊
    SYVoiceRoomEMMessageTypeChatRoom, // 聊天室
} SYVoiceRoomEMMessageType;

@protocol SYVoiceRoomEMManagerDelegate <NSObject>

- (void)voiceRoomEMManagerDidReceiveMessage:(NSString *)message
                                       type:(SYVoiceRoomEMMessageType)type
                                  channelId:(NSString *)channelId;

- (void)voiceRoomEMManagerDidCheckUnreadMessage:(BOOL)hasUnread;

@end

@interface SYVoiceRoomEMManager : NSObject

@property (nonatomic, weak) id <SYVoiceRoomEMManagerDelegate> delegate;

+ (instancetype)sharedInstance;

// 在需要使用之前必须调用
- (void)start;
// 结束使用时调用
- (void)stop;

- (void)checkUnreadMessage;

- (BOOL)enterGroupWithGroupId:(NSString *)groupId;

- (BOOL)enterChatRoomWithChatRoomId:(NSString *)chatRoomId success:(void(^)(BOOL))success;

- (void)leaveGroupId:(NSString *)groupId;
- (void)leaveChatRoom:(NSString *)chatRoomId;

- (void)sendMessage:(NSString *)message
               type:(SYVoiceRoomEMMessageType)type
             fromId:(NSString *)fromId
               toId:(NSString *)toId;


@end

NS_ASSUME_NONNULL_END
