//
//  SYVoiceRoomToolbar.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomToolbar.h"

#define SYVoiceRoomToolbarButtonSpace 12.f

@interface SYVoiceRoomToolbar ()

@property (nonatomic, strong) UIButton *inputButton;
@property (nonatomic, strong) UIButton *micButton;
@property (nonatomic, strong) UIButton *seatButton;
@property (nonatomic, strong) UIButton *giftButton;
@property (nonatomic, strong) UIView *redDot;                   // 排麦红点
@property (nonatomic, strong) UIButton *expressionButton;
@property (nonatomic, strong) UIButton *pkButton;
@property (nonatomic, strong) UIButton *privateMessageButton;   // 私信btn
@property (nonatomic, strong) UIView *privateMessageRedDot;     // 私信红点

@end

@implementation SYVoiceRoomToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.inputButton];
        [self addSubview:self.micButton];
        [self addSubview:self.seatButton];
        [self.seatButton addSubview:self.redDot];
        [self addSubview:self.giftButton];
        [self addSubview:self.expressionButton];
        [self addSubview:self.pkButton];
        [self addSubview:self.privateMessageButton];
        [self.privateMessageButton addSubview:self.privateMessageRedDot];
    }
    return self;
}

- (void)changeUserRole:(SYChatRoomUserRole)role {
    if (role == SYChatRoomUserRoleHost ||
        role == SYChatRoomUserRoleBroadcaster) {
        self.seatButton.hidden = YES;
        self.micButton.hidden = NO;
        self.expressionButton.hidden = NO;
        self.inputButton.sy_left = CGRectGetMaxX(self.micButton.frame) + SYVoiceRoomToolbarButtonSpace;
        self.expressionButton.sy_left = CGRectGetMaxX(self.inputButton.frame) + SYVoiceRoomToolbarButtonSpace;
        self.privateMessageButton.sy_left = CGRectGetMaxX(self.expressionButton.frame) + SYVoiceRoomToolbarButtonSpace;
    } else {
        self.seatButton.hidden = NO;
        self.micButton.hidden = YES;
        self.expressionButton.hidden = NO;
        self.inputButton.sy_left = CGRectGetMaxX(self.seatButton.frame) + SYVoiceRoomToolbarButtonSpace;
        self.expressionButton.sy_left = CGRectGetMaxX(self.inputButton.frame) + SYVoiceRoomToolbarButtonSpace;
        self.privateMessageButton.sy_left = CGRectGetMaxX(self.expressionButton.frame) + SYVoiceRoomToolbarButtonSpace;
    }
}

- (void)changeMicState:(BOOL)isMuted {
    self.micButton.selected = isMuted;
}

- (void)changeApplyMicState:(BOOL)micState {
    self.redDot.hidden = !micState;
}

- (void)hideApplyMicButton {
    self.seatButton.alpha = 0;
    self.seatButton.sy_right = 0.f;
}

- (void)changeInputAvailability:(BOOL)isAvailable {
    self.inputButton.enabled = isAvailable;
}

- (void)setPKFuncEnable:(BOOL)enable {
    self.pkButton.hidden = !enable;
}

- (void)setHasUnreadMessage:(BOOL)hasUnread {
    self.privateMessageRedDot.hidden = !hasUnread;
}

- (UIButton *)inputButton {
    if (!_inputButton) {
        _inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inputButton.frame = CGRectMake(110.f, 7.f, 36.f, 36.f);
        [_inputButton setImage:[UIImage imageNamed_sy:@"voiceroom_chat"] forState:UIControlStateNormal];
        [_inputButton addTarget:self
                         action:@selector(tapInput:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputButton;
}

- (void)tapInput:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomToolbarTouchInputButton)]) {
        [self.delegate voiceRoomToolbarTouchInputButton];
    }
}

- (UIButton *)micButton {
    if (!_micButton) {
        _micButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _micButton.frame = CGRectMake(16.f, 7.f, 36, 36);
        [_micButton setImage:[UIImage imageNamed_sy:@"voiceroom_mute"]
                    forState:UIControlStateNormal];
        [_micButton setImage:[UIImage imageNamed_sy:@"voiceroom_mute_h"]
                    forState:UIControlStateSelected];
        [_micButton addTarget:self
                       action:@selector(micAction:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _micButton;
}
    
- (void)micAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomToolbarTouchMicButton)]) {
        [self.delegate voiceRoomToolbarTouchMicButton];
    }
}

