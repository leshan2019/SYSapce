//
//  SYGiftRenderHandler.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/27.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGiftAnimationView.h"
#import "FXKeyframeAnimation.h"
#import "CALayer+FXAnimationEngine.h"
#import "SYGiftInfoManager.h"
#import <SVGAPlayer/SVGA.h>
#import "NSMutableAttributedString+SYAttrStr.h"
#import "SYImageCutter.h"

//#define SVGA_TEXTNAME  @"banner"
//#define SVGA_DRIVER_IMAGENAME @"avatar"

@interface SYGiftAnimationView () <FXAnimationDelegate,SVGAPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *animationArray;
@property (nonatomic, assign) BOOL isAnimate;
@property (nonatomic, strong) CALayer *baseLayer;
@property (nonatomic, strong) CALayer *animationLayer;

@property (nonatomic, strong) NSTimer *backgroundTimer;
@property (nonatomic, strong) SVGAPlayer *player;
@property (nonatomic, strong) SVGAPlayer *propPlayer;
@property (nonatomic, strong) UIView *propBgView;
@property(nonatomic,strong)  AVAudioPlayer *audioPlayer ;
@end

@implementation SYGiftAnimationView

- (void)dealloc {
    self.player = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)destory {
    [self stopTimer];
    [self stopAnimation];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(enterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        self.player = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, self.frame.size.height*1/5, self.frame.size.width, 200)];
        self.player.loops = 1;
        self.player.delegate = self;
        [self addSubview:self.player];
        
        self.propBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.propBgView.backgroundColor = [UIColor clearColor];
        self.propBgView.hidden = YES;
        [self addSubview:self.propBgView];
        
        self.propPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, self.frame.size.height*2/5, self.frame.size.width, 200)];
        self.propPlayer.loops = 1 ;
        self.propPlayer.delegate = self;
        [self.propBgView addSubview:self.propPlayer];
    }
    return self;
}

- (void)addGiftAnimationWithGiftID:(NSInteger)giftID{
    if (!self.animationArray) {
        self.animationArray = [NSMutableArray new];
    }
    [self.animationArray addObject:@(giftID)];
    [self check];
}

- (void)addGiftAnimationWithAnimationModel:(SYAnimationModel *)model{
    if (!self.animationArray) {
        self.animationArray = [NSMutableArray new];
    }
    
    [self.animationArray addObject:model];
    [self check];
}

- (void)enterBackground:(id)sender {
    [self stopAnimation];
    [self check];
}

- (void)startTimerWithDuration:(NSTimeInterval)duration {
    [self stopTimer];
    self.backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                            target:self
                                                          selector:@selector(timerAction:)
                                                          userInfo:nil
                                                           repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.backgroundTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if (self.backgroundTimer && [self.backgroundTimer isKindOfClass:[NSTimer class]] &&
        [self.backgroundTimer isValid]) {
        [self.backgroundTimer invalidate];
    }
    self.backgroundTimer = nil;
}

- (void)timerAction:(id)sender {
    [self stopTimer];
    self.isAnimate = NO;
    [self check];
}

