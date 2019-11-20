//
//  SYAudioManager.m
//  Shining
//
//  Created by letv_lzb on 2019/3/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYAudioRecordManager.h"
#import "SYAudioFileTools.h"
#import "SYSigleCase.h"
#import "SYLameTools.h"

@interface SYAudioRecordManager ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, copy) NSString *recordPath;
/** 录音文件路径*/
@property (nonatomic, copy) NSString *recordResultPath;
/**
是否边录边转换成mp3 格式
 */
@property (nonatomic, assign) BOOL isAutoConventMp3;

/**
 录音成功的block
 */
@property (nonatomic, copy) SYAudioSuccess successBlock;



/**
 录音文件的名字
 */
@property (nonatomic, strong) NSString *audioFileName;

/**
 录音的类型
 */
@property (nonatomic, strong) NSString *recordType;

/**
 录音倒计时结束
 */
@property (nonatomic, copy) SYLongTimeHander longTimerHander;


/**
 当前已录音时间
 */
@property (nonatomic, copy) SYRecordTimeHander recordTimerHander;


@property (nonatomic, strong) NSTimer *timer;

/**
 录制总时长
 */
@property (nonatomic, assign) NSTimeInterval recodeDuration;

/**
 已经录制的时长
 */
@property (nonatomic, assign) NSTimeInterval recodeTime;

@end

@implementation SYAudioRecordManager


SYSingleCaseM(SYAudioRecordManager)

- (AVAudioRecorder *)audioRecorder
{
    __weak typeof(self) weakSelf = self;
    if (!_audioRecorder) {
        // 0. 设置录音会话
        /**
         AVAudioSessionCategoryPlayAndRecord: 可以边播放边录音(也就是平时看到的背景音乐)
         */
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        // 启动会话
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        // 1. 确定录音存放的位置
        NSURL *url = [NSURL URLWithString:weakSelf.recordPath];
        // 2. 设置录音参数
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        // 设置编码格式
        /**
         kAudioFormatLinearPCM: 无损压缩，内容非常大
         kAudioFormatMPEG4AAC
         */
        [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        // 采样率：必须保证和转码设置的相同
        [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];
        // 通道数（必须设置为双声道, 不然转码生成的 MP3 会声音尖锐变声.）
        [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
        //音频质量,采样质量(音频质量越高，文件的大小也就越大)
        [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        // 3. 创建录音对象
        NSError *error ;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        //开启音量监测
        _audioRecorder.meteringEnabled = YES;

        _audioRecorder.delegate = weakSelf;

        if(error){
            NSLog(@"创建录音对象时发生错误，错误信息：%@",error.localizedDescription);
        }
    }
    return _audioRecorder;
}



/** 开始录音 */
- (void)beginRecordWithRecordName: (NSString *)recordName withRecordType:(NSString *)type withAutoConventToMp3:(BOOL)isConventToMp3 duration:(CGFloat) duration
{
    if (_audioRecorder) {
        self.recodeTime = 0;
        self.audioRecorder = nil;
    }
    if (_timer) {
        [_timer invalidate];
        self.timer = nil;
    }
    // 正在录制就返回，防止多次点击录音
    _recodeDuration = duration;
    _recordType = type;
    _isAutoConventMp3 = isConventToMp3;
    if ([recordName containsString:[NSString stringWithFormat:@".%@",_recordType]]) {
        _audioFileName = recordName;
    }else{
        _audioFileName = [NSString stringWithFormat:@"%@.%@",recordName,_recordType];
    }
    if (![SYAudioFileTools audioFileOrFolderExists:cachesRecorderFolderPath]) {
        // 创建 /Library/Caches/SYRecorder 文件夹
        [SYAudioFileTools audioCreateFolder:cachesRecorderFolderPath];
    }
    // 创建录音文件存放路径
    _recordPath = [cachesRecorderFolderPath stringByAppendingPathComponent:_audioFileName];
    // 准备录音
    if ([self.audioRecorder prepareToRecord]) {
        // 开始录音
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateRecordDuration) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        }
        [self.audioRecorder record];
        // 判断是否需要边录边转 MP3
        __weak typeof(self) weakSelf = self;
        if (_isAutoConventMp3) {
            [[SYLameTools shareSYLameTools] audioRecodingToMP3:_recordPath isDeleteSourchFile:YES withSuccessBack:^(NSString * _Nonnull resultPath) {
                weakSelf.recordResultPath = resultPath;
                if (weakSelf.successBlock) {
                    weakSelf.successBlock(YES,weakSelf.recordPath,weakSelf.audioCurrentTime,weakSelf.recodeDuration);
                }
                NSLog(@"SY recording convert mp3 success path is %@",resultPath);
            } withFailBack:^(NSString * _Nonnull error) {
                NSLog(@"SY recording convert mp3 error : %@",error);
                weakSelf.recordResultPath = weakSelf.recordPath;
            }];
        }else{
            self.recordResultPath = self.recordPath;
        }
    }
}


- (void)updateRecordDuration
{
    if (self.recodeDuration > 0
        && self.recodeTime >= self.recodeDuration) {
        if (self.longTimerHander) {
            self.longTimerHander(YES, self.recodeTime);
        }
    }
    if (self.audioRecorder.isRecording) {
        if (self.audioCurrentTime > 0) {
            self.recodeTime = self.audioCurrentTime;
        }
        if (self.recordTimerHander) {
            self.recordTimerHander(self.recodeTime, self.recodeDuration);
        }
    }
}

/** 结束录音 */
- (void)endRecord
{
    self.recodeTime = self.audioCurrentTime;
    [self.audioRecorder stop];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/** 暂停录音 */
- (void)pauseRecord
{
    [self.audioRecorder pause];
}

/** 删除录音 */
- (void)deleteRecord
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.audioRecorder stop];
    // 删除录音之前必须先停止录音
    [self.audioRecorder deleteRecording];
    self.recodeTime = 0;
}

