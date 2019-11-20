//
//  SYVoiceRoomMusicPanel.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomMusicPanel.h"

@interface SYVoiceRoomMusicPanel ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *playModeButton;
@property (nonatomic, strong) UIButton *volumeButton;
@property (nonatomic, strong) UIButton *controlButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UISlider *sliderView;

@property (nonatomic, assign) SYVoiceRoomMusicPlayMode currentPlayMode;
@property (nonatomic, assign) BOOL isPlaying;

@end

@implementation SYVoiceRoomMusicPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentPlayMode = SYVoiceRoomMusicPlayModeLoop;
        _isPlaying = NO;
        [self addSubview:self.backImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.sizeLabel];
        [self addSubview:self.currentTimeLabel];
        [self addSubview:self.durationLabel];
        [self addSubview:self.sliderView];
        [self addSubview:self.playModeButton];
        [self addSubview:self.volumeButton];
        [self addSubview:self.nextButton];
        [self addSubview:self.controlButton];
    }
    return self;
}

- (void)playWithSongTitle:(NSString *)title
                     size:(long long)size {
    self.titleLabel.text = title;
    NSString *sizeString = [NSString stringWithFormat:@"%.1fM", (float)size / 1024.f / 1024.f];
    self.sizeLabel.text = sizeString;
    self.isPlaying = YES;
    [self reloadPlayState];
}

- (void)stopPlay {
    self.isPlaying = NO;
    [self reloadPlayState];
    self.titleLabel.text = @"";
    self.sizeLabel.text = @"";
    self.currentTimeLabel.text = @"";
    self.durationLabel.text = @"";
    self.sliderView.value = 0;
}

- (void)changeCurrentPlaybackTime:(NSInteger)time {
    self.currentTimeLabel.text = [self timeStringWithInterval:time];
    self.sliderView.value = time;
}

- (void)changeDuration:(NSInteger)duration {
    self.sliderView.maximumValue = duration;
    self.durationLabel.text = [self timeStringWithInterval:duration];
}

#pragma mark - UI

- (void)reloadPlayState {
    UIImage *image = self.isPlaying ? [UIImage imageNamed_sy:@"voiceroom_music_pause"] : [UIImage imageNamed_sy:@"voiceroom_music_play"];
    [self.controlButton setImage:image forState:UIControlStateNormal];
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.image = [UIImage imageNamed_sy:@"voiceroom_music_panel"];
    }
    return _backImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self labelWithFrame:CGRectMake(15.f, 10.f, 250.f, 20.f)
                                 textColor:[UIColor whiteColor]
                                      font:[UIFont systemFontOfSize:14.f]
                             textAlignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [self labelWithFrame:CGRectMake(self.titleLabel.sy_left, self.titleLabel.sy_bottom + 4.f, 150.f, 14.f)
                                textColor:[UIColor sam_colorWithHex:@"#BAC0C5"]
                                     font:[UIFont systemFontOfSize:10.f]
                            textAlignment:NSTextAlignmentLeft];
    }
    return _sizeLabel;
}

-(UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [self labelWithFrame:CGRectMake(15.f, self.sizeLabel.sy_bottom + 19.f, 34.f, 11.f)
                                textColor:[UIColor sam_colorWithHex:@"#CCCCCC"]
                                     font:[UIFont systemFontOfSize:9.f]
                            textAlignment:NSTextAlignmentLeft];
    }
    return _currentTimeLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [self labelWithFrame:CGRectMake(self.sy_width - 15.f - 34.f, self.currentTimeLabel.sy_top, 34.f, 11.f)
                                       textColor:[UIColor sam_colorWithHex:@"#CCCCCC"]
                                            font:[UIFont systemFontOfSize:9.f]
                                   textAlignment:NSTextAlignmentRight];
    }
    return _durationLabel;
}

- (UISlider *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UISlider alloc] initWithFrame:CGRectMake(self.currentTimeLabel.sy_right, self.sizeLabel.sy_bottom + 9.f, self.durationLabel.sy_left - self.currentTimeLabel.sy_right, 30.f)];
        _sliderView.continuous = NO;
        _sliderView.minimumTrackTintColor = [UIColor sam_colorWithHex:@"#7138EF"];
        _sliderView.maximumTrackTintColor = [UIColor sam_colorWithHex:@"#999999"];
//        _sliderView.thumbTintColor = [UIColor sam_colorWithHex:@"#EFEFEF"];
        [_sliderView setThumbImage:[UIImage imageNamed_sy:@"voiceroom_music_dot"]
                          forState:UIControlStateNormal];
        _sliderView.minimumValue = 0;
        [_sliderView addTarget:self
                        action:@selector(changeSliderValue:)
              forControlEvents:UIControlEventValueChanged];
    }
    return _sliderView;
}

- (UIButton *)playModeButton {
    if (!_playModeButton) {
        CGFloat width = 30.f;
        CGFloat y = self.sy_height - width - 13.f;
        if (iPhoneX) {
            y -= 34.f;
        }
        _playModeButton = [self buttonWithFrame:CGRectMake(15.f, y, width, width)
                                          image:[self modeImageWithMode:self.currentPlayMode]
                                         action:@selector(changeMode:)];
    }
    return _playModeButton;
}

