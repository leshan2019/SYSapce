//
//  SYLiveRoomToolbar.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomToolbar.h"

@interface SYLiveRoomToolbar ()

@property (nonatomic, strong) UIButton *inputButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *giftButton;
@property (nonatomic, strong) UIButton *expressionButton;
@property (nonatomic, strong) UIButton *privateMessageButton;   // 私信btn
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *privateMessageRedDot;

@end

@implementation SYLiveRoomToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.inputButton];
        [self addSubview:self.closeButton];
        [self addSubview:self.shareButton];
        [self addSubview:self.giftButton];
        [self addSubview:self.privateMessageButton];
        [self addSubview:self.expressionButton];
        [self addSubview:self.moreButton];
        [self.privateMessageButton addSubview:self.privateMessageRedDot];
    }
    return self;
}

- (void)setUserRoleWithIsHost:(BOOL)isHost {
    self.giftButton.hidden = isHost;
    self.privateMessageButton.hidden = !isHost;
}

- (void)setHasUnreadMessage:(BOOL)hasUnread {
    self.privateMessageRedDot.hidden = !hasUnread;
}

#pragma mark -

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

- (UIButton *)inputButton {
    if (!_inputButton) {
        _inputButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _inputButton.frame = CGRectMake(16.f, 6.f, 84, 36);
        _inputButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_inputButton setTitle:@"撩一下..." forState:UIControlStateNormal];
        [_inputButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        _inputButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_inputButton addTarget:self
                         action:@selector(inputText:)
               forControlEvents:UIControlEventTouchUpInside];
        _inputButton.layer.cornerRadius = 18.f;
    }
    return _inputButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.sy_width - 16.f - 36.f, 6.f, 36.f, 36.f);
        [_closeButton setImage:[UIImage imageNamed_sy:@"liveRoom_close"]
                      forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(close:)
               forControlEvents:UIControlEventTouchUpInside];
        _closeButton.hidden = YES;
    }
    return _closeButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(self.moreButton.sy_left - 14.f - 36.f, 6.f, 36, 36);
        [_shareButton setImage:[UIImage imageNamed_sy:@"liveRoom_share"]
                      forState:UIControlStateNormal];
        [_shareButton addTarget:self
                         action:@selector(share:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIButton *)giftButton {
    if (!_giftButton) {
        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _giftButton.frame = CGRectMake(self.shareButton.sy_left - 14.f - 36.f, 6.f, 36.f, 36.f);
        [_giftButton setImage:[UIImage imageNamed_sy:@"liveRoom_gift"]
                     forState:UIControlStateNormal];
        [_giftButton addTarget:self
                        action:@selector(openGift:)
              forControlEvents:UIControlEventTouchUpInside];
        _giftButton.hidden = YES;
    }
    return _giftButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(self.closeButton.sy_left - 14.f - 36.f, 6.f, 36.f, 36.f);
        [_moreButton setImage:[UIImage imageNamed_sy:@"liveRoom_more"]
                     forState:UIControlStateNormal];
        [_moreButton addTarget:self
                        action:@selector(openMore:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIButton *)privateMessageButton {
    if (!_privateMessageButton) {
        _privateMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _privateMessageButton.frame = CGRectMake(self.shareButton.sy_left - 14.f - 36.f, 6.f, 36.f, 36.f);
        [_privateMessageButton setImage:[UIImage imageNamed_sy:@"voiceroom_private_msg"]
                     forState:UIControlStateNormal];
        [_privateMessageButton addTarget:self
                        action:@selector(openPrivateMessage:)
              forControlEvents:UIControlEventTouchUpInside];
        _privateMessageButton.hidden = YES;
    }
    return _privateMessageButton;
}

- (UIButton *)expressionButton {
    if (!_expressionButton) {
        _expressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _expressionButton.frame = CGRectMake(self.privateMessageButton.sy_left - 14.f - 36.f, 6.f, 36.f, 36.f);
        [_expressionButton setImage:[UIImage imageNamed_sy:@"voiceroom_expression"]
                               forState:UIControlStateNormal];
        [_expressionButton addTarget:self
                                  action:@selector(openExpression:)
                        forControlEvents:UIControlEventTouchUpInside];
    }
    return _expressionButton;
}

- (void)inputText:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveRoomToolbarTouchInputButton)]) {
        [self.delegate liveRoomToolbarTouchInputButton];
    }
}

- (void)close:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveRoomToolbarDidSelectClose)]) {
        [self.delegate liveRoomToolbarDidSelectClose];
    }
}

- (void)share:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveRoomToolbarTouchShareButton)]) {
        [self.delegate liveRoomToolbarTouchShareButton];
    }
}

- (void)openGift:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveRoomToolbarTouchGiftButton)]) {
        [self.delegate liveRoomToolbarTouchGiftButton];
    }
}

- (void)openMore:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveRoomToolbarTouchMoreButton)]) {
        [self.delegate liveRoomToolbarTouchMoreButton];
    }
}

- (void)openPrivateMessage:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveRoomToolbarTouchPrivateMessageButton)]) {
        [self.delegate liveRoomToolbarTouchPrivateMessageButton];
    }
}

- (void)openExpression:(id)sender {
    if ([self.delegate respondsToSelector:@selector(liveRoomToolbarTouchExpressionButton)]) {
        [self.delegate liveRoomToolbarTouchExpressionButton];
    }
}

@end
