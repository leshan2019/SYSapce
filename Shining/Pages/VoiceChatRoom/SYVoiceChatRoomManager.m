//
//  SYVoiceChatRoomManager.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceChatRoomManager.h"
#import "SYVoiceChatRoomVC.h"
#import "SYVoiceRoomFloatBall.h"
#import "SYVoiceChatEngine.h"
#import "SYNavigationController.h"
#import "SYVoiceChatNetManager.h"
#import "SYChildProtectManager.h"
#import "SYLiveRoomVC.h"
#import "SYLiveRoomPlayListVC.h"

@interface SYVoiceChatRoomManager () <SYVoiceChatRoomVCDelegate, SYVoiceRoomFloatBallDelegate, SYPasswordInputViewDelegate, SYLiveRoomVCDelegate>

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) SYVoiceRoomFloatBall *floatBall;
@property (nonatomic, assign) CGPoint floatBallOrigin;
@property (nonatomic, assign) CGPoint panStartOrigin;
@property (nonatomic, assign) BOOL networkReachable;

@property (nonatomic, strong) NSString *lockRoomId; // 如果遇到私房，临时记录私房id，去输入密码
@property (nonatomic, assign) NSInteger lockRoomType; //

@property (nonatomic, strong) NSArray *liveRoomIDList;
@property (nonatomic, assign) NSInteger liveRoomCategoryID;

@end

@implementation SYVoiceChatRoomManager

+ (instancetype)sharedManager {
    static SYVoiceChatRoomManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SYVoiceChatRoomManager alloc] init];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        manager.floatBallOrigin = CGPointMake(12.f, window.sy_height - 136.f);
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(networkChanged:)
                                                     name:SYNetworkingReachabilityDidChangeNotification
                                                   object:nil];
        _networkReachable = [SYNetworkReachability isNetworkReachable];
        _fromTag = SYVoiceChatRoomFromTagUnknown;
    }
    return self;
}

- (void)networkChanged:(id)sender {
    if (![SYNetworkReachability isNetworkReachable]) {
        // 断网直接踢出房间
        [SYToastView showToast:@"网络中断，请检查网络"];
        if (self.currentVC) {
            if (self.currentVC.presentedViewController) {
                [self.currentVC.presentedViewController dismissViewControllerAnimated:NO
                                                                           completion:nil];
            }
            [self.currentVC dismissViewControllerAnimated:YES completion:nil];
            [self voiceChatRoomVCForceClosedWithVC:self.currentVC];
        }
    } else {
        if (!self.networkReachable) {
            [[SYVoiceChatEngine sharedEngine] leaveChannel];
        }
    }
    
    self.networkReachable = [SYNetworkReachability isNetworkReachable];
}

- (void)presentVoiceChatRoom:(SYVoiceChatRoomVC *)vc {
    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    if (vc) {
        [self removeFloatBall];
        self.currentVC = vc;
        vc.delegate = self;
        SYNavigationController *naviVC = [[SYNavigationController alloc] initWithRootViewController:vc];
        naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [rootVC presentViewController:naviVC
                             animated:YES
                           completion:nil];
    }
}

- (void)presentLiveRoom:(SYLiveRoomVC *)vc {
    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    if (vc) {
        [self removeFloatBall];
        self.currentVC = vc;
        vc.delegate = self;
        SYNavigationController *naviVC = [[SYNavigationController alloc] initWithRootViewController:vc];
        naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [rootVC presentViewController:naviVC
                             animated:YES
                           completion:nil];
    }
}

- (void)presentLiveRoomPlayListVC:(SYLiveRoomPlayListVC *)vc {
    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    if (vc) {
        [self removeFloatBall];
        self.currentVC = vc;
        vc.delegate = self;
        SYNavigationController *naviVC = [[SYNavigationController alloc] initWithRootViewController:vc];
        naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [rootVC presentViewController:naviVC
                             animated:YES
                           completion:nil];
    }
}

