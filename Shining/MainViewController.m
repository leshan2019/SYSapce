//
//  MainViewController.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "MainViewController.h"
#import <UserNotifications/UserNotifications.h>

#import "ChatHelper.h"
#import "IMGlobalVariables.h"
#import "UserProfileManager.h"
#import "UITabBar+SYBadge.h"
#import "SYContactViewController.h"
#import "SYCommonStatusManager.h"
#import "SYRoomCategoryViewModel.h"
#import "SYNoNetworkView.h"
#import "ShiningSdkManager.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface MainViewController () {
    UIBarButtonItem *_addFriendItem;
    EMConnectionState _connectionState;
}
@property (nonatomic, strong) NSDate *lastPlaySoundDate;
@property (nonatomic, assign) NSInteger currentItemTag;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setShadowImage:[self imageWithColor:DEFAULT_THEME_BG_COLOR]];
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:DEFAULT_THEME_BG_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupUnreadMessageCount];
    [self checkUnReceiveDayTask];
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();return image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    //if 使tabBarController中管理的viewControllers都符合 UIRectEdgeNone
    //    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
    //        [self setEdgesForExtendedLayout: UIRectEdgeNone];
    //    }
    [[UINavigationBar appearance] setShadowImage:[self imageWithColor:DEFAULT_THEME_BG_COLOR]];
    [[UINavigationBar appearance] setBackgroundImage:[self imageWithColor:DEFAULT_THEME_BG_COLOR] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    //    [self didUnreadMessagesCountChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    self.view.backgroundColor = [UIColor sam_colorWithHex:@"#F5F6F7"];
    
    [self setupSubviews];
    
//    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 44)];
//    [addButton setImage:[UIImage imageNamed_sy:@"im_contact"] forState:UIControlStateNormal];
//    [addButton addTarget:_chatListVC action:@selector(gotoContactAction) forControlEvents:UIControlEventTouchUpInside];
//    addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    addButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
//    _addFriendItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    //    [self setupUnreadMessageCount];
    self.selectedIndex = 0;
    [ChatHelper shareHelper].conversationListVC = _chatListVC;
    //////
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)gotoContactAction
{
    UIViewController *contactController = [[SYContactViewController alloc] init];
    [self.navigationController pushViewController:contactController animated:YES];
}

#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if (self.currentItemTag != item.tag) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.titleView = nil;
        if (item.tag == 1) {
            self.title = @"找朋友";
        }
        else if (item.tag == 3){
            self.title = [NSBundle sy_localizedStringForKey:@"title.conversation" value:@"Conversations"];
            self.navigationItem.rightBarButtonItem = _addFriendItem;
        }
        else if (item.tag == 4){
             self.title = [NSBundle sy_localizedStringForKey:@"title.my" value:@"Mine"];
        } else if (item.tag == 0 || item.tag == 2) {
            self.title = @"";
        }
    } else {
        // 点击广场tab，刷新广场页面和关注页面
//        if (item.tag == 2) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:SYSquareRefreshNotificaion object:nil];
//        }
    }
    
    self.currentItemTag = item.tag;
    
}
#pragma mark - private

- (void)setupSubviews
{
    self.tabBar.accessibilityIdentifier = @"tabbar";
    //    self.tabBar.backgroundImage = [[UIImage imageNamed_sy:@"tabbarBackground"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    //    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed_sy:@"tabbarSelectBg"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
    
    _voiceRoomHomeVC = [[SYVoiceRoomHomeVC alloc] init];
    _voiceRoomHomeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSBundle sy_localizedStringForKey:@"title.chatroom" value:@"Home"]
                                                                image:[[UIImage imageNamed_sy:@"tabbar_chatroom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                        selectedImage:[[UIImage imageNamed_sy:@"tabbar_chatroomHL"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self unSelectedTapTabBarItems:_voiceRoomHomeVC.tabBarItem];
    [self selectedTapTabBarItems:_voiceRoomHomeVC.tabBarItem];
    _voiceRoomHomeVC.tabBarItem.tag = 0;
    
//    _findFriendVC = [[SYFindFriendViewController alloc] initWithNibName:nil bundle:nil];
//    _findFriendVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSBundle sy_localizedStringForKey:@"title.friend" value:@"Friends"]
//                                                           image:[[UIImage imageNamed_sy:@"tabbar_friends"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                                   selectedImage:[[UIImage imageNamed_sy:@"tabbar_friendsHL"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    _findFriendVC.tabBarItem.tag = 1;
//    _findFriendVC.tabBarItem.accessibilityIdentifier = @"findFriends";
//    [self unSelectedTapTabBarItems:_findFriendVC.tabBarItem];
//    [self selectedTapTabBarItems:_findFriendVC.tabBarItem];
//
//    _activityVC = [[SYActivityTabVC alloc] init];
//    _activityVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSBundle sy_localizedStringForKey:@"title.square" value:@"Squares"]
//                                                           image:[[UIImage imageNamed_sy:@"tabbar_square"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                                   selectedImage:[[UIImage imageNamed_sy:@"tabbar_squareHL"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    _activityVC.tabBarItem.tag = 2;
////    _chatListVC.tabBarItem.accessibilityIdentifier = @"conversation";
//    [self unSelectedTapTabBarItems:_activityVC.tabBarItem];
//    [self selectedTapTabBarItems:_activityVC.tabBarItem];
//

    _chatListVC = [[SYConversationListController alloc] initWithNibName:nil bundle:nil];
    [_chatListVC networkChanged:_connectionState];
    _chatListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSBundle sy_localizedStringForKey:@"title.conversation" value:@"Conversations"]
                                                           image:[[UIImage imageNamed_sy:@"tabbar_chats"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                   selectedImage:[[UIImage imageNamed_sy:@"tabbar_chatsHL"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    _chatListVC.tabBarItem.tag = 3;

    _chatListVC.tabBarItem.accessibilityIdentifier = @"conversation";
    [self unSelectedTapTabBarItems:_chatListVC.tabBarItem];
    [self selectedTapTabBarItems:_chatListVC.tabBarItem];
//
//
//    _settingsVC = [[SYMineViewController alloc] init];
//    _settingsVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[NSBundle sy_localizedStringForKey:@"title.my" value:@"Mine"]
//                                                           image:[[UIImage imageNamed_sy:@"tabbar_setting"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                                   selectedImage:[[UIImage imageNamed_sy:@"tabbar_settingHL"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    _settingsVC.tabBarItem.tag = 4;
//    _settingsVC.tabBarItem.accessibilityIdentifier = @"setting";
//    _settingsVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [self unSelectedTapTabBarItems:_settingsVC.tabBarItem];
//    [self selectedTapTabBarItems:_settingsVC.tabBarItem];
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *standardAppearance = [[UITabBarAppearance alloc] init];
        UITabBarItemAppearance *inlineLayoutAppearance = [[UITabBarItemAppearance alloc] init];
        [ inlineLayoutAppearance.normal setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor sy_colorWithHexString:@"#444444"]}];
        [ inlineLayoutAppearance.selected setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor sy_colorWithHexString:@"#000000"]}];
        standardAppearance.stackedLayoutAppearance = inlineLayoutAppearance;
        self.tabBar.standardAppearance = standardAppearance;
    }
    self.viewControllers = @[_voiceRoomHomeVC/*,_findFriendVC,_activityVC,_chatListVC, _settingsVC*/];
    [self selectedTapTabBarItems:_voiceRoomHomeVC.tabBarItem];

}

