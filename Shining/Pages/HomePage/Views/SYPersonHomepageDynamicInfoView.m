//
//  SYPersonHomepageDynamicInfoView.m
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageDynamicInfoView.h"
#import "SYPersonHomepageInfoView.h"
#import "SYPersonHomepageDynamicView.h"

@interface SYPersonHomepageDynamicInfoView ()<UIScrollViewDelegate,
SYDynamicViewProtocol>

@property (nonatomic, strong) UIButton *dynamicBtn;     // "动态"btn
@property (nonatomic, strong) UIButton *infoBtn;        // "资料"btn
@property (nonatomic, strong) UIView *scrollLine;       // 横线

@property (nonatomic, strong) UIScrollView *scrollView; // 滚动view
@property (nonatomic, strong) SYPersonHomepageDynamicView *dynamicView; // 动态view
@property (nonatomic, strong) SYPersonHomepageInfoView *infoView;    // 资料view

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) UIView *bottomLine;               // 分割线

@end

@implementation SYPersonHomepageDynamicInfoView

- (instancetype)initWithFrame:(CGRect)frame userId:(NSString *)userId {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.userId = userId;
    }
    return self;
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    [self.dynamicView configeUserId:userId];
}

#pragma mark - Public

- (void)requestDynamicListData {
    [self.dynamicView requestFirstPageListData];
}

- (void)updateInfoView:(NSString *)userId coordinate:(NSString *)coordinate constellation:(NSString *)constellation {
    [self.infoView updateHomepageInfoViewWithId:userId coordinate:coordinate constellation:constellation];
}

- (UIScrollView *)getDynammicScrollView {
    return [self.dynamicView getDynamicScrollView];
}

- (void)setDynamicViewScrollDelegate:(UIViewController *)vc {
    self.dynamicView.offSetDelegate = vc;
}

#pragma mark - Private

- (void)initSubViews {
    self.backgroundColor = RGBACOLOR(247,247,247,1);
    [self addSubview:self.dynamicBtn];
    [self addSubview:self.infoBtn];
    [self addSubview:self.scrollLine];
    [self addSubview:self.bottomLine];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.dynamicView];
    [self.scrollView addSubview:self.infoView];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    self.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    self.width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    [self.dynamicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(self.width / 2 - 37 - 40);
        make.top.equalTo(self).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 28));
    }];
    [self.infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-(self.width / 2 - 37 - 40));
        make.top.equalTo(self).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 28));
    }];
    [self.scrollLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 3));
        make.top.equalTo(self.dynamicBtn.mas_bottom).with.offset(2);
        make.left.equalTo(self.dynamicBtn).with.offset(13);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.right.equalTo(self);
        make.top.equalTo(self.scrollLine.mas_bottom).with.offset(1);
        make.height.mas_equalTo(1);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomLine.mas_bottom);
        make.left.equalTo(self);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(height - 46);
    }];
    [self.dynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.width.mas_equalTo(self.width);
        make.height.mas_equalTo(height - 46);
    }];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dynamicView.mas_right);
        make.top.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(self.width, 300));
    }];
    self.scrollView.contentSize = CGSizeMake(2 * self.width, 0);
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        NSInteger x = self.scrollView.contentOffset.x;
        // 手势互斥相关处理逻辑
        if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(changeDynamicInfoViewScrollViewContentOffset:)]) {
            [self.scrollDelegate changeDynamicInfoViewScrollViewContentOffset:x];
        }
        // 字体颜色变化
        if (x <= self.width/2) {
            self.dynamicBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
            self.infoBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            self.dynamicBtn.selected = YES;
            self.infoBtn.selected = NO;
            [self.scrollLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.dynamicBtn).with.offset(13);
            }];
        } else {
            self.dynamicBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
            self.infoBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
            self.dynamicBtn.selected = NO;
            self.infoBtn.selected = YES;
            [self.scrollLine mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.dynamicBtn).with.offset(40+74+13);
            }];
        }
//        // 横线x变化
//        NSInteger xChange = self.width / 14 ;
//        NSInteger addCount = x/xChange;
//        // x : 13 -> 20
//        if (x <= self.width/2) {
//            [self.scrollLine mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.dynamicBtn).with.offset(13 + addCount);
//            }];
//        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat x = self.scrollView.contentOffset.x;
        if (x == 0) {
            self.dynamicBtn.selected = YES;
            self.infoBtn.selected = NO;
        } else if (x == self.width) {
            self.dynamicBtn.selected = NO;
            self.infoBtn.selected = YES;
        }
    }
}

#pragma mark - BtnClickEvent

- (void)handleDynamicBtnClick {
    if (self.dynamicBtn.selected) {
        return;
    }
//    self.dynamicBtn.selected = YES;
//    self.dynamicBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
//    self.infoBtn.selected = NO;
//    self.infoBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)handleInfoBtnClick {
    if (self.infoBtn.selected) {
        return;
    }
//    self.infoBtn.selected = YES;
//    self.infoBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
//    self.dynamicBtn.selected = NO;
//    self.dynamicBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self.scrollView setContentOffset:CGPointMake(self.width, 0) animated:YES];
}

#pragma mark - SYDynamicViewProtocol

// 头像
- (void)SYDynamicViewClickAvatar:(NSString *)userId {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickAvatar:)]) {
        [self.delegate SYDynamicViewClickAvatar:userId];
    }
}

// 播放视频
- (void)SYDynamicViewClickPlayVideo:(NSString *)videoUrl {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickPlayVideo:)]) {
        [self.delegate SYDynamicViewClickPlayVideo:videoUrl];
    }
}

#pragma mark - Lazyload

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, 0)];
        _scrollView.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIButton *)dynamicBtn {
    if (!_dynamicBtn) {
        _dynamicBtn = [UIButton new];
        _dynamicBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        [_dynamicBtn setTitle:@"动态" forState:UIControlStateNormal];
        [_dynamicBtn setTitleColor:RGBACOLOR(144,144,144,1) forState:UIControlStateNormal];
        [_dynamicBtn setTitleColor:RGBACOLOR(97,42,224,1) forState:UIControlStateSelected];
        _dynamicBtn.selected = YES;
        [_dynamicBtn addTarget:self action:@selector(handleDynamicBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dynamicBtn;
}

- (UIButton *)infoBtn {
    if (!_infoBtn) {
        _infoBtn = [UIButton new];
        [_infoBtn setTitle:@"资料" forState:UIControlStateNormal];
        _infoBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [_infoBtn setTitleColor:RGBACOLOR(144,144,144,1) forState:UIControlStateNormal];
        [_infoBtn setTitleColor:RGBACOLOR(97,42,224,1) forState:UIControlStateSelected];
        [_infoBtn addTarget:self action:@selector(handleInfoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoBtn;
}

- (UIView *)scrollLine {
    if (!_scrollLine) {
        _scrollLine = [UIView new];
        _scrollLine.backgroundColor = RGBACOLOR(97,42,224,1);
        _scrollLine.clipsToBounds = YES;
        _scrollLine.layer.cornerRadius = 1.5;
    }
    return _scrollLine;
}

- (SYPersonHomepageDynamicView *)dynamicView {
    if (!_dynamicView) {
        _dynamicView = [[SYPersonHomepageDynamicView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, self.sy_height - 46) type:SYDynamicType_Homepage];
        _dynamicView.delegate = self;
    }
    return _dynamicView;
}

- (SYPersonHomepageInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[SYPersonHomepageInfoView alloc] initWithFrame:CGRectZero];
    }
    return _infoView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(238,238,238,1);
    }
    return _bottomLine;
}

@end