- (void)presentAnotherRoomWithRoomId:(NSString *)roomId
                            password:(NSString *)password
                            roomType:(NSInteger)type
                              hostID:(NSString *)hostID
                            roomName:(NSString *)roomName {
    __weak typeof(self) weakSelf = self;
    void (^block)(void) = ^{
        [weakSelf removeFloatBall];
        [weakSelf voiceRoomFloatBallDidClose];
        weakSelf.channelID = roomId;
        if (type == 2) {
//            UserProfileEntity *userInfo = [UserProfileEntity getUserProfileEntity];
//            if (userInfo.userid && [userInfo.userid isEqualToString:hostID]) {
//                SYLiveRoomVC *vc = [[SYLiveRoomVC alloc] initWithChannelID:roomId
//                                                                     title:roomName
//                                                                  password:password
//                                                                streamType:SYLivingStreamTypePush];
//                [self presentLiveRoom:vc];
//            } else {
//                SYLiveRoomVC *vc = [[SYLiveRoomVC alloc] initWithChannelID:roomId
//                                                                     title:roomName
//                                                                  password:password];
//                [self presentLiveRoom:vc];
//            }
            
            if (self.liveRoomIDList) {
                SYLiveRoomPlayListVC *vc = [[SYLiveRoomPlayListVC alloc] initWithChannelIDList:self.liveRoomIDList
                                                                              currentChannelID:roomId
                                                                                      password:password
                                            categoryID:self.liveRoomCategoryID];
                [self presentLiveRoomPlayListVC:vc];
                self.liveRoomIDList = nil;
                self.liveRoomCategoryID = 0;
            } else {
                SYLiveRoomVC *vc = [[SYLiveRoomVC alloc] initWithChannelID:roomId
                                                                     title:roomName
                                                                  password:password];
                [self presentLiveRoom:vc];
            }
            
        } else {
            SYVoiceChatRoomVC *vc = [[SYVoiceChatRoomVC alloc] initWithChannelID:roomId
                                                                           title:roomName
                                                                        password:password];
            vc.from = [weakSelf fromString];
            vc.reportInfo = self.reportInfo;
            [weakSelf presentVoiceChatRoom:vc];
        }
    };
    if (![roomId isEqualToString:self.channelID?:@""]) {
        if (self.currentVC) {
            if (self.floatBall) {
                // 说明在浮球状态
                block();
            } else {
                [self.currentVC.navigationController dismissViewControllerAnimated:YES
                                                                        completion:block];
            }
        } else {
            block();
        }
    } else {
        if (self.currentVC) {
            if (self.floatBall) {
                [self removeFloatBall];
                [self presentCurrentVoiceChatRoom];
            } else {
                [self.currentVC.navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
}

- (void)presentCurrentVoiceChatRoom {
    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    if (self.currentVC) {
        [self removeFloatBall];
        SYNavigationController *naviVC = [[SYNavigationController alloc] initWithRootViewController:self.currentVC];
        naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [rootVC presentViewController:naviVC
                             animated:YES
                           completion:nil];
    }
}

- (void)forceDismissCurrentVoiceChatRoom {
    if (self.currentVC) {
        [self.currentVC.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self voiceChatRoomVCForceClosedWithVC:self.currentVC];
        self.currentVC = nil;
    }
}

- (void)voiceChatRoomVC:(SYVoiceChatRoomVC *)vc
  didPopOutWithRoomName:(NSString *)roomName
               roomIcon:(NSString *)roomIcon {
    if (!self.floatBall) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        SYVoiceRoomFloatBall *floatBall = [[SYVoiceRoomFloatBall alloc] initWithFrame:CGRectMake(self.floatBallOrigin.x, self.floatBallOrigin.y, 156.f, 42.f)];
        floatBall.delegate = self;
        [floatBall showWithRoomName:roomName
                           roomIcon:roomIcon];
        [window addSubview:floatBall];
        self.floatBall = floatBall;
        self.currentVC = vc;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(pan:)];
        [floatBall addGestureRecognizer:pan];
    }
}

- (void)voiceChatRoomVCChangeAnotherRoomWithVC:(SYVoiceChatRoomVC *)vc roomId:(NSString *)roomId {
    if (vc == self.currentVC) {
        [self tryToEnterVoiceChatRoomWithRoomId:roomId];
    }
}

- (void)voiceChatRoomVCForceClosedWithVC:(SYVoiceChatRoomVC *)vc {
    [self.floatBall removeFromSuperview];
    [self voiceRoomFloatBallDidClose];
}

- (void)voiceRoomFloatBallDidClose {
    self.currentVC = nil;
    self.floatBall = nil;
    self.channelID = nil;
}

- (void)voiceRoomFloatBallDidEnterRoomWithFloatBall:(SYVoiceRoomFloatBall *)floatBall {
    self.floatBall = nil;
    [self presentCurrentVoiceChatRoom];
}

- (void)liveRoomDidClose {
    [self.floatBall removeFromSuperview];
    [self voiceRoomFloatBallDidClose];
}

#pragma mark - private method

- (void)removeFloatBall {
    [self.floatBall removeFromSuperview];
    self.floatBall = nil;
}

- (void)pan:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.panStartOrigin = self.floatBallOrigin;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        CGPoint translation = [pan translationInView:pan.view.superview];
        CGPoint willPoint = CGPointMake(self.floatBallOrigin.x + translation.x, self.floatBallOrigin.y + translation.y);
        if (willPoint.x < 0) {
            willPoint.x = 0;
        }
        if (willPoint.y < 0) {
            willPoint.y = 0;
        }
        if (willPoint.x + self.floatBall.sy_width > window.sy_width) {
            willPoint.x = window.sy_width - self.floatBall.sy_width;
        }
        if (willPoint.y + self.floatBall.sy_height > window.sy_height) {
            willPoint.y = window.sy_height - self.floatBall.sy_height;
        }
        self.panStartOrigin = willPoint;
        
    } else if (pan.state == UIGestureRecognizerStateEnded ||
               pan.state == UIGestureRecognizerStateCancelled) {
        self.floatBallOrigin = self.panStartOrigin;
    }
    [self adjustFloatBallPosition];
}