-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem {
    tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -1);
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:12], NSFontAttributeName,
                                        [UIColor sy_colorWithHexString:@"#444444"],NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIFont systemFontOfSize:12],NSFontAttributeName,
                                            [UIColor sy_colorWithHexString:@"#000000"],NSForegroundColorAttributeName,
                                            nil] forState:UIControlStateSelected];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        if (conversation.type == EMConversationTypeChat) {
            unreadCount += conversation.unreadMessagesCount;
        }
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            //            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
            [self.tabBar sy_showBadgeOnItemIndex:3];
            
        }else{
            //            _chatListVC.tabBarItem.badgeValue = nil;
            [self.tabBar sy_hideBadgeOnItemIndex:3];
            
        }
    }
}

//统计已完成未领取的每日任务
- (void)checkUnReceiveDayTask {
    __weak typeof(self) weakSelf = self;
    if(_settingsVC) {
        [[SYCommonStatusManager sharedInstance]checkDayTaskUnReceived:^(BOOL isUnReceived) {
            if (isUnReceived) {
                [weakSelf.tabBar sy_showBadgeOnItemIndex:4];
                
            }else{
                [weakSelf.tabBar sy_hideBadgeOnItemIndex:4];
            }
        }];
    }
}


- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = [NSBundle sy_localizedStringForKey:@"message.image" value:@"Image"];
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = [NSBundle sy_localizedStringForKey:@"message.location" value:@"Location"];
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = [NSBundle sy_localizedStringForKey:@"message.voice" value:@"Voice"];
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = [NSBundle sy_localizedStringForKey:@"message.video" value:@"Video"];
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, [NSBundle sy_localizedStringForKey:@"group.atPushTitle" value:@" @ me in the group"]];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, [NSBundle sy_localizedStringForKey:@"group.atPushTitle" value:@" @ me in the group"]];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        alertBody = [NSBundle sy_localizedStringForKey:@"receiveMessage" value:@"you have a new message"];
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = [NSBundle sy_localizedStringForKey:@"open" value:@"Open"];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:[NSBundle sy_localizedStringForKey:@"reconnection.ongoing" value:@"reconnecting..."]];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:[NSBundle sy_localizedStringForKey:@"reconnection.fail" value:@"reconnection failure, later will continue to reconnection"]];
        }else{
            [self showHint:[NSBundle sy_localizedStringForKey:@"reconnection.success" value:@"reconnection successful！"]];
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[SYChatViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
        [self tabBar:self.tabBar didSelectItem:_chatListVC.tabBarItem];
    }
}


- (void)jumpToVoiceRoomHome
{
    if ([self.navigationController.topViewController isKindOfClass:[SYVoiceRoomHomeVC class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_voiceRoomHomeVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_voiceRoomHomeVC];
        [self tabBar:self.tabBar didSelectItem:_voiceRoomHomeVC.tabBarItem];
    }
}


- (void)jumpToMineVC
{
    if ([self.navigationController.topViewController isKindOfClass:[SYMineViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_settingsVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_settingsVC];
        [self tabBar:self.tabBar didSelectItem:_settingsVC.tabBarItem];
    }
}


- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[SYChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[SYChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    SYChatViewController *chatViewController = (SYChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[SYChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                SYChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[SYChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[SYChatViewController class]]) {
            //                        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //                        [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[SYChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                } else {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    SYChatViewController *chatViewController = (SYChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[SYChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                SYChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[SYChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}
@end
