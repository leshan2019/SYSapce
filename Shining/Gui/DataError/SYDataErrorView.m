//
//  SYDataErrorView.m
//  Shining
//
//  Created by 杨玄 on 2019/5/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYDataErrorView.h"

@interface SYDataErrorView ()

@property (nonatomic, weak) id <SYDataErrorViewDelegate> delegate;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *refreshBtn;

@end

@implementation SYDataErrorView

- (instancetype)initSYDataErrorViewWithFrame:(CGRect)frame withDelegate:(id<SYDataErrorViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self addSubview:self.tipLabel];
        [self addSubview:self.refreshBtn];
        [self mas_makeConstraits];
    }
    return self;
}

- (void)mas_makeConstraits {

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.center.equalTo(self);
        make.height.mas_equalTo(15);
    }];

    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 28));
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(23);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - Lazyload

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"获取数据失败，请重试";
        _tipLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        _tipLabel.textColor = RGBACOLOR(153,153,153,1);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIButton *)refreshBtn {
    if (!_refreshBtn) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
        _refreshBtn.clipsToBounds = YES;
        _refreshBtn.layer.cornerRadius = 14;
        _refreshBtn.layer.borderWidth = 1;
        _refreshBtn.layer.borderColor = RGBACOLOR(153,153,153,1).CGColor;
        _refreshBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        [_refreshBtn setTitleColor:RGBACOLOR(68,68,68,1) forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(handleRefreshBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshBtn;
}

- (void)handleRefreshBtnClickEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYDataErrorViewClickRefreshBtn)]) {
        [self.delegate SYDataErrorViewClickRefreshBtn];
    }
}

@end