- (void)adjustFloatBallPosition {
    self.floatBall.sy_left = self.panStartOrigin.x;
    self.floatBall.sy_top = self.panStartOrigin.y;
}

- (NSString *)fromString {
    switch (self.fromTag) {
        case SYVoiceChatRoomFromTagFocus:
        {
            return @"focus";
        }
            break;
        case SYVoiceChatRoomFromTagList:
        {
            return @"list";
        }
            break;
        case SYVoiceChatRoomFromTagOverScreen:
        {
            return @"piaoping";
        }
            break;
        case SYVoiceChatRoomFromTagLetvHomeFocus:
        {
            return @"letv-focus";
        }
            break;
        case SYVoiceChatRoomFromTagLetvList:
        {
            return @"letv-list";
        }
            break;
        case SYVoiceChatRoomFromTagHalfScreen:
        {
            return @"letv-album";
        }
            break;
        case SYVoiceChatRoomFromTagUnknown:
        {
            return @"unknown";
        }
            break;
        case SYVoiceChatRoomFromTagUserPage:
        {
            return @"personHome";
        }
            break;
        case SYVoiceChatRoomFromTagMyRoomList:
        {
            return @"my";
        }
            break;
        case SYVoiceChatRoomFromTagListFlow:
        {
            return @"flow";
        }
            break;
        case SYVoiceChatRoomFromTagAttentionList:
        {
            return @"attentionList";
        }
            break;
        case SYVoiceChatRoomFromTagLetvHome:
        {
            return @"letv-home";
        }
            break;
        case SYVoiceChatRoomFromTagLetvListFocus:
        {
            return @"letv-list-foucs";
        }
            break;
        default:
            break;
    }
    return @"";
}

#pragma mark - 总入口


- (void)tryToEnterVoiceChatRoomWithRoomId:(NSString *)roomId from:(SYVoiceChatRoomFromTag)fromTag reportInfo:(NSDictionary *)info {
    if (!roomId) {
        return;
    }
    self.reportInfo = info;
    [self tryToEnterVoiceChatRoomWithRoomId:roomId from:fromTag];
}

