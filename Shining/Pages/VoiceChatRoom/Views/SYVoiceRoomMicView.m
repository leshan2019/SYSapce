//
//  SYVoiceRoomMicView.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomMicView.h"
#import "SYVoiceChatUserViewModel.h"
#import "RippleAnimationView.h"
#import "SYVoiceRoomMicAnimationModel.h"

@interface SYVoiceRoomMicView () <CAAnimationDelegate>

@property (nonatomic, assign) NSInteger position;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *avatarBox;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *muteIndicator;
@property (nonatomic, assign) BOOL isOccupied;
@property (nonatomic, assign) SYVoiceRoomMicViewStyle style;
@property (nonatomic, strong) RippleAnimationView *waveView;
@property (nonatomic, strong) UIImageView *hostIndicator; // 主持人标志
@property (nonatomic, strong) UIImageView *gameImageView;
// pk
@property (nonatomic, strong) UIImageView *pkImageView;
@property (nonatomic, strong) UILabel *pkLabel;
@property (nonatomic, strong) UIImageView *pkCrownView;

@property (nonatomic, strong) UIView *giftAnimationBackView;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, assign) BOOL isGiftAnimating;
@property (nonatomic, assign) BOOL isGameAnimating;
@property (nonatomic, strong) NSMutableArray *giftImageArray;
@property (nonatomic, strong) NSMutableArray *animationModelArray;

@end

@implementation SYVoiceRoomMicView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(SYVoiceRoomMicViewStyle)style
                     position:(NSInteger)position {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        _isOccupied = NO;
        _position = position;
        _style = style;
        _isGiftAnimating = NO;
        _isGameAnimating = NO;
        _giftImageArray = [NSMutableArray new];
        _animationModelArray = [NSMutableArray new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.avatarView];
        [self addSubview:self.avatarBox];
        [self addSubview:self.muteIndicator];
        [self.avatarView addSubview:self.gameImageView];
        [self.avatarView addSubview:self.giftAnimationBackView];
        [self addSubview:self.giftImageView];
        [self addSubview:self.nameLabel];
        
        if (style == SYVoiceRoomMicViewStyleHost ||
            style == SYVoiceRoomMicViewStyleSingleHost) {
            [self addSubview:self.hostIndicator];
        }
        
        [self addSubview:self.pkImageView];
        [self addSubview:self.pkLabel];
        [self addSubview:self.pkCrownView];
    }
    return self;
}

- (void)tap:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceRoomMicViewDidSelectMic:atIndex:)]) {
        [self.delegate voiceRoomMicViewDidSelectMic:self
                                            atIndex:self.position];
    }
}

- (void)drawWithUserViewModel:(SYVoiceChatUserViewModel *)userViewModel {
    if (_hostIndicator) {
        _hostIndicator.hidden = YES;
    }
    self.nameLabel.textColor = userViewModel.bossMic ? [UIColor sam_colorWithHex:@"#FFB94B"] : [UIColor whiteColor];
    [self handlePKWithUser:userViewModel];
    if (userViewModel.uid) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:userViewModel.avatarURL]
                           placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
        [self.avatarBox sd_setImageWithURL:[NSURL URLWithString:userViewModel.avatarBox]];
        self.nameLabel.text = userViewModel.name;
        self.avatarView.layer.borderWidth = 1.f;
//        self.avatarView.layer.borderColor = [[UIColor sam_colorWithHex:@"#7B40FF"] CGColor];
        if (self.style != SYVoiceRoomMicViewStyleSingleHost) {
            CGFloat maxWidth = self.sy_width;
            if (self.style == SYVoiceRoomMicViewStyleHost) {
//                maxWidth += 40.f;
            }
            else if (self.style == SYVoiceRoomMicViewStyleOrdinary) {
                if (iPhone5 == NO) {
                    maxWidth += 10.f;
                }
            }
            CGRect rect = [self.nameLabel.text boundingRectWithSize:CGSizeMake(maxWidth, self.nameLabel.sy_height)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName: self.nameLabel.font}
                                                            context:nil];
            CGSize size = CGSizeMake(MAX(rect.size.width, 36.f), self.nameLabel.sy_height);
            self.nameLabel.sy_size = size;
            self.nameLabel.sy_left = (self.sy_width - size.width) / 2.f;
            if (self.style == SYVoiceRoomMicViewStyleHost) {
                self.hostIndicator.hidden = NO;
                self.hostIndicator.sy_left = self.nameLabel.sy_left - 38.f;
            }
        } else {
            self.hostIndicator.hidden = NO;
        }
    } else {
        NSString *name = (self.position == 0) ? @"主持人" : [NSString stringWithFormat:@"%ld号麦", self.position];
        if (userViewModel.bossMic) {
            name = @"点击上麦";
        }
        self.nameLabel.text = name;
        if (self.style != SYVoiceRoomMicViewStyleSingleHost) {
            self.nameLabel.sy_width = 50;
            self.nameLabel.sy_left = (self.sy_width - self.nameLabel.sy_width) / 2.f;
        }
        if (userViewModel.bossMic) {
            self.avatarView.image = [UIImage imageNamed_sy:@"voiceroom_mic_gold"];
        } else {
            self.avatarView.image = [UIImage imageNamed_sy:@"voiceroom_mic"];
        }
        self.avatarView.layer.borderWidth = 0.f;
        self.avatarBox.image = nil;
    }
    [self changeMuteState:userViewModel.isMuted];
    _isOccupied = (userViewModel.uid);
}

