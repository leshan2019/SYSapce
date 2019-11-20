//
//  SYMineShareFriendVC.m
//  Shining
//
//  Created by 杨玄 on 2019/3/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineShareFriendVC.h"
//#import <Masonry.h>
#import "WXApiObject.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"

@interface SYMineShareFriendVC ()<WXApiManagerDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *wxSectionBtn;
@property (nonatomic, strong) UIButton *wxTimelineBtn;
@property (nonatomic, strong) UIButton *qqFrientBtn;

@end

@implementation SYMineShareFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [WXApiManager sharedManager].delegate = self;
    self.view.backgroundColor = RGBACOLOR(226, 226, 226, 1);
    [self.view addSubview:self.bottomView];

    [self.bottomView addSubview:self.wxSectionBtn];
    [self.bottomView addSubview:self.wxTimelineBtn];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(62);
    }];

    [self.wxSectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).with.offset(10);
        make.bottom.equalTo(self.bottomView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];

    [self.wxTimelineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wxSectionBtn.mas_right).with.offset(30);
        make.bottom.equalTo(self.bottomView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(33, 33));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - WXApiManagerDelegate

- (void)managerDidRecvSendMessageToWXResponse:(SendMessageToWXResp *)response {
    if (response) {
        [SYToastView showToast:[NSString stringWithFormat:@"分享成功回调 = %@",response]];
    }
}

#pragma mark - LazyLoad

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = RGBACOLOR(187, 187, 187, 1);
    }
    return _bottomView;
}

- (UIButton *)wxSectionBtn {
    if (!_wxSectionBtn) {
        _wxSectionBtn = [UIButton new];
        _wxSectionBtn.backgroundColor = [UIColor redColor];
        [_wxSectionBtn setTitle:@"WS" forState:UIControlStateNormal];
        [_wxSectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wxSectionBtn addTarget:self action:@selector(shareToWXSection) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxSectionBtn;
}

- (UIButton *)wxTimelineBtn {
    if (!_wxTimelineBtn) {
        _wxTimelineBtn = [UIButton new];
        _wxTimelineBtn.backgroundColor = [UIColor redColor];
        [_wxTimelineBtn setTitle:@"WT" forState:UIControlStateNormal];
        [_wxTimelineBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wxTimelineBtn addTarget:self action:@selector(shareToWXTimeline) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxTimelineBtn;
}

// 微信分享 - 会话列表
- (void)shareToWXSection {
    BOOL success = [WXApiRequestHandler shareToWXSessionWithTitle:@"标题" description:@"描述" withThumbImage:@"缩略图" withUrl:@"https://www.baidu.com" ];
    if (success) {
        [SYToastView showToast:@"微信好友发送成功"];
    } else {
        [SYToastView showToast:@"微信好友发送失败"];
    }
}

// 微信分享 - 朋友圈
- (void)shareToWXTimeline {
    BOOL success = [WXApiRequestHandler shareToWXTimelineWithTitle:@"标题" description:@"描述" withThumbImageName:@"缩略图" withUrl:@"https://www.baidu.com" ];
    if (success) {
        [SYToastView showToast:@"朋友圈发送成功"];
    } else {
        [SYToastView showToast:@"朋友圈发送失败"];
    }
}

@end
