//
//  ChatHelper.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "ChatHelper.h"

static ChatHelper *helper = nil;

@implementation ChatHelper
+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatHelper alloc] init];
    });
    return helper;
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient] removeMultiDevicesDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

#pragma mark - init

- (void)initHelper
{
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient] addMultiDevicesDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
}

- (void)asyncPushOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    });
}

- (void)asyncGroupFromServer
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient].groupManager getJoinedGroups];
        EMError *error = nil;
        [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:0 pageSize:-1 error:&error];
    });
}

- (void)asyncConversationFromDB
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself.conversationListVC) {
                [weakself.conversationListVC refreshDataSource];
            }

            [gMainController setupUnreadMessageCount];
        });
    });
}

- (void)sendMessage:(NSString *)message
               type:(EMChatType)type
             fromId:(NSString *)fromId
               toId:(NSString *)toId
                ext:(NSDictionary *)ext{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:message];
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:toId
                                                          from:fromId
                                                            to:toId
                                                          body:body
                                                           ext:ext];
    msg.chatType = type;
    __weak typeof(self) weakSelf = self;
    [[EMClient sharedClient].chatManager sendMessage:msg progress:nil completion:^(EMMessage *_message, EMError *error) {
        NSLog(@"");
    }];
}

#pragma mark - EMClientDelegate

// 网络状态变化回调
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState{
    [gMainController networkChanged:aConnectionState];
}

- (void)userAccountDidLoginFromOtherDevice
{
    [SYToastView showToast:@"您的账号已在其他设备登录"];
    [[UserProfileManager sharedInstance]logOut];
 
}

- (void)userAccountDidRemoveFromServer
{
  
}

- (void)userDidForbidByServer
{
 
}

#pragma mark EMChatManagerDelegate
- (void)conversationListDidUpdate:(NSArray *)aConversationList{
    NSLog(@"列表更新");
}
- (void)messagesDidReceive:(NSArray *)aMessages
{
    [self asyncConversationFromDB];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];

}
@end
