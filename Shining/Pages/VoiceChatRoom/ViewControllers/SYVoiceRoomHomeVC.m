//
//  SYVoiceRoomHomeVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomHomeVC.h"
#import "SYVoiceRoomHomeFocusCell.h"
#import "SYVoiceRoomHomeCategoryCell.h"
#import "SYVoiceRoomHomeListCell.h"
#import "SYVoiceRoomHomeHeaderView.h"
#import "SYMyVoiceChatRoomListVC.h"
#import "SYVoiceChatRoomVC.h"
#import "SYVoiceChatRoomManager.h"
#import "SYRoomHomeView.h"
#import "SYMineViewController.h"
#import "ShiningSdkManager.h"
#import "SYUserServiceAPI.h"
#import "UIButton+SYBadge.h"
#import "SYNoNetworkView.h"
#import "SYCreateVoiceRoomVC.h"
#import "SYPerfectUserInfoVC.h"
//#import "HeziSDK.h"
#import "SYSearchUserVC.h"
#import "SYRoomCategoryViewModel.h"
#import "SYRoomHomePageViewModel.h"
#import "SYRoomHomeBgScrollView.h"
//
#import "SYCategoryView.h"

#import "SYNoNetworkView.h"
//#import "SYCreateActivityVC.h"
#import "SYNavigationController.h"
#import "SYConversationListController.h"

#define MAX_FONT 20.f
#define Tab_SPEC 2.f
#define spec  7.f

@interface SYVoiceRoomHomeVC () <
UIScrollViewDelegate,
SYNoNetworkViewDelegate,
/*HeziTriggerActivePageDelegate,*/
SYRoomHomeViewDelegate,
SYNoNetworkViewDelegate,
SYCategoryViewDelegate
>
@property (nonatomic, strong) SYRoomHomeBgScrollView *bgScrollView;
//
@property (nonatomic, strong) NSMutableArray<SYRoomHomeView*> *homeViewsArr;
@property (nonatomic, assign) NSInteger beginIndex;
@property (nonatomic, strong) SYNoNetworkView *noNetworkView;
@property (nonatomic, strong) UIButton *IMBtn;
//
@property (nonatomic, assign) BOOL isShowing;//当前VC是否正在显示
//@property (nonatomic, strong) HeziTrigger *heziTriggerHanlder;
//
@property (nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) SYRoomHomePageViewModel *viewModel;
@property (nonatomic, strong) SYRoomCategoryViewModel *categoryViewModel;
//
@property (nonatomic, strong) SYCategoryTitleView *tabScrollView;
@end

@implementation SYVoiceRoomHomeVC

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setupUnreadMessageCount" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SYNotification_CloseHezi" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[SYRoomHomePageViewModel alloc]init];
    [self sy_configDataInfoPageName:SYPageNameType_VoiceRoom_Home];
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = DEFAULT_THEME_BG_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStatusUserInfoChanged)
                                                 name:KNOTIFICATION_USERINFOREADY
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dissmissHezi)
                                                 name:@"SYNotification_CloseHezi"
                                               object:nil];
    
    
    [self.view addSubview:self.bgScrollView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    //
    self.categoryViewModel = [[SYRoomCategoryViewModel alloc]init];
    [self requestCategoryList];
    
}
- (void)resetCategoryViewModel{
    self.indexArr = @[].mutableCopy;
    self.homeViewsArr = @[].mutableCopy;
    self.bgScrollView.contentSize = CGSizeMake(self.view.sy_width*[self.categoryViewModel first_categoryCount], self.view.sy_height);
    for (int i=0; i<[self.categoryViewModel first_categoryCount]; i++) {
        NSInteger type = [self.categoryViewModel first_categoryTypeIndex:i];
        [self.indexArr addObject:@(type)];
        
        CGFloat y = iPhoneX ? 88.f : 64.f;
        CGFloat x = self.view.sy_width;
        
        SYRoomHomeView * homeView = [[SYRoomHomeView alloc]initWithFrame:CGRectMake(x*i, y, self.view.sy_width, self.view.sy_height - y ) andCategoryType:type];
        homeView.delegate = self;
        homeView.categoryViewModel = self.categoryViewModel;
        homeView.backgroundColor = [UIColor orangeColor];
        [homeView resetSubViewsFrame];
        [self.bgScrollView addSubview:homeView];
        [self.homeViewsArr addObject:homeView];
    }
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
    if (unreadCount > 0) {
        
        [self.IMBtn sy_showBadgeOnItem];
        
    }else{
        [self.IMBtn sy_hideBadgeOnItem];
        
    }
    [self.IMBtn setNeedsLayout];
}