- (UIButton *)volumeButton {
    if (!_volumeButton) {
        _volumeButton = [self buttonWithFrame:CGRectMake(self.playModeButton.sy_right + 10.f, self.playModeButton.sy_top, 30, 30)
                                        image:[UIImage imageNamed_sy:@"voiceroom_music_volume"]
                                       action:@selector(changeVolume:)];
    }
    return _volumeButton;
}

- (UIButton *)controlButton {
    if (!_controlButton) {
        CGFloat y = self.sy_height - 8.f - 40.f;
        if (iPhoneX) {
            y -= 34.f;
        }
        _controlButton = [self buttonWithFrame:CGRectMake(self.nextButton.sy_left - 20.f - 40.f, y, 40.f, 40.f)
                                         image:[UIImage imageNamed_sy:@"voiceroom_music_play"]
                                        action:@selector(playControlAction:)];
    }
    return _controlButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        CGFloat y = self.sy_height - 13.f - 30.f;
        if (iPhoneX) {
            y -= 34.f;
        }
        _nextButton = [self buttonWithFrame:CGRectMake(self.sy_width - 15.f - 30.f, y, 30, 30)
                                      image:[UIImage imageNamed_sy:@"voiceroom_music_next"]
                                     action:@selector(playNext:)];
    }
    return _nextButton;
}

#pragma mark - action

- (void)changeMode:(id)sender {
    if (self.currentPlayMode == SYVoiceRoomMusicPlayModeRandom) {
        self.currentPlayMode = SYVoiceRoomMusicPlayModeLoop;
    } else {
        self.currentPlayMode += 1;
    }
    [self.playModeButton setImage:[self modeImageWithMode:self.currentPlayMode]
                         forState:UIControlStateNormal];
    NSString *modeString = [self modeStringWithMode:self.currentPlayMode];
    if (![NSString sy_isBlankString:modeString]) {
        [SYToastView showToast:[NSString stringWithFormat:@"已切换至%@",modeString]];
    }
}

- (void)changeVolume:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomMusicPanelDidSelectVolumeButton)]) {
        [self.delegate voiceRoomMusicPanelDidSelectVolumeButton];
    }
}

- (void)playNext:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomMusicPanelDidPlayNext)]) {
        [self.delegate voiceRoomMusicPanelDidPlayNext];
    }
}

- (void)playControlAction:(id)sender {
    if (self.isPlaying) {
        if ([self.delegate respondsToSelector:@selector(voiceRoomMusicPanelDidPause)]) {
            [self.delegate voiceRoomMusicPanelDidPause];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(voiceRoomMusicPanelDidPlay)]) {
            [self.delegate voiceRoomMusicPanelDidPlay];
        }
    }
    self.isPlaying = !self.isPlaying;
    [self reloadPlayState];
}

- (void)changeSliderValue:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomMusicPanelDidSeekToTime:)]) {
        [self.delegate voiceRoomMusicPanelDidSeekToTime:self.sliderView.value];
    }
}

#pragma mark - private

- (UILabel *)labelWithFrame:(CGRect)frame
                  textColor:(UIColor *)color
                       font:(UIFont *)font
              textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = color;
    label.font = font;
    label.textAlignment = alignment;
    return label;
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                        image:(UIImage *)image
                       action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIImage *)modeImageWithMode:(SYVoiceRoomMusicPlayMode)mode {
    UIImage *image = nil;
    switch (mode) {
        case SYVoiceRoomMusicPlayModeLoop:
        {
            image = [UIImage imageNamed_sy:@"voiceroom_music_modeLoop"];
        }
            break;
        case SYVoiceRoomMusicPlayModeSingleLoop:
        {
            image = [UIImage imageNamed_sy:@"voiceroom_music_modeSingleLoop"];
        }
            break;
        case SYVoiceRoomMusicPlayModeRandom:
        {
            image = [UIImage imageNamed_sy:@"voiceroom_music_modeRandom"];
        }
            break;
        default:
            break;
    }
    return image;
}

- (NSString *)modeStringWithMode:(SYVoiceRoomMusicPlayMode)mode {
    NSString *string = @"";
    switch (mode) {
        case SYVoiceRoomMusicPlayModeLoop:
        {
            string = @"全部循环模式";
        }
            break;
        case SYVoiceRoomMusicPlayModeSingleLoop:
        {
            string = @"单曲循环模式";
        }
            break;
        case SYVoiceRoomMusicPlayModeRandom:
        {
            string = @"随机模式";
        }
            break;
        default:
            break;
    }
    return string;
}

- (NSString *)timeStringWithInterval:(NSTimeInterval)interval {
    NSInteger seconds = interval / 1000.f;
    NSInteger second = seconds % 60;
    NSString *secondString = [NSString stringWithFormat:@"%ld", (long)second];
    if (second < 10) {
        secondString  = [@"0" stringByAppendingString:secondString];
    }
    
    NSInteger minute = seconds / 60;
    NSString *minuteString = [NSString stringWithFormat:@"%ld", (long)minute];
    if (minute < 10) {
        minuteString  = [@"0" stringByAppendingString:minuteString];
    }
    return [NSString stringWithFormat:@"%@:%@", minuteString, secondString];
}

@end