- (void)handlePKWithUser:(SYVoiceChatUserViewModel *)userViewModel {
    self.pkImageView.hidden = !(userViewModel.beanString && userViewModel.uid);
    self.pkLabel.hidden = !(userViewModel.beanString && userViewModel.uid);
    self.pkCrownView.hidden = !(userViewModel.beanString && userViewModel.uid);
    if (userViewModel.beanString) {
        CGRect rect = [userViewModel.beanString boundingRectWithSize:CGSizeMake(999, self.pkLabel.sy_height) options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName: self.pkLabel.font}
                                                             context:nil];
        self.pkLabel.sy_width = rect.size.width;
        self.pkLabel.text = userViewModel.beanString;
        self.pkCrownView.hidden = !(userViewModel.isMaxPKBeans || userViewModel.isMinPKBeans);
        if(userViewModel.isMinPKBeans){
            self.pkCrownView.image = [UIImage imageNamed_sy:@"voiceroom_pk_bomb"];
        }
        if (userViewModel.isMaxPKBeans) {
            self.pkCrownView.image = [UIImage imageNamed_sy:@"voiceroom_pk_crown"];
        }
        
        if (self.style == SYVoiceRoomMicViewStyleSingleHost) {
            
        } else {
            CGFloat width = self.pkImageView.sy_width + 2.f + self.pkLabel.sy_width;
            CGFloat x = (self.sy_width - width) / 2.f;
            self.pkImageView.sy_left = x;
            self.pkLabel.sy_left = self.pkImageView.sy_right + 2.f;
        }
    }
}

- (void)changeMuteState:(BOOL)isMuted {
    self.muteIndicator.hidden = !isMuted;
    if (isMuted) {
        [self removeSpeakerAudioWave];
    }
}

- (void)drawSpeakerAudioWave {
//    [self removeSpeakerAudioWave];
    if (self.isOccupied && self.waveView.superview == nil) {
        self.waveView = [[RippleAnimationView alloc] initWithFrame:self.avatarView.frame
                                                     animationType:AnimationTypeWithBackground];
        [self addSubview:self.waveView];
        [self sendSubviewToBack:self.waveView];
    }
}

- (void)removeSpeakerAudioWave {
    if (self.waveView) {
        [self.waveView removeFromSuperview];
        self.waveView = nil;
    }
}

- (void)showGameImages:(NSArray *)images repeatTime:(NSInteger)repeat result:(NSString *)result {
    if ([images count] <= 0) {
        return;
    }
    SYVoiceRoomMicAnimationModel *model = [SYVoiceRoomMicAnimationModel new];
    model.type = SYVoiceRoomMicAnimationTypeGame;
    model.images = images;
    model.repeat = repeat;
    model.result = result;
    
    [self.animationModelArray addObject:model];
    [self checkGameAnimation];
}

- (void)showExpressionImages:(NSArray <UIImage *>*)images {
    if ([images count] <= 0) {
        return;
    }
    SYVoiceRoomMicAnimationModel *model = [SYVoiceRoomMicAnimationModel new];
    model.type = SYVoiceRoomMicAnimationTypeExpression;
    model.images = images;
    model.repeat = 1;
    
    [self.animationModelArray addObject:model];
    [self checkGameAnimation];
}

- (void)showGiftAnimationWithImageUrl:(NSString *)url {
    if ([NSString sy_isBlankString:url]) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url]
                                                          options:0
                                                         progress:nil
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                if (image) {
                                                                    [weakSelf.giftImageArray addObject:image];
                                                                    [weakSelf check];
                                                                }
                                                            });
                                                        }];
}

