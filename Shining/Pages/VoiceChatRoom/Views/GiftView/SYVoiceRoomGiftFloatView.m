//
//  SYVoiceRoomGiftFloatView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/4.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGiftFloatView.h"
#import "KSGradientLabel.h"

@interface SYVoiceRoomGiftFloatView () <CAAnimationDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) KSGradientLabel *multiplyLabel;
@property (nonatomic, strong) KSGradientLabel *numsLabel;

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, assign) BOOL isAnimate;

@end

@implementation SYVoiceRoomGiftFloatView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.imageView];
        [self.containerView addSubview:self.iconView];
        [self.containerView addSubview:self.label];
        [self.containerView addSubview:self.multiplyLabel];
        [self.containerView addSubview:self.numsLabel];
    }
    return self;
}

- (void)addFloatGiftWithGiftMessageViewModel:(SYVoiceTextMessageViewModel *)viewModel {
    if (!self.modelArray) {
        self.modelArray = [NSMutableArray new];
    }
    
    if (viewModel) {
        [self.modelArray addObject:viewModel];
    }
    
    if (self.isAnimate) {
        
    } else {
        [self playNext];
    }
}

- (void)playNext {
    SYVoiceTextMessageViewModel *viewModel = [self.modelArray firstObject];
    if (viewModel) {
        [self.modelArray removeObject:viewModel];
        [self playWithViewModel:viewModel];
    }
}

- (void)playWithViewModel:(SYVoiceTextMessageViewModel *)viewModel {
    self.isAnimate = YES;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:viewModel.giftURL]];
    NSString *username = viewModel.username;
    if (username.length > 8) {
        username = [username substringToIndex:8];
        username = [username stringByAppendingString:@"..."];
    }
    NSString *receiverName = viewModel.receiverUsername;
    if (receiverName.length > 8) {
        receiverName = [receiverName substringToIndex:8];
        receiverName = [receiverName stringByAppendingString:@"..."];
    }
    self.label.text = [NSString stringWithFormat:@"%@ 送给 \n%@", username, receiverName];
    NSInteger giftNums = viewModel.giftNums;
    if (giftNums > 1) {
        self.multiplyLabel.hidden = NO;
        self.numsLabel.hidden = NO;
        self.numsLabel.text = [NSString stringWithFormat:@"%ld", viewModel.giftNums];
    } else {
        self.multiplyLabel.hidden = YES;
        self.numsLabel.hidden = YES;
    }
    
    self.containerView.sy_left = - self.containerView.sy_width;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 2;
    group.delegate = self;

    CABasicAnimation *inAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    inAnimation.beginTime = 0;
    inAnimation.duration = 0.5;
    inAnimation.toValue = @(10.f + self.containerView.sy_width / 2.f);
    inAnimation.fillMode = kCAFillModeForwards;
    inAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *outAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    outAnimation.beginTime = 1.5;
    outAnimation.toValue = @(self.containerView.layer.position.y - self.containerView.layer.bounds.size.height);
    outAnimation.duration = 0.5;
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.beginTime = 1.5;
    fadeAnimation.toValue = @(0.f);
    fadeAnimation.duration = 0.5;
    
    group.animations = @[inAnimation, outAnimation,fadeAnimation];
//    group.animations = @[inAnimation];
    [self.containerView.layer addAnimation:group
                                    forKey:@"anim"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.isAnimate = NO;
    [self playNext];
}

#pragma mark -

- (UIView *)containerView {
    if (!_containerView) {
        CGFloat width = 330.f;
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(- width, 0, width, 50.f)];
    }
    return _containerView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11.f, 208.f, 39.f)];
        _imageView.image = [UIImage imageNamed_sy:@"voiceroom_gift_float"];
    }
    return _imageView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.sy_width - 84, -5, 84, 60)];
    }
    return _iconView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 11.f + 6.f, self.containerView.sy_width - 70.f - 20.f, 28.f)];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont systemFontOfSize:10.f];
        _label.textColor = [UIColor whiteColor];
        _label.numberOfLines = 2;
    }
    return _label;
}

- (KSGradientLabel *)multiplyLabel {
    if (!_multiplyLabel) {
        _multiplyLabel = [[KSGradientLabel alloc] initWithFrame:CGRectMake(self.iconView.sy_right, 0, 15.f, self.containerView.sy_height)];
        _multiplyLabel.text = @"x";
        _multiplyLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT"
                                              size:20];
        _multiplyLabel.textColor = [UIColor whiteColor];
        _multiplyLabel.drawOutline = YES;
        _multiplyLabel.outlineColor = [UIColor sam_colorWithHex:@"#A36506"];
        _multiplyLabel.outlineThickness = 1.f;
        _multiplyLabel.drawGradient = YES;
        [_multiplyLabel setGradientStartColor:[UIColor sam_colorWithHex:@"#FD8800"]
                                     endColor:[UIColor sam_colorWithHex:@"#FFD35A"]];
//        _multiplyLabel.shadowColor = RGBACOLOR(0, 0, 0, 0.62);
//        _multiplyLabel.shadowOffset = CGSizeMake(2, 2);
    }
    return _multiplyLabel;
}

- (KSGradientLabel *)numsLabel {
    if (!_numsLabel) {
        _numsLabel = [[KSGradientLabel alloc] initWithFrame:CGRectMake(self.multiplyLabel.sy_right, 0, 100.f, self.containerView.sy_height)];
        _numsLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT"
                                              size:40];
        _numsLabel.textColor = [UIColor whiteColor];
        _numsLabel.drawOutline = YES;
        _numsLabel.outlineColor = [UIColor sam_colorWithHex:@"#A36506"];
        _numsLabel.outlineThickness = 1.f;
        _numsLabel.drawGradient = YES;
        [_numsLabel setGradientStartColor:[UIColor sam_colorWithHex:@"#FD8800"]
                                     endColor:[UIColor sam_colorWithHex:@"#FFD35A"]];
//        _numsLabel.shadowColor = RGBACOLOR(0, 0, 0, 0.62);
//        _numsLabel.shadowOffset = CGSizeMake(2, 2);
    }
    return _numsLabel;
}

@end