- (void)stopAnimation {
    self.isAnimate = NO;
    
    [self.animationLayer removeFromSuperlayer];
    self.animationLayer = nil;
    
    [self.baseLayer removeAnimationForKey:@"riseset"];
    [self.baseLayer removeFromSuperlayer];
    self.baseLayer = nil;
    
    [self.player stopAnimation];
    self.player.videoItem = nil;
    
    self.propBgView.hidden = YES;
    [self.propPlayer stopAnimation];
    self.propPlayer.videoItem = nil;
    
    if (self.audioEffectPlayer && [self.audioEffectPlayer respondsToSelector:@selector(voiceRoomAudioPlayAudioStopEffect)]) {
        [self.audioEffectPlayer voiceRoomAudioPlayAudioStopEffect];
    }
    
    if (self.audioPlayer) {
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
   
}

- (void)check {
    if (self.delegate && [self.delegate respondsToSelector:@selector(isAnimationOff)]) {
       BOOL isAnimationOFF = [self.delegate isAnimationOff];
        if (isAnimationOFF) {
            if (self.animationArray.count>0) {
                [self.animationArray removeAllObjects];
            }
            return;
        }
    }

    if (!self.isAnimate) {
        SYAnimationModel *model = [self.animationArray firstObject];
        switch (model.animationType) {
            case SYAnimationType_Driver:
            {
                [self.animationArray removeObjectAtIndex:0];
                [self showAnimationWithDriver:model.user];

            }
                break;
            case SYAnimationType_Gift:
            {
                NSInteger giftID = model.animationId;
                [self.animationArray removeObjectAtIndex:0];
                if (model.isRandomGift) {
                    [self showRandomGift:@(giftID) andGiftIdArray:model.randomGiftArray];
                }else{
                    [self showAnimationWithGiftID:@(giftID) withSender:model.user withReciever:model.recieverUser];
                }
            }
            default:
                break;
        }

    }
}

- (void)showAnimationWithGiftID:(NSNumber *)giftID withSender:(SYVoiceRoomUser *)sender withReciever:(SYVoiceRoomUser *)reciever {
    
    NSString *svgaPath = [[SYGiftInfoManager sharedManager] giftSVGAWithGiftID:[giftID integerValue]];
    if (svgaPath) {
        NSURL *url=[NSURL  fileURLWithPath:svgaPath];
        if ([NSObject sy_empty:url]) {
            return;
        }
        SVGAParser *parser = [[SVGAParser alloc] init];
        __weak typeof(self) weakSelf = self;
        self.isAnimate = YES;
        [parser parseWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            if (videoItem != nil) {
                CGFloat ratio = videoItem.videoSize.width / videoItem.videoSize.height;
                CGFloat height = self.sy_width / ratio;
                CGFloat y = (self.sy_height - height) / 2.f;
                weakSelf.player.frame = CGRectMake(0, y, self.sy_width, height);
                NSTimeInterval duration = videoItem.frames / videoItem.FPS;
                if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
                    [self startTimerWithDuration:duration];
                    return;
                }
                
                if ([NSString sy_isBlankString:sender.icon]) {
                    [weakSelf.player setImage:[UIImage imageNamed_sy:@"letv_chatHome_user"]
                                           forKey:SVGA_GIFT_SENDER];
                }else{
                    [self dowithSVGAImage:sender.icon finishBlock:^(UIImage *img) {
                        [weakSelf.player setImage:img forKey:SVGA_GIFT_SENDER];
                    }];
                }
                
                if ([NSString sy_isBlankString:reciever.icon]) {
                    [weakSelf.player setImage:[UIImage imageNamed_sy:@"letv_chatHome_user"]
                                           forKey:SVGA_GIFT_RECIEVER];
                }else{
                    [self dowithSVGAImage:reciever.icon finishBlock:^(UIImage *img) {
                        [weakSelf.player setImage:img forKey:SVGA_GIFT_RECIEVER];
                    }];
                }
                
                weakSelf.player.videoItem = videoItem;
                [weakSelf.player startAnimation];
                NSString *audioAffectPath = [[SYGiftInfoManager sharedManager] giftAnimationAudioEffectWithGiftID:[giftID integerValue]];
                
//                if (self.audioEffectPlayer && [self.audioEffectPlayer respondsToSelector:@selector(voiceRoomAudioPlayAudioEffectWithFilePath:)]) {
//                    [self.audioEffectPlayer voiceRoomAudioPlayAudioEffectWithFilePath:audioAffectPath];
//                }
                
                [weakSelf playSounds:audioAffectPath];
            } else {
                [weakSelf stopAnimation];
                [weakSelf check];
            }
        } failureBlock:nil];
        return;
    }
    NSArray *images = [[SYGiftInfoManager sharedManager] giftAnimationImagesWithGiftID:[giftID integerValue]];
  
    if ([images count] == 0) {
        [self check];
        return;
    }
    
    float duration = (float)[images count] / 10.f;
    self.isAnimate = YES;
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
        [self startTimerWithDuration:duration];
        return;
    }
    
    if (self.baseLayer) {
        [self.baseLayer removeFromSuperlayer];
    }
    self.baseLayer = [CALayer layer];
    self.baseLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.baseLayer.frame = self.layer.bounds;
    self.baseLayer.opacity = 0.0;
    [self.layer addSublayer:self.baseLayer];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = duration;
    
    CABasicAnimation *riseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    riseAnimation.beginTime = 0;
    riseAnimation.duration = 0.5;
    riseAnimation.fromValue = @(0);
    riseAnimation.toValue = @(0.6);
    riseAnimation.fillMode= kCAFillModeForwards;
    riseAnimation.removedOnCompletion = NO;
    CABasicAnimation *setAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    setAnimation.beginTime = duration - 0.5;
    setAnimation.duration = 0.5;
    setAnimation.fromValue = @(0.6);
    setAnimation.toValue = @(0);
    riseAnimation.fillMode= kCAFillModeForwards;
    setAnimation.removedOnCompletion = NO;
    
    group.animations = @[riseAnimation, setAnimation];
    [self.baseLayer addAnimation:group forKey:@"riseset"];
    
    // 加载动画
    FXKeyframeAnimation *animation = [FXKeyframeAnimation animationWithIdentifier:@"gift"];
    animation.delegate = self;
    animation.frames = images;
    animation.duration = duration;
    animation.repeats = 1;

    CALayer *layer = [CALayer layer];
    UIImage *image0 = [images objectAtIndex:0];
    CGFloat ratio = image0.size.width / image0.size.height;
    CGFloat height = self.sy_width / ratio;
    CGFloat y = (self.sy_height - height) / 2.f;
    layer.frame = CGRectMake(0, y, self.sy_width, height);
    [self.layer addSublayer:layer];
    // decode image asynchronously
    [layer fx_playAnimationAsyncDecodeImage:animation];
    self.animationLayer = layer;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(giftAnimationRenderHandlerStartAnimation)]) {
        [self.delegate giftAnimationRenderHandlerStartAnimation];
    }
    
     NSString *audioAffectPath = [[SYGiftInfoManager sharedManager] giftAnimationAudioEffectWithGiftID:[giftID integerValue]];
    
