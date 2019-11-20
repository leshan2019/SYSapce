//
//  SYShareView.m
//  Shining
//
//  Created by mengxiangjian on 2019/5/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYShareView.h"

@interface SYShareView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *weixinButton;
@property (nonatomic, strong) UIButton *wxTimeLineButton;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation SYShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.maskView];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.titleLable];
        [self.containerView addSubview:self.cancelButton];
        [self.containerView addSubview:self.weixinButton];
        [self.containerView addSubview:self.wxTimeLineButton];
        [self.containerView addSubview:self.lineLabel];
        NSURL *url_Weixin = [NSURL URLWithString:@"weixin://"];
        BOOL canOpen_Weixin = [[UIApplication sharedApplication] canOpenURL:url_Weixin];
        if (!canOpen_Weixin) {
            [self.weixinButton setEnabled:NO];
            [self.wxTimeLineButton setEnabled:NO];
        }else{
            [self.weixinButton setEnabled:YES];
            [self.wxTimeLineButton setEnabled:YES];
        }
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)containerView {
    if (!_containerView) {
        CGFloat height = 200;
        CGFloat y = self.sy_height - height;
        if (iPhoneX) {
            y -= 34.f;
            height += 34;
        }
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.sy_width, height)];
        _containerView.backgroundColor = [UIColor whiteColor];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:_containerView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer * layer = [[CAShapeLayer alloc]init];
        layer.frame = _containerView.bounds;
        layer.path = path.CGPath;
        _containerView.layer.mask = layer;
    }
    return _containerView;
}


- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.containerView.sy_width-16, 52)];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
        _titleLable.textColor = [UIColor sy_colorWithHexString:@"#0B0B0B"];
        _titleLable.text = @"分享至";
    }
    return _titleLable;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat height = 52;
        CGFloat y = self.containerView.sy_height - height;
        if (iPhoneX) {
            y -= 34.f;
        }
        _cancelButton.frame = CGRectMake(0, y, self.containerView.sy_width, height);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor]
                            forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(tap:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)weixinButton {
    if (!_weixinButton) {
        _weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _weixinButton.frame = CGRectMake(10, CGRectGetMaxY(self.titleLable.frame), 68, 90);
//        [_weixinButton setTitle:@"微信好友" forState:UIControlStateNormal];
        [_weixinButton setImage:[UIImage imageNamed_sy:@"share_weixin_icon"]
                       forState:UIControlStateNormal];
//        _weixinButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
//        [_weixinButton setTitleColor:[UIColor sy_colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        _weixinButton.imageEdgeInsets = UIEdgeInsetsMake(14, 0, 32, 0);
//        _weixinButton.titleEdgeInsets = UIEdgeInsetsMake(60, -50, 0, 0);
        [_weixinButton addTarget:self
                          action:@selector(weixinShare:)
                forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, _weixinButton.sy_width, 15.f)];
        label.textColor = [UIColor sy_colorWithHexString:@"#888888"];
        label.font = [UIFont systemFontOfSize:10];
        label.text = @"微信好友";
        label.textAlignment = NSTextAlignmentCenter;
        [_weixinButton addSubview:label];
    }
    return _weixinButton;
}


- (UIButton *)wxTimeLineButton {
    if (!_wxTimeLineButton) {
        _wxTimeLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wxTimeLineButton.frame = CGRectMake(CGRectGetMaxX(self.weixinButton.frame)+6.f, CGRectGetMaxY(self.titleLable.frame), 68, 90);
//        [_wxTimeLineButton setTitle:@"朋友圈" forState:UIControlStateNormal];
        [_wxTimeLineButton setImage:[UIImage imageNamed_sy:@"share_weixin_timeline_icon"]
                       forState:UIControlStateNormal];
//        _wxTimeLineButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
//        [_wxTimeLineButton setTitleColor:[UIColor sy_colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        _wxTimeLineButton.imageEdgeInsets = UIEdgeInsetsMake(14, 0, 32, 0);
//        _wxTimeLineButton.titleEdgeInsets = UIEdgeInsetsMake(60, -54, 0, 0);
        [_wxTimeLineButton addTarget:self
                          action:@selector(weixinTimeLineShare:)
                forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, _weixinButton.sy_width, 15.f)];
        label.textColor = [UIColor sy_colorWithHexString:@"#888888"];
        label.font = [UIFont systemFontOfSize:10];
        label.text = @"朋友圈";
        label.textAlignment = NSTextAlignmentCenter;
        [_wxTimeLineButton addSubview:label];
    }
    return _wxTimeLineButton;
}


- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.weixinButton.frame), self.containerView.sy_width, 5)];
        _lineLabel.backgroundColor = [UIColor sy_colorWithHexString:@"#000000" alpha:0.04/1.0];
    }
    return _lineLabel;
}

- (void)tap:(id)sender {
    [self removeFromSuperview];
}

- (void)weixinShare:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewDidSelectShareType:)]) {
        [self.delegate shareViewDidSelectShareType:SYShareViewTypeWeixinSession];
    }
    [self tap:nil];
}

- (void)weixinTimeLineShare:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareViewDidSelectShareType:)]) {
        [self.delegate shareViewDidSelectShareType:SYShareViewTypeWeixinTimeline];
    }
    [self tap:nil];
}



@end
