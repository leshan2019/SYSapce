//
//  SYVoiceRoomNavBar.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/7.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomNavBar.h"

@interface SYVoiceRoomNavBar ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *extendButton;

@end

@implementation SYVoiceRoomNavBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backButton];
        [self addSubview:self.titleLabel];
        [self addSubview:self.extendButton];
    }
    return self;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = iPhoneX ? 44.f : 20.f;
        _backButton.frame = CGRectMake(10.f, y, 36.f, 44.f);
        [_backButton setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"] forState:UIControlStateNormal];
        [_backButton addTarget:self
                        action:@selector(back:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat y = iPhoneX ? 44.f : 20.f;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, y, self.bounds.size.width - 200, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17.f];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)extendButton {
    if (!_extendButton) {
        _extendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = iPhoneX ? 44.f : 20.f;
        _extendButton.frame = CGRectMake(self.bounds.size.width - 10.f - 36.f, y, 36.f, 44.f);
        [_extendButton setImage:[UIImage imageNamed_sy:@"voiceroom_more"] forState:UIControlStateNormal];
        [_extendButton addTarget:self
                          action:@selector(more:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _extendButton;
}

- (void)setTitleView:(UIView *)titleView {
    CGFloat y = iPhoneX ? 44.f : 20.f;
    [self addSubview:titleView];
    titleView.sy_top = y;
    titleView.sy_centerX = CGRectGetMidX(self.bounds);
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setMoreButtonHidden:(BOOL)hidden {
    self.extendButton.hidden = hidden;
}

- (void)setRightBarButton:(UIButton *)button {
    [self.extendButton removeFromSuperview];
    [self addSubview:button];
    self.extendButton = button;
    CGFloat y = iPhoneX ? 44.f : 20.f;
    self.extendButton.sy_left = self.sy_width - 10.f - button.sy_width;
    self.extendButton.sy_top = y;
    [self.extendButton addTarget:self
                          action:@selector(more:)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)back:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomBarDidTapBack)]) {
        [self.delegate voiceRoomBarDidTapBack];
    }
}

- (void)more:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomBarDidTapMore)]) {
        [self.delegate voiceRoomBarDidTapMore];
    }
}

@end