- (void)myChannel:(id)sender {
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络连接中断，请检查网络"];
        return;
    }
    SYMyVoiceChatRoomListVC *vc = [[SYMyVoiceChatRoomListVC alloc] init];
    //    SYCreateVoiceRoomVC *vc = [[SYCreateVoiceRoomVC alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isShowing = NO;
//    [[HeziSDKManager sharedInstance]onPageEnd:@"聊天室首页"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarDard];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    //    self.navigationController.navigationBar.barTintColor = [UIColor sam_colorWithHex:@"#F5F6F7"];
    self.isShowing = YES;
    
//    [[HeziSDKManager sharedInstance]onPageStart:@"聊天室首页"];
    [self triggerWithEvent:@"logged"];
    
    [self updateViewModel];
    [self setNavLeftItem];
    NSString *livingChannelID = [SYSettingManager livingChannelID];
    [SYSettingManager setLivingChannelID:nil];
    if (![NSString sy_isBlankString:livingChannelID]) {
        void (^block)(void) = ^ {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"直播正在继续，点击确定立即返回"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定"
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction * _Nonnull action) {
                [[SYVoiceChatRoomManager sharedManager] tryToEnterVoiceChatRoomWithRoomId:livingChannelID];
            }];
            [alert addAction:action];
            [alert addAction:action1];
            [self presentViewController:alert
                               animated:YES
                             completion:nil];
        };
        
        //        [self.viewModel requestRoomInfoWithRoomId:livingChannelID
        //                                            block:^(BOOL success) {
        //                                                if (success) {
        //                                                    block();
        //                                                }
        //                                            }];
        block();
    }
}

- (void)updateViewModel {
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestPageType:FirstCategoryType_default  andUserRightWithBlock:^(BOOL success) {
        if (success && [weakSelf.viewModel canEnterMyChannel]) {
            [weakSelf createShiningRightBarItemView:YES];
        } else {
            [weakSelf createShiningRightBarItemView:NO];
        }
    }];
}


- (void)dissmissHezi {
//    if (self.heziTriggerHanlder) {
//        [self.heziTriggerHanlder dismiss];
//        self.heziTriggerHanlder = nil;
//    }
}

#pragma mark - RoomHome delegate
- (void)roomHomeView_clickFocusView:(UIViewController *)vc{
    [self chatingRoomClickFocusView:vc];
}

- (void)chatingRoomClickFocusView:(UIViewController *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 登陆用户信息状态发生变化通知
 */
- (void)loginStatusUserInfoChanged {
    // 请求个人用户信息
    if (![NSString sy_isBlankString:[SYSettingManager accessToken]]) {
        [self updateViewModel];
#ifdef ShiningSdk
        if (self.isShowing) {
            if ([[UserProfileManager sharedInstance] getIsFromLoginPage]) {
                if ([[UserProfileManager sharedInstance] isUserManualLogin]) {
                    [[UserProfileManager sharedInstance] setNeedInfo:YES];
                }
                UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
                if (![SYSettingManager isShowNeedInfo:user.userid]) {
                    SYPerfectUserInfoVC *vc = [[SYPerfectUserInfoVC alloc] init];
                    vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:vc animated:YES completion:nil];
                }
            }else {
                [ShiningSdkManager voiceHomeAutoLogin:self];
            }
        }
        [[UserProfileManager sharedInstance] setFromLoginPage:NO];
        [[UserProfileManager sharedInstance] setUserManualLogin:NO];
#else
        if (self.isShowing) {
            if ([[UserProfileManager sharedInstance] isUserManualLogin]) {
                SYPerfectUserInfoVC *vc = [[SYPerfectUserInfoVC alloc] init];
                vc.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:vc animated:YES completion:nil];
                [[UserProfileManager sharedInstance] setUserManualLogin:NO];
            }
        }
#endif
    }
}
/**
 乐视视频sdk 首页 right btn
 @param canEnterMyChannel 是否有创建房间权限
 */
