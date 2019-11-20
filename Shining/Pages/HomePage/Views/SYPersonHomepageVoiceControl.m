//
//  SYPersonHomepageVoiceView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageVoiceControl.h"
#import "SYAudioPlayer.h"

@interface SYPersonHomepageVoiceControl ()

@property (nonatomic, strong) UIImageView *backImage;   // 背景图
@property (nonatomic, strong) UILabel *timeLabel;       // 时间label
@property (nonatomic, strong) UIImageView *playIcon;    // 播放icon

@property (nonatomic, assign) NSInteger duration;       // 音频总时

@property (nonatomic, strong) SYAudioPlayer *audioPlayer;       // 录音播放器
@property (nonatomic, assign) SYAudioPlayStatus playState;      // 当前录音状态
@property (nonatomic, assign) NSString *voiceUrl;               // 音频url
@property (nonatomic, assign) NSInteger voiceDuration;          // 音频duration
@property (nonatomic, assign) NSInteger currentTime;            // 音频当前播放时长

@end

@implementation SYPersonHomepageVoiceControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 15;
        [self addSubview:self.backImage];
        [self addSubview:self.timeLabel];
        [self addSubview:self.playIcon];

        [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];

        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.playIcon.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(34, 17));
        }];
    }
    return self;
}

- (void)dealloc {
    // 这里必须stop，不然会崩溃
    [self.audioPlayer setPlayerCallBack:nil];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)setVoiceDuration:(NSInteger)voiceDuration {
    if (voiceDuration <= 0) {
        AVURLAsset*audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.voiceUrl] options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        _voiceDuration = floor(audioDurationSeconds);
    } else {
        _voiceDuration = voiceDuration;
    }
}

#pragma mark - Public

- (void)updateVoiceControl:(NSString *)voiceUrl voiceDuration:(NSInteger)duration {
    self.voiceUrl = voiceUrl;
    self.voiceDuration = duration;
    if (self.audioPlayer) {
        [self.audioPlayer setPlayerCallBack:nil];
        [self.audioPlayer stop];
        self.audioPlayer = nil;
        [self handlePlayTime:self.voiceDuration];
        [self updatePlayIcon:NO];
    }
    if ([NSString sy_isBlankString:voiceUrl]) {
        self.playState = SYAudioPlayStatusError;
        return;
    }
    self.audioPlayer = [[SYAudioPlayer alloc] initWithUrls:@[voiceUrl] seekDuration:0 duration:0];
    __weak typeof(self) weakSelf = self;
    [self.audioPlayer setPlayerCallBack:^(SYAudioPlayStatus status, NSTimeInterval playTime, NSTimeInterval playDutation, NSString * _Nonnull error) {
        NSLog(@"playTime-haha-%f",playTime);
        NSLog(@"playTime-haha-state=%lu",(unsigned long)status);
        if (status != SYAudioPlayStatusPlaying && status != SYAudioPlayStatusPause) {
            weakSelf.playState = status;
        }
        if (status == SYAudioPlayStatusPrepare || status == SYAudioPlayStatusFinish) {
            [weakSelf handlePlayTime:weakSelf.voiceDuration];
            [weakSelf updatePlayIcon:NO];
        } else if (status == SYAudioPlayStatusPlaying) {
            [weakSelf handlePlayTime:playTime];
        }
    }];
}

- (void)clickSYPersonHomepageVoiceControl {
    SYAudioPlayStatus state = self.playState;
    switch (state) {
        case SYAudioPlayStatusPrepare:
        {
            if (![SYNetworkReachability isNetworkReachable]) {
                [SYToastView showToast:@"网络异常，请检查网络连接~"];
                return;
            }

            [self startPlay];
        }
            break;
        case SYAudioPlayStatusPlaying:
        {
            [self pausePlay];
        }
            break;
        case SYAudioPlayStatusPause:
        {
            [self continuePlay];
        }
            break;
        case SYAudioPlayStatusFinish: {
            if (![SYNetworkReachability isNetworkReachable]) {
                [SYToastView showToast:@"网络异常，请检查网络连接~"];
                return;
            }
            [self rePlay];
        }
            break;
        case SYAudioPlayStatusError: {
            [SYToastView showToast:@"录音文件加载失败，稍后再试"];
        }
        default:
            break;
    }
}

// 开始播放
- (void)startPlay {
    [self updatePlayIcon:YES];
    [self.audioPlayer play];
    self.playState = SYAudioPlayStatusPlaying;
}

// 暂停播放
- (void)pausePlay {
    [self updatePlayIcon:NO];
    [self.audioPlayer pause];
    self.playState = SYAudioPlayStatusPause;
}

// 继续播放
- (void)continuePlay {
    [self updatePlayIcon:YES];
    [self.audioPlayer play];
    self.playState = SYAudioPlayStatusPlaying;
}

// 重播
- (void)rePlay {
    [self updatePlayIcon:YES];
    [self.audioPlayer rePLay];
    self.playState = SYAudioPlayStatusPlaying;
}

// 停止播放
- (void)stopPlay {
    if (self.playState == SYAudioPlayStatusPlaying) {
        [self pausePlay];
    }
}

#pragma mark - PrivateMethod

- (void)handlePlayTime:(NSTimeInterval)playTime {
    NSInteger currentPlayTime = floor(playTime);
    if (currentPlayTime < 0) {
        currentPlayTime = 0;
    }
    if (currentPlayTime > self.voiceDuration) {
        currentPlayTime = self.voiceDuration;
    }
    self.currentTime = currentPlayTime;
    [self updatePlayTime:self.currentTime];
}

- (void)updatePlayTime:(NSInteger)playTime {
    NSString *finalTime = @"";
    if (playTime < 10) {
        finalTime = [NSString stringWithFormat:@"00:0%ld",(long)playTime];
    } else {
        finalTime = [NSString stringWithFormat:@"00:%ld",(long)playTime];
    }
    self.timeLabel.text = finalTime;
}

- (void)updatePlayIcon:(BOOL)play {
    if (play) {
        self.playIcon.image = [UIImage imageNamed_sy:@"homepage_voice_pause"];
    } else {
        self.playIcon.image = [UIImage imageNamed_sy:@"homepage_voice_play"];
    }
}

#pragma mark - Lazyload

- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [UIImageView new];
        _backImage.image = [UIImage imageNamed_sy:@"homepage_voice_bg"];
        _backImage.clipsToBounds = YES;
    }
    return _backImage;
}

- (UIImageView *)playIcon {
    if (!_playIcon) {
        _playIcon = [UIImageView new];
        _playIcon.image = [UIImage imageNamed_sy:@"homepage_voice_play"];
        _playIcon.userInteractionEnabled = NO;
    }
    return _playIcon;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"00:00";
    }
    return _timeLabel;
}

@end
