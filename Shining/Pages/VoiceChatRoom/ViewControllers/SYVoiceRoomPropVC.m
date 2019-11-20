//
//  SYVoiceRoomPropVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/30.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomPropVC.h"
#import "SYVoiceRoomNavBar.h"
#import "SYVoiceRoomPropView.h"
#import "SYGiftInfoManager.h"
#import "SYMyCoinViewController.h"
#import <SVGAPlayer/SVGA.h>
#import "SYImageCutter.h"
#import "SYVoiceRoomGiveGiftView.h"
#import "SYGiveFriendGiftsVC.h"
#import "SYUserServiceAPI.h"

@interface SYVoiceRoomPropVC ()
<
SYVoiceRoomNavBarDelegate,
SYVoiceRoomPropViewDelegate,
SVGAPlayerDelegate,
SYVoiceRoomGiveGiftViewDelegate
>

@property (nonatomic, strong) SYVoiceRoomNavBar *navBar;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIImageView *roundImageView;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *avatarBox;

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *vehicleButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) UIView *propBgView;
@property (nonatomic, strong) SVGAPlayer *propPlayer;

@property (nonatomic, assign) NSInteger currentShowIndex;               // 当前展示的头像还是坐骑
@property (nonatomic, strong) SYVoiceRoomGiveGiftView *giveGiftView;    // 装扮赠送view

@end

@implementation SYVoiceRoomPropVC

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sy_configDataInfoPageName:SYPageNameType_Disguised];
    
    self.viewArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.roundImageView];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.avatarImageView];
    [self.view addSubview:self.avatarBox];
    
    [self.view addSubview:self.avatarButton];
    [self.view addSubview:self.vehicleButton];
    [self.view addSubview:self.lineView];
    
    self.propBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.propBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.propBgView.hidden = YES;
    [self.view addSubview:self.propBgView];
    
    self.propPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/4, self.view.frame.size.width, 200)];
    self.propPlayer.loops = 1 ;
    self.propPlayer.delegate = self;
    [self.propBgView addSubview:self.propPlayer];
    
    self.avatarButton.selected = YES;
    
    CGFloat y = 272.f;
    if (iPhoneX) {
        y += 24;
    }
    SYVoiceRoomPropView *propView = [[SYVoiceRoomPropView alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, self.view.sy_height - y) propType:1];
    propView.delegate = self;
    [self.view addSubview:propView];
    [propView requestData];
    [self.viewArray addObject:propView];
    self.currentShowIndex = 0;

    UserProfileEntity *userModel = [UserProfileEntity getUserProfileEntity];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar_imgurl]
                            placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    if (userModel.avatarbox > 0) {
        NSString *url = [[SYGiftInfoManager sharedManager] avatarBoxURLWithPropId:userModel.avatarbox];
        [self.avatarBox sd_setImageWithURL:[NSURL URLWithString:url]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarLight];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (SYVoiceRoomNavBar *)navBar {
    if (!_navBar) {
        CGFloat height = iPhoneX ? 88.f : 64.f;
        _navBar = [[SYVoiceRoomNavBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
        _navBar.delegate = self;
        [_navBar setMoreButtonHidden:YES];
        [_navBar setTitle:@"我的装扮"];
    }
    return _navBar;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 92.f, 92.f)];
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = 46.f;
        _avatarImageView.center = CGPointMake(self.view.sy_width / 2.f, self.roundImageView.sy_top);
    }
    return _avatarImageView;
}

- (UIImageView *)avatarBox {
    if (!_avatarBox) {
        _avatarBox = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125.f, 125.f)];
        _avatarBox.center = self.avatarImageView.center;
    }
    return _avatarBox;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        CGFloat ratio = 750.f / 606.f;
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.sy_width, self.view.sy_width / ratio - 100)];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.image = [UIImage imageNamed_sy:@"voiceroom_prop_top"];
        _topImageView.clipsToBounds = YES;
    }
    return _topImageView;
}

- (UIImageView *)roundImageView {
    if (!_roundImageView) {
        CGFloat y = iPhoneX ? (116.f + 24.f) : 116.f;
        CGFloat ratio = 750.f / 280.f;
        CGFloat height = self.view.sy_width / ratio;
        _roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, height)];
        _roundImageView.image = [UIImage imageNamed_sy:@"voiceroom_prop_round"];
    }
    return _roundImageView;
}

