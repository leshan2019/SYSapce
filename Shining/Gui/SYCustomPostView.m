//
//  SYCustomPostView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCustomPostView.h"

@interface SYCustomPostView ()

@property (nonatomic, strong) UIView *backMask;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *msg;

@end

@implementation SYCustomPostView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)msg {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        _msg = msg;
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window) {
        self.frame = window.bounds;
        [window addSubview:self];
        [self addSubview:self.backMask];
        self.backMask.frame = self.bounds;
        
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.msgLabel];
        
        self.titleLabel.text = self.title;
        self.msgLabel.text = self.msg;
        
        CGFloat containerWidth = CGRectGetWidth(self.bounds) - 42.f * 2;
        CGFloat top = 20.f;
        if (self.title) {
            CGRect frame = self.titleLabel.frame;
            frame.origin.x = 20.f;
            frame.origin.y = top;
            frame.size.width = containerWidth - 20.f * 2;
            frame.size.height = 18.f;
            self.titleLabel.frame = frame;
            top += CGRectGetHeight(frame);
            top += 20.f;
        }
        
        if (self.msg) {
            CGRect frame = self.msgLabel.frame;
            frame.origin.x = 20.f;
            frame.origin.y = top;
            frame.size.width = containerWidth - 20.f * 2;
            CGRect rect = [self.msg boundingRectWithSize:CGSizeMake(frame.size.width, 999)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName: self.msgLabel.font}
                                                 context:nil];
            frame.size.height = rect.size.height;
            self.msgLabel.frame = frame;
            top += CGRectGetHeight(frame);
            top += 30.f;
        }
        
        CGRect frame = self.containerView.frame;
        frame.size.width = containerWidth;
        frame.size.height = top;
        self.containerView.frame = frame;
        self.containerView.center = window.center;
    }
}

- (UIView *)backMask {
    if (!_backMask) {
        _backMask = [[UIView alloc] initWithFrame:CGRectZero];
        _backMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_backMask addGestureRecognizer:tap];
    }
    return _backMask;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 10.f;
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:16.f weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor sam_colorWithHex:@"#3E4A59"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _msgLabel.font = [UIFont systemFontOfSize:14.f];
        _msgLabel.textColor = [UIColor sam_colorWithHex:@"#3E4A59"];
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (void)tap:(id)sender {
    [self removeFromSuperview];
}

@end