- (UIButton *)seatButton {
    if (!_seatButton) {
        _seatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _seatButton.frame = CGRectMake(16.f, 11.f, 68, 28);
        _seatButton.clipsToBounds = YES;
        _seatButton.layer.cornerRadius = 14.f;
        [_seatButton setBackgroundImage:[UIImage imageNamed_sy:@"voiceroom_send_bg"]
                               forState:UIControlStateNormal];
        _seatButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        [_seatButton setTitle:@"排麦" forState:UIControlStateNormal];
        [_seatButton addTarget:self
                        action:@selector(seatAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _seatButton;
}

- (UIView *)redDot {
    if (!_redDot) {
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(52.f, 5.f, 6.f, 6.f)];
        _redDot.backgroundColor = [UIColor whiteColor];
        _redDot.layer.cornerRadius = 3.f;
    }
    return _redDot;
}

- (void)seatAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomToolbarTouchSeatButton)]) {
        [self.delegate voiceRoomToolbarTouchSeatButton];
    }
}

- (UIButton *)giftButton {
    if (!_giftButton) {
        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _giftButton.frame = CGRectMake(self.bounds.size.width - 52.f, 7, 36, 36);
        [_giftButton setImage:[UIImage imageNamed_sy:@"voiceroom_gift"] forState:UIControlStateNormal];
        [_giftButton setImage:[UIImage imageNamed_sy:@"voiceroom_gift_h"] forState:UIControlStateHighlighted];
        [_giftButton addTarget:self action:@selector(giftAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftButton;
}

- (void)giftAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomToolbarTouchGiftButton)]) {
        [self.delegate voiceRoomToolbarTouchGiftButton];
    }
}

- (UIButton *)expressionButton {
    if (!_expressionButton) {
        _expressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _expressionButton.frame = CGRectMake(self.inputButton.sy_right + SYVoiceRoomToolbarButtonSpace, 7, 36, 36);
        [_expressionButton setImage:[UIImage imageNamed_sy:@"voiceroom_expression"] forState:UIControlStateNormal];
        [_expressionButton addTarget:self action:@selector(expressionAction:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _expressionButton;
}

- (void)expressionAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomToolbarTouchExpressionButton)]) {
        [self.delegate voiceRoomToolbarTouchExpressionButton];
    }
}

- (UIButton *)pkButton {
    if (!_pkButton) {
        _pkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pkButton.frame = CGRectMake(self.giftButton.sy_left - 36.f - SYVoiceRoomToolbarButtonSpace, 7, 36, 36);
        [_pkButton setImage:[UIImage imageNamed_sy:@"voiceroom_pk_more"]
                   forState:UIControlStateNormal];
        [_pkButton addTarget:self
                      action:@selector(pkAction:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _pkButton;
}

- (void)pkAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomToolbarTouchPKButton)]) {
        [self.delegate voiceRoomToolbarTouchPKButton];
    }
}

- (UIButton *)privateMessageButton {
    if (!_privateMessageButton) {
        _privateMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _privateMessageButton.frame = CGRectMake(self.inputButton.sy_right + SYVoiceRoomToolbarButtonSpace, 7.f, 36.f, 36.f);
        [_privateMessageButton setImage:[UIImage imageNamed_sy:@"voiceroom_private_msg"] forState:UIControlStateNormal];
        [_privateMessageButton addTarget:self
                         action:@selector(tapPrivateMessageBtn:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _privateMessageButton;
}

- (void)tapPrivateMessageBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomToolbarTouchPrivateMessageButton)]) {
        [self.delegate voiceRoomToolbarTouchPrivateMessageButton];
    }
}

- (UIView *)privateMessageRedDot {
    if (!_privateMessageRedDot) {
        _privateMessageRedDot = [[UIView alloc] initWithFrame:CGRectMake(28.f, 4.f, 4.f, 4.f)];
        UIColor *red = [UIColor redColor];
        _privateMessageRedDot.backgroundColor = red;
        _privateMessageRedDot.layer.cornerRadius = 2.f;
        _privateMessageRedDot.hidden = YES;
    }
    return _privateMessageRedDot;
}

@end
