//
//  SYVideoPullViewController.m
//  Shining
//
//  Created by Zhang Qigang on 2019/9/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <PLPlayerKit/PLPlayerKit.h>
#import "SYLivingModel.h"
#import "SYLivingAPI.h"
#import "SYVideoPullViewController.h"

@interface SYVideoPullViewController ()<PLPlayerDelegate>
@property (nonatomic, copy) NSString* roomId;
@property (nonatomic, strong) PLPlayer* player;

@property (nonatomic, strong) UIView* loadingView;
@property (nonatomic, strong) UIStackView* loadingVLayoutView;
@property (nonatomic, strong) UILabel* loadingLabel;
@property (nonatomic, strong) UIImageView* loadingImageView;
@property (nonatomic, strong) UIVisualEffectView* loadingMaskView;

@property (nonatomic, assign) BOOL reconnecting;

@property (nonatomic, strong) NSTimer* reconnectTimer;
@property (nonatomic, assign) BOOL idleTimerDisabled;

- (void) showLoading;
- (void) hideLoading;

- (void) showLeaving;
- (void) hideLeaving;
@end

@implementation SYVideoPullViewController

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SYNetworkingReachabilityDidChangeNotification object:nil];
    [self cancelRetry];
    UIApplication.sharedApplication.idleTimerDisabled = self.idleTimerDisabled;
}

- (instancetype) init {
    return nil;
}

- (instancetype) initWithRoomId: (NSString*) roomId {
    if (self = [super init]) {
        self.roomId = roomId;
        _reconnecting = NO;
        self.idleTimerDisabled = UIApplication.sharedApplication.idleTimerDisabled;
        UIApplication.sharedApplication.idleTimerDisabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.loadingView];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:SYNetworkingReachabilityDidChangeNotification
                                               object:nil];
    [self getStreamPullUrl];
}

// 显示 Loading
- (void) showLoading {
    self.loadingVLayoutView.hidden = YES;
    self.loadingView.hidden = NO;
    self.loadingMaskView.hidden = NO;
    [MBProgressHUD showHUDAddedTo: self.loadingView animated: NO];
}

// 隐藏k Loading
- (void) hideLoading {
    self.loadingVLayoutView.hidden = YES;
    self.loadingView.hidden = YES;
    self.loadingMaskView.hidden = YES;
    [MBProgressHUD hideHUDForView: self.loadingView animated: NO];
}

// 显示主播离开
- (void) showLeaving {
    self.loadingVLayoutView.hidden = NO;
    [self.loadingImageView startAnimating];
    self.loadingView.hidden = NO;
    self.loadingMaskView.hidden = YES;
    [MBProgressHUD hideHUDForView: self.loadingView animated: NO];
}

// 隐藏主播离开
- (void) hideLeaving {
    self.loadingVLayoutView.hidden = YES;
    self.loadingView.hidden = YES;
    self.loadingMaskView.hidden = YES;
    [self.loadingImageView stopAnimating];
    [MBProgressHUD hideHUDForView: self.loadingView animated: NO];
}

- (void) reconnectAction: (id) sender {
    [self getStreamPullUrl];
}

- (void)getStreamPullUrl {
    __weak typeof(self) weakSelf = self;
    [self cancelRetry];
    [self showLoading];
    [[SYLivingAPI shared] getStreamPullUrlWithRoomId: self.roomId
                                        successBlock:^(id  _Nullable response) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                NSLog(@"main queue");
                                                __strong typeof(weakSelf) strongSelf = weakSelf;
                                                SYLivingStreamModel* m = (SYLivingStreamModel*) response;
                                                NSString* url = m.url;
                                                if (url && url.length) {
                                                    PLPlayerOption *option = [PLPlayerOption defaultOption];
                                                    [option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
                                                    NSURL *pull = [NSURL URLWithString: url];
                                                    if (strongSelf.player) {
                                                        [strongSelf.player.playerView removeFromSuperview];
                                                    }
                                                    strongSelf.player = [PLPlayer playerWithURL: pull option: option];
                                                    strongSelf.player.delegate = strongSelf;
                                                    strongSelf.player.playerView.contentMode = UIViewContentModeScaleAspectFill;
                                                    strongSelf.player.autoReconnectEnable = YES;
                                                    [strongSelf.view addSubview: strongSelf.player.playerView];
                                                    [strongSelf.view bringSubviewToFront: self.loadingView];
                                                    [strongSelf.player play];
                                                }
                                            });
                                        } failureBlock:^(NSError * _Nullable error) {
                                            __strong typeof(weakSelf) strongSelf = weakSelf;
                                            [strongSelf retryStreamingDelay: 10.0f];
                                            [self hideLoading];
                                        }];
}

