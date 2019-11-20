//
//  SYPersonHomeRecordControl.m
//  Shining
//
//  Created by 杨玄 on 2019/4/26.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomeRecordControl.h"
#import "SYAudioRecordManager.h"
#import "SYLameTools.h"
#import "SYAudioPlayerManager.h"

#define RecordMaxTime 15
#define RecordMinTime 5

@interface SYPersonHomeRecordControl ()

@property (nonatomic, strong) UILabel *timeLabel;           // "00:12"
@property (nonatomic, strong) UILabel *recordTipLabel;      // "点击录制/录音中/录音完成"

@property (nonatomic, strong) UIImageView *recordBackImage; // 录音背景
@property (nonatomic, strong) UIImageView *recordStateImage;// 录音状态image

@property (nonatomic, strong) UIButton *deleteBtn;          // 删除录音按钮
@property (nonatomic, strong) UIButton *completeBtn;        // 完成录音按钮

// 录音时间相关
@property (nonatomic, strong) NSTimer *recordTimer;             // 录音时间timer
@property (nonatomic, assign) NSInteger tempRecordTime;         // 临时录音时间
@property (nonatomic, assign) NSInteger listenRecordTime;       // 试听录音时间
@property (nonatomic, assign) SYRecordControlType recordType;   // 当前录音状态
@property (nonatomic, copy) NSString *recordAudioPath;          // 录音后的本地路径
@property (nonatomic, strong) SYAudioPlayer *audioPlayer;       // 录音播放器
@property (nonatomic, assign) BOOL isListening;                 // 正在试听中

// 圆弧动画相关
@property (nonatomic, strong) NSTimer *circleTimer;             // 进度条timer
@property (nonatomic, assign) CGFloat circleAngle;              // 进度条初始弧度
@property (nonatomic, strong) CAShapeLayer *circleLayer;        // 进度条layer
@property (nonatomic, strong) UIBezierPath *circlePath;

@end

@implementation SYPersonHomeRecordControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.timeLabel];
        [self addSubview:self.recordTipLabel];
        [self addSubview:self.recordBackImage];
        [self.recordBackImage addSubview:self.recordStateImage];
        [self addSubview:self.deleteBtn];
        [self addSubview:self.completeBtn];
        [self makeConsWithSubviews];
        [self initAudioManager];
    }
    return self;
}

#pragma mark - Public

- (void)updateRecordControlStateWithType:(SYRecordControlType)type {
    self.recordType = type;
    switch (type) {
        case SYRecordControlType_Prepare:
        {
            self.timeLabel.text = @"00:00";
            self.recordTipLabel.text = @"点击录制";
            self.recordStateImage.image = [UIImage imageNamed_sy:@"homepage_record_tube"];
            self.deleteBtn.hidden = YES;
            self.completeBtn.hidden = YES;
            self.recordAudioPath = @"";
            [self deleteCircleLine];
            self.tempRecordTime = 0;
            self.circleAngle = 0;
            self.listenRecordTime = 0;
            self.isListening = NO;
        }
            break;
        case SYRecordControlType_Recording:
        {
            self.timeLabel.text = @"00:00";
            self.recordTipLabel.text = @"录音中";
            self.recordStateImage.image = [UIImage imageNamed_sy:@"homepage_record_continue"];
            self.deleteBtn.hidden = YES;
            self.completeBtn.hidden = YES;
        }
            break;
        case SYRecordControlType_Finished:
        {
            self.recordTipLabel.text = @"录音完成";
            self.recordStateImage.image = [UIImage imageNamed_sy:@"homepage_record_finish"];
            self.deleteBtn.hidden = NO;
            self.completeBtn.hidden = NO;
        }
            break;
        case SYRecordControlType_Listening:
        {
            NSString *recordingTime = @"";
            if (self.tempRecordTime >= 10) {
                recordingTime = [NSString stringWithFormat:@"%ld",self.tempRecordTime];
            } else {
                recordingTime = [NSString stringWithFormat:@"0%ld",self.tempRecordTime];
            }
            self.timeLabel.text = [NSString stringWithFormat:@"00:%@",recordingTime];
            self.recordTipLabel.text = @"试听中";
            self.recordStateImage.image = [UIImage imageNamed_sy:@"homepage_record_continue"];
        }
            break;
        case SYRecordControlType_ListenPause:
        {
            self.recordTipLabel.text = @"暂停试听";
            self.recordStateImage.image = [UIImage imageNamed_sy:@"homepage_record_finish"];
        }
            break;
        case SYRecordControlType_ListenFinish:
        {
            self.recordTipLabel.text = @"试听结束";
            self.recordStateImage.image = [UIImage imageNamed_sy:@"homepage_record_finish"];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private

// 添加约束布局
- (void)makeConsWithSubviews {
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(17);
    }];
    [self.recordTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(3);
        make.size.mas_equalTo(CGSizeMake(98, 14));
    }];
    [self.recordBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.recordTipLabel.mas_bottom).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(98, 98));
    }];
    [self.recordStateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.recordBackImage);
        make.size.mas_equalTo(CGSizeMake(18, 26));
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(53);
        make.centerY.equalTo(self.recordBackImage);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-53);
        make.centerY.equalTo(self.recordBackImage);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - BtnClickEvent

