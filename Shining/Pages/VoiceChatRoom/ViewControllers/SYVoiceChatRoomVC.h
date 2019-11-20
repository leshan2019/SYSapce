//
//  SYChatRoomVC.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SYChatEngineEnum.h"

@class SYVoiceChatRoomVC;

NS_ASSUME_NONNULL_BEGIN

@protocol SYVoiceChatRoomVCDelegate <NSObject>

- (void)voiceChatRoomVC:(UIViewController *)vc
  didPopOutWithRoomName:(NSString *)roomName
               roomIcon:(NSString *)roomIcon;

- (void)voiceChatRoomVCForceClosedWithVC:(UIViewController *)vc;

- (void)voiceChatRoomVCChangeAnotherRoomWithVC:(UIViewController *)vc
                                        roomId:(NSString *)roomId;

@end

@interface SYVoiceChatRoomVC : UIViewController

@property (nonatomic, weak) id <SYVoiceChatRoomVCDelegate> delegate;
@property (nonatomic, strong, readonly) NSString *channelID;

@property (nonatomic, strong) NSString *from; // 来源
@property (nonatomic, strong) NSDictionary *reportInfo; // 数据上报dict

- (instancetype)initWithChannelID:(NSString *)channelID
                            title:(NSString *)title;

- (instancetype)initWithChannelID:(NSString *)channelID
                            title:(NSString *)title
                         password:(NSString *)password;

- (void)leaveChannel;

@end

NS_ASSUME_NONNULL_END