//    if (self.audioEffectPlayer && [self.audioEffectPlayer respondsToSelector:@selector(voiceRoomAudioPlayAudioEffectWithFilePath:)]) {
//        [self.audioEffectPlayer voiceRoomAudioPlayAudioEffectWithFilePath:audioAffectPath];
//    }
    [self playSounds:audioAffectPath];

}
- (void)showAnimationWithDriver:(SYVoiceRoomUser *)user
{
    NSString *svgaPath = [[SYGiftInfoManager sharedManager] propSVGAWithPropID:user.vehicle];
    if (svgaPath) {
        NSURL *url=[NSURL  fileURLWithPath:svgaPath];
        if ([NSObject sy_empty:url]) {
            return;
        }
        SVGAParser *parser = [[SVGAParser alloc] init];
        __weak typeof(self) weakSelf = self;
        self.isAnimate = YES;
        [parser parseWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            if (videoItem != nil) {
                CGFloat ratio = videoItem.videoSize.width / videoItem.videoSize.height;
                CGFloat height = self.sy_width / ratio;
                CGFloat y = (self.sy_height - height) / 2.f;
                weakSelf.propPlayer.frame = CGRectMake(0, y, self.sy_width, height);
                
                NSTimeInterval duration = videoItem.frames / videoItem.FPS;
                if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
                    [self startTimerWithDuration:duration];
                    return;
                }
                weakSelf.propPlayer.videoItem = videoItem;
                weakSelf.propBgView.hidden = NO;
                NSString *userNameStr = user.username;
                //限制昵称个数，防止字数太多超出的情况
                if (userNameStr.length>MAXLENGTH_OF_DRIVER_USERNAME) {
                  userNameStr = [NSString stringWithFormat:@"%@...",[userNameStr substringToIndex:MAXLENGTH_OF_DRIVER_USERNAME]];
                }
                NSString *textStr = [NSString stringWithFormat:@"%@进入聊天室",userNameStr];
                
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:textStr];
                NSRange range = [textStr rangeOfString:userNameStr?:@""];
                NSRange allRange =  [textStr rangeOfString:textStr?:@""];
                [text addAttribute:NSFontAttributeName
                                      value:[UIFont boldSystemFontOfSize:22.0]
                                      range:allRange];
                [text addAttribute:NSForegroundColorAttributeName
                                      value:[UIColor sam_colorWithHex:@"#ffbc44"]
                                      range:range];
                [text addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]
                             range:[textStr rangeOfString:@"进入聊天室"]];
                
      
                if ([NSString sy_isBlankString:user.icon]) {
                    [weakSelf.propPlayer setImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]
                                           forKey:SVGA_DRIVER_IMAGENAME];
                }else{
                    
                    [self dowithSVGAImage:user.icon finishBlock:^(UIImage *img) {
                        [weakSelf.propPlayer setImage:img forKey:SVGA_DRIVER_IMAGENAME];
                    }];
                }
                
                [weakSelf.propPlayer setAttributedText:text forKey:SVGA_TEXTNAME];
                [weakSelf.propPlayer startAnimation];
            } else {
                [weakSelf stopAnimation];
                [weakSelf check];
            }
        } failureBlock:nil];
        return;
    }
}

