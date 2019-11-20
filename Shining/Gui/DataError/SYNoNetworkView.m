//
//  SYNoNetworkView.m
//  Shining
//
//  Created by 杨玄 on 2019/5/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYNoNetworkView.h"

@interface SYNoNetworkView ()

@property (nonatomic, weak) id <SYNoNetworkViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *noNetImage;
@property (nonatomic, strong) UILabel *noNetTitle;
@property (nonatomic, strong) UILabel *noNetSubTitle;
@property (nonatomic, strong) UIButton *refreshBtn;

@end

@implementation SYNoNetworkView

- (instancetype)initSYNoNetworkViewWithFrame:(CGRect)frame
                                withDelegate:(id<SYNoNetworkViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self addSubview:self.noNetImage];
        [self addSubview:self.noNetTitle];
        [self addSubview:self.noNetSubTitle];
        [self addSubview:self.refreshBtn];
        [self mas_makeConstraits];
    }
    return self;
}

- (void)mas_makeConstraits {

    [self.noNetTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.center.equalTo(self);
        make.height.mas_equalTo(18);
    }];

    [self.noNetSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.noNetTitle.mas_bottom).with.offset(8);
        make.right.equalTo(self);
        make.height.mas_equalTo(15);
    }];

    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(85, 28));
        make.top.equalTo(self.noNetSubTitle.mas_bottom).with.offset(23);
        make.centerX.equalTo(self);
    }];

    CGSize imageSize = self.noNetImage.frame.size;
    [self.noNetImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageSize);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.noNetTitle.mas_top).with.offset(-12);
    }];

}

#pragma mark - Lazyload

- (UIImageView *)noNetImage {
    if (!_noNetImage) {
        _noNetImage = [UIImageView new];
        _noNetImage.bounds = CGRectMake(0, 0, 110, 110);
        _noNetImage.image = [UIImage imageNamed_sy:@"SY_NONetwork_Image"];
    }
    return _noNetImage;
}

- (UILabel *)noNetTitle {
    if (!_noNetTitle) {
        _noNetTitle = [UILabel new];
        _noNetTitle.text = @"网络未连接";
        _noNetTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _noNetTitle.textColor = RGBACOLOR(68,68,68,1);
        _noNetTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _noNetTitle;
}

- (UILabel *)noNetSubTitle {
    if (!_noNetSubTitle) {
        _noNetSubTitle = [UILabel new];
        _noNetSubTitle.text = @"别紧张，请检查网络后刷新页面～";
        _noNetSubTitle.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        _noNetSubTitle.textColor = RGBACOLOR(153,153,153,1);
        _noNetSubTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _noNetSubTitle;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYNoNetworkViewClickRefreshBtn)]) {
        [self.delegate SYNoNetworkViewClickRefreshBtn];
    }
}

@end
