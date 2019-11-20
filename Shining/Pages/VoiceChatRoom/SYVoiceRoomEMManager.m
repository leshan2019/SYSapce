//
//  SYVoiceRoomEMManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/5/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomEMManager.h"

@interface SYVoiceRoomEMManager () <EMChatManagerDelegate>

@end

@implementation SYVoiceRoomEMManager

+ (instancetype)sharedInstance {
    static SYVoiceRoomEMManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [SYVoiceRoomEMManager new];
    });
    return manager;
}

- (void)start {
    [self stop];
    [[EMClient sharedClient].chatManager addDelegate:self
                                       delegateQueue:nil];
}

- (void)stop {
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)enterGroupWithGroupId:(NSString *)groupId {
    [[EMClient sharedClient].groupManager joinPublicGroup:groupId
                                               completion:^(EMGroup *aGroup, EMError *aError) {
                                                   
                                               }];
    return YES;
}

- (BOOL)enterChatRoomWithChatRoomId:(NSString *)chatRoomId success:(void(^)(BOOL))success {
    [[EMClient sharedClient].roomManager joinChatroom:chatRoomId completion:^(EMChatroom *aChatroom, EMError *aError) {
        if (success) {
            success(!aError);
        }
    }];
    return YES;
}

- (void)leaveGroupId:(NSString *)groupId {
    [[EMClient sharedClient].groupManager leaveGroup:groupId
                                          completion:^(EMError *aError) {
                                              
                                          }];
}

- (void)leaveChatRoom:(NSString *)chatRoomId {
    [[EMClient sharedClient].roomManager leaveChatroom:chatRoomId
                                            completion:^(EMError *aError) {
                                                
                                            }];
}

- (void)sendMessage:(NSString *)message
               type:(SYVoiceRoomEMMessageType)type
             fromId:(NSString *)fromId
               toId:(NSString *)toId {
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:message];
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:toId
                                                          from:fromId
                                                            to:toId
                                                          body:body
                                                           ext:nil];
    msg.chatType = EMChatTypeGroupChat;
    if (type == SYVoiceRoomEMMessageTypeChatRoom) {
        msg.chatType = EMChatTypeChatRoom;
    }
    __weak typeof(self) weakSelf = self;
    [[EMClient sharedClient].chatManager sendMessage:msg progress:nil completion:^(EMMessage *_message, EMError *error) {
        if (type == SYVoiceRoomEMMessageTypeChatRoom && !error) {
            if ([weakSelf.delegate respondsToSelector:@selector(voiceRoomEMManagerDidReceiveMessage:type:channelId:)]) {
                [weakSelf.delegate voiceRoomEMManagerDidReceiveMessage:message
                                                                  type:SYVoiceRoomEMMessageTypeChatRoom
                                                             channelId:toId];
            }
        }
    }];
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        EMMessageBodyType bodyType = message.body.type;
        if (bodyType == EMMessageBodyTypeText) {
            EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
            EMChatType chatType = message.chatType;
            if (chatType != EMChatTypeChat) {
                if ([self.delegate respondsToSelector:@selector(voiceRoomEMManagerDidReceiveMessage:type:channelId:)]) {
                    [self.delegate voiceRoomEMManagerDidReceiveMessage:textBody.text
                                                                  type:[self typeWithType:chatType]
                                                             channelId:message.to];
                }
            }
        }
    }
}

- (SYVoiceRoomEMMessageType)typeWithType:(EMChatType)type {
    switch (type) {
        case EMChatTypeChatRoom:
        {
            return SYVoiceRoomEMMessageTypeChatRoom;
        }
            break;
        case EMChatTypeGroupChat:
        {
            return SYVoiceRoomEMMessageTypeGroup;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (void)checkUnreadMessage {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    [self setupUnreadMessageCount];
}

-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        if (conversation.type == EMConversationTypeChat) {
            unreadCount += conversation.unreadMessagesCount;
            if (unreadCount > 0) {
                break;
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(voiceRoomEMManagerDidCheckUnreadMessage:)]) {
        [self.delegate voiceRoomEMManagerDidCheckUnreadMessage:(unreadCount > 0)];
    }
}

@end
