//
//  SYVoiceChatRoomForbidChatVC.h
//  Shining
//
//  Created by 杨玄 on 2019/3/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceRoomInfoChangeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  房间信息 - 禁言名单VC
 */
@interface SYVoiceChatRoomForbidChatVC : UIViewController

@property (nonatomic, weak) id <SYVoiceRoomInfoChangeProtocol> delegate;
@property (nonatomic, copy) NSString *channelId;

@end

NS_ASSUME_NONNULL_END