// 删除录音
- (void)handleDeleteRecordBtnClickEvent {
    if (self.isListening) {
        [self pausePlayRecord];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYPersonHomeRecordControl:deleteCurrentRecordAudioPath:)]) {
        [self.delegate SYPersonHomeRecordControl:self deleteCurrentRecordAudioPath:self.recordAudioPath];
    }
}

// 保存录音
- (void)handleCompleteRecordBtnClickEvent {
    if (self.isListening) {
        [self pausePlayRecord];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYPersonHomeRecordControl:saveCurrentRecordAudioPath:recordDuration:)]) {
        [self.delegate SYPersonHomeRecordControl:self saveCurrentRecordAudioPath:self.recordAudioPath recordDuration:self.listenRecordTime];
    }
}

// 开始录音/完成录音/播放录音
- (void)handleRecordImageClickEvent {
    switch (self.recordType) {
        case SYRecordControlType_Prepare:
        {
            [self beginRecordVoice];
        }
            break;
        case SYRecordControlType_Recording:
        {
            [self endRecordVoice];
        }
            break;
        case SYRecordControlType_Finished:
        {
            [self startListenRecord];
        }
            break;
        case SYRecordControlType_Listening:
        {
            [self pausePlayRecord];
        }
            break;
        case SYRecordControlType_ListenPause:
        {
            [self continuePlayRecord];
        }
            break;
        case SYRecordControlType_ListenFinish:
        {
            [self startListenRecord];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 录音功能相关

/**
 录音manager加载
 */
- (void)initAudioManager
{
    __weak typeof(self) weakSelf = self;
    [[SYAudioRecordManager shareSYAudioRecordManager] setSuccessBlock:^(BOOL ret, NSString * _Nonnull resultPath, NSTimeInterval recordTime, NSTimeInterval duration) {
        if (self.recordType == SYRecordControlType_Finished) {
            if (ret) {
                if (recordTime < RecordMinTime) {
                    [SYToastView showToast:@"录音时间不能少于5秒"];
                    [weakSelf updateRecordControlStateWithType:SYRecordControlType_Prepare];
                    NSFileManager *fm = [NSFileManager defaultManager];
                    NSError *error;
                    [fm removeItemAtPath:resultPath error:&error];
                    if (error == nil) {
                        NSLog(@"录音文件删除成功，path：%@",resultPath);
                    }
                } else {
                    [SYLameTools audioToMP3:resultPath isDeleteSourchFile:YES withSuccessBack:^(NSString * _Nonnull mp3Path) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.recordAudioPath = mp3Path;
                        });
                    } withFailBack:^(NSString * _Nonnull error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.recordAudioPath = resultPath;
                        });
                    }];
                }
            } else {
                [SYToastView showToast:@"录音失败，请重新录制"];
                [weakSelf updateRecordControlStateWithType:SYRecordControlType_Prepare];
            }
        }
    }];
}