- (void) retryStreamingDelay: (CGFloat) delay {
    [self cancelRetry];

    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval: delay
                                                      target:self
                                                    selector:@selector(reconnectAction:)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.reconnectTimer = timer;
}

- (void)reGetStreamPullUrl {
    if (self.player && self.player.status != PLPlayerStatusPlaying) {
        if (self.player.status == PLPlayerStateAutoReconnecting) {
            [self.player stop];
        }
        [self getStreamPullUrl];
    }
}

- (void) cancelRetry {
    if (self.reconnectTimer) {
        [self.reconnectTimer invalidate];
        self.reconnectTimer = nil;
    }
}

#pragma mark -
#pragma mark rotation
- (BOOL)shouldAutorotate{
    return NO;
}

//支持旋转的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark getter

- (void) setReconnecting:(BOOL)reconnecting {
    if (_reconnecting != reconnecting) {
        _reconnecting = reconnecting;
        if (reconnecting) {
            if (self.delegate && [self.delegate respondsToSelector: @selector(videoPullViewControllerPlayerReconnectingBegin:)]) {
                [self.delegate performSelector: @selector(videoPullViewControllerPlayerReconnectingBegin:) withObject: self];
            }
        } else {
            if (self.delegate && [self.delegate respondsToSelector: @selector(videoPullViewControllerPlayerReconnectingEnd:)]) {
                [self.delegate performSelector: @selector(videoPullViewControllerPlayerReconnectingEnd:) withObject: self];
            }
        }
    }
}

- (UIImageView*) loadingImageView {
    if (!_loadingImageView) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
        NSMutableArray* imageFrames = [NSMutableArray arrayWithCapacity: 40];
        for (int i = 0; i < 50; i ++) {
            NSString* imageName = [NSString stringWithFormat: @"loading_%04d", i];
            UIImage* image = [UIImage imageNamed_sy: imageName];
            [imageFrames addObject: image];
        }
        imageView.animationImages = imageFrames;
        imageView.animationDuration = 1.0f;
        imageView.animationRepeatCount = 0;
        _loadingImageView = imageView;
    }
    return _loadingImageView;
}

- (UILabel*) loadingLabel {
    if (!_loadingLabel) {
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectZero];
        label.text = @"主播暂时离开，请稍等 ...";
        label.numberOfLines = 1;
        label.textColor = [UIColor sy_colorWithHexString: @"#FFFFFF"];
        label.font = [UIFont systemFontOfSize: 16.0f];
        label.textAlignment = NSTextAlignmentCenter;
        _loadingLabel = label;
    }
    return _loadingLabel;
}

- (UIVisualEffectView*) loadingMaskView {
    if (!_loadingMaskView) {
        UIVisualEffectView* blur = [[UIVisualEffectView alloc] initWithEffect: [UIBlurEffect effectWithStyle: UIBlurEffectStyleExtraLight]];
        _loadingMaskView = blur;
    }
    
    return _loadingMaskView;
}

- (UIStackView*) loadingVLayoutView {
    if (!_loadingVLayoutView) {
        UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews: @[
                                                                                  self.loadingImageView,
                                                                                  self.loadingLabel,
                                                                                  ]];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 2.0f;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.distribution = UIStackViewDistributionFill;
        stackView.hidden = YES;
        _loadingVLayoutView = stackView;
    }
    return _loadingVLayoutView;
}

- (UIView*) loadingView {
    if (!_loadingView) {
        UIView* view = [[UIView alloc] initWithFrame: CGRectZero];
        [view addSubview: self.loadingMaskView];
        [view addSubview: self.loadingVLayoutView];
        [self.loadingMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        [self.loadingVLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
        }];
        _loadingView = view;
    }
    return _loadingView;
}
#pragma mark -
#pragma PLPlayerDelegate
- (void)playerWillBeginBackgroundTask:(PLPlayer *)player {
}

