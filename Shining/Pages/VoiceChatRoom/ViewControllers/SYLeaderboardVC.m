//
//  SYLeaderboardVC.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLeaderboardVC.h"
#import "SYVoiceRoomNavBar.h"
#import "SYScrollSegmentedControl.h"
#import "SYLeaderBoardView.h"
#import "SYPersonHomepageVC.h"
#import "ShiningSdkManager.h"

@interface SYLeaderboardVC () <SYVoiceRoomNavBarDelegate,SYLeaderBoardViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, strong) SYVoiceRoomNavBar *navBar;
@property (nonatomic, strong) SYScrollSegmentedControl *scrollSegmentedControl;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *topTitle;

@end

@implementation SYLeaderboardVC

- (instancetype)initWithChannelID:(NSString *)channelID {
    self = [super init];
    if (self) {
        _channelID = channelID;
        _viewArray = [NSMutableArray new];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self sy_configDataInfoPageName:SYPageNameType_VoiceRoom_LeaderBoard];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.navBar];
    if (self.onlyShowOutcome) {
        [self.navBar addSubview:self.topTitle];
    } else {
        [self.navBar addSubview:self.scrollSegmentedControl];
    }
    
    [self drawLeaderBoardView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sy_setStatusBarLight];
}

- (void)drawLeaderBoardView {
    CGFloat count = self.onlyShowOutcome ? 1 : 2;
    NSInteger index = self.scrollSegmentedControl.selectedSegmentIndex;
    for (int i = 0; i < count; i ++) {
        if (i == 0) {
            SYLeaderBoardView *view = [[SYLeaderBoardView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.sy_width, self.scrollView.sy_height)
                                                                     channelID:self.channelID
                                                                          type:SYLeaderBoardViewTypeOutcome];
            view.delegate = self;
            [self.scrollView addSubview:view];
            [self.viewArray addObject:view];
        } else {
            SYLeaderBoardView *view = [[SYLeaderBoardView alloc] initWithFrame:CGRectMake(self.scrollView.sy_width, 0, self.scrollView.sy_width, self.scrollView.sy_height)
                                                                     channelID:self.channelID
                                                                          type:SYLeaderBoardViewTypeIncome];
            view.delegate = self;
            [self.scrollView addSubview:view];
            [self.viewArray addObject:view];
        }
    }

    self.scrollView.contentSize = CGSizeMake(count*self.scrollView.sy_width, 0);

//    for (int i = 0; i < [self.viewArray count]; i ++) {
//        SYLeaderBoardView *view = [self.viewArray objectAtIndex:i];
//        view.hidden = (i != index);
//    }
    [self.scrollSegmentedControl setBorderColor:(index == 0) ? [UIColor sam_colorWithHex:@"#7B40FF"] : [UIColor whiteColor]];
    [self.scrollSegmentedControl setSelectedTitleColor:(index == 0) ? [UIColor sam_colorWithHex:@"#7B40FF"] : [UIColor sam_colorWithHex:@"#38B1F3"]];
}

- (void)typeSelect:(id)sender {
//    [self drawLeaderBoardView];
    NSInteger index = self.scrollSegmentedControl.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.sy_width * index, 0)
                             animated:YES];
    [self.scrollSegmentedControl setBorderColor:(index == 0) ? [UIColor sam_colorWithHex:@"#7B40FF"] : [UIColor whiteColor]];
    [self.scrollSegmentedControl setSelectedTitleColor:(index == 0) ? [UIColor sam_colorWithHex:@"#7B40FF"] : [UIColor sam_colorWithHex:@"#38B1F3"]];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.sy_width;
        self.scrollSegmentedControl.selectedSegmentIndex = index;
    }
}

#pragma mark - SYLeaderBoardViewDelegate

- (void)leaderBoardViewDidSelectUserWithUid:(NSString *)uid {
    if ([NSString sy_isBlankString:[SYSettingManager accessToken]]) {
        [ShiningSdkManager checkLetvAutoLogin:self.navigationController];
        return;
    }
    SYPersonHomepageVC *vc = [[SYPersonHomepageVC alloc] init];
    vc.userId = uid;
    vc.attentionBlock = self.followSuccessBlock;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)topTitle {
    if (!_topTitle) {
        _topTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 243.f;
        CGFloat height = 30.f;
        CGFloat x = (self.navBar.sy_width - width) / 2.f;
        CGFloat y = self.navBar.sy_height - height - 7.f;
        _topTitle.frame = CGRectMake(x, y, width, height);
        [_topTitle setTitle:@"粉丝贡献榜" forState:UIControlStateNormal];
        [_topTitle setTitleColor:RGBACOLOR(113,56,239,1) forState:UIControlStateNormal];
        _topTitle.backgroundColor = [UIColor whiteColor];
        _topTitle.layer.cornerRadius = 15;
        _topTitle.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _topTitle;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (SYScrollSegmentedControl *)scrollSegmentedControl {
    if (!_scrollSegmentedControl) {
        CGFloat width = 242.f;
        CGFloat height = 30.f;
        CGFloat x = (self.navBar.sy_width - width) / 2.f;
        CGFloat y = self.navBar.sy_height - height - 7.f;
        _scrollSegmentedControl = [[SYScrollSegmentedControl alloc] initWithFrame:CGRectMake(x, y, width, height)
                                                                       titleArray:@[@"粉丝贡献榜", @"主播实力榜"]];
        [_scrollSegmentedControl setBorderColor:[UIColor sam_colorWithHex:@"#7B40FF"]];
        [_scrollSegmentedControl setSelectedTitleColor:[UIColor sam_colorWithHex:@"#7B40FF"]];
        [_scrollSegmentedControl addTarget:self
                                    action:@selector(typeSelect:)
                          forControlEvents:UIControlEventValueChanged];
    }
    return _scrollSegmentedControl;
}

- (SYVoiceRoomNavBar *)navBar {
    if (!_navBar) {
        CGFloat height = iPhoneX ? 88.f : 64.f;
        _navBar = [[SYVoiceRoomNavBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, height)];
        _navBar.delegate = self;
        [_navBar setMoreButtonHidden:YES];
    }
    return _navBar;
}

- (void)voiceRoomBarDidTapBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