- (void)createRightBarItemView:(BOOL)canEnterMyChannel {
    CGFloat buttonWidth = 28.f;
    CGFloat buttonHeight = 44.f;
    CGFloat spacing = 15.f;
    if (iPhone5) {
        spacing = 2;
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth , buttonHeight)];
    backgroundView.userInteractionEnabled = YES;
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [searchButton setImage:[UIImage imageNamed_sy:@"letv_chatHome_search"]
                  forState:UIControlStateNormal];
    [searchButton addTarget:self
                     action:@selector(search:)
           forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:searchButton];
    if ([NSString sy_isBlankString:[SYSettingManager accessToken]]) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 0;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:backgroundView]];
        return;
    }
    UIButton *creatChannelBtn = nil;
    if (canEnterMyChannel) {
        UIImage *img = [UIImage imageNamed_sy:@"letv_chatHome_CreatHome"];
        creatChannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect tempFrame;
        tempFrame.size = CGSizeMake(buttonWidth, buttonHeight);
        tempFrame.origin = CGPointMake(searchButton.sy_right + spacing, 0);
        [creatChannelBtn setFrame:tempFrame];
        [creatChannelBtn setImage:img forState:UIControlStateNormal];
        [creatChannelBtn addTarget:self action:@selector(myChannel:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:creatChannelBtn];
        backgroundView.sy_width += (buttonWidth + spacing);
    }
    
    self.IMBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.IMBtn.frame = CGRectMake(canEnterMyChannel ? creatChannelBtn.sy_right + spacing : searchButton.sy_right + spacing, 0, buttonWidth, buttonHeight);
    UIImage *img = [UIImage imageNamed_sy:@"letv_chatHome_IM"];
    [self.IMBtn setTitleColor:[UIColor sy_colorWithHexString:@"#444444"] forState:UIControlStateNormal];
    [self.IMBtn setImage:img forState:UIControlStateNormal];
    [self.IMBtn addTarget:self action:@selector(doIMTap) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:self.IMBtn];
    backgroundView.sy_width += (buttonWidth + spacing);
    
    [self setupUnreadMessageCount];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:backgroundView]];
}

// 独立app RightBarItem 创建
- (void)createShiningRightBarItemView:(BOOL)canEnterMyChannel {
    if (self.tabBarController.selectedIndex != 0) {
        /**
        *  网络请求慢的时候，等切换到别的tab的时候，网络请求回来，但是此时已不再聊天室首页了，
        *  导致影响了别的tab的右上角度的按钮
        */
        return;
    }
    CGFloat buttonWidth = 28.f;
    CGFloat buttonHeight = 44.f;
    CGFloat spacing = 10.f;
    if (iPhone5) {
        spacing = 2;
    }
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth , buttonHeight)];
    backgroundView.userInteractionEnabled = YES;
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [searchButton setImage:[UIImage imageNamed_sy:@"letv_chatHome_search"]
                  forState:UIControlStateNormal];
    [searchButton addTarget:self
                     action:@selector(search:)
           forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:searchButton];
    if ([NSString sy_isBlankString:[SYSettingManager accessToken]]) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 0;
        self.tabBarController.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:backgroundView]];
        return;
    }
    UIButton *creatChannelBtn = nil;
    if (canEnterMyChannel) {
        UIImage *img = [UIImage imageNamed_sy:@"letv_chatHome_CreatHome"];
        creatChannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect tempFrame;
        tempFrame.size = CGSizeMake(buttonWidth, buttonHeight);
        tempFrame.origin = CGPointMake(searchButton.sy_right + spacing, 0);
        [creatChannelBtn setFrame:tempFrame];
        [creatChannelBtn setImage:img forState:UIControlStateNormal];
        [creatChannelBtn addTarget:self action:@selector(myChannel:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:creatChannelBtn];
        backgroundView.sy_width += (buttonWidth + spacing);
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = 0;
    self.tabBarController.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:backgroundView]];
}

/**
 进入IM 页
 */
