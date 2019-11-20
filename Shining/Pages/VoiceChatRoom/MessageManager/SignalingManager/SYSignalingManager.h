//
//  SYSignalingManager.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYSignalingManagerDelegate <NSObject>

- (void)signalingManagerDidJoinChannel;
- (void)signalingManagerDidFailed;
- (void)signalingManagerDidReceiveMessage:(NSString *)message;

@end

@interface SYSignalingManager : NSObject

- (instancetype)initWithUserID:(NSString *)uid
                         token:(NSString *)token
                     channelID:(NSString *)channelID;

- (void)startWithDelegate:(id <SYSignalingManagerDelegate>)delegate;

- (void)sendMessage:(NSString *)message;

- (void)leaveChannel;

@end

NS_ASSUME_NONNULL_END