// 开始录音
- (void)beginRecordVoice {
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    switch (permission) {
        case AVAudioSessionRecordPermissionUndetermined:
        {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        [self updateRecordControlStateWithType:SYRecordControlType_Recording];
                        NSString *audioName = [NSString stringWithFormat:@"uid_%.2f",[[NSDate date] timeIntervalSince1970]];
                        [[SYAudioRecordManager shareSYAudioRecordManager] beginRecordWithRecordName:audioName withRecordType:@"waf" withAutoConventToMp3:NO duration:RecordMaxTime];
                        [self startRecordTimer];
                        [self createCircleLine];
                    } else {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(SYPersonHomeRecordControlLeadUserToOpenRecordPermission)]) {
                            [self.delegate SYPersonHomeRecordControlLeadUserToOpenRecordPermission];
                        }
                    }
                });
            }];
        }
            break;
        case AVAudioSessionRecordPermissionGranted:
        {
            // 已开启麦克风权限
            [self updateRecordControlStateWithType:SYRecordControlType_Recording];
            NSString *audioName = [NSString stringWithFormat:@"uid_%.2f",[[NSDate date] timeIntervalSince1970]];
            [[SYAudioRecordManager shareSYAudioRecordManager] beginRecordWithRecordName:audioName withRecordType:@"waf" withAutoConventToMp3:NO duration:RecordMaxTime];
            [self startRecordTimer];
            [self createCircleLine];
        }
            break;
        case AVAudioSessionRecordPermissionDenied:
        {
            // 已关闭麦克风权限
            if (self.delegate && [self.delegate respondsToSelector:@selector(SYPersonHomeRecordControlLeadUserToOpenRecordPermission)]) {
                [self.delegate SYPersonHomeRecordControlLeadUserToOpenRecordPermission];
            }
        }
            break;
        default:
            break;
    }
}

// 结束录音
- (void)endRecordVoice {
    [self stopRecordTimer];
    [self stopCircleLine];
    [self updateRecordControlStateWithType:SYRecordControlType_Finished];
    [[SYAudioRecordManager shareSYAudioRecordManager] endRecord];
    // 保留录音的时间，赋值给试听时间
    self.listenRecordTime = self.tempRecordTime;
}

// 开始试听
- (void)startListenRecord {
    self.isListening = YES;
    self.tempRecordTime = 0;
    self.circleAngle = 0;
    [self startRecordTimer];
    [self createCircleLine];
    [self updateRecordControlStateWithType:SYRecordControlType_Listening];
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
    self.audioPlayer = [[SYAudioPlayer alloc] initWithUrls:@[self.recordAudioPath] seekDuration:0 duration:0];
    [self.audioPlayer play];
}

// 暂停试听
- (void)pausePlayRecord {
    [self updateRecordControlStateWithType:SYRecordControlType_ListenPause];
    [self stopRecordTimer];
    [self stopCircleLine];
    if (self.audioPlayer) {
        [self.audioPlayer pause];
    }
}

// 继续试听
- (void)continuePlayRecord {
    [self updateRecordControlStateWithType:SYRecordControlType_Listening];
    [self startRecordTimer];
    [self createCircleLine];
    if (self.audioPlayer) {
        [self.audioPlayer play];
    }
}

// 结束试听
- (void)stopPlayRecord {
    self.isListening = NO;
    [self updateRecordControlStateWithType:SYRecordControlType_ListenFinish];
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

#pragma mark - 录音时间相关

- (void)startRecordTimer {
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateRecordTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.recordTimer forMode:NSRunLoopCommonModes];
}