- (void)checkGameAnimation {
    if (self.isGameAnimating) {
        return;
    }
    SYVoiceRoomMicAnimationModel *model = [self.animationModelArray firstObject];
    if (model) {
        [self.animationModelArray removeObject:model];
        [self gameAnimationWithAnimationModel:model];
    }
}

- (void)check {
    if (self.isGiftAnimating) {
        return;
    }
    UIImage *image = [self.giftImageArray firstObject];
    if (image) {
        [self.giftImageArray removeObject:image];
        [self animateGiftWithImage:image];
    }
}

- (void)animateGiftWithImage:(UIImage *)image {
    self.isGiftAnimating = YES;
//    [self.giftImageView.layer removeAllAnimations];
    self.giftImageView.image = image;
//    [self.giftAnimationBackView.layer removeAllAnimations];
//    self.giftAnimationBackView.alpha = 0;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = 1.3;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.beginTime = 0.f;
    animation1.duration = 0.2;
    animation1.fromValue = @(0.5);
    animation1.toValue = @(1.6);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.beginTime = 0.f;
    animation2.duration = 0.2;
    animation2.fromValue = @(0.5);
    animation2.toValue = @(1);
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation3.beginTime = 0.2f;
    animation3.duration = 0.1;
    animation3.fromValue = @(1.6);
    animation3.toValue = @(1.5);
    animation3.fillMode= kCAFillModeForwards;
    animation3.removedOnCompletion = NO;
    
    CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation4.beginTime = 0.3f;
    animation4.duration = 0.3;
    animation4.toValue = @(-14.f / 180.f * M_PI);
    
    CABasicAnimation *animation5 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation5.beginTime = 0.6f;
    animation5.duration = 0.4;
    animation5.fromValue = @(-14.f / 180.f * M_PI);
    animation5.toValue = @(14.f / 180.f * M_PI);
    
    CABasicAnimation *animation6 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation6.beginTime = 1.0f;
    animation6.duration = 0.3;
    animation6.fromValue = @(14.f / 180.f * M_PI);
    animation6.toValue = @(0);
    
    group.animations = @[animation1, animation2, animation3, animation4, animation5, animation6];
    [self.giftImageView.layer addAnimation:group forKey:@"gift"];
    
    CAAnimationGroup *backGroup = [CAAnimationGroup animation];
    backGroup.duration = 1.3;
    
    CABasicAnimation *animation7 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation7.beginTime = 0.f;
    animation7.duration = 0.2;
    animation7.fromValue = @(0);
    animation7.toValue = @(0.6);
    animation7.fillMode= kCAFillModeForwards;
    animation7.removedOnCompletion = NO;
    
    CABasicAnimation *animation8 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation8.beginTime = 1.1;
    animation8.duration = 0.2;
    animation8.fromValue = @(0.6);
    animation8.toValue = @(0);
    animation8.fillMode= kCAFillModeForwards;
    animation8.removedOnCompletion = NO;
    
    backGroup.animations = @[animation7, animation8];
    [self.giftAnimationBackView.layer addAnimation:backGroup forKey:@"back"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.giftImageView.image = nil;
    self.giftAnimationBackView.alpha = 0;
    self.isGiftAnimating = NO;
    [self check];
}

- (void)gameAnimationWithAnimationModel:(SYVoiceRoomMicAnimationModel *)model {
    if (!model) {
        return;
    }
    self.isGameAnimating = YES;
    if (model.type == SYVoiceRoomMicAnimationTypeGame) {
        self.gameImageView.animationImages = model.images;
        self.gameImageView.animationDuration = 2.f / (float)model.repeat;
        self.gameImageView.animationRepeatCount = model.repeat;
        [self.gameImageView startAnimating];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.gameImageView stopAnimating];
            self.gameImageView.image = [UIImage imageNamed_sy:model.result];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.gameImageView.image = nil;
                self.isGameAnimating = NO;
                [self checkGameAnimation];
            });
        });
    } else {
        self.gameImageView.animationImages = model.images;
        self.gameImageView.animationDuration = [model.images count] / 24.f;
        self.gameImageView.animationRepeatCount = model.repeat;
        [self.gameImageView startAnimating];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.gameImageView stopAnimating];
            self.gameImageView.image = nil;
            self.isGameAnimating = NO;
            [self checkGameAnimation];
        });
    }
}

#pragma mark - UI