- (void)doIMTap {
    SYConversationListController *chatListVC = [[SYConversationListController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:chatListVC animated:YES];
}

// 搜索点击事件，搜索页面的入口
- (void)search:(id)sender {
    BOOL hasLogin = [self checkUserHasLoginAccount];
    if (!hasLogin) {
        return;
    }
    SYSearchUserVC *vc = [SYSearchUserVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)checkUserHasLoginAccount {
    if ([SYSettingManager userHasLogin]) {
        return YES;
    }
    [ShiningSdkManager checkLetvAutoLogin:self];
    return NO;
}

/**
 乐视视频 sdk 首页 leftbar btn
 */
- (void)createLeftBarItemView {
    self.tabBarController.navigationItem.leftBarButtonItems = nil;
#ifdef ShiningSdk
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 100, 28)];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed_sy:@"shiningAbBack"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed_sy:@"shiningAbBack_h"] forState:UIControlStateHighlighted];
    UIBarButtonItem*back = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem*content = [[UIBarButtonItem alloc] initWithCustomView:self.tabScrollView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 0;
        self.tabBarController.navigationItem.leftBarButtonItems = @[negativeSpacer,back,content ];
    } else {
        self.tabBarController.navigationItem.leftBarButtonItems = @[back,content];
    }
#else
    UIBarButtonItem*left = [[UIBarButtonItem alloc]initWithCustomView:self.tabScrollView];
    self.tabBarController.navigationItem.leftBarButtonItem = left;
#endif
}

-(void)back{
    [[ShiningSdkManager shareShiningSdkManager] exitShiningAppMainView:^{

    }];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addNoNetworkView {
    [self removeNoNetworkView];
    
    self.noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:self.view.bounds
                                                                  withDelegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.noNetworkView];
}

- (void)removeNoNetworkView {
    if (self.noNetworkView) {
        [self.noNetworkView removeFromSuperview];
    }
    self.noNetworkView = nil;
}

#pragma mark - UI
- (SYRoomHomeBgScrollView *)bgScrollView{
    if (!_bgScrollView) {
        SYRoomHomeBgScrollView *scr = [[SYRoomHomeBgScrollView alloc] initWithFrame:self.view.bounds];
        scr.sy_top = 3;
        scr.delegate = self;
        scr.contentSize = CGSizeMake(self.view.sy_width*[self.categoryViewModel first_categoryCount], self.view.sy_height);
        scr.showsVerticalScrollIndicator = NO;
        scr.showsHorizontalScrollIndicator = NO;
        scr.pagingEnabled = YES;
        scr.bounces = NO;
        if (@available(iOS 11.0, *)) {
            scr.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _bgScrollView = scr;
    }
    return _bgScrollView;
}
#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.bgScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.view.sy_width;
        if (index < self.homeViewsArr.count) {
            SYRoomHomeView*homeView = self.homeViewsArr[index];
            if (homeView && !homeView.hasRequestedData) {
                [homeView requestVideoHomeData];
            }
        }
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.view.sy_width;
    if (index < self.homeViewsArr.count) {
        SYRoomHomeView*homeView = self.homeViewsArr[index];
        [homeView setMainTableViewScrollEnable:( scrollView.contentOffset.x == scrollView.sy_width*index)];
    }
}
#pragma mark -

-(void)triggerWithEvent:(NSString *)event
{
//    UserProfileEntity *user = [UserProfileEntity getUserProfileEntity];
//    NSString *mobile = ![NSString sy_isBlankString: user.mobile]?user.mobile:@"13800138000";
//    self.heziTriggerHanlder = [HeziTrigger trigger:event userInfo:@{@"username":user.userid?:@"",@"mobile":mobile}  showIconInView:self.view rootController:self delegate:self shareBlock:^(HeziShareModel *sharemodel) {
//        NSLog(@"sharemodel titkle==%@",sharemodel.title);
//    }];
    
}

