//
//  SYLiveRoomVC.h
//  Shining
//
//  Created by mengxiangjian on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYVoiceChatRoomVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SYLivingStreamType) {
    SYLivingStreamTypePull = 0,
    SYLivingStreamTypePush = 1,
};

@protocol SYLiveRoomVCDelegate <NSObject>

- (void)liveRoomDidClose;

@end

@interface SYLiveRoomVC : UIViewController

@property (nonatomic, weak) id <SYVoiceChatRoomVCDelegate> delegate;

- (instancetype)initWithChannelID:(NSString *)channelID
                            title:(NSString *)title;

- (instancetype)initWithChannelID:(NSString *)channelID
                            title:(NSString *)title
                         password:(NSString *)password;

- (instancetype)initWithChannelID:(NSString *)channelID
                            title:(NSString *)title
                         password:(NSString *)password
                       streamType:(SYLivingStreamType) streamType;

- (void)leaveChannel;

@end

NS_ASSUME_NONNULL_END
