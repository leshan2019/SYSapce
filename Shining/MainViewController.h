//
//  MainViewController.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

#import "SYConversationListController.h"
#import "SYVoiceRoomHomeVC.h"
#import "SYMineViewController.h"
//#import "SYFindFriendViewController.h"
//#import "SYActivityTabVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UITabBarController

@property (nonatomic, strong) SYConversationListController *chatListVC;
@property (nonatomic, strong) SYMineViewController *settingsVC;
@property (nonatomic, strong) SYVoiceRoomHomeVC *voiceRoomHomeVC;
//@property (nonatomic, strong) SYFindFriendViewController *findFriendVC;
//@property (nonatomic, strong) SYActivityTabVC *activityVC;

- (void)jumpToChatList;

/**
 跳转到首页tab
 */
- (void)jumpToVoiceRoomHome;
/**
 跳转到我的tab
 */
- (void)jumpToMineVC;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;
@end

NS_ASSUME_NONNULL_END
