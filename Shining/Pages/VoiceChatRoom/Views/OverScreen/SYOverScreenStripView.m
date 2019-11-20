//
//  SYOverScreenStripView.m
//  Shining
//
//  Created by mengxiangjian on 2019/5/8.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYOverScreenStripView.h"

@interface SYOverScreenStripView () <CAAnimationDelegate>

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAGradientLayer *backGradientLayer;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *giftView;
@property (nonatomic, strong) UILabel *label;
//@property (nonatomic, strong) UILabel *openLabel;
@property (nonatomic, strong) NSString *roomId;

@end

@implementation SYOverScreenStripView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.backGradientLayer];
        [self.layer addSublayer:self.gradientLayer];
        [self addSubview:self.giftView];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.label];
//        [self.containerView addSubview:self.openLabel];
        self.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(overScreenStripViewOpenChatRoomWithRoomId:)]) {
        [self.delegate overScreenStripViewOpenChatRoomWithRoomId:self.roomId];
    }
}

- (void)showWithGiftImageURL:(NSString *)imageURL
                    giftName:(NSString *)giftName
                      sender:(NSString *)sender
                    receiver:(NSString *)receiver
                       price:(NSInteger)price
                      roomId:(NSString *)roomId
                    gameName:(NSString *)gameName
                        type:(SYOverScreenStripViewType)type {
    self.hidden = NO;
    self.roomId = roomId;
    if (type == SYOverScreenStripViewTypeAllRooms ||
        type == SYOverScreenStripViewTypeInteral) {
        self.giftView.sy_size = CGSizeMake(56, 40);
        [self.giftView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        NSString *message = [NSString stringWithFormat:@"%@送给%@ %@", sender, receiver, giftName];
        NSString *openText = @"，点击进入房间围观哦～";
        if (type == SYOverScreenStripViewTypeInteral) {
            openText = @"，感谢捧场哟～";
        }
        message = [message stringByAppendingString:openText];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor sam_colorWithHex:@"#FFFC63"]
                       range:[message rangeOfString:sender?:@""]];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor sam_colorWithHex:@"#FFFC63"]
                       range:[message rangeOfString:receiver?:@""]];
        self.label.attributedText = string;

        //    CGFloat maxWidth = self.containerView.sy_width - 40 * 2 - self.giftView.sy_width;
        CGFloat maxWidth = 9999;
        CGRect rect = [message boundingRectWithSize:CGSizeMake(maxWidth, self.label.sy_height)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: self.label.font}
                                            context:nil];
        self.label.sy_width = rect.size.width;
        self.label.sy_left = self.containerView.sy_width;
        
    } else if (type == SYOverScreenStripViewTypeGameWin){
        self.giftView.sy_size = CGSizeMake(56, 40);
        self.giftView.image = [UIImage imageNamed_sy:@"voiceroom_float_egg"];
        NSString *message = [NSString stringWithFormat:@"恭喜%@在%@开出价值%ld蜜豆的礼物！进入房间沾喜气喽～", sender, gameName, (long)price];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor sam_colorWithHex:@"#FFFC63"]
                       range:[message rangeOfString:sender?:@""]];
        self.label.attributedText = string;
        CGFloat maxWidth = 9999;
        CGRect rect = [message boundingRectWithSize:CGSizeMake(maxWidth, self.label.sy_height)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: self.label.font}
                                            context:nil];
        self.label.sy_width = rect.size.width;
        self.label.sy_left = self.containerView.sy_width;
    } else if (type == SYOverScreenStripViewTypeBeeGameWin){
        self.giftView.sy_size = CGSizeMake(40, 40);
        self.giftView.image = [UIImage imageNamed_sy:@"voiceroom_float_bee"];
        NSString *message = [NSString stringWithFormat:@"恭喜%@在%@中得到%@~运气不错哦~", sender, gameName, giftName];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor sam_colorWithHex:@"#FFFC63"]
                       range:[message rangeOfString:sender?:@""]];
        self.label.attributedText = string;
        CGFloat maxWidth = 9999;
        CGRect rect = [message boundingRectWithSize:CGSizeMake(maxWidth, self.label.sy_height)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: self.label.font}
                                            context:nil];
        self.label.sy_width = rect.size.width;
        self.label.sy_left = self.containerView.sy_width;
    } else if (type == SYOverScreenStripViewTypeSendGroupRedpacket) {
        self.giftView.sy_size = CGSizeMake(56, 41);
        self.giftView.image = [UIImage imageNamed_sy:@"voiceroom_redPacket_floating"];
        NSString *message = [NSString stringWithFormat:@"%@发送了大红包哦~快来抢咯~",sender];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:message];
        [string addAttribute:NSForegroundColorAttributeName
                       value:[UIColor sam_colorWithHex:@"#FFFC63"]
                       range:[message rangeOfString:sender?:@""]];
        self.label.attributedText = string;
        CGFloat maxWidth = 9999;
        CGRect rect = [message boundingRectWithSize:CGSizeMake(maxWidth, self.label.sy_height)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName: self.label.font}
                                            context:nil];
        self.label.sy_width = rect.size.width;
        self.label.sy_left = self.containerView.sy_width;
    }
    
    CGFloat totalDuration = 0;
    CABasicAnimation *inAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    inAnimation.beginTime = 0;
    inAnimation.duration = 0.5;
    inAnimation.toValue = @(self.label.sy_width / 2.f);
    inAnimation.fillMode = kCAFillModeForwards;
    inAnimation.removedOnCompletion = NO;
    
    totalDuration += 5.5f;
    
    CABasicAnimation *moveAnimation = nil;
    if (self.label.sy_width > self.containerView.sy_width) {
        CGFloat remain = self.label.sy_width - self.containerView.sy_width;
        CGFloat velocity = 50.f;
        CGFloat duration = remain / velocity;
        moveAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        moveAnimation.beginTime = totalDuration;
        moveAnimation.duration = duration;
        moveAnimation.toValue = @(self.label.sy_width / 2.f - remain);
        moveAnimation.fillMode = kCAFillModeForwards;
        moveAnimation.removedOnCompletion = NO;
        totalDuration += duration;
    }
    totalDuration += 5.f;
    
    CABasicAnimation *outAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    outAnimation.beginTime = totalDuration;
    outAnimation.duration = 0.5;
    outAnimation.toValue = @(- self.label.sy_width / 2.f);
    outAnimation.fillMode = kCAFillModeForwards;
    outAnimation.removedOnCompletion = NO;
    
    totalDuration += 0.5;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = totalDuration;
    group.delegate = self;
    if (moveAnimation) {
        group.animations = @[inAnimation, moveAnimation, outAnimation];
    } else {
        group.animations = @[inAnimation, outAnimation];
    }
    
    [self.label.layer addAnimation:group
                            forKey:@"anim"];
}

