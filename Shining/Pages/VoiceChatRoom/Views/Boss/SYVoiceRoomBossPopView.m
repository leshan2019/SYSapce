//
//  SYVoiceRoomBossPopView.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/7.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomBossPopView.h"

@interface SYVoiceRoomBossPopView ()

@property (nonatomic, strong) SYVoiceRoomBossViewModel *viewModel;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *bgView;

@property (nonatomic, strong) UIImageView *placeholderView; // 头像占位图
@property (nonatomic, strong) UIImageView *avatarView;
//@property (nonatomic, strong) UIImageView *avatarBox;
@property (nonatomic, strong) UILabel *nameLabel; // 昵称label
@property (nonatomic, strong) UILabel *countDownLabel; // 倒计时label
@property (nonatomic, strong) UILabel *hintLabel; // 提示label
@property (nonatomic, strong) UILabel *ruleLabel; // 规则label
@property (nonatomic, strong) UIButton *giftButton;

@property (nonatomic, strong) NSTimer *countDownTimer;

@end

@implementation SYVoiceRoomBossPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.bgView];
        
        [self.bgView addSubview:self.placeholderView];
        [self.placeholderView addSubview:self.avatarView];
//        [self.bgView addSubview:self.avatarBox];
        [self.bgView addSubview:self.nameLabel];
        [self.bgView addSubview:self.countDownLabel];
        [self.bgView addSubview:self.hintLabel];
        [self.bgView addSubview:self.ruleLabel];
        [self.bgView addSubview:self.giftButton];
    }
    return self;
}

- (void)destroy {
    [self stopTimer];
}

- (void)showWithBossViewModel:(SYVoiceRoomBossViewModel *)viewModel {
    self.viewModel = viewModel;
    [self stopTimer];
    BOOL isValid = viewModel.isValid;
//    self.avatarBox.hidden = !isValid;
    self.avatarView.hidden = !isValid;
    self.nameLabel.hidden = !isValid;
    self.countDownLabel.hidden = !isValid;
    self.hintLabel.hidden = !isValid;
    self.ruleLabel.hidden = isValid;
    if (isValid && viewModel.isMyself) {
        self.giftButton.hidden = YES;
        self.hintLabel.hidden = YES;
    } else {
        self.giftButton.hidden = NO;
    }
    if (isValid) {
        [self startTimer];
        self.placeholderView.image = [UIImage imageNamed_sy:@"voiceroom_boss_avatar_bg"];
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:viewModel.userAvatar]
                           placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
//        [self.avatarBox sd_setImageWithURL:[NSURL URLWithString:viewModel.userAvatarBox]];
        self.nameLabel.text = viewModel.userName;
        self.countDownLabel.text = [NSString stringWithFormat:@"剩余时间：%@", [self countDownStringWithCountDown:viewModel.countDown]];
        self.hintLabel.text = [NSString stringWithFormat:@"消费单个礼物价值>%ld蜜豆即可抢占老板位哦～", (long)viewModel.price];
        [self.giftButton setTitle:@"我要上位"
                         forState:UIControlStateNormal];
        
    } else {
        self.placeholderView.image = [UIImage imageNamed_sy:@"voiceroom_boss_placeholder"];
        NSInteger hour = [SYSettingManager bossCDMinutes] / 60;
        NSString *condition = [NSString stringWithFormat:@">=%ld蜜豆且消费最高者", (long)[SYSettingManager bossTrigger]];
        NSString *rule = [NSString stringWithFormat:@"1.房间内消费单礼物价值%@ 即可登上老板位，倒计时%ld小时。\n\n2.上位后%ld小时内用户可通过消费蜜豆抢占老板位哦。", condition, (long)hour, (long)hour];
        NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:rule];
        [aStr addAttribute:NSFontAttributeName value:self.ruleLabel.font range:NSMakeRange(0, rule.length)];
        [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor sam_colorWithHex:@"#444444"]
                     range:NSMakeRange(0, rule.length)];
        NSRange range = [rule rangeOfString:condition];
        [aStr addAttribute:NSForegroundColorAttributeName
                     value:[UIColor sam_colorWithHex:@"#FF40A5"]
                     range:range];
        CGRect rect = [aStr boundingRectWithSize:CGSizeMake(self.ruleLabel.sy_width, 999)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                         context:nil];
        self.ruleLabel.sy_height = rect.size.height;
        self.ruleLabel.attributedText = aStr;
        [self.giftButton setTitle:@"上老板位"
                         forState:UIControlStateNormal];
    }
}

- (void)startTimer {
    [self stopTimer];
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(timerAction:)
                                                         userInfo:nil
                                                          repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.countDownTimer && [self.countDownTimer isKindOfClass:[NSTimer class]]
        && [self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
    }
    self.countDownTimer = nil;
}

