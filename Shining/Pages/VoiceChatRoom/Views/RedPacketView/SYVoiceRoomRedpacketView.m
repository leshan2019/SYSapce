//
//  SYVoiceRoomRedpacketView.m
//  Shining
//
//  Created by yangxuan on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomRedpacketView.h"

@interface SYVoiceRoomRedpacketView ()

@property (nonatomic, strong) UIButton *redPacketIcon;
@property (nonatomic, strong) UIImageView *redPacketCountBg;
@property (nonatomic, strong) UILabel *redPacketCountLabel;
@property (nonatomic, strong) UILabel *redPacketTimeTip;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger leftTime;
@property (nonatomic, assign) BOOL canGet;

@property (nonatomic, weak) id <SYVoiceRoomRedpacketViewDelegate>delegate;
@property (nonatomic, copy) void(^clickBlock)(void);

@end

@implementation SYVoiceRoomRedpacketView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<SYVoiceRoomRedpacketViewDelegate>)delegate withClickBlock:(void (^)(void))block {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.clickBlock = block;
        self.delegate = delegate;
    }
    return self;
}

- (void)updateRedpacketCount:(NSInteger)count {
    if (count < 0) {
        count = 0;
    }
    self.redPacketCountBg.hidden = count <= 1;
    if (count > 99) {
        self.redPacketCountLabel.text = @"99+";
    } else {
        self.redPacketCountLabel.text = [NSString stringWithFormat:@"%ld",count];
    }
}

- (void)updateRedpacketGetTime:(NSInteger)time {
    [self stopTimer];
    NSInteger hasPassTime = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(hasPassedTime)]) {
        hasPassTime = [self.delegate hasPassedTime];
    }
    self.leftTime = time - hasPassTime;
    if (time <= 0) {
        self.redPacketTimeTip.text = @"可领取";
        self.canGet = YES;
    } else if (time > 0) {
        self.canGet = NO;
        NSString *leftTime = [NSString sy_safeString:[SYUtil getTimeStrWithSeconds:self.leftTime]];
        self.redPacketTimeTip.text = leftTime;
        [self startTimer];
    }
}

- (void)stopRuningTimer {
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (BOOL)canGetRedPacket {
    return self.canGet;
}

#pragma mark - Timer

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(updateRedpacketLeaveTime)
                                                userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)updateRedpacketLeaveTime {
    self.leftTime -= 1;
    if (self.leftTime <= 0) {
        self.leftTime = 0;
        [self stopTimer];
    }
    if (self.leftTime == 0) {
        self.redPacketTimeTip.text = @"可领取";
        self.canGet = YES;
    } else {
        NSString *leftTime = [NSString sy_safeString:[SYUtil getTimeStrWithSeconds:self.leftTime]];
        self.redPacketTimeTip.text = leftTime;
        self.canGet = NO;
    }
}

#pragma mark - Private

- (void)initSubViews {
    [self addSubview:self.redPacketIcon];
    [self addSubview:self.redPacketCountBg];
    [self.redPacketCountBg addSubview:self.redPacketCountLabel];
    [self addSubview:self.redPacketTimeTip];
}

- (void)clickRedpacketBtn {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

#pragma mark - Lazyload

- (UIButton *)redPacketIcon {
    if (!_redPacketIcon) {
        _redPacketIcon = [UIButton new];
        _redPacketIcon.frame = CGRectMake(0, 13, 46, 34);
        [_redPacketIcon setImage:[UIImage imageNamed_sy:@"voiceroom_redPacket"] forState:UIControlStateNormal];
        [_redPacketIcon addTarget:self action:@selector(clickRedpacketBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redPacketIcon;
}

- (UIImageView *)redPacketCountBg {
    if (!_redPacketCountBg) {
        _redPacketCountBg = [UIImageView new];
        _redPacketCountBg.frame = CGRectMake(46 - 20, 0, 20, 12);
        _redPacketCountBg.image = [UIImage imageNamed_sy:@"voiceroom_redPacket_countBg"];
    }
    return _redPacketCountBg;
}

- (UILabel *)redPacketCountLabel {
    if (!_redPacketCountLabel) {
        _redPacketCountLabel = [UILabel new];
        _redPacketCountLabel.frame = CGRectMake(0, 0, 20, 12);
        _redPacketCountLabel.textColor = [UIColor whiteColor];
        _redPacketCountLabel.font = [UIFont fontWithName:@"ArialMT" size:8];
        _redPacketCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _redPacketCountLabel;
}

- (UILabel *)redPacketTimeTip {
    if (!_redPacketTimeTip) {
        _redPacketTimeTip = [UILabel new];
        _redPacketTimeTip.frame = CGRectMake(0, self.redPacketIcon.sy_bottom + 2, self.redPacketIcon.sy_width, 10);
        _redPacketTimeTip.textColor = RGBACOLOR(255, 255, 255, 0.8);
        _redPacketTimeTip.font = [UIFont fontWithName:@"ArialMT" size:8];
        _redPacketTimeTip.textAlignment = NSTextAlignmentCenter;
    }
    return _redPacketTimeTip;
}

@end