/*
#pragma mark 盒子触发相关回调
- (void)heziTirgger:(HeziTrigger *)trigger triggerError:(NSError *)error{
    //请求失败的错误回调
    //当触发失败时 用户可重新发起触发请求 以便不影响用户的抽奖机会
    NSLog(@"error msg===>%@,tag===>%ld",error.localizedDescription,(long)trigger.tag);
}

- (void)heziTriggerSuccess:(HeziTrigger *)trigger triggerInformation:(id)triggerInfo {
    NSError * error = nil;
    if (![NSObject sy_empty: triggerInfo]) {
        NSData * data = [NSJSONSerialization dataWithJSONObject:triggerInfo options:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            NSLog(@"heziTriggerSuccess 服务器返回:%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        }
    }
}

//触发活动打开拦截事件
//可以在该方法中自定义活动页(如果没有特别要求,使用sdk内置的活动页可以大大减少开发时间和debug时间),自定义方案在(#pragma mark - 自定义活动页)
-(BOOL)heziTriggerWillOpenActivePage:(HeziTrigger *)heziSDK activityURL:(NSString *)url{
    
    NSArray *views = [heziSDK subviews];
    if (views && views.count>0) {
        UIImageView *iconView = views.firstObject;
        if (iconView.frame.size.width
            >150) {
            NSLog(@"当前触发的是大图");
        } else{
            NSLog(@"当前触发的是小图");
        }
    }
    
    for (UIView *view in views) {
        if ([view isKindOfClass:UIImageView.class]) {
            UIImageView *imgView = (UIImageView *)view;
            NSLog(@"imagw=>%f,imgH=%f",imgView.frame.size.width,imgView.frame.size.height);
        }
    }
    
    //不拦截sdk内部的跳转 要跳转到自己的 webview 页面的话返回 NO
    NSLog(@"url==>%@",url);
    return  YES;
}

//盒子活动关闭回调
-(void)heziTriggerDidCloseActivePage:(HeziTrigger *)heziSDK{
    //默认情况下触发的图标点击不会自动关闭,开发者要关闭需要在这里调用关闭的方法
    NSLog(@"heziTriggerDidCloseActivePage has called");
    [heziSDK dismiss];
    
}

 */
#pragma mark - leftitems
- (SYCategoryTitleView *)tabScrollView{
    if (!_tabScrollView) {
        SYCategoryTitleView*tabView = [[SYCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        tabView.cellSpacing = 22;
        tabView.backgroundColor = [UIColor clearColor];
        tabView.delegate = self;
        tabView.contentEdgeInsetLeft= 10;
        tabView.titleFont = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        tabView.titleSelectedFont = [UIFont systemFontOfSize:MAX_FONT weight:UIFontWeightSemibold];
        tabView.titleSelectedColor = [UIColor sy_colorWithHexString:@"#612AE0"];
        tabView.titleColor = [UIColor sy_colorWithHexString:@"#909090"];
        tabView.titleColorGradientEnabled = YES;
        tabView.titleLabelZoomEnabled = YES;
        tabView.titleLabelAnchorPointStyle = SYCategoryTitleLabelAnchorPointStyleBottom;
        
        SYCategoryIndicatorLineView *lineView = [[SYCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = [UIColor sy_colorWithHexString:@"#612AE0"];
        lineView.indicatorWidth = 12;
        lineView.lineStyle = SYCategoryIndicatorLineStyle_LengthenOffset;
        tabView.indicators = @[lineView];
        tabView.contentScrollView = self.bgScrollView;
        _tabScrollView = tabView;
    }
    return _tabScrollView;
}

- (void)requestCategoryList{
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [self.categoryViewModel requestCategoryListWithBlock:^(BOOL success) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (!success) {
            [weakSelf addNoNetworkView];
        }
        [weakSelf resetCategoryViewModel];
        [weakSelf reloadLeftTabsSubViews];
    }];
}

- (void)SYNoNetworkViewClickRefreshBtn {
    [self removeNoNetworkView];
    [self requestCategoryList];
}

-(void)setNavLeftItem{
#ifdef ShiningSdk
    [ShiningSdkManager voiceHomeAutoLogin:self];
#endif
    [self createLeftBarItemView];
}
-(void)reloadLeftTabsSubViews{
    
    CGFloat width = [self.categoryViewModel first_categoryTitleSepCount]*MAX_FONT+([self.categoryViewModel first_categoryCount]-1)*22+20 ;
    if (width > 180) {
        width = 180;
    }
#ifdef ShiningSdk
    if (iPhone5) {
        width -= 66;
    }
#endif
    self.tabScrollView.titles = [self.categoryViewModel first_categoryTitlesArray];
    self.tabScrollView.frame = CGRectMake(0, 0, width,44 );
    [self.tabScrollView reloadData];
    [self setNavLeftItem];
    //    NSInteger type = [self.categoryViewModel first_categoryTypeIndex:0];
    SYRoomHomeView*homeView = self.homeViewsArr.firstObject;
    homeView.categoryViewModel = self.categoryViewModel;
    [homeView requestVideoHomeData];
}
#pragma mark ======= SYTabView delegate ======
- (void)categoryView:(SYCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    if (index < self.homeViewsArr.count) {
        SYRoomHomeView*homeView = self.homeViewsArr[index];
        if (homeView && !homeView.hasRequestedData) {
            [homeView requestVideoHomeData];
        }
    }
}
@end