- (void)showRandomGift:(NSNumber *)giftID andGiftIdArray:(NSArray *)giftIdArray
{
    NSArray *svgaPathArray = [[SYGiftInfoManager sharedManager] randomGiftSVGAsWithGiftID:[giftID integerValue]];
    
    NSString *svgaPath = @"";
    if (giftIdArray.count >0 && svgaPathArray.count>=giftIdArray.count) {
        svgaPath =  svgaPathArray[giftIdArray.count-1];
    }
    if (![NSString sy_isBlankString:svgaPath]) {
        NSURL *url=[NSURL  fileURLWithPath:svgaPath];
        if ([NSObject sy_empty:url]) {
            return;
        }
        SVGAParser *parser = [[SVGAParser alloc] init];
        __weak typeof(self) weakSelf = self;
        self.isAnimate = YES;
        [parser parseWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            if (videoItem != nil) {
                weakSelf.player.videoItem = videoItem;
                for (int i = 0; i < [giftIdArray count]; i++) {
                    NSString *key = (i==0) ? @"gift":[NSString stringWithFormat:@"gift%d",i+1];
                    NSInteger giftId = [giftIdArray[i] integerValue];
                    SYGiftModel *model = [[SYGiftInfoManager sharedManager]giftWithGiftID:giftId];
                    [weakSelf.player setImageWithURL:[NSURL URLWithString:model.icon] forKey:key];
                    
                }
                [weakSelf.player startAnimation];
            }
        } failureBlock:nil];
    }
}

#pragma mark -

- (void)fxAnimationDidStart:(FXAnimation *)anim {
}

- (void)fxAnimationDidStop:(FXAnimation *)anim finished:(BOOL)finished {
    [self stopAnimation];
    
//    if ([self.delegate respondsToSelector:@selector(giftAnimationRenderHandlerDidEndAnimation)]) {
//        [self.delegate giftAnimationRenderHandlerDidEndAnimation];
//    }
    [self check];
}

#pragma mark - SVGAPlayerDelegate
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player
{
    [self stopAnimation];
    [self check];
}


- (void)playSounds:(NSString *)filePath{
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isExist)
    {
        return;
    }
    NSURL *urlFile = [NSURL fileURLWithPath:filePath];
    NSError *error;
    @try {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlFile error:&error];
    }@catch(id anException){
    }
    if (self.audioPlayer) {
        self.audioPlayer.numberOfLoops = 1;
        self.audioPlayer.enableRate = NO; // 设置为 YES 可以控制播放速率
        self.audioPlayer.volume = 0.7;
        if ([self.audioPlayer prepareToPlay])
        {
            // 播放时，设置喇叭播放否则音量很小
//            AVAudioSession *playSession = [AVAudioSession sharedInstance];
//            [playSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//            [playSession setActive:YES error:nil];
            [self.audioPlayer play];
        }
      
    }else {
        NSLog(@"创建播放器出错 error: %@",[error localizedDescription]);
    }
}

- (void)dowithSVGAImage:(NSString *)imageUrlString finishBlock:(void(^)(UIImage *))finishBlock
{
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageUrlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data != nil) {
            UIImage *image = [UIImage imageWithData:data];
            if (image != nil) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UIImage *circleImg = [SYImageCutter convertToCircleWithImage:image onWidth:0.f onColor:[UIColor clearColor]];
                    finishBlock(circleImg);
                }];
            }
        }
    }] resume];
}

@end