- (void)stopRecordTimer {
    if (self.recordTimer) {
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
}

- (void)updateRecordTime {
    if (self.listenRecordTime > 0) {
        // 试听自动结束
        if (self.tempRecordTime >= self.listenRecordTime) {   // 自动结束试听
            [self updateRecordControlStateWithType:SYRecordControlType_ListenFinish];
            [self stopRecordTimer];
            [self stopCircleLine];
            [self stopPlayRecord];
            return;
        }
    } else {
        // 录音自动结束
        if (self.tempRecordTime >= RecordMaxTime) {
            [self endRecordVoice];
            [self stopRecordTimer];
            return;
        }
    }

    // 更新时间label
    self.tempRecordTime += 1;
    NSLog(@"录制中-%ld",self.tempRecordTime);
    NSString *recordingTime = @"";
    if (self.tempRecordTime >= 10) {
        recordingTime = [NSString stringWithFormat:@"%ld",self.tempRecordTime];
    } else {
        recordingTime = [NSString stringWithFormat:@"0%ld",self.tempRecordTime];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"00:%@",recordingTime];
}

#pragma mark - 进度条相关

- (void)createCircleLine {
    if (self.circleTimer) {
        [self.circleTimer invalidate];
        self.circleTimer = nil;
    }
    self.circleTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(drawCircleLine) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.circleTimer forMode:NSRunLoopCommonModes];
}

- (void)stopCircleLine {
    if (self.circleTimer) {
        [self.circleTimer invalidate];
        self.circleTimer = nil;
    }
}

- (void)deleteCircleLine {
    if (self.circleTimer) {
        [self.circleTimer invalidate];
        self.circleTimer = nil;
    }
    if (self.circleLayer) {
        [self.circleLayer removeFromSuperlayer];
        self.circleLayer = nil;
    }
    self.circleAngle = 0;
}

- (void)drawCircleLine {
    CGRect circleBounds = self.recordBackImage.bounds;
    // 滚动条
    if (self.circlePath) {
        [self.circlePath removeAllPoints];
        self.circlePath = nil;
    }
    self.circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circleBounds.size.width/2, circleBounds.size.height/2) radius:circleBounds.size.width/2-1 startAngle:-M_PI_2 endAngle:((M_PI * 2) * self.circleAngle - M_PI_2) clockwise:YES];
    if (!self.circleLayer) {
        self.circleLayer = [CAShapeLayer new];
        [self.recordBackImage.layer addSublayer:self.circleLayer];
        self.circleLayer.fillColor    = nil;
        self.circleLayer.strokeColor  = [UIColor sy_colorWithHexString:@"#FF4176"].CGColor;
        self.circleLayer.lineCap      = kCALineCapRound;
        self.circleLayer.path         = self.circlePath.CGPath;
        self.circleLayer.lineWidth    = 2;
        self.circleLayer.frame        = circleBounds;
    }else{
        self.circleLayer.path         = self.circlePath.CGPath;
    }

    if (self.circleAngle > 1.000000) {
        [self stopCircleLine];
    }

    double per = 1.0/150.0;

    self.circleAngle += per;
}

#pragma mark - Lazyload

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)recordTipLabel {
    if (!_recordTipLabel) {
        _recordTipLabel = [UILabel new];
        _recordTipLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        _recordTipLabel.textColor = [UIColor sy_colorWithHexString:@"#DEDEDE"];
        _recordTipLabel.textAlignment = NSTextAlignmentCenter;
        _recordTipLabel.text = @"点击录制";
    }
    return _recordTipLabel;
}

- (UIImageView *)recordBackImage {
    if (!_recordBackImage) {
        _recordBackImage = [UIImageView new];
        _recordBackImage.userInteractionEnabled = YES;
        _recordBackImage.image = [UIImage imageNamed_sy:@"homepage_record_bg"];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRecordImageClickEvent)];
        [_recordBackImage addGestureRecognizer:tapGesture];
    }
    return _recordBackImage;
}

- (UIImageView *)recordStateImage {
    if (!_recordStateImage) {
        _recordStateImage = [UIImageView new];
        _recordStateImage.image = [UIImage imageNamed_sy:@"homepage_record_tube"];
        _recordStateImage.contentMode = UIViewContentModeCenter;
        _recordStateImage.userInteractionEnabled = YES;
    }
    return _recordStateImage;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setImage:[UIImage imageNamed_sy:@"homepage_record_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(handleDeleteRecordBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIButton *)completeBtn {
    if (!_completeBtn) {
        _completeBtn = [UIButton new];
        [_completeBtn setImage:[UIImage imageNamed_sy:@"homepage_record_complete"] forState:UIControlStateNormal];
        [_completeBtn addTarget:self action:@selector(handleCompleteRecordBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}


@end
