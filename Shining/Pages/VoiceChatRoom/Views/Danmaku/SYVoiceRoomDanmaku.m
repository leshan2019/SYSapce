//
//  SYVoiceRoomDanmaku.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomDanmaku.h"

@interface SYVoiceRoomDanmaku ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation SYVoiceRoomDanmaku

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.gradientLayer];
        [self addSubview:self.avatarView];
        [self addSubview:self.label];
        [self addSubview:self.iconView];
    }
    return self;
}

- (void)showWithAvatarURL:(NSString *)avatarURL
                  message:(NSString *)message
                     type:(SYVoiceRoomDanmakuType)type {
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatarURL]
                       placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    NSString *boundingMessage = message;
    if (boundingMessage.length > 25) {
        boundingMessage = [boundingMessage substringToIndex:25];
    }
    CGRect rect = [boundingMessage boundingRectWithSize:CGSizeMake(999, self.label.sy_height)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: self.label.font}
                                                context:nil];
    self.label.sy_width = rect.size.width;
    self.label.text = message;
    self.sy_width = self.label.sy_right + 8.f;
    if (type == SYVoiceRoomDanmakuTypeHighLevel) {
        self.label.textColor = [UIColor sam_colorWithHex:@"#FF4097"];
        self.iconView.sy_left = self.label.sy_right + 8.f;
        self.sy_width += self.iconView.sy_width;
        CGFloat height = 22.f;
        CGFloat x = self.avatarView.sy_width / 2.f;
        self.gradientLayer.frame = CGRectMake(x, (self.sy_height - height) / 2.f, self.sy_width - x - 30.f, height);
        self.gradientLayer.cornerRadius = 0;
    } else {
        self.label.textColor = [UIColor sam_colorWithHex:@"#DEDEDE"];
        CGFloat height = 22.f;
        CGFloat x = self.avatarView.sy_width / 2.f;
        self.gradientLayer.frame = CGRectMake(x, (self.sy_height - height) / 2.f, self.sy_width - x, height);
        self.gradientLayer.cornerRadius = 10.f;
    }
    self.iconView.hidden = (type != SYVoiceRoomDanmakuTypeHighLevel);
    
    switch (type) {
        case SYVoiceRoomDanmakuTypeDefault:
        {
            UIColor *color = [[UIColor sam_colorWithHex:@"#030009"] colorWithAlphaComponent:0.5];
            self.gradientLayer.colors = @[(__bridge id)color.CGColor, (__bridge id)color.CGColor];
            self.gradientLayer.locations = @[@(0), @(1)];
        }
            break;
        case SYVoiceRoomDanmakuTypeMidLevel:
        {
            UIColor *color1 = [UIColor sam_colorWithHex:@"#E9C38B"];
            UIColor *color2 = [UIColor sam_colorWithHex:@"#C89E62"];
            self.gradientLayer.colors = @[(__bridge id)color2.CGColor, (__bridge id)color1.CGColor];
            self.gradientLayer.locations = @[@(0), @(1)];
        }
            break;
        case SYVoiceRoomDanmakuTypeHighLevel:
        {
//            UIColor *color1 = [UIColor sam_colorWithHex:@"#FF4140"];
//            UIColor *color2 = [UIColor sam_colorWithHex:@"#FC7675"];
//            self.gradientLayer.colors = @[(__bridge id)color1.CGColor, (__bridge id)color2.CGColor];
            UIColor *color1 = [[UIColor sam_colorWithHex:@"#030009"] colorWithAlphaComponent:0.6];
            UIColor *color2 = [[UIColor sam_colorWithHex:@"#030009"] colorWithAlphaComponent:0.6];
            UIColor *color3 = [[UIColor sam_colorWithHex:@"#030009"] colorWithAlphaComponent:0.0];
            self.gradientLayer.colors = @[(__bridge id)color1.CGColor, (__bridge id)color2.CGColor, (__bridge id)color3.CGColor];
            self.gradientLayer.locations = @[@(0), @(0.8), @(1)];
        }
            break;
        default:
            break;
    }
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        CGFloat y = 0.f;
        CGFloat height = self.sy_height - y * 2.f;
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, height, height)];
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.cornerRadius = height / 2.f;
    }
    return _avatarView;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint = CGPointMake(1, 0.5);
        _gradientLayer.cornerRadius = 10.f;
    }
    return _gradientLayer;
}

- (UILabel *)label {
    if (!_label) {
        CGFloat x = self.avatarView.sy_right + 4.f;
        CGFloat height = 16.f;
        CGFloat y = (self.sy_height - height) / 2.f;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, self.sy_width - x - 8.f, height)];
        _label.font = [UIFont systemFontOfSize:11.f];
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        CGFloat x = self.label.sy_right + 8.f;
        CGFloat height = 22.f;
        CGFloat y = (self.sy_height - height) / 2.f;
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 45.f, height)];
        _iconView.image = [UIImage imageNamed_sy:@"voiceroom_danmu_icon"];
    }
    return _iconView;
}

@end
