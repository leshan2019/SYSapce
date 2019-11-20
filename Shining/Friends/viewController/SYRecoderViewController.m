//
//  SYRecoderViewController.m
//  Shining
//
//  Created by letv_lzb on 2019/3/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//
/*
#import "SYRecoderViewController.h"
#import "SYRecordVocieButton.h"
//#import <TABCardView.h>
//#import <TABBaseCardView.h>
#import "SYAudioRecordManager.h"
#import "SYLameTools.h"
#import "SYRecordSuccessView.h"

@interface SYRecoderViewController ()<TABCardViewDelegate,SYRecordVocieButtonDelegate>
@property (nonatomic, strong) UIView *recordBackView;
@property (nonatomic, strong) SYRecordVocieButton *recordBtn;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) TABCardView *cardView;
@property (nonatomic, strong) UILabel *descLal;
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIBezierPath *progressPath;
@property (nonatomic, strong) UIBezierPath *trackPath;
@property (nonatomic, assign) CGFloat hudu;
@property (nonatomic, copy)   NSString *audioPath;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *backgroundImage;

@property (nonatomic, strong) SYRecordSuccessView *recordSuccessView;

@end

@implementation SYRecoderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0/255 green:191/255 blue:255/255 alpha:1];
    [self sy_setView];
    [self sy_setAudioManager];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}



- (void)sy_setAudioManager
{
    __weak typeof(self) weakSelf = self;
    [[SYAudioRecordManager shareSYAudioRecordManager] setRecordTimerHander:^(NSTimeInterval currentTime,NSTimeInterval duration) {
        [weakSelf sy_didRecordingWithButton:weakSelf.recordBtn recordTime:currentTime duration:duration];
    }];

    [[SYAudioRecordManager shareSYAudioRecordManager] setSuccessBlock:^(BOOL ret, NSString * _Nonnull resultPath, NSTimeInterval recordTime, NSTimeInterval duration) {
        if (ret) {
            if (recordTime < 6) {
                // 判断输入路径是否存在
                [SYToastView showToast:@"录音时间太多，不能小于6m秒"];
                NSLog(@"录音时间太多，不能小于6m秒");
                NSFileManager *fm = [NSFileManager defaultManager];
                NSError *error;
                [fm removeItemAtPath:resultPath error:&error];
                if (error == nil) {
                    NSLog(@"录音文件删除成功，path：%@",resultPath);
                }
            }else{
                [SYLameTools audioToMP3:resultPath isDeleteSourchFile:YES withSuccessBack:^(NSString * _Nonnull mp3Path) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"最终录音mp3格式路径：%@",mp3Path);
                        weakSelf.audioPath = mp3Path;
                        [weakSelf switchRecordAndRecordSuccess:YES];
                    });
                } withFailBack:^(NSString * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"最终录音waf格式路径：%@",resultPath);
                        weakSelf.audioPath = resultPath;
                        [weakSelf switchRecordAndRecordSuccess:YES];
                    });
                }];
            }
        }
    }];
}



- (void)switchRecordAndRecordSuccess:(BOOL)isToSuccessView {
    if (isToSuccessView) {
        self.recordSuccessView.audioUrl = self.audioPath;
        self.recordSuccessView.hidden = NO;
        self.recordBtn.hidden = YES;
        self.descLal.hidden = YES;
        self.recordBackView.hidden = YES;
    }else {
        self.recordSuccessView.hidden = YES;
        self.recordBtn.hidden = NO;
        self.descLal.hidden = NO;
        self.recordBackView.hidden = NO;
    }

}


- (void)sy_setView
{
    if (!self.backgroundImage) {}
    if (!self.backButton) {}
    __weak typeof(self) weakSelf = self;
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.font = [UIFont boldSystemFontOfSize:28];
        _titleLbl.text = @"声音瓶";
    }
    if (!_titleLbl.superview) {
        [self.view addSubview:_titleLbl];
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view).with.offset(85);
            make.left.equalTo(weakSelf.view).with.offset(20);
            make.right.equalTo(weakSelf.view).with.offset(-20);
            make.height.mas_equalTo(@50);
        }];
    }

    if (!_cardView) {
        _cardView = [[TABCardView alloc] init];
        _cardView.backgroundColor = [UIColor sy_colorWithHexString:@"FFFFFF"];
        _cardView.delegate = self;
    }
    if (!_cardView.superview) {
        [self.view addSubview:_cardView];
        [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLbl.mas_bottom).with.offset(20);
            make.left.equalTo(weakSelf.view).with.offset(20);
            make.right.equalTo(weakSelf.view).with.offset(-20);
            make.height.mas_equalTo(@280);
        }];
    }


    if (!_descLal) {
        _descLal = [[UILabel alloc] init];
        _descLal.backgroundColor = [UIColor clearColor];
        _descLal.textColor = [UIColor whiteColor];
        _descLal.textAlignment = NSTextAlignmentCenter;
        _descLal.font = [UIFont boldSystemFontOfSize:12];
        _descLal.text = @"请按住录音按钮，贴近手机下方话筒，进行录音";
    }
    if (!_descLal.superview) {
        [self.view addSubview:_descLal];
        __weak typeof(self) weakSelf = self;
        [_descLal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-40);
            make.size.mas_equalTo(CGSizeMake(weakSelf.view.sy_width, 20));
        }];
    }


    if (!_recordBtn) {
        _recordBtn = [[SYRecordVocieButton alloc] init];
        _recordBtn.delegate = self;
    }
    if (!_recordBtn.superview) {
        [self.view addSubview:_recordBtn];
        [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.descLal.mas_top).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        _recordBtn.layer.cornerRadius = 50;
    }

    if (!_recordBackView) {
        _recordBackView = [[UIView alloc] init];
        _recordBackView.backgroundColor = [UIColor clearColor];
    }
    if (!_recordBackView.superview) {
        [self.view insertSubview:_recordBackView belowSubview:weakSelf.recordBtn];
        [_recordBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.recordBtn);
            make.size.mas_equalTo(CGSizeMake(100*2, 100*2));
        }];
        _recordBackView.layer.cornerRadius = 100;
    }

    [self.view addSubview:self.recordSuccessView];
    [self.recordSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-40);
        make.height.mas_equalTo(100);
    }];
}


- (SYRecordSuccessView *)recordSuccessView {
    if (!_recordSuccessView) {
        _recordSuccessView = [SYRecordSuccessView new];//[[SYRecordSuccessView alloc] initWithFrame:CGRectMake(0, self.view.sy_height-100, self.view.sy_height, 100)];
        _recordSuccessView.backgroundColor = [UIColor clearColor];
        _recordSuccessView.hidden = YES;
    }
    return _recordSuccessView;
}

- (UIImageView *)backgroundImage
{
    if (!_backgroundImage) {
        _backgroundImage = [UIImageView new];
        _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImage.image = [UIImage imageNamed_sy:@"mine_background"];
    }
    if (!_backgroundImage.superview) {
        [self.view addSubview:_backgroundImage];
        [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _backgroundImage;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat top = 22.f;
        if (iPhoneX) {
            top += 24;
        }
        _backButton.frame = CGRectMake(14.f, top, 36, 44);
        [_backButton setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"]
                     forState:UIControlStateNormal];
        [_backButton addTarget:self
                        action:@selector(back)
              forControlEvents:UIControlEventTouchUpInside];
    }
    if (!_backButton.superview) {
        [self.view addSubview:_backButton];
    }
    return _backButton;
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma SYRecordVocieButtonDelegate

- (void)sy_continueRecordingWithButton:(nonnull SYRecordVocieButton *)button
{
    NSLog(@"sy_continueRecordingWithButton");
}

- (void)sy_didBeginRecordWithButton:(nonnull SYRecordVocieButton *)button
{
    NSLog(@"sy_didBeginRecordWithButton");
    NSString *audioName = [NSString stringWithFormat:@"uid_%.2f",[[NSDate date] timeIntervalSince1970]];
    [[SYAudioRecordManager shareSYAudioRecordManager] beginRecordWithRecordName:audioName withRecordType:@"waf" withAutoConventToMp3:NO duration:15];
    [self startCircleProgressLayer];
    [self startReplicatorLayer];
}


- (void)sy_didCancelRecordWithButton:(nonnull SYRecordVocieButton *)button
{
    NSLog(@"sy_didCancelRecordWithButton");
    // 结束录音
    [[SYAudioRecordManager shareSYAudioRecordManager] endRecord];
    [self cancelCircleProgressLayer];
    [self cancelReplicatorLayer];
}

- (void)sy_didFinishedRecordWithButton:(nonnull SYRecordVocieButton *)button audioLocalPath:(nonnull NSString *)audioLocalPath
{
    NSLog(@"sy_didFinishedRecordWithButton");
    // 结束录音
    [[SYAudioRecordManager shareSYAudioRecordManager] endRecord];
    [self cancelCircleProgressLayer];
    [self cancelReplicatorLayer];
}

- (void)sy_willCancelRecordWithButton:(nonnull SYRecordVocieButton *)button
{
    NSLog(@"sy_willCancelRecordWithButton");
}


- (void)sy_didRecordingWithButton:(SYRecordVocieButton *)button recordTime:(NSTimeInterval)time duration:(NSTimeInterval)duration
{
    self.recordSuccessView.audioDuration = time;
    NSLog(@"sy_didRecordingWithButton recordTime:%.2f duration: %.2f",time,duration);
}


#pragma mark - 绘制圆形进度条
-(void)createBezierPath:(CGRect)mybound
{
    self.hudu = 0;
    //外圆
    _trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(mybound.size.width/2, mybound.size.height/2)//设置圆心坐标
                                                radius:mybound.size.width/ 2//设置圆的半径
                                            startAngle:0//设置画圆弧度起始角度
                                              endAngle:M_PI * 2//设置画圆弧度结束角度
                                             clockwise:YES];//是否顺时针画圆
    _shapeLayer = [CAShapeLayer new];
    [self.recordBtn.layer addSublayer:_shapeLayer];
    _shapeLayer.fillColor = nil;
    _shapeLayer.strokeColor=[UIColor grayColor].CGColor;
    _shapeLayer.path = _trackPath.CGPath;
    _shapeLayer.lineWidth= 5;
    _shapeLayer.frame = mybound;

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startProgressAction:) userInfo:@{@"rect":NSStringFromCGRect(mybound)} repeats:YES];
}

-(void)startProgressAction:(NSTimer *)timer
{
    CGRect mybound = CGRectFromString([[timer userInfo] objectForKey:@"rect"]);
    //内圆
    if (_progressPath) {
        [_progressPath removeAllPoints];
        _progressPath = nil;
    }
    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(mybound.size.width/2, mybound.size.height/2) radius:mybound.size.width / 2 startAngle:-M_PI_2 endAngle:((M_PI * 2) * self.hudu - M_PI_2) clockwise:YES];
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer new];
        [self.recordBtn.layer addSublayer:_progressLayer];

        _progressLayer.fillColor    = nil;
        _progressLayer.strokeColor  = [UIColor redColor].CGColor;
        _progressLayer.lineCap      = kCALineCapRound;
        _progressLayer.path         = _progressPath.CGPath;
        _progressLayer.lineWidth    = 5;
        _progressLayer.frame        = mybound;
    }else{
        _progressLayer.path         = _progressPath.CGPath;
    }

//    _progressLabel.text         = [NSString stringWithFormat:@"%.2f%@",hudu,@"%"];

    if (self.hudu > 1.000000) {
//        _progressLabel.text = @"100%";
        [_timer invalidate];
        _timer = nil;
        self.hudu = 0;
    }

    double per = 1.000000/150.00;
    
    self.hudu += per;
}


- (void)startCircleProgressLayer
{

    [self createBezierPath:self.recordBtn.bounds];

}


- (void)animate
{
    if (self.shapeLayer) {
        self.shapeLayer.strokeEnd += 0.01;
    }
}



- (void)cancelCircleProgressLayer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }
    if (self.progressLayer) {
        [self.progressLayer removeFromSuperlayer];
        self.progressLayer = nil;
    }
    self.hudu = 0;
//    self.shapeLayer.strokeEnd = 0;
}


- (void)startReplicatorLayer
{
    //中间动画
    CGRect rect = _recordBackView.bounds;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = rect;
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
    shapeLayer.fillColor = [UIColor colorWithRed:198/255.0 green:201/255.0 blue:220/255.0 alpha:1.0].CGColor;//蓝色
    shapeLayer.opacity = 0.0;

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[[self alphaAnimation],[self scaleAnimation]];
    animationGroup.duration = 3.2;
    animationGroup.autoreverses = NO;
    animationGroup.repeatCount = HUGE;
    //页面跳转再返回后，动画是否停止
    animationGroup.removedOnCompletion = NO;

    [shapeLayer addAnimation:animationGroup forKey:@"animationGroup"];

    self.replicatorLayer = [CAReplicatorLayer layer];
    self.replicatorLayer.frame = rect;
    self.replicatorLayer.instanceDelay = 0.8;
    self.replicatorLayer.instanceCount = 4;
    [self.replicatorLayer addSublayer:shapeLayer];
    [self.recordBackView.layer addSublayer:self.replicatorLayer];
}



- (CABasicAnimation *)alphaAnimation
{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @(1.0);
    alpha.toValue = @(0.0);
    return alpha;
}



- (CABasicAnimation *)scaleAnimation
{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 0.0)];
    return scale;
}


- (void)cancelReplicatorLayer
{
    if (self.replicatorLayer) {
        [self.replicatorLayer removeAllAnimations];
        [self.replicatorLayer removeFromSuperlayer];
        self.replicatorLayer = nil;
    }
}


@end
*/
