//
//  SYNavigationController.m
//  LetvShiningModule
//
//  Created by mengxiangjian on 2019/5/7.
//  Copyright © 2019 LeEco. All rights reserved.
//

#import "SYNavigationController.h"
#import "ChatHelper.h"

@interface SYNavigationController ()

@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, assign) BOOL isShowKeyboard;
@property (nonatomic, assign) CGFloat customKeyboardHeight;

@end

@implementation SYNavigationController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.usedByPrivateMessage) {
        CGFloat normalHeight = iPhoneX ? 331+34 : 331;
        self.view.backgroundColor = [UIColor whiteColor];
        if (self.isShowKeyboard) {
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            CGFloat height = normalHeight + self.customKeyboardHeight;
            if (height > (screenSize.height - 20)) {
                height = screenSize.height - 20;
            }
            self.view.frame = CGRectMake(0, screenSize.height - height, screenSize.width, height);
        } else {
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            self.view.frame = CGRectMake(0, screenSize.height - normalHeight, screenSize.width, normalHeight);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.usedByPrivateMessage) {
        [self addKeyboardNotifcations];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.usedByPrivateMessage) {
        [self removeKeyboardNotifications];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.usedByPrivateMessage) {
        [self.view.superview addSubview:self.clearBtn];
        [self.view.superview sendSubviewToBack:self.clearBtn];
    }
}

//是否自动旋转,返回YES可以自动旋转,返回NO禁止旋转
- (BOOL)shouldAutorotate{
    return NO;
}

//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

//由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Lazyload

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] initWithFrame:self.view.superview.bounds];
        _clearBtn.backgroundColor = [UIColor clearColor];
        [_clearBtn addTarget:self action:@selector(hidePrivateMessageView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (void)hidePrivateMessageView {
    if ([ChatHelper shareHelper].chatVC!=nil) {
        if ([ChatHelper shareHelper].chatVC.deleteConversationIfNull) {
            //判断当前会话是否为空，若符合则删除该会话
            EMMessage *message = [[ChatHelper shareHelper].chatVC.conversation latestMessage];
            if (message == nil) {
                [[EMClient sharedClient].chatManager deleteConversation:[ChatHelper shareHelper].chatVC.conversation.conversationId isDeleteMessages:NO completion:nil];
            }
        }
        [ChatHelper shareHelper].chatVC = nil;
//        [[EMClient sharedClient].chatManager removeDelegate:self];
//        [[EMClient sharedClient].roomManager removeDelegate:self];
        
    }
    
    [UIView setAnimationsEnabled:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 私信功能键盘相关

- (void)addKeyboardNotifcations {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"SYChatViewControllerWillShowCustomKeyboardNotification"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"SYChatViewControllerWillhideShowCustomKeyboardNotification"
                                               object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SYChatViewControllerWillShowCustomKeyboardNotification"
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SYChatViewControllerWillhideShowCustomKeyboardNotification"
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.isShowKeyboard = YES;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {   // 系统键盘
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.customKeyboardHeight = endFrame.size.height - iPhoneX_BOTTOM_HEIGHT;
    } else if ([notification.name isEqualToString:@"SYChatViewControllerWillShowCustomKeyboardNotification"]) { // 自定义键盘
        NSNumber *height = notification.object;
        self.customKeyboardHeight = [height floatValue];
    } else {
        self.customKeyboardHeight = 0;
    }
    [self viewWillLayoutSubviews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.isShowKeyboard = NO;
    self.customKeyboardHeight = 0;
    [self viewWillLayoutSubviews];
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}


@end



@implementation UINavigationController (SYExtension)


- (void)sy_pushAnimationDidStop {
}

- (void)sy_pushViewController: (UIViewController*)controller
    animatedWithTransition: (UIViewAnimationTransition)transition {
  [self pushViewController:controller animated:NO];

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:1];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(sy_pushAnimationDidStop)];
  [UIView setAnimationTransition:transition forView:self.view cache:YES];
  [UIView commitAnimations];
}

- (UIViewController*)sy_popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
  UIViewController* poppedController = [self popViewControllerAnimated:NO];

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:1];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(sy_pushAnimationDidStop)];
  [UIView setAnimationTransition:transition forView:self.view cache:NO];
  [UIView commitAnimations];

  return poppedController;
}

@end
