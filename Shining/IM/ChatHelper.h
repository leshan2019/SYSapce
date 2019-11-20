//
//  ChatHelper.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SYConversationListController.h"
#import "SYChatViewController.h"

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

#define extRedPacket        @"redPacket"
#define extSyUserInfo       @"syUserInfo"

NS_ASSUME_NONNULL_BEGIN

@interface ChatHelper : NSObject<EMClientDelegate, EMMultiDevicesDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

@property (nonatomic, weak) SYConversationListController *conversationListVC;

@property (nonatomic, weak) SYChatViewController *chatVC;

+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

- (void)sendMessage:(NSString *)message
               type:(EMChatType)type
             fromId:(NSString *)fromId
               toId:(NSString *)toId
                ext:(NSDictionary *)ext;
@end

NS_ASSUME_NONNULL_END