- (UIButton *)avatarButton {
    if (!_avatarButton) {
        CGFloat y = iPhoneX ? (198.f + 24.f) : 198.f;
        _avatarButton = [self buttonWithFrame:CGRectMake(0, y, self.view.sy_width / 2.f, 60.f)
                                        title:@"头像框"];
        [_avatarButton addTarget:self
                          action:@selector(showAvatarList:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}

- (UIButton *)vehicleButton {
    if (!_vehicleButton) {
        CGFloat y = iPhoneX ? (198.f + 24.f) : 198.f;
        _vehicleButton = [self buttonWithFrame:CGRectMake(self.view.sy_width / 2.f, y, self.view.sy_width / 2.f, 60)
                                         title:@"坐骑"];
        [_vehicleButton addTarget:self
                           action:@selector(showVehicleList:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _vehicleButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        CGFloat width = 49.f;
        CGFloat x = (self.view.sy_width / 2.f - width) / 2.f;
        x = (NSInteger)x;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(x, self.avatarButton.sy_top + 50.f, width, 2.f)];
        _lineView.backgroundColor = [UIColor sam_colorWithHex:@"#7138EF"];
        _lineView.layer.cornerRadius = 1.f;
    }
    return _lineView;
}

#pragma mark -

- (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor sam_colorWithHex:@"#343642"]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor sam_colorWithHex:@"#7138EF"]
                 forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:17.f];
    return button;
}

- (void)showAvatarList:(id)sender {
    self.avatarButton.selected = YES;
    self.vehicleButton.selected = NO;
    
    if ([self.viewArray count] >= 2) {
        SYVoiceRoomPropView *propView = [self.viewArray objectAtIndex:1];
        propView.hidden = YES;
        propView = [self.viewArray objectAtIndex:0];
        propView.hidden = NO;
    }
    self.currentShowIndex = 0;
    
    [self adjustLineViewPosition:0];
}

- (void)showVehicleList:(id)sender {
    self.avatarButton.selected = NO;
    self.vehicleButton.selected = YES;
    
    if ([self.viewArray count] < 2) {
        CGFloat y = 272.f;
        if (iPhoneX) {
            y += 24;
        }
        SYVoiceRoomPropView *propView = [[SYVoiceRoomPropView alloc] initWithFrame:CGRectMake(0, y, self.view.sy_width, self.view.sy_height - y) propType:2];
        [self.view addSubview:propView];
        [propView requestData];
        [self.viewArray addObject:propView];
        propView.delegate = self;
    }
    
    SYVoiceRoomPropView *propView = [self.viewArray objectAtIndex:0];
    propView.hidden = YES;
    propView = [self.viewArray objectAtIndex:1];
    propView.hidden = NO;

    self.currentShowIndex = 1;

    [self adjustLineViewPosition:1];
}

#pragma mark -

- (void)voiceRoomBarDidTapBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SYVoiceRoomPropViewDelegate

- (void)propViewDidLackOfBalance {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"余额不足"
                                                                   message:@"请前往充值"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                   }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去充值"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        SYMyCoinViewController *coinVC = [[SYMyCoinViewController alloc] init];
                                                        [coinVC requestMyCoin];
                                                        [self.navigationController pushViewController:coinVC animated:YES];
                                                    }];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (void)propViewDidSelectAvatarBox:(NSString *)avatarBox {
    [self.avatarBox sd_setImageWithURL:[NSURL URLWithString:avatarBox]];
}

- (void)propViewDidSlelectDriverBox:(NSInteger)propID {
    [self showAnimationWithDriver:propID];
}

// 弹出装扮赠送浮层
- (void)propViewClickGiveGiftsBtn {
    if (self.giveGiftView) {
        [self.giveGiftView removeFromSuperview];
        self.giveGiftView = nil;
    }
    self.giveGiftView = [[SYVoiceRoomGiveGiftView alloc] initWithFrame:self.view.bounds];
    self.giveGiftView.delegate = self;
    [self.view addSubview:self.giveGiftView];
}

#pragma mark - SVGAPlayerDelegate

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player
{
    self.propBgView.hidden = YES;
    [self.propPlayer stopAnimation];
    self.propPlayer.videoItem = nil;
}

#pragma mark - SYVoiceRoomGiveGiftViewDelegate

