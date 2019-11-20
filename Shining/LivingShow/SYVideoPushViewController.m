//
//  SYVideoPushViewController.m
//  Shining
//
//  Created by Zhang Qigang on 2019/9/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//
/*
#import <Foundation/Foundation.h>
//#import <TuSDK/TuSDK.h>
//#import <TuSDKVideo/TuSDKVideo.h>
//#import <PLMediaStreamingKit/PLMediaStreamingKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SYLivingShow.h"
#import "SYVideoRoomConfigView.h"
#import "SYLivingModel.h"
#import "SYLivingAPI.h"
#import "SYLivingShowBeautifyViewController.h"
#import "SYLivingShowCooldownViewController.h"
#import "SYVideoPushViewController.h"

#define QINIU_SDK_FIX_HD 1

static NSString* SYEffectSmootherKey = @"tu_smoother";
static NSString* SYEffectSlimmingKey = @"tu_slimming";
static NSString* SYEffectEyelidKey = @"tu_eyelid";
static NSString* SYEffectWhiteningKey = @"tu_whitening";
static NSString* SYCurrentEffectIdKey = @"tu_current_effect_id";
static NSString* SYCurrentEffectValueKey = @"tu_current_effect_value";
static NSString* SYEffectValueKeyFormat = @"tu_effect_value.%@";


static NSString* SYMirrorStatus = @"sy_mirror_status_value";


static CGFloat SYEffectDefaultValueSmoothing = 0.30f;
static CGFloat SYEffectDefaultValueSlimming = 0.20f;
static CGFloat SYEffectDefaultValueEyelid = 0.30f;
static CGFloat SYEffectDefaultValueWhitening = 0.40f;
static CGFloat SYEffectDefaultValue = 0.75f;

@interface SYVideoPushViewController () <TuSDKFilterProcessorFaceDetectionDelegate,
                                         TuSDKFilterProcessorMediaEffectDelegate,
                                         PLMediaStreamingSessionDelegate,
                                         SYVideoRoomConfigDelegate,
                                         SYLivingShowBeautifyViewControllerDelegate,
                                         SYLivingShowCooldownViewControllerDelegate>
@property (nonatomic, copy) NSString* roomId;
@property (nonatomic, assign) BOOL skipPreview;
@property (nonatomic, strong) TuSDKFilterProcessor* filterProcessor;

@property (nonatomic, strong) TuSDKMediaSkinFaceEffect* skinFaceEffect;
@property (nonatomic, strong) TuSDKMediaPlasticFaceEffect* plasticFaceEffect;
@property (nonatomic, copy) NSString* currentEffectId;

@property (nonatomic, assign) BOOL isUserPushStreaming;

@property (nonatomic, strong) PLMediaStreamingSession* session;

@property (nonatomic, strong) SYVideoRoomConfigView* roomConfigView;

@property (nonatomic, assign) BOOL shouldHideRoomConfigViewCloseBeatify;

@property (nonatomic, assign) BOOL idleTimerDisabled;
@end

@implementation SYVideoPushViewController
- (void) dealloc {
    [NSNotificationCenter.defaultCenter removeObserver: self];
    [_session destroy];
    self.isUserPushStreaming = NO;
    [_filterProcessor destory];
    UIApplication.sharedApplication.idleTimerDisabled = self.idleTimerDisabled;
}

- (instancetype) init {
    return nil;
}

- (instancetype) initWithRoomId: (NSString*) roomId {
    return [self initWithRoomId: roomId skipPreview: NO];
}

- (instancetype) initWithRoomId: (NSString*) roomId skipPreview: (BOOL) skipPreview {
    if (self = [super init]) {
        self.idleTimerDisabled = UIApplication.sharedApplication.idleTimerDisabled;
        UIApplication.sharedApplication.idleTimerDisabled = YES;
        
        self.roomId = roomId;
        self.skipPreview = skipPreview;
        self.isUserPushStreaming = NO;
        [NSNotificationCenter.defaultCenter addObserver: self selector: @selector(audioRouteChanged:) name: AVAudioSessionRouteChangeNotification object: nil];
    }
    return self;
}

- (void) audioRouteChanged: (NSNotification*) notification {
    NSDictionary* dict = notification.userInfo;
    
    AVAudioSessionRouteChangeReason reason = [dict[AVAudioSessionRouteChangeReasonKey] integerValue];
    NSString* r = nil;
    switch (reason) {
        case AVAudioSessionRouteChangeReasonUnknown:
            r = @"AVAudioSessionRouteChangeReasonUnknown";
            break;
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            r = @"AVAudioSessionRouteChangeReasonNewDeviceAvailable";
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            r = @"AVAudioSessionRouteChangeReasonOldDeviceUnavailable";
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            r = @"AVAudioSessionRouteChangeReasonCategoryChange";
            if (![AVAudioSession.sharedInstance.category isEqualToString: AVAudioSessionCategoryPlayAndRecord]) {
                NSError* err = nil;
                [AVAudioSession.sharedInstance setCategory: AVAudioSessionCategoryPlayAndRecord error: &err];
                if (err) {
                    NSLog(@"Can't set session mode to PlayAndRecord by PushStreaming, error: %@", err);
                }
            }
            break;
        case AVAudioSessionRouteChangeReasonOverride:
            r = @"AVAudioSessionRouteChangeReasonOverride";
            break;
        case AVAudioSessionRouteChangeReasonWakeFromSleep:
            r = @"AVAudioSessionRouteChangeReasonWakeFromSleep";
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
            r = @"AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory";
            break;
        case AVAudioSessionRouteChangeReasonRouteConfigurationChange:
            r = @"AVAudioSessionRouteChangeReasonRouteConfigurationChange";
            break;
    }
    
    NSLog(@"Route Changed: %@", r);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SYLivingShow.shared initStreaming];
    
#if TARGET_OS_SIMULATOR
    self.view.backgroundColor = [UIColor grayColor];
#else
    self.view.backgroundColor = [UIColor whiteColor];
#endif
    [self.view addSubview: self.session.previewView];
    
    [self loadConfig];
   
    if (self.skipPreview) {
        __weak typeof(self) weakSelf = self;
        [self startPushStream:^(PLStreamStartStateFeedback feedback) {
            if (feedback == PLStreamStartStateSuccess) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoPushViewControllerStreamingConnected:)]) {
                    [weakSelf.delegate videoPushViewControllerStreamingConnected:weakSelf];
                }
            }
        }];
        if (self.delegate && [self.delegate respondsToSelector: @selector(videoPushViewControllerStartPushStream:)]) {
            [self.delegate performSelector: @selector(videoPushViewControllerStartPushStream:) withObject: self];
        }
    } else {
        self.roomConfigView.delegate = self;
        [self.view addSubview: self.roomConfigView];
        [self.roomConfigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        if (self.delegate && [self.delegate respondsToSelector: @selector(videoPushViewController:getRoomTitleSuccess:)]) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate videoPushViewController: self getRoomTitleSuccess: ^(NSString* title) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    strongSelf.roomConfigView.title = title;
                }];
            });
        }
    }
}

- (void) loadConfig {
    CGFloat smoothing =  [[NSUserDefaults standardUserDefaults] floatForKey: SYEffectSmootherKey];
     [self.skinFaceEffect submitParameterWithKey:@"smoothing" argPrecent: smoothing];
    CGFloat slimming = [[NSUserDefaults standardUserDefaults] floatForKey: SYEffectSlimmingKey];
    [self.plasticFaceEffect submitParameterWithKey: @"chinSize" argPrecent: slimming];
    CGFloat eyelid = [[NSUserDefaults standardUserDefaults] floatForKey: SYEffectEyelidKey];
    [self.plasticFaceEffect submitParameterWithKey: @"eyeSize" argPrecent: eyelid];
    CGFloat whitening =  [[NSUserDefaults standardUserDefaults] floatForKey: SYEffectWhiteningKey];
    [self.skinFaceEffect submitParameterWithKey:@"whitening" argPrecent: whitening];
    NSString* currentEffectId = [[NSUserDefaults standardUserDefaults] stringForKey: SYCurrentEffectIdKey];
    NSString* defaultEffectId = nil;
    if (currentEffectId == nil) {
        defaultEffectId = @"SkinFair_2";
    } else if ([currentEffectId isEqualToString: SYFilterNullId]) {
        // nop!
    }
    if (defaultEffectId.length) {
        self.currentEffectId = defaultEffectId;
        TuSDKMediaFilterEffect *effect = [[TuSDKMediaFilterEffect alloc] initWithEffectCode: defaultEffectId];
        [self.filterProcessor addMediaEffect: effect];
        CGFloat value = [[NSUserDefaults standardUserDefaults] floatForKey: SYCurrentEffectValueKey];
         [effect submitParameterWithKey: currentEffectId argPrecent: value];
    }
}

#pragma mark -
#pragma mark actions

- (void) presentBeautifyController {
    [self presentBeautifyControllerWithRoomConfigViewHidden: YES];
}

- (void) switchCamera {
    [self.session toggleCamera];
    AVCaptureDevicePosition position = self.session.videoCaptureConfiguration.position;
    if (position != self.filterProcessor.cameraPosition) {
        self.filterProcessor.cameraPosition = position;
    }
}

- (void) flipHorizontal:(BOOL) isOpen{
    // 主播端不做处理，只有观众端处理。
    //self.session.previewMirrorRearFacing = !self.session.previewMirrorRearFacing;
    //self.session.previewMirrorFrontFacing = !self.session.previewMirrorFrontFacing;
    self.session.streamMirrorRearFacing = !isOpen;
    self.session.streamMirrorFrontFacing = !isOpen;

    [[NSUserDefaults standardUserDefaults] setBool:isOpen forKey:SYMirrorStatus];

    self.filterProcessor.horizontallyMirrorRearFacingCamera = self.session.streamMirrorRearFacing;
    self.filterProcessor.horizontallyMirrorFrontFacingCamera = self.session.streamMirrorFrontFacing;
    
    // Toast
    NSString* message = nil;
    AVCaptureDevicePosition position = self.session.videoCaptureConfiguration.position;
    if ( (position == AVCaptureDevicePositionBack && self.session.streamMirrorRearFacing == YES)
        || (position == AVCaptureDevicePositionFront && self.session.streamMirrorFrontFacing)) {
        message = @"镜像模式关闭, 观众看到的画面和你是相同的";
    } else {
        message = @"镜像模式打开, 观众看到的画面和你是相反的";
    }
    
//    [SYToastView sy_showToast: message];
    if ([self.delegate respondsToSelector:@selector(videoPushViewControllerSuccessFlipHorizontal:toastString:)]) {
        [self.delegate videoPushViewControllerSuccessFlipHorizontal:[self mirrorState]
                                                        toastString:message];
    }
}

- (BOOL) mirrorState {
    return self.session.streamMirrorFrontFacing;
}

#pragma mark getter

- (TuSDKMediaSkinFaceEffect*) skinFaceEffect {
    if (!_skinFaceEffect) {
        TuSDKMediaSkinFaceEffect* skin = [[TuSDKMediaSkinFaceEffect alloc] initUseSkinNatural: NO];
        for (TuSDKFilterArg* arg in skin.filterArgs) {
            NSString* key = arg.key;
            CGFloat maxFactor = 1.0f;
            CGFloat defaultFactor = 1.0f;
            BOOL needUpdate = NO;
            if ([key isEqualToString: @"smoothing"]) {
                maxFactor = 0.7f;
                defaultFactor = 0.5f;
                needUpdate = YES;
            } else if ([key isEqualToString: @"whitening"]) {
                maxFactor = 0.5f;
                defaultFactor = 0.5f;
                needUpdate = YES;
            } else if ([key isEqualToString: @"ruddy"]) {
                maxFactor = 0.65f;
                defaultFactor = 0.3f;
                needUpdate = YES;
            } else {
                maxFactor = 0.7f;
                defaultFactor = 0.3f;
                needUpdate = YES;
            }
            
            if (needUpdate) {
                if (defaultFactor != 1.0f) {
                    arg.defaultValue = arg.minFloatValue + (arg.maxFloatValue - arg.minFloatValue) * defaultFactor * maxFactor;
                }
                if (maxFactor != 1) {
                    arg.maxFloatValue = arg.minFloatValue + (arg.maxFloatValue - arg.minFloatValue) * maxFactor;
                }
                [arg reset];
            }
        }
        
        [skin submitParameters];
        _skinFaceEffect = skin;
    }
    return _skinFaceEffect;
}

- (TuSDKMediaPlasticFaceEffect*) plasticFaceEffect {
    if (!_plasticFaceEffect) {
        TuSDKMediaPlasticFaceEffect *plastic = [[TuSDKMediaPlasticFaceEffect alloc] init];
        for (TuSDKFilterArg* arg in plastic.filterArgs) {
            NSString* key = arg.key;
            
            BOOL needUpdate = NO;
            CGFloat defaultFactor = 1.0f;
            CGFloat maxFactor = 1.0f;
            
            if ([key isEqualToString: @"eyeSize"]) {
                maxFactor = 0.85f;
                defaultFactor = 0.5f;
                needUpdate = YES;
            } else if ([key isEqualToString: @"chinSize"]) {
                maxFactor = 0.8f;
                defaultFactor = 0.2f;
                needUpdate = YES;
            } else {
//                maxFactor = 0.85f;
//                defaultFactor = 0.2f;
//                needUpdate = YES;
            }
            
            if (needUpdate) {
                if (defaultFactor != 1.0f) {
                    arg.defaultValue = arg.minFloatValue + (arg.maxFloatValue - arg.minFloatValue) * defaultFactor * maxFactor;
                }
                if (maxFactor != 1) {
                    arg.maxFloatValue = arg.minFloatValue + (arg.maxFloatValue - arg.minFloatValue) * maxFactor;
                }
                [arg reset];
            }
        }
        [plastic submitParameters];
        _plasticFaceEffect = plastic;
    }
    
    return _plasticFaceEffect;
}

- (TuSDKFilterProcessor*) filterProcessor {
    @synchronized (self) {
        if (!_filterProcessor) {
            TuSDKFilterProcessor* processor = [[TuSDKFilterProcessor alloc] initWithFormatType: kCVPixelFormatType_32BGRA isOriginalOrientation: NO];
            processor.mediaEffectDelegate = self;
            // TODO: 处理旋转
            processor.horizontallyMirrorFrontFacingCamera = NO;
            processor.cameraPosition = AVCaptureDevicePositionFront;
            processor.adjustOutputRotation = NO;
            processor.enableLiveSticker = YES;
            if ([processor addMediaEffect: self.skinFaceEffect]) {
                NSLog(@"=========== 加入美颜效果.");
            }
            if ([processor addMediaEffect: self.plasticFaceEffect]) {
                NSLog(@"============ 加入微整形效果.");
            }
            BOOL isMirror = [[NSUserDefaults standardUserDefaults] boolForKey:SYMirrorStatus];
            processor.horizontallyMirrorRearFacingCamera = !isMirror;
            processor.horizontallyMirrorFrontFacingCamera = !isMirror;
            _filterProcessor = processor;
        }
    }
    return _filterProcessor;
}

- (PLMediaStreamingSession*) session {
    if (!_session) {
#ifdef QINIU_SDK_FIX_HD
//        PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
//        videoCaptureConfiguration.position = AVCaptureDevicePositionFront;
//        videoCaptureConfiguration.sessionPreset = AVCaptureSessionPresetHigh;
//        videoCaptureConfiguration.sessionPreset = AVCaptureSessionPresetiFrame1280x720;
        BOOL isMirror = [[NSUserDefaults standardUserDefaults] boolForKey:SYMirrorStatus];
        PLVideoCaptureConfiguration *videoCaptureConfiguration = [[PLVideoCaptureConfiguration alloc] initWithVideoFrameRate:24
                                                                                                               sessionPreset: AVCaptureSessionPreset1280x720
                                                                                                    previewMirrorFrontFacing: YES
                                                                                                     previewMirrorRearFacing: NO
                                                                                                     streamMirrorFrontFacing: !isMirror
                                                                                                      streamMirrorRearFacing: !isMirror
                                                                                                              cameraPosition: AVCaptureDevicePositionFront
                                                                                                            videoOrientation: AVCaptureVideoOrientationPortrait];
#else
        PLVideoCaptureConfiguration *videoCaptureConfiguration = [[PLVideoCaptureConfiguration alloc]initWithVideoFrameRate:24 sessionPreset: AVCaptureSessionPreset previewMirrorFrontFacing:YES previewMirrorRearFacing:NO streamMirrorFrontFacing:NO streamMirrorRearFacing:NO cameraPosition:AVCaptureDevicePositionFront videoOrientation:AVCaptureVideoOrientationPortrait];
        
#endif
        
        PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
#ifdef QINIU_SDK_FIX_HD
        PLVideoStreamingConfiguration* videoStreamingConfiguration = [[PLVideoStreamingConfiguration alloc]
                                                                      initWithVideoSize: CGSizeMake(720, 1280)
                                                                      expectedSourceVideoFrameRate: 24
                                                                      videoMaxKeyframeInterval: 24*3
                                                                      averageVideoBitRate: 1600 * 1024
                                                                      videoProfileLevel: AVVideoProfileLevelH264High41
                                                                      videoEncoderType: PLH264EncoderType_VideoToolbox];
#else
        PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration configurationWithVideoQuality: kPLVideoStreamingQualityHigh1];
#endif
        PLAudioStreamingConfiguration *audioStreamingConfiguration = [[PLAudioStreamingConfiguration alloc] initWithAudioQuality: kPLAudioStreamingQualityHigh1];

        PLMediaStreamingSession* session =  [[PLMediaStreamingSession alloc]
                                             initWithVideoCaptureConfiguration: videoCaptureConfiguration
                                             audioCaptureConfiguration: audioCaptureConfiguration
                                             videoStreamingConfiguration: videoStreamingConfiguration
                                             audioStreamingConfiguration: audioStreamingConfiguration
                                             stream: nil];
        session.delegate = self;
        session.autoReconnectEnable = YES;
        [session setBeautifyModeOn: NO];
        _session = session;
    }
    return _session;
}

- (SYVideoRoomConfigView*) roomConfigView {
    if (!_roomConfigView) {
        SYVideoRoomConfigView* configView = [[SYVideoRoomConfigView alloc] initWithFrame: CGRectZero];
        _roomConfigView = configView;
    }
    
    return _roomConfigView;
}

#pragma mark setter

- (void) setIsUserPushStreaming: (BOOL) isUserPushStreaming {
    if (_isUserPushStreaming != isUserPushStreaming) {
        if (_isUserPushStreaming) {
            [[NSNotificationCenter defaultCenter] removeObserver: self];
            // TODO: unregister notification
        } else {
            // TODO: register notification
            [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object: nil];
            [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidEnterForeground) name: UIApplicationDidBecomeActiveNotification object: nil];
        }
        _isUserPushStreaming = isUserPushStreaming;
    }
}


- (void) reStartPushStream {
    __weak typeof(self) weakSelf = self;
    [self startPushStream:^(PLStreamStartStateFeedback feedback) {
        if (feedback == PLStreamStartStateSuccess || weakSelf.session.isStreamingRunning) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoPushViewControllerStreamingConnected:)]) {
                [weakSelf.delegate videoPushViewControllerStreamingConnected:weakSelf];
            }
        }
    }];
}


- (void) startPushStream:(void (^)(PLStreamStartStateFeedback feedback))handler {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
    [[SYLivingAPI shared] getStreamPushUrlWithRoomId: self.roomId
                                        successBlock:^(id  _Nullable response) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                NSLog(@"main queue");
                                                __strong typeof(weakSelf) strongSelf = weakSelf;
                                                strongSelf.isUserPushStreaming = YES;
                                                SYLivingStreamModel* m = (SYLivingStreamModel*) response;
                                                NSString* url = m.url;
                                                if (url && url.length) {
                                                    NSURL* push = [NSURL URLWithString: url];
                                                    [strongSelf.session startStreamingWithPushURL:  push
                                                                                         feedback:^(PLStreamStartStateFeedback feedback) {
                                                                                             if (handler) {
                                                                                                 handler(feedback);
                                                                                             }
                                                                                             if (feedback == PLStreamStartStateSuccess) {
                                                                                                 NSLog(@"Streaming started.");
                                                                                                 [SYToastView sy_showToast: @"开始直播中!"];
                                                                                             } else {
                                                                                                 NSLog(@"Oops.");
                                                                                             }
                                                                                             [MBProgressHUD hideHUDForView: strongSelf.view animated: YES];
                                                                                         }];
                                                } else {
                                                    
                                                }
                                                
                                            });
                                        }
                                        failureBlock:^(NSError * _Nullable error) {
                                            __strong typeof(weakSelf) strongSelf = weakSelf;
                                            [MBProgressHUD hideHUDForView: strongSelf.view animated: YES];
                                            [SYToastView sy_showToast: @"直播失败!"];
                                        }];
}

- (void) stopPushStream {
    [self.session stopStreaming];
}

- (void) applicationDidEnterBackground {
    [SYToastView sy_showToast:@"进入后台直播会中断"];
    [self stopPushStream];
}

- (void) applicationDidEnterForeground {
    __weak typeof(self) weakSelf = self;
    [self startPushStream:^(PLStreamStartStateFeedback feedback) {
        if (feedback == PLStreamStartStateSuccess || weakSelf.session.isStreamingRunning) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoPushViewControllerStreamingConnected:)]) {
                [weakSelf.delegate videoPushViewControllerStreamingConnected:weakSelf];
            }
        }
    }];
}
#pragma mark Rotation
- (BOOL)shouldAutorotate{
    return NO;
}

//支持旋转的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark -
#pragma mark TuSDKFilterProcessorFaceDetectionDelegate
///
 *  人脸检测事件委托 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param processor 视频处理对象
 *  @param type 人脸信息
 *  @param count 检测到的人脸数量
///
- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor
 faceDetectionResultType:(lsqVideoProcesserFaceDetectionResultType)type
               faceCount:(NSUInteger)count {
    
}

#pragma mark TuSDKFilterProcessorMediaEffectDelegate


 一个新的特效正在被应用

 @param processor 视频处理对象
 @param mediaEffectData 应用的特效信息
 @since 2.2.0

- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor
  didApplyingMediaEffect:(id<TuSDKMediaEffect>)mediaEffectData {
    
}

///
// *特效数据移除
//
// @param processor 视频处理对象
// @param mediaEffectDatas 被移除的特效列表
// @since 2.2.0
 ///
- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor
   didRemoveMediaEffects:(NSArray<id<TuSDKMediaEffect>> *)mediaEffectDatas {
    
}

#pragma mark PLMediaStreamingSessionDelegate
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session streamStateDidChange:(PLStreamState)state {
     //只有在正常连接，正常断开的情况下跳转的状态才会触发这一回调。所谓正常连接是指通过调用
     //-startStreamingWithFeedback: 方法使得流连接的各种状态，而所谓正常断开是指调用
     //-stopStreaming 方法使得流断开的各种状态。所以只有以下四种状态会触发这一回调方法。

    switch (state) {
        case PLStreamStateConnecting:
        case PLStreamStateConnected:
        case PLStreamStateDisconnecting:
            NSLog(@"正常操作状态更新: %@", @(state));
            break;
        case PLStreamStateDisconnected:
            if (self.delegate && [self.delegate respondsToSelector: @selector(videoPushViewControllerStreamingDisconnected:withError:)]) {
                [self.delegate performSelector: @selector(videoPushViewControllerStreamingDisconnected:withError:)
                                    withObject: self
                                    withObject: nil];
            }
            NSLog(@"正常操作状态更新: %@", @(state));
            break;
        default:
            NSLog(@"正常操作状态更新: %@", @(state));
    }
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didDisconnectWithError:(NSError *)error {

//     除了调用 -stopStreaming 之外的所有导致流断开的情况，都被归属于非正常断开的情况，此时就会触发该回调。
//     对于错误的处理，我们不建议触发了一次 error 后就停掉，最好可以在此时尝试有限次数的重连，详见重连小节。

    if (error == nil) {
        error = [NSError errorWithDomain: @"com.le" code: -1 userInfo: nil];
    }
    if (self.delegate && [self.delegate respondsToSelector: @selector(videoPushViewControllerStreamingDisconnected:withError:)]) {
        [self.delegate performSelector: @selector(videoPushViewControllerStreamingDisconnected:withError:)
                            withObject: self
                            withObject: error];
    }
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session streamStatusDidUpdate:(PLStreamStatus *)status {

//     默认情况下，该回调每隔 3s 调用一次，每次包含了这 3s 内音视频的 fps 和总共的码率（注意单位是 kbps）。
//     你可以通过 PLMediaStreamingSession 的 statusUpdateInterval 属性来读取或更改这个回调的间隔。

}

- (CVPixelBufferRef)mediaStreamingSession:(PLMediaStreamingSession *)session cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    // TODO: 美颜引擎处理
    CVPixelBufferRef newPixelBuffer  = [self.filterProcessor syncProcessPixelBuffer: pixelBuffer];
    [self.filterProcessor destroyFrameData];
    return newPixelBuffer;
}


#pragma mark SYLivingShowBeautifyViewControllerDelegate

#define DEFINE_BEAUTIFY_DELEGATE(Name, default) \
- (CGFloat) beautifyViewController##Name: (SYLivingShowBeautifyViewController*) controller { \
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults]; \
    if ([[[defaults dictionaryRepresentation] allKeys] containsObject: SYEffect##Name##Key]) { \
        return [defaults floatForKey: SYEffect##Name##Key]; \
    } else { \
        return default; \
    } \
}

DEFINE_BEAUTIFY_DELEGATE(Smoother, SYEffectDefaultValueSmoothing)
DEFINE_BEAUTIFY_DELEGATE(Slimming, SYEffectDefaultValueSlimming)
DEFINE_BEAUTIFY_DELEGATE(Eyelid, SYEffectDefaultValueEyelid)
DEFINE_BEAUTIFY_DELEGATE(Whitening, SYEffectDefaultValueWhitening)

#undef DEFINE_BEAUTIFY_DELEGATE

- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setSmoother: (CGFloat) smoother {
    [[NSUserDefaults standardUserDefaults] setFloat: smoother forKey: SYEffectSmootherKey];
    [self.skinFaceEffect submitParameterWithKey:@"smoothing" argPrecent: smoother];
}

- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setSlimming: (CGFloat) slimming {
    [[NSUserDefaults standardUserDefaults] setFloat: slimming forKey: SYEffectSlimmingKey];
    [self.plasticFaceEffect submitParameterWithKey: @"chinSize" argPrecent: slimming];
}

- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setEyelid: (CGFloat) eyelid {
    [[NSUserDefaults standardUserDefaults] setFloat: eyelid forKey: SYEffectEyelidKey];
    [self.plasticFaceEffect submitParameterWithKey: @"eyeSize" argPrecent: eyelid];
}

- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setWhitening: (CGFloat) whitening {
    [[NSUserDefaults standardUserDefaults] setFloat: whitening forKey: SYEffectWhiteningKey];
    [self.skinFaceEffect submitParameterWithKey:@"whitening" argPrecent: whitening];
}

- (void) beautifyViewControllerClosed: (SYLivingShowBeautifyViewController*) controller {
    [self dismissViewControllerAnimated: YES completion: ^{
        self.roomConfigView.hidden = self.shouldHideRoomConfigViewCloseBeatify;
    }];
}

- (NSString* _Nullable) beautifyViewControllerCurrentEffectId: (SYLivingShowBeautifyViewController*) controller {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if ([[[defaults dictionaryRepresentation] allKeys] containsObject: SYCurrentEffectIdKey]) {
        return [defaults objectForKey: SYCurrentEffectIdKey];
    } else {
        return @"SkinFair_2";
    }
}

- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setCurrentEffectId: (NSString* _Nullable) effectId {
    if (effectId.length) {
        [[NSUserDefaults standardUserDefaults] setObject: effectId forKey: SYCurrentEffectIdKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey: SYCurrentEffectIdKey];
    }
    // TODO: nil 处理应该放到下面.
    if (effectId.length == 0
        || [effectId isEqualToString: SYFilterNullId]) {
        self.currentEffectId = effectId;
        TuSDKMediaFilterEffect *effect = [self.filterProcessor mediaEffectsWithType:TuSDKMediaEffectDataTypeFilter].firstObject;
        [self.filterProcessor removeMediaEffect: effect];
    }
}

- (CGFloat) beautifyViewController:(SYLivingShowBeautifyViewController*) controller effectValueForId: (NSString*) effectId {
    //NSString* key = [NSString stringWithFormat: SYEffectValueKeyFormat, effectId];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* savedEffectId = [[NSUserDefaults standardUserDefaults] objectForKey: SYCurrentEffectIdKey];
    if ([savedEffectId isEqualToString: effectId]) {
        if ([[[defaults dictionaryRepresentation] allKeys] containsObject: SYCurrentEffectValueKey]) {
            return [defaults floatForKey: SYCurrentEffectValueKey];
        } else {
            return SYEffectDefaultValue;
        }
    } else {
        return SYEffectDefaultValue;
    }
}

- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller updateCurrentEffectId: (NSString*) effectId withValue: (CGFloat) effectValue {
    // TODO: 应该处理 null;
    //NSString* key = [NSString stringWithFormat: SYEffectValueKeyFormat, effectId];
    //[[NSUserDefaults standardUserDefaults] setFloat: effectValue forKey: key];
    [[NSUserDefaults standardUserDefaults] setObject: effectId forKey: SYCurrentEffectIdKey];
    [[NSUserDefaults standardUserDefaults] setFloat: effectValue forKey: SYCurrentEffectValueKey];
#ifdef DEBUG
    NSLog(@"filter effect: %@ value: %.2f", effectId, effectValue);
#endif
    if (self.currentEffectId != effectId) {
        // TODO: 替换滤镜
        self.currentEffectId = effectId;
        
        if (effectId.length == 0 || [effectId isEqualToString: SYFilterNullId]) {
            TuSDKMediaFilterEffect *effect = [self.filterProcessor mediaEffectsWithType:TuSDKMediaEffectDataTypeFilter].firstObject;
            [self.filterProcessor removeMediaEffect: effect];
        } else {
            TuSDKMediaFilterEffect *effect = [[TuSDKMediaFilterEffect alloc] initWithEffectCode: effectId];
            NSLog(@"change:  effectId:%@", effectId);
            [self.filterProcessor addMediaEffect: effect];
            [effect submitParameterWithKey: effectId argPrecent: effectValue];
        }
    } else {
        TuSDKMediaFilterEffect *effect = [self.filterProcessor mediaEffectsWithType:TuSDKMediaEffectDataTypeFilter].firstObject;
        //[effect submitParameter: 0 argPrecent: effectValue];
        [effect submitParameterWithKey: @"mixied" argPrecent: effectValue];
    }
}

- (void) presentBeautifyControllerWithRoomConfigViewHidden: (BOOL) hidden {
    self.roomConfigView.hidden = YES;
    self.shouldHideRoomConfigViewCloseBeatify = hidden;
    SYLivingShowBeautifyViewController* controller = [[SYLivingShowBeautifyViewController alloc] initWithDelegate: self];
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController: controller animated: YES completion: nil];
}

#pragma mark SYVideoRoomConfigDelegate

- (void) beautifyButtonClicked {
    self.roomConfigView.hidden = YES;
    // 显示 ViewController
    [self presentBeautifyControllerWithRoomConfigViewHidden: NO];
}


- (void) startShowButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector: @selector(videoPushViewControllerStartShowClicked:)]) {
        [self.delegate performSelector: @selector(videoPushViewControllerStartShowClicked:) withObject: self];
    }
    
    SYLivingShowCooldownViewController* controller = [[SYLivingShowCooldownViewController alloc] initWithCounterOfSeconds: 3];
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.roomConfigView.hidden = YES;
    [self presentViewController: controller animated: YES completion: ^{
    }];
    
}

- (void) roomConfigButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector: @selector(videoPushViewControllerConfigClicked:)]) {
        [self.delegate performSelector: @selector(videoPushViewControllerConfigClicked:) withObject: self];
    }
    return;
}

- (void) closeButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector: @selector(videoPushViewControllerCloseClicked:)]) {
        [self.delegate performSelector: @selector(videoPushViewControllerCloseClicked:) withObject: self];
    }
    return;
}

- (void) roomTitleChanged:(NSString *)title {
    if (self.delegate && [self.delegate respondsToSelector: @selector(videoPushViewController:setRoomTitle:)]) {
        [self.delegate performSelector: @selector(videoPushViewController:setRoomTitle:) withObject: self withObject: title];
    }
    return;
}

#pragma mark SYLivingShowCooldownViewControllerDelegate

- (void) cooldownControllerTimeout: (SYLivingShowCooldownViewController*) controller {
    [self dismissViewControllerAnimated: YES completion: ^{
        __weak typeof(self) weakSelf = self;
        [self startPushStream:^(PLStreamStartStateFeedback feedback) {
            if (feedback == PLStreamStartStateSuccess) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(videoPushViewControllerStreamingConnected:)]) {
                    [weakSelf.delegate videoPushViewControllerStreamingConnected:weakSelf];
                }
            }
        }];
    }];
    if (self.delegate && [self.delegate respondsToSelector: @selector(videoPushViewControllerStartPushStream:)]) {
        [self.delegate performSelector: @selector(videoPushViewControllerStartPushStream:) withObject: self];
    }
}
@end
*/