- (void)playerWillEndBackgroundTask:(PLPlayer *)player {
    if (_player && !_player.isPlaying) {
        if (_player.status == PLPlayerStatusPaused ||
            _player.status == PLPlayerStatusCaching) {
            [_player resume];
        }else {
            BOOL success = [_player play];
            if (!success) {
                [self reGetStreamPullUrl];
            }
        }
    }
}

- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state
{
    if (state == PLPlayerStatusPlaying ||
        state == PLPlayerStatusPaused ||
        state == PLPlayerStatusUnknow ||
        state == PLPlayerStatusCompleted) {
        NSLog(@"Hide waiting");
        [self hideLoading];
        self.reconnecting = NO;
    }else if (state == PLPlayerStatusCaching) {
        //主播断流前经过这个状态
//        [self showLoading];
    }else if (state == PLPlayerStatusStopped) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(videoPullViewControllerPlayerStopped:)]) {
            [self.delegate performSelector: @selector(videoPullViewControllerPlayerStopped:) withObject: self];
        }
    } else if (state == PLPlayerStatusError) {
        NSLog(@"Hide waiting");
        //[self hideLoading];
        if (![SYNetworkReachability isNetworkReachable]) {
            [SYToastView showToast:@"网络连接中断，请检查网络"];
        }else {
            [self showLeaving];
        }
        [self retryStreamingDelay: 10.0f];
        self.reconnecting = NO;
        // TODO: 这里不知道需要不需要调用，看测试的结果再说吧。
        if (self.delegate && [self.delegate respondsToSelector: @selector(videoPullViewController:playWithError:)]) {
            [self.delegate performSelector: @selector(videoPullViewController:playWithError:) withObject: self withObject: nil];
        }
    } else if (state == PLPlayerStatusPreparing ||
               state == PLPlayerStatusReady) {
        NSLog(@"Show waiting");
        [self showLoading];
    } else if (state == PLPlayerStateAutoReconnecting) {
        NSLog(@"Show waiting");
        self.reconnecting = YES;
        [self showLoading];
    }
}

- (void)player: (PLPlayer *)player stoppedWithError:(NSError *)error
{
    NSLog(@"Hide waiting");
    [self hideLoading];
    if (![SYNetworkReachability isNetworkReachable]) {
        [SYToastView showToast:@"网络连接中断，请检查网络"];
    }else {
        [self showLeaving];
    }
    self.reconnecting = NO;
    NSString *info = error.userInfo[@"NSLocalizedDescription"];
    NSLog(@"%@", info);
    if (self.delegate && [self.delegate respondsToSelector: @selector(videoPullViewController:playWithError:)]) {
        [self.delegate performSelector: @selector(videoPullViewController:playWithError:) withObject: self withObject: error];
    }
}

- (void)player: (nonnull PLPlayer*) player
willRenderFrame: (nullable CVPixelBufferRef)frame
           pts: (int64_t)pts
  sarNumerator: (int)sarNumerator
sarDenominator:(int)sarDenominator {
    dispatch_main_async_safe(^{
        if (![UIApplication sharedApplication].isIdleTimerDisabled) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
    });
}

- (AudioBufferList*) player: (PLPlayer*) player
      willAudioRenderBuffer: (AudioBufferList*) audioBufferList
                       asbd: (AudioStreamBasicDescription) audioStreamDescription
                        pts: (int64_t)pts
               sampleFormat: (PLPlayerAVSampleFormat) sampleFormat {
    return audioBufferList;
}

- (void) player: (nonnull PLPlayer*) player
    firstRender: (PLPlayerFirstRenderType) firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
        NSLog(@"第一帧");
    }
}

- (void) player: (nonnull PLPlayer*) player
        SEIData: (nullable NSData *) SEIData {
    
}

- (void) player: (PLPlayer*) player
     codecError: (NSError*) error {
    
    NSString *info = error.userInfo[@"NSLocalizedDescription"];
    NSLog(@"%@", info);
    NSLog(@"hide waiting");
    [self hideLoading];
}

- (void) player: (PLPlayer*) player
loadedTimeRange: (CMTimeRange) timeRange {
    
}


- (void)networkChanged:(id)sender {
    if ([SYNetworkReachability isNetworkReachable]) {
        if (_player && !_player.isPlaying) {
            if (_player.status == PLPlayerStatusPaused ||
                _player.status == PLPlayerStatusCaching) {
                [_player resume];
            }else {
                [self reGetStreamPullUrl];
            }
        }
    }
}
@end
