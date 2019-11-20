//
//  SYVoiceRoomFloatBall.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomFloatBall.h"

@interface SYVoiceRoomFloatBall ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SYVoiceRoomFloatBall

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = self.sy_height / 2.f;
        self.clipsToBounds = YES;
        [self.layer addSublayer:self.gradientLayer];
        [self addSubview:self.avatarView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.infoLabel];
        [self addSubview:self.closeButton];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showWithRoomName:(NSString *)roomName
                roomIcon:(NSString *)roomIcon {
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:roomIcon]
                       placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    self.nameLabel.text = roomName;
}

- (void)tap:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomFloatBallDidEnterRoomWithFloatBall:)]) {
        [self.delegate voiceRoomFloatBallDidEnterRoomWithFloatBall:self];
    }
    [self removeFromSuperview];
}

- (void)close:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomFloatBallDidClose)]) {
        [self.delegate voiceRoomFloatBallDidClose];
    }
    [self removeFromSuperview];
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        NSArray *colors = @[(__bridge id)[UIColor sam_colorWithHex:@"#AD73FD"].CGColor, (__bridge id)[UIColor sam_colorWithHex:@"#753FFB"].CGColor];
        _gradientLayer.colors = colors;
    }
    return _gradientLayer;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(2.f, 2.f, self.sy_height - 4.f, self.sy_height - 4)];
        _avatarView.layer.cornerRadius = _avatarView.sy_height / 2.f;
        _avatarView.clipsToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat x = self.avatarView.sy_right + 2.f;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 7.f, self.sy_width - x - 36.f, 16)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.sy_left, self.nameLabel.sy_bottom + 2.f, self.nameLabel.sy_width, 11)];
        _infoLabel.textColor = [UIColor sam_colorWithHex:@"#CCCCCC"];
        _infoLabel.font = [UIFont systemFontOfSize:9];
        _infoLabel.text = @"点击返回聊天室";
    }
    return _infoLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(self.sy_width - 42, 0, 42, 42);
        [_closeButton setImage:[UIImage imageNamed_sy:@"float_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(close:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}


@end