- (CAGradientLayer *)backGradientLayer {
    if (!_backGradientLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(30.f, 0, self.sy_width - 45.f, self.sy_height);
        layer.colors = @[(__bridge id)[UIColor sam_colorWithHex:@"#FFE6AE"].CGColor,
                         (__bridge id)[UIColor sam_colorWithHex:@"#FFC454"].CGColor];
        layer.startPoint = CGPointMake(0, 0.5);
        layer.endPoint = CGPointMake(1, 0.5);
        layer.cornerRadius = self.sy_height / 2.f;
        _backGradientLayer = layer;
    }
    return _backGradientLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = CGRectMake(31.f, 1.f, self.sy_width - 47.f, self.sy_height - 2.f);
        layer.colors = @[(__bridge id)[UIColor sam_colorWithHex:@"#FF51AD"].CGColor,
                         (__bridge id)[UIColor sam_colorWithHex:@"#7138EF"].CGColor];
        layer.startPoint = CGPointMake(0, 0.5);
        layer.endPoint = CGPointMake(1, 0.5);
        layer.cornerRadius = (self.sy_height - 2.f) / 2.f;
        _gradientLayer = layer;
    }
    return _gradientLayer;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(77, 0, self.sy_width - 107, self.sy_height)];
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

- (UIImageView *)giftView {
    if (!_giftView) {
        CGFloat height = 40.f;
        CGFloat width = 56.f;
        _giftView = [[UIImageView alloc] initWithFrame:CGRectMake(16.f, - 3.f, width, height)];
    }
    return _giftView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(self.containerView.sy_width, 0, 0, self.containerView.sy_height)];
        _label.font = [UIFont systemFontOfSize:13.f];
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

//- (UILabel *)openLabel {
//    if (!_openLabel) {
//        _openLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.label.sy_top, 0, self.label.sy_height)];
//        _openLabel.font = [UIFont systemFontOfSize:11.f];
//        _openLabel.textColor = [UIColor whiteColor];
//    }
//    return _openLabel;
//}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.label.sy_left = self.containerView.sy_width;
    self.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(overScreenStripViewAnimationDidFinish)]) {
        [self.delegate overScreenStripViewAnimationDidFinish];
    }
}

@end
