//
//  SYVoiceRoomMessageFloatView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomMessageFloatView.h"
#import "SYVoiceRoomDanmaku.h"
#import "SYOverScreenStripView.h"

#define kFloatViewDanmakuDuration 9

@interface SYVoiceRoomMessageFloatView () <SYOverScreenStripViewDelegate, CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *msgArray;
@property (nonatomic, assign) BOOL isAnimate;
@property (nonatomic, strong) SYVoiceRoomDanmaku *danmaku;
@property (nonatomic, strong) SYOverScreenStripView *overScreenView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SYVoiceRoomMessageFloatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _msgArray = [NSMutableArray new];
        _isAnimate = NO;
        [self addSubview:self.danmaku];
        [self addSubview:self.overScreenView];
    }
    return self;
}

- (void)destory {
    [self stopTimer];
    [self stopAnimation];
}

- (void)addMessage:(SYVoiceTextMessageViewModel *)msgViewModel {
    if (!msgViewModel || ((NSInteger)msgViewModel.messageType <= 10 && (![msgViewModel.from isEqualToString:@"OverScreen"] && ![msgViewModel.from isEqualToString:@"OverScreenInternal"] && ![msgViewModel.from isEqualToString:@"OverScreenGameWin"] && ![msgViewModel.from isEqualToString:@"OverScreenBeeGameWin"]))) {
        return;
    }
    [self.msgArray addObject:msgViewModel];
    [self check];
}

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kFloatViewDanmakuDuration
                                                  target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                 repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if ([self.timer isKindOfClass:[NSTimer class]] &&
        [self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)timerAction:(id)sender {
    [self stopTimer];
    [self stopAnimation];
}

- (void)check {
    if (self.isAnimate) {
        return;
    }
    
    SYVoiceTextMessageViewModel *model = [self.msgArray firstObject];
    if (model) {
        [self.msgArray removeObject:model];
        [self animateMessage:model];
    }
}

- (void)animateMessage:(SYVoiceTextMessageViewModel *)model {
    self.isAnimate = YES;
    if (model.messageType == SYVoiceTextMessageTypeGift) {
        SYOverScreenStripViewType type = SYOverScreenStripViewTypeAllRooms;
        if ([model.from isEqualToString:@"OverScreenInternal"]) {
            type = SYOverScreenStripViewTypeInteral;
        } else if ([model.from isEqualToString:@"OverScreen"]) {
            type = SYOverScreenStripViewTypeAllRooms;
        } else if ([model.from isEqualToString:@"OverScreenGameWin"]) {
            type = SYOverScreenStripViewTypeGameWin;
        } else if ([model.from isEqualToString:@"OverScreenBeeGameWin"]) {
            type = SYOverScreenStripViewTypeBeeGameWin;
        } else if ([model.from isEqualToString:@"OverScreenSendGroupRedPacket"]) {
            type = SYOverScreenStripViewTypeSendGroupRedpacket;
        } else {
            [self stopAnimation];
            return;
        }
        [self.overScreenView showWithGiftImageURL:model.giftURL
                                         giftName:model.giftName
                                           sender:model.username receiver:model.receiverUsername
                                            price:model.giftPrice
                                           roomId:model.channel
                                         gameName:model.gameName
                                             type:type];
    } else if (model.messageType == SYVoiceTextMessageTypeSendRedpacket) {
        if ([model.from isEqualToString:@"OverScreenSendGroupRedPacket"]) {
            [self.overScreenView showWithGiftImageURL:@""
            giftName:@""
              sender:model.username receiver:@""
               price:0
              roomId:model.channel
            gameName:@""
                type:SYOverScreenStripViewTypeSendGroupRedpacket];
        } else {
            [self stopAnimation];
            return;
        }
    } else {
        SYVoiceRoomDanmakuType type = [self danmakuTypeWithMessageType:model.messageType];
        if (type == SYVoiceRoomDanmakuTypeUnknown) {
            [self stopAnimation];
            return;
        }
        if ([[self superview] superview] == nil ||
            [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
            // 浮球状态
            [self startTimer];
            return;
        }
        [self.danmaku showWithAvatarURL:model.avatarURL
                                message:model.message
                                   type:type];
        [UIView animateWithDuration:kFloatViewDanmakuDuration
                         animations:^{
                             self.danmaku.sy_right = 0.f;
                         } completion:^(BOOL finished) {
                             self.danmaku.sy_left = self.sy_width;
                             [self stopAnimation];
                         }];
//        CABasicAnimation *inAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
//        inAnimation.beginTime = 0;
//        inAnimation.duration = kFloatViewDanmakuDuration;
//        inAnimation.toValue = @(-self.danmaku.sy_width / 2.f);
//        inAnimation.delegate = self;
//        [self.danmaku.layer addAnimation:inAnimation forKey:@"float"];
//        inAnimation.fillMode = kCAFillModeForwards;
//        inAnimation.removedOnCompletion = NO;
    }
}

- (SYVoiceRoomDanmaku *)danmaku {
    if (!_danmaku) {
        _danmaku = [[SYVoiceRoomDanmaku alloc] initWithFrame:CGRectMake(self.sy_width, 2.f + 16.f, 154.f, 24.f)];
    }
    return _danmaku;
}

- (SYOverScreenStripView *)overScreenView {
    if (!_overScreenView) {
        _overScreenView = [[SYOverScreenStripView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, 30)];
        _overScreenView.delegate = self;
    }
    return _overScreenView;
}

- (SYVoiceRoomDanmakuType)danmakuTypeWithMessageType:(SYVoiceTextMessageType)messageType {
    SYVoiceRoomDanmakuType type = SYVoiceRoomDanmakuTypeUnknown;
    switch (messageType) {
        case SYVoiceTextMessageTypeSuperDanmaku:
        {
            type = SYVoiceRoomDanmakuTypeMidLevel;
        }
            break;
        case SYVoiceTextMessageTypeVipDanmaku:
        {
            type = SYVoiceRoomDanmakuTypeHighLevel;
        }
            break;
        case SYVoiceTextMessageTypeDanmaku:
        {
            type = SYVoiceRoomDanmakuTypeDefault;
        }
            break;
        default:
            break;
    }
    return type;
}

#pragma mark -

- (void)stopAnimation {
    self.isAnimate = NO;
    [self check];
}

#pragma mark -

- (void)overScreenStripViewAnimationDidFinish {
    [self stopAnimation];
}

- (void)overScreenStripViewOpenChatRoomWithRoomId:(NSString *)roomId {
    if ([self.delegate respondsToSelector:@selector(voiceRoomMessageFloatViewOpenRoomWithRoomId:)]) {
        [self.delegate voiceRoomMessageFloatViewOpenRoomWithRoomId:roomId];
    }
}

@end