-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        CGSize size = CGSizeMake(375, 318);
        CGFloat ratio = self.sy_width / 375.f;
        size = CGSizeMake(size.width * ratio, size.height * ratio);
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.sy_height - size.height, size.width, size.height)];
        _bgView.image = [UIImage imageNamed_sy:@"voiceroom_boss_bg"];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIImageView *)placeholderView {
    if (!_placeholderView) {
        CGFloat width = 80;
        CGFloat left = (self.bgView.sy_width - width) / 2.f;
        _placeholderView = [[UIImageView alloc] initWithFrame:CGRectMake(left, 18, width, width)];
        _placeholderView.userInteractionEnabled = YES;
    }
    return _placeholderView;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
//        CGFloat ratio = self.sy_width / 375.f;
//        CGSize size = CGSizeMake(64 * ratio, 64 * ratio);
//        CGFloat centerY = 72.f * ratio;
        CGFloat width = 54.f;
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake((self.placeholderView.sy_width - width) / 2.f + 1.f, 21, width, width)];
        _avatarView.layer.cornerRadius = _avatarView.sy_width / 2.f;
        _avatarView.clipsToBounds = YES;
        _avatarView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapAvatar:)];
        [_avatarView addGestureRecognizer:tap];
    }
    return _avatarView;
}

//- (UIImageView *)avatarBox {
//    if (!_avatarBox) {
//        CGFloat width = 86.f;
//        _avatarBox = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
//        _avatarBox.center = self.avatarView.center;
//    }
//    return _avatarBox;
//}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat width = self.sy_width - 100.f;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, self.avatarView.sy_bottom + 32.f, width, 20.f)];
        _nameLabel.font = [UIFont systemFontOfSize:14.f];
        _nameLabel.textColor = [UIColor sam_colorWithHex:@"#0B0B0B"];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)countDownLabel {
    if (!_countDownLabel) {
        CGFloat width = self.sy_width - 100.f;
        _countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, self.nameLabel.sy_bottom + 4.f, width, 24.f)];
        _countDownLabel.font = [UIFont boldSystemFontOfSize:17.f];
        _countDownLabel.textColor = [UIColor sam_colorWithHex:@"#0B0B0B"];
        _countDownLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countDownLabel;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        CGFloat width = self.sy_width - 60.f;
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.countDownLabel.sy_bottom + 10.f, width, 20.f)];
        _hintLabel.font = [UIFont boldSystemFontOfSize:14.f];
        _hintLabel.textColor = [UIColor sam_colorWithHex:@"#FF40A5"];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hintLabel;
}

- (UILabel *)ruleLabel {
    if (!_ruleLabel) {
        _ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22.f, self.avatarView.sy_bottom + 32.f, self.bgView.sy_width - 22.f * 2.f, 0)];
        _ruleLabel.font = [UIFont systemFontOfSize:14.f];
        _ruleLabel.numberOfLines = 0;
    }
    return _ruleLabel;
}

- (UIButton *)giftButton {
    if (!_giftButton) {
        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 224.f;
        CGFloat height = 42.f;
        _giftButton.frame = CGRectMake((self.bgView.sy_width - width) / 2.f, self.bgView.sy_height - 42.f - height, width, height);
        _giftButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
        [_giftButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        [_giftButton setBackgroundImage:[UIImage imageNamed_sy:@"voiceroom_boss_button"]
                               forState:UIControlStateNormal];
        [_giftButton addTarget:self
                        action:@selector(showGift:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftButton;
}

- (void)tap:(id)sender {
    [self removeFromSuperview];
}

- (void)showGift:(id)sender {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(voiceRoomBossPopViewDidShowGift)]) {
        [self.delegate voiceRoomBossPopViewDidShowGift];
    }
}

- (NSString *)countDownStringWithCountDown:(NSInteger)countDown {
    NSInteger hour = countDown / 3600;
    NSString *hourString = (hour >= 10) ? [NSString stringWithFormat:@"%ld", (long)hour] : [NSString stringWithFormat:@"0%ld", (long)hour];
    
    countDown -= hour * 3600;
    NSInteger minite = countDown / 60;
    NSString *minuteString = (minite >= 10) ? [NSString stringWithFormat:@"%ld", (long)minite] : [NSString stringWithFormat:@"0%ld", (long)minite];
    
    countDown -= minite * 60;
    NSInteger second = countDown;
    NSString *secondString = (second >= 10) ? [NSString stringWithFormat:@"%ld", (long)second] : [NSString stringWithFormat:@"0%ld", (long)second];
    
    return [NSString stringWithFormat:@"%@:%@:%@", hourString, minuteString, secondString];
}

- (void)timerAction:(id)sender {
    self.countDownLabel.text = [NSString stringWithFormat:@"剩余时间：%@", [self countDownStringWithCountDown:self.viewModel.countDown]];
}

- (void)tapAvatar:(id)sender {
    if ([NSString sy_isBlankString:self.viewModel.userUid]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(voiceRoomBossPopViewDidShowPersonPageWithUid:)]) {
        [self.delegate voiceRoomBossPopViewDidShowPersonPageWithUid:self.viewModel.userUid];
    }
}

@end