// 装扮赠送 - 赠送好友
- (void)SYVoiceRoomGiveGiftViewClickGiveFriendBtn {
    SYGiveFriendGiftsVC *vc = [SYGiveFriendGiftsVC new];
    __weak typeof(self) weakSelf = self;
    vc.ensureBlock = ^(NSString * _Nonnull userId) {
        [weakSelf.giveGiftView updateGiveFriendId:userId];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

// 装扮赠送 - 购买
- (void)SYVoiceRoomGiveGiftViewClickBuyBtn:(NSString *)userId {
    SYVoiceRoomPropView *propView = [self.viewArray objectAtIndex:self.currentShowIndex];
    [propView buyGiftForFriend:userId success:^(BOOL success, NSInteger code) {
        if (success) {
            [SYToastView showToast:@"赠送成功"];
            [self.giveGiftView removeFromSuperview];
            self.giveGiftView = nil;
            [self getFriendIMUserId:userId withPropType:self.currentShowIndex];
        } else {
            if (code == 4003) {
                [self propViewDidLackOfBalance];
            } else if (code == 4004) {
                [SYToastView showToast:@"用户ID不存在，请检查后再填写"];
            } else {
                [SYToastView showToast:@"赠送失败"];
            }
        }
    }];
}

- (void)getFriendIMUserId:(NSString *)userId withPropType:(NSInteger)type {
    [[SYUserServiceAPI sharedInstance] requestOtherUserInfo:userId success:^(id  _Nullable response) {
        UserProfileEntity *userModel = (UserProfileEntity *)response;
        [UserProfileEntity saveOtherUserInfo:userModel];
        [self sendMessageToFriend:userModel.em_username propType:type];
    } failure:^(NSError * _Nullable error) {
    }];
}

- (void)sendMessageToFriend:(NSString *)imUserId propType:(NSInteger)type {
    NSString *sendText = @"我赠送了你一个头像框哦，到装扮商场去看看吧~";
    if (type == 1) {
        sendText = @"我赠送了你一个坐骑哦，到装扮商场去看看吧~";
    }
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:sendText];
    NSString *from = [[EMClient sharedClient] currentUsername];
    UserProfileEntity *entity =  [UserProfileEntity getUserProfileEntity];
    NSString *userInfoStr =  [entity yy_modelToJSONString];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:imUserId from:from to:imUserId body:body ext:@{@"syUserInfo":userInfoStr}];
    message.chatType = EMChatTypeChat;
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:nil];
}

#pragma mark -

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)showAnimationWithDriver:(NSInteger)propId
{
    NSString *svgaPath = [[SYGiftInfoManager sharedManager] propSVGAWithPropID:propId];
    if (svgaPath) {
        NSURL *url=[NSURL  fileURLWithPath:svgaPath];
        if ([NSObject sy_empty:url]) {
            return;
        }
        SVGAParser *parser = [[SVGAParser alloc] init];
        __weak typeof(self) weakSelf = self;
//        self.isAnimate = YES;
        [parser parseWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            if (videoItem != nil) {
                CGFloat ratio = videoItem.videoSize.width / videoItem.videoSize.height;
                CGFloat height = self.view.sy_width / ratio;
                CGFloat y = (self.view.sy_height - height) / 2.f;
                weakSelf.propPlayer.frame = CGRectMake(0, y, self.view.sy_width, height);
                
                weakSelf.propPlayer.videoItem = videoItem;
                weakSelf.propBgView.hidden = NO;
                [weakSelf.view bringSubviewToFront:weakSelf.propBgView];
                UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];

                NSString *userNameStr = user.username;
                if (userNameStr.length>MAXLENGTH_OF_DRIVER_USERNAME) {
                    userNameStr = [NSString stringWithFormat:@"%@...",[userNameStr substringToIndex:MAXLENGTH_OF_DRIVER_USERNAME]];
                }
                NSString *textStr = [NSString stringWithFormat:@"%@进入聊天室",userNameStr];
                
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:textStr];
                NSRange range = [textStr rangeOfString:userNameStr?:@""];
                NSRange allRange =  [textStr rangeOfString:textStr?:@""];
                [text addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:22.0]
                             range:allRange];
                [text addAttribute:NSForegroundColorAttributeName
                             value:[UIColor sam_colorWithHex:@"#ffbc44"]
                             range:range];
                [text addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]
                             range:[textStr rangeOfString:@"进入聊天室"]];
                if ([NSString sy_isBlankString:user.avatar_imgurl]) {
                    [weakSelf.propPlayer setImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"] forKey:SVGA_DRIVER_IMAGENAME];
                }else{
                    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:user.avatar_imgurl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        if (error == nil && data != nil) {
                            UIImage *image = [UIImage imageWithData:data];
                            if (image != nil) {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    UIImage *circleImg = [SYImageCutter convertToCircleWithImage:image onWidth:0.f onColor:[UIColor clearColor]];
                                    [weakSelf.propPlayer setImage:circleImg forKey:SVGA_DRIVER_IMAGENAME];
                                }];
                            }
                        }
                    }] resume];
                }
                
                
                [weakSelf.propPlayer setAttributedText:text forKey:SVGA_TEXTNAME];
                [weakSelf.propPlayer startAnimation];
            }
        } failureBlock:nil];
        return;
    }
}

#pragma mark -

- (void)adjustLineViewPosition:(NSInteger)position {
    if (position > 1) {
        return;
    }
    CGFloat x = (self.view.sy_width / 2.f - self.lineView.sy_width) / 2.f + position * self.view.sy_width / 2.f;
    x = (NSInteger)x;
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.lineView.sy_left = x;
                     }];
}

@end
