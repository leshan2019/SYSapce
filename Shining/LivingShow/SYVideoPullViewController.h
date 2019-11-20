//
//  SYVideoPullViewController.h
//  Shining
//
//  Created by Zhang Qigang on 2019/9/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYVideoPullViewController;

@protocol SYVideoPullViewControllerDelegate <NSObject>
@optional
- (void) videoPullViewController: (SYVideoPullViewController*) controller playWithError: (NSError*) error;
- (void) videoPullViewControllerPlayerStopped: (SYVideoPullViewController*) controller;
- (void) videoPullViewControllerPlayerReconnectingBegin: (SYVideoPullViewController*) controller;
- (void) videoPullViewControllerPlayerReconnectingEnd: (SYVideoPullViewController*) controller;
@end

@interface SYVideoPullViewController : UIViewController
@property (nonatomic, weak) id<SYVideoPullViewControllerDelegate> delegate;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithRoomId: (NSString*) roomId;

/**
 重新获取拉流地址
 */
- (void) reGetStreamPullUrl;
/**
 取消重试的定时器
 */
- (void) cancelRetry;
@end

NS_ASSUME_NONNULL_END
