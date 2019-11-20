//
//  RobotChatViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "RobotChatViewController.h"
#import "RobotManager.h"

@implementation RobotChatViewController

- (void)sendTextMessage:(NSString *)text
{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *message = [EaseSDKHelper getTextMessage:text to:self.conversation.conversationId messageType:[self _messageTypeFromConversationType] messageExt:ext];
    [self addMessageToDataSource:message
                        progress:nil];
}

- (void)sendImageMessage:(UIImage *)image
{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *message = [EaseSDKHelper getImageMessageWithImage:image to:self.conversation.conversationId messageType:[self _messageTypeFromConversationType] messageExt:ext];
    [self addMessageToDataSource:message
                        progress:nil];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath duration:(NSInteger)duration
{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *message = [EaseSDKHelper getVoiceMessageWithLocalPath:localPath duration:duration to:self.conversation.conversationId messageType:[self _messageTypeFromConversationType] messageExt:ext];
    [self addMessageToDataSource:message
                        progress:nil];
}

- (void)sendVideoMessageWithURL:(NSURL *)url
{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *message = [EaseSDKHelper getVideoMessageWithURL:url duration:0 to:self.conversation.conversationId messageType:[self _messageTypeFromConversationType] messageExt:ext];
    [self addMessageToDataSource:message
                        progress:nil];
}

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address
{
    NSDictionary *ext = nil;
    ext = @{kRobot_Message_Ext:[NSNumber numberWithBool:YES]};
    EMMessage *message = [EaseSDKHelper getLocationMessageWithLatitude:latitude longitude:longitude address:address to:self.conversation.conversationId messageType:[self _messageTypeFromConversationType] messageExt:ext];
    [self addMessageToDataSource:message
                        progress:nil];
}

- (EMChatType)_messageTypeFromConversationType
{
    EMChatType type = EMChatTypeChat;
    switch (self.conversation.type) {
        case EMConversationTypeChat:
            type = EMChatTypeChat;
            break;
        case EMConversationTypeGroupChat:
            type = EMChatTypeGroupChat;
            break;
        case EMConversationTypeChatRoom:
            type = EMChatTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}
@end