/** 重新录音 */
- (void)reRecord
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.audioRecorder = nil;
    self.recodeTime = 0;
    [self beginRecordWithRecordName:self.audioFileName withRecordType:self.recordType withAutoConventToMp3:self.isAutoConventMp3 duration:self.recodeDuration];
}

/**
 更新音频测量值，注意如果要更新音频测量值必须设置meteringEnabled为YES，通过音频测量值可以即时获得音频分贝等信息
 */
-(void)updateMeters
{
    [self.audioRecorder updateMeters];
}


/**
 获得指定声道的分贝峰值
 获得指定声道的分贝峰值，注意如果要获得分贝峰值必须在此之前调用updateMeters方法
 @return 指定频道的值
 */
- (float)peakPowerForChannel0
{

    [self.audioRecorder updateMeters];
    return [self.audioRecorder peakPowerForChannel:0];
}


/**
 <#Description#>

 @param successBlock <#successBlock description#>
 */
- (void)setSuccessBlock:(SYAudioSuccess)successBlock
{
    _successBlock = successBlock;
}


/**
 <#Description#>

 @param longTimerHander <#longTimerHander description#>
 */
- (void)setLongTimerHander:(SYLongTimeHander)longTimerHander
{
    _longTimerHander = longTimerHander;
}


/**
 <#Description#>

 @param recordTimerHander <#recordTimerHander description#>
 */
- (void)setRecordTimerHander:(SYRecordTimeHander)recordTimerHander
{
    _recordTimerHander = recordTimerHander;
}


/**
 当前录音的时间
 */
-(NSTimeInterval)audioCurrentTime
{
    return self.audioRecorder.currentTime;
}

/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (flag) {
        NSLog(@"SY ----- recording end");
        if (self.isAutoConventMp3) {
            [[SYLameTools shareSYLameTools] sendEndRecord];
        }else{
            if (self.successBlock) {
                self.successBlock(flag,self.recordPath,self.recodeTime,self.recodeDuration);
            }
        }
    }
}


@end
