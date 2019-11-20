//
//  SYPersonHomepageVoiceView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageVoiceView.h"
#import "SYPersonHomeRecordControl.h"
#import "SYPersonHomepageVoiceControl.h"

@interface SYPersonHomepageVoiceView ()<SYPersonHomeRecordControlDelegate>

@property (nonatomic, strong) UILabel *titleLabel;                              // “声音”
@property (nonatomic, strong) UIButton *recordBtn;                              // 点击录制/重新录制
@property (nonatomic, strong) SYPersonHomepageVoiceControl *serverRecordBtn;    // server端录音播放入口
@property (nonatomic, strong) UIButton *deleteRecord;                           // 删除按钮
@property (nonatomic, strong) SYPersonHomeRecordControl *recordControl;         // 录音控件

// 声音url
@property (nonatomic, copy) NSString *voiceUrl;
// 声音时长
@property (nonatomic, copy) NSString *voiceTime;

@end

@implementation SYPersonHomepageVoiceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.recordBtn];
        [self addSubview:self.serverRecordBtn];
        [self addSubview:self.deleteRecord];
        [self addSubview:self.recordControl];
        [self makeConsWithSubviews];
    }
    return self;
}

#pragma mark - PublicMethod

- (void)updateVoiceViewWithVoiceUrl:(NSString *)voiceUrl voiceDuration:(NSInteger)duration {
    if ([NSString sy_isBlankString:voiceUrl]) {
        self.recordBtn.selected = NO;
        self.recordBtn.hidden = NO;
        self.serverRecordBtn.hidden = YES;
        self.deleteRecord.hidden = YES;
        self.recordControl.hidden = YES;
        [self.serverRecordBtn updateVoiceControl:@"" voiceDuration:0];
    } else {
        self.recordBtn.hidden = NO;
        self.recordBtn.selected = YES;
        self.serverRecordBtn.hidden = NO;
        self.deleteRecord.hidden = NO;
        self.recordControl.hidden = YES;
        [self.serverRecordBtn updateVoiceControl:voiceUrl voiceDuration:duration];
    }
    [self.recordControl updateRecordControlStateWithType:SYRecordControlType_Prepare];
}

- (void)setVoiceViewToRecordState {
    [self.recordControl updateRecordControlStateWithType:SYRecordControlType_Prepare];
}

// 停止播放
- (void)stopPlay {
    [self.serverRecordBtn stopPlay];
}

#pragma mark - PrivateMethod

// 添加约束布局
- (void)makeConsWithSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 17));
    }];

    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-20);
        make.centerY.equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake(81, 30));
    }];

    [self.recordControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).with.offset(46);
        make.bottom.equalTo(self);
    }];

    [self.serverRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(27);
        make.size.mas_equalTo(CGSizeMake(112, 34));
    }];

    [self.deleteRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serverRecordBtn.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(22);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}

#pragma mark - BtnClickEvent

// 点击录制声音、重新录制
- (void)handleRecordBtnClickEvent:(UIButton *)btn {
    [self stopPlay];
    self.recordBtn.hidden = YES;
    self.serverRecordBtn.hidden = YES;
    self.deleteRecord.hidden = YES;
    self.recordControl.hidden = NO;
    [self.recordControl updateRecordControlStateWithType:SYRecordControlType_Prepare];
}

// 删除server录音
- (void)handleVoiceDeleteBtnClickEvent {
    [self stopPlay];
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYPersonHomepageVoiceViewDeleteServerVoice)]) {
        [self.delegate SYPersonHomepageVoiceViewDeleteServerVoice];
    }
}

// 播放server录音
- (void)handleRecordVoiceViewClickEvent {
    [self.serverRecordBtn clickSYPersonHomepageVoiceControl];
}

#pragma mark - SYPersonHomeRecordControlDelegate

- (void)SYPersonHomeRecordControlLeadUserToOpenRecordPermission {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYPersonHomepageVoiceViewLeadUserToOpenRecordPermission)]) {
        [self.delegate SYPersonHomepageVoiceViewLeadUserToOpenRecordPermission];
    }
}

// 删除本地录音
- (void)SYPersonHomeRecordControl:(UIView *)view deleteCurrentRecordAudioPath:(NSString *)audioPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYPersonHomepageVoiceViewDeleteLocalVoice:)]) {
        [self.delegate SYPersonHomepageVoiceViewDeleteLocalVoice:audioPath];
    }
}

// 保存本地录音
- (void)SYPersonHomeRecordControl:(UIView *)view saveCurrentRecordAudioPath:(NSString *)audioPath recordDuration:(NSInteger)duration{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYPersonHomepageVoiceViewSaveLocalVoice:voiceDuration:)]) {
        [self.delegate SYPersonHomepageVoiceViewSaveLocalVoice:audioPath voiceDuration:duration];
    }
}

#pragma mark - Lazyload

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _titleLabel.textColor = RGBACOLOR(11, 11, 11, 1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"声音";
    }
    return _titleLabel;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton new];
        _recordBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        [_recordBtn setTitle:@"录制声音" forState:UIControlStateNormal];
        [_recordBtn setTitle:@"重新录制" forState:UIControlStateSelected];
        [_recordBtn setTitleColor:RGBACOLOR(123,64,255,1) forState:UIControlStateNormal];
        _recordBtn.backgroundColor = [UIColor whiteColor];
        _recordBtn.clipsToBounds = YES;
        _recordBtn.layer.cornerRadius = 15;
        [_recordBtn addTarget:self action:@selector(handleRecordBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (SYPersonHomeRecordControl *)recordControl {
    if (!_recordControl) {
        _recordControl = [[SYPersonHomeRecordControl alloc] initWithFrame:CGRectZero];
        _recordControl.delegate = self;
        _recordControl.userInteractionEnabled = YES;
        _recordControl.hidden = YES;
        [_recordControl updateRecordControlStateWithType:SYRecordControlType_Prepare];
    }
    return _recordControl;
}

- (SYPersonHomepageVoiceControl *)serverRecordBtn {
    if (!_serverRecordBtn) {
        _serverRecordBtn = [[SYPersonHomepageVoiceControl alloc] initWithFrame:CGRectZero];
        _serverRecordBtn.hidden = YES;
        [_serverRecordBtn addTarget:self action:@selector(handleRecordVoiceViewClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serverRecordBtn;
}

- (UIButton *)deleteRecord {
    if (!_deleteRecord) {
        _deleteRecord = [UIButton new];
        [_deleteRecord setImage:[UIImage imageNamed_sy:@"homepage_voice_delete"] forState:UIControlStateNormal];
        _deleteRecord.hidden = YES;
        [_deleteRecord addTarget:self action:@selector(handleVoiceDeleteBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteRecord;
}

@end