- (void)tryToEnterVoiceChatRoomWithRoomId:(NSString *)roomId from:(SYVoiceChatRoomFromTag)fromTag {
    if (!roomId) {
        return;
    }
    self.fromTag = fromTag;
    [self tryToEnterVoiceChatRoomWithRoomId:roomId];
}
- (void)tryToEnterVideoChatRoomWithRoomId:(NSString *)roomId from:(SYVoiceChatRoomFromTag)fromTag{
    //进入视频直播间
    [self tryToEnterVoiceChatRoomWithRoomId:roomId from:fromTag];
}
- (void)tryToEnterVoiceChatRoomWithRoomId:(NSString *)roomId {
    //
    if (!roomId) {
        return;
    }
    self.liveRoomIDList = nil;
    self.liveRoomCategoryID = 0;
    SYVoiceChatNetManager *manager = [[SYVoiceChatNetManager alloc] init];
    [manager requestChannelInfoWithChannelID:roomId
                                     success:^(id  _Nullable response) {
                                         if ([response isKindOfClass:[SYChatRoomModel class]]) {
                                             SYChatRoomModel *roomModel = (SYChatRoomModel *)response;
                                             // 根据未成年认证等级决定是否可以进入房间
                                             NSArray *whiteList = [SYSettingManager roomCategoryIdWhiteList];
                                             NSString *categoryStr = [NSString stringWithFormat:@"%ld", roomModel.category];
//                                             if (![whiteList containsObject:categoryStr]) {
//                                                 if ([[SYChildProtectManager sharedInstance] needChildProtectWithNavigationController:nil]) {
//                                                     return;
//                                                 }
//                                             }
                                             [self handleRoomInfo:roomModel];
                                         }
                                     } failure:^(NSError * _Nullable error) {
                                         [SYToastView showToast:@"房间信息获取失败"];
                                     }];
}

- (void)tryToEnterLiveRoomWithRoomId:(NSString *)roomId
                      liveRoomIDList:(NSArray *)liveRoomIDList
                          categoryID:(NSInteger)categoryID {
    [self tryToEnterVoiceChatRoomWithRoomId:roomId];
    self.liveRoomIDList = liveRoomIDList;
    self.liveRoomCategoryID = categoryID;
}

- (void)handleRoomInfo:(SYChatRoomModel *)roomModel {
    if ([roomModel.id isEqualToString:self.channelID]) {
        [self presentAnotherRoomWithRoomId:roomModel.id password:@"" roomType:roomModel.type hostID:roomModel.userInfo.id roomName:roomModel.name];
    } else {
        if (roomModel.lock == 1) {
            // 上锁
            self.lockRoomId = roomModel.id;
            self.lockRoomType = roomModel.type;
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            if (window) {
                SYPasswordInputView *view = [[SYPasswordInputView alloc] initWithFrame:window.bounds];
                view.delegate = self;
                [window addSubview:view];
            }
        } else{
            [self presentAnotherRoomWithRoomId:roomModel.id password:@"" roomType:roomModel.type hostID:roomModel.userInfo.id roomName:roomModel.name];
        }
    }
}

- (void)passwordInputViewDidEnterPassword:(NSString *)password {
    if (!self.lockRoomId) {
        return;
    }
    NSString *channelID = self.lockRoomId;
//    if (![channelID isEqualToString:self.channelID]) {
//        SYVoiceChatRoomVC *vc = [[SYVoiceChatRoomVC alloc] initWithChannelID:channelID
//                                                                       title:@""
//                                                                    password:password];
//        [[SYVoiceChatRoomManager sharedManager] presentVoiceChatRoom:vc];
//    } else {
//        [[SYVoiceChatRoomManager sharedManager] presentCurrentVoiceChatRoom];
//    }
    [self presentAnotherRoomWithRoomId:channelID password:password roomType:self.lockRoomType hostID:@"" roomName:@""];
    self.lockRoomId = nil;
    self.lockRoomType = 0;
}

- (void)passwordInputViewDidCancelEnter {
    self.lockRoomId = nil;
    self.lockRoomType = 0;
}

- (void)forceUpdateCurrentFloatBallToFront {
    if (self.floatBall) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        if (self.floatBall.superview == nil) {
            [window addSubview:self.floatBall];
        }else {
            [window bringSubviewToFront:self.floatBall];
        }
    }
}

@end