- (UIImageView *)hostIndicator {
    if (!_hostIndicator) {
        CGFloat x = 0;
        CGFloat y = self.avatarView.sy_height + 4.f;
        if (self.style == SYVoiceRoomMicViewStyleSingleHost) {
            x = self.avatarView.sy_right + 20.f;
            y = self.nameLabel.sy_bottom + 6.f;
        }
        _hostIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 32, 14)];
        _hostIndicator.image = [UIImage imageNamed_sy:@"voiceroom_host"];
        _hostIndicator.hidden = YES;
    }
    return _hostIndicator;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        CGFloat width = (self.style != SYVoiceRoomMicViewStyleSingleHost) ? 54.f : 64.f;
        CGFloat x = (self.sy_width - width) / 2.f;
        CGFloat y = 0.f;
        if (self.style == SYVoiceRoomMicViewStyleSingleHost) {
            x = 10.f;
            y = 10.f;
        }
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        _avatarView.layer.cornerRadius = width / 2.f;
        _avatarView.clipsToBounds = YES;
        _avatarView.layer.borderWidth = 1.f;
        _avatarView.layer.borderColor = [[[UIColor sam_colorWithHex:@"#FBC9FF"] colorWithAlphaComponent:0.74] CGColor];
    }
    return _avatarView;
}

- (UIImageView *)avatarBox {
    if (!_avatarBox) {
        CGFloat width = (self.style != SYVoiceRoomMicViewStyleSingleHost) ? 74.f : 86.f;
        _avatarBox = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        _avatarBox.center = self.avatarView.center;
    }
    return _avatarBox;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGFloat x = 0.f;
        CGFloat width = self.bounds.size.width;
        CGFloat y = _avatarView.bounds.size.height + 4.f;
        NSTextAlignment alignment = NSTextAlignmentCenter;
        CGFloat height = 14.f;
        if (self.style == SYVoiceRoomMicViewStyleSingleHost) {
            x = self.avatarView.sy_right + 20.f;
            width = self.sy_width - x;
            y = 20.f;
            alignment = NSTextAlignmentLeft;
            height = 20.f;
        }
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _nameLabel.textAlignment = alignment;
        _nameLabel.textColor = [UIColor whiteColor];
        if (self.style != SYVoiceRoomMicViewStyleSingleHost) {
            _nameLabel.font = [UIFont systemFontOfSize:10.f weight:UIFontWeightMedium];
        } else {
            _nameLabel.font = [UIFont systemFontOfSize:15.f];
        }
    }
    return _nameLabel;
}

- (UIImageView *)muteIndicator {
    if (!_muteIndicator) {
        CGFloat width = 20.f;
        CGFloat x = self.avatarView.sy_right - width;
        CGFloat y = self.avatarView.sy_bottom - width;
        _muteIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
        _muteIndicator.image = [UIImage imageNamed_sy:@"voiceroom_mic_close"];
    }
    return _muteIndicator;
}

- (UIImageView *)gameImageView {
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _gameImageView.center = CGPointMake(self.avatarView.sy_width / 2.f, self.avatarView.sy_height / 2.f);
//        _gameImageView.alpha = 0;
    }
    return _gameImageView;
}

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
        _giftImageView.center = self.avatarView.center;
    }
    return _giftImageView;
}

- (UIView *)giftAnimationBackView {
    if (!_giftAnimationBackView) {
        _giftAnimationBackView = [[UIView alloc] initWithFrame:self.avatarView.bounds];
        _giftAnimationBackView.layer.cornerRadius = _giftAnimationBackView.sy_height / 2.f;
        _giftAnimationBackView.backgroundColor = [UIColor blackColor];
        _giftAnimationBackView.alpha = 0;
    }
    return _giftAnimationBackView;
}

- (UIImageView *)pkImageView {
    if (!_pkImageView) {
        _pkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.nameLabel.sy_bottom + 3.f, 8.f, 7.f)];
        _pkImageView.image = [UIImage imageNamed_sy:@"voiceroom_pk_result"];
        if (self.style == SYVoiceRoomMicViewStyleSingleHost) {
            _pkImageView.sy_left = self.hostIndicator.sy_left;
            _pkImageView.sy_top = self.hostIndicator.sy_bottom + 10.f;
        }
    }
    return _pkImageView;
}

- (UILabel *)pkLabel {
    if (!_pkLabel) {
        _pkLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.pkImageView.sy_right + 2.f, self.pkImageView.sy_top, 0, 8)];
        _pkLabel.textColor = [UIColor whiteColor];
        _pkLabel.font = [UIFont systemFontOfSize:8.f];
    }
    return _pkLabel;
}

- (UIImageView *)pkCrownView {
    if (!_pkCrownView) {
        _pkCrownView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17.f, 18.f)];
        _pkCrownView.center = self.avatarView.sy_origin;
        _pkCrownView.image = [UIImage imageNamed_sy:@"voiceroom_pk_crown"];
    }
    return _pkCrownView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
