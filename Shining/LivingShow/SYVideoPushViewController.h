//
//  SYVideoPushViewController.h
//  Shining
//
//  Created by Zhang Qigang on 2019/9/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*
@class SYVideoPushViewController;

@protocol SYVideoPushViewControllerDelegate <NSObject>
@optional
- (void) videoPushViewController: (SYVideoPushViewController*) controller getRoomTitleSuccess: (void (^)(NSString* title)) success;
- (void) videoPushViewController: (SYVideoPushViewController*) controller setRoomTitle: (NSString*) title;
@optional
- (void) videoPushViewControllerStartShowClicked: (SYVideoPushViewController*) controller;
- (void) videoPushViewControllerStartPushStream: (SYVideoPushViewController*) controller;
- (void) videoPushViewControllerCloseClicked: (SYVideoPushViewController*) controller;
- (void) videoPushViewControllerBeautifyClicked: (SYVideoPushViewController*) controller;
- (void) videoPushViewControllerConfigClicked: (SYVideoPushViewController*) controller;
- (void) videoPushViewControllerStreamingConnected: (SYVideoPushViewController*) controller;
- (void) videoPushViewControllerStreamingDisconnected: (SYVideoPushViewController*) controller withError: (NSError*) error;
- (void) videoPushViewControllerSuccessFlipHorizontal:(BOOL)mirrorState
                                          toastString:(NSString *)toastString;
@end

@interface SYVideoPushViewController : UIViewController
@property (nonatomic, weak) id<SYVideoPushViewControllerDelegate> delegate;
- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithRoomId: (NSString*) roomId;
- (instancetype) initWithRoomId: (NSString*) roomId skipPreview: (BOOL) skipPreview;
// 弹出美颜
- (void) presentBeautifyController;
- (void) switchCamera;
- (void) flipHorizontal:(BOOL) isOpen;
- (BOOL) mirrorState;

/// 重新推流
- (void) reStartPushStream;
@end
 */

NS_ASSUME_NONNULL_END
