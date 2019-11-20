//
//  IMDingMessageHelper.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotification_DingAction @"DingAction"

NS_ASSUME_NONNULL_BEGIN

@interface IMDingMessageHelper : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary *dingAcks;

+ (instancetype)sharedHelper;

+ (BOOL)isDingMessage:(EMMessage *)aMessage;

+ (BOOL)isDingMessageAck:(EMMessage *)aMessage;

- (NSInteger)dingAckCount:(EMMessage *)aMessage;

- (EMMessage *)createDingMessageWithText:(NSString *)aText
                          conversationId:(NSString *)aConversationId
                                      to:(NSString *)aTo
                                chatType:(EMChatType)aChatType;

- (EMMessage *)createDingAckForMessage:(EMMessage *)aMessage;

- (NSString *)addDingMessageAck:(EMMessage *)aAckMessage;

- (NSArray *)usersHasReadMessage:(EMMessage *)aMessage;

- (void)deleteConversation:(NSString *)aConversationId;

- (void)deleteConversation:(NSString *)aConversationId
                   message:(NSString *)aMessageId;

- (void)save;
@end

NS_ASSUME_NONNULL_END
