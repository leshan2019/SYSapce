//
//  SYVoiceRoomOptionView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomOptionView.h"

@interface SYVoiceRoomOptionView ()

@property (nonatomic, strong) UIView *backMask;
@property (nonatomic, assign) CGPoint pointer;
@property (nonatomic, assign) NSInteger micIndex;
@property (nonatomic, strong) UIImageView *containerview;

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *muteButton;


@end

@implementation SYVoiceRoomOptionView

- (instancetype)initWithFrame:(CGRect)frame
                  showAtPoint:(CGPoint)point
                     micIndex:(NSInteger)micIndex {
    self = [super initWithFrame:frame];
    if (self) {
        _pointer = point;
        _micIndex = micIndex;
        [self addSubview:self.backMask];
        [self addSubview:self.containerview];
        [self.containerview addSubview:self.confirmButton];
        [self.containerview addSubview:self.muteButton];
    }
    return self;
}

- (void)setMutedState:(BOOL)isMuted {
    [self.muteButton setTitle:isMuted?@"开麦":@"关麦"
                     forState:UIControlStateNormal];
}

- (UIView *)backMask {
    if (!_backMask) {
        _backMask = [[UIView alloc] initWithFrame:self.bounds];
        _backMask.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_backMask addGestureRecognizer:tap];
    }
    return _backMask;
}

- (UIImageView *)containerview {
    if (!_containerview) {
        CGFloat width = 90.f;
        CGFloat height = 43.f;
        CGFloat x = self.pointer.x - width / 2.f;
        CGFloat y = self.pointer.y;
        _containerview = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _containerview.image = [UIImage imageNamed_sy:@"voiceroom_option"];
        _containerview.userInteractionEnabled = YES;
    }
    return _containerview;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(0, 7.f, CGRectGetWidth(self.containerview.bounds) / 2.f, 36.f);
        [_confirmButton addTarget:self
                        action:@selector(confirm:)
              forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitle:@"抱人" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_confirmButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor sam_colorWithHex:@"#7B40FF"]
                          forState:UIControlStateHighlighted];
    }
    return _confirmButton;
}

- (UIButton *)muteButton {
    if (!_muteButton) {
        _muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _muteButton.frame = CGRectMake(CGRectGetWidth(self.containerview.bounds) / 2.f, 7.f, CGRectGetWidth(self.containerview.bounds) / 2.f, 36.f);
        [_muteButton addTarget:self
                        action:@selector(mute:)
              forControlEvents:UIControlEventTouchUpInside];
        [_muteButton setTitle:@"静音" forState:UIControlStateNormal];
        _muteButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_muteButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_muteButton setTitleColor:[UIColor sam_colorWithHex:@"#7B40FF"]
                          forState:UIControlStateHighlighted];
    }
    return _muteButton;
}

- (void)tap:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomOptionViewDidCancel)]) {
        [self.delegate voiceRoomOptionViewDidCancel];
    }
    [self removeFromSuperview];
}

- (void)mute:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomOptionViewDidSelectMuteMicAtIndex:)]) {
        [self.delegate voiceRoomOptionViewDidSelectMuteMicAtIndex:self.micIndex];
    }
    [self removeFromSuperview];
}

- (void)confirm:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomOptionViewDidSelectConfirmMicAtIndex:)]) {
        [self.delegate voiceRoomOptionViewDidSelectConfirmMicAtIndex:self.micIndex];
    }
    [self removeFromSuperview];
}


@end
