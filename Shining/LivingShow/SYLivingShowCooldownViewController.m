//
//  SYLivingShowCooldownViewController.m
//  Shining
//
//  Created by Zhang Qigang on 2019/9/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLivingShowCooldownViewController.h"

#define ANIMATION_USE_IMAGE 1

@interface SYLivingShowCooldownViewController ()
@property (nonatomic, assign) NSInteger maxSeconds;
@property (nonatomic, assign) NSInteger seconds;
#ifndef ANIMATION_USE_IMAGE
@property (nonatomic, strong) UILabel* counterLabel;
@property (nonatomic, strong) UILabel* hintLabel;
@property (nonatomic, strong) UIStackView* mainVLayoutView;
#else
@property (nonatomic, strong) UIImageView* imageView;
#endif

@property (nonatomic, strong) NSTimer* counterTimer;

@end

@implementation SYLivingShowCooldownViewController
- (void) dealloc {
}

- (instancetype) initWithCounterOfSeconds: (NSInteger) seconds {
    self = [super init];
    if (self) {
        self.maxSeconds = seconds;
        self.seconds = seconds;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
#ifndef ANIMATION_USE_IMAGE
    [self.view addSubview: self.mainVLayoutView];
    [self.mainVLayoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [self initialText];
#else
    [self.view addSubview: self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
#endif
}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [self.imageView startAnimating];
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                      target:self
                                                    selector:@selector(timerAction:)
                                                    userInfo:nil
                                                     repeats:YES];
    _counterTimer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void) viewWillDisappear: (BOOL) animated {
    [super viewWillDisappear: animated];
}

- (void)timerAction:(id)sender {
    self.seconds -= 1;
    [self updateText];
    if (self.seconds <= 0) {
        [self.counterTimer invalidate];
        [self.imageView stopAnimating];
        [self callClose];
    }
}

- (void) initialText {
#ifndef ANIMATION_USE_IMAGE
    self.counterLabel.text = [NSString stringWithFormat: @"%@", @(self.seconds)];
    self.hintLabel.text = [NSString stringWithFormat: @"你的观众还有 %@ 秒抵达战场", @(self.seconds)];
    self.counterLabel.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
#endif
}

- (void) updateText {
#ifndef ANIMATION_USE_IMAGE
    dispatch_async(dispatch_get_main_queue(), ^{
        self.counterLabel.text = [NSString stringWithFormat: @"%@", @(self.seconds)];
        self.hintLabel.text = [NSString stringWithFormat: @"你的观众还有 %@ 秒抵达战场", @(self.seconds)];
        self.counterLabel.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView beginAnimations: nil context: nil];
        self.counterLabel.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        [UIView commitAnimations];
    });
#endif
}

- (void) callClose {
    if (self.delegate && [self.delegate respondsToSelector: @selector(cooldownControllerTimeout:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate cooldownControllerTimeout: self];
        });
    }
}

#pragma mark -
#pragma mark getter
#ifndef ANIMATION_USE_IMAGE
- (UIStackView*) mainVLayoutView {
    if (!_mainVLayoutView) {
        UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews: @[
                                                                                  self.counterLabel,
                                                                                  self.hintLabel,
                                                                                  ]];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        
        _mainVLayoutView = stackView;
    }
    return _mainVLayoutView;
}

- (UILabel*) counterLabel {
    if (!_counterLabel) {
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectZero];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100.0, 100.0));
        }];
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize: 80.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor sy_colorWithHexString: @"#FFFFFF"];
        _counterLabel = label;
    }
    return _counterLabel;
}

- (UILabel*) hintLabel {
    if (!_hintLabel) {
        UILabel* label = [[UILabel alloc] initWithFrame: CGRectZero];
        label.text = [NSString stringWithFormat: @"你的观众还有 %@ 秒抵达战场", @(self.seconds)];
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize: 18.0f];
        label.textColor = [UIColor sy_colorWithHexString: @"#FFFFFF"];
        _hintLabel = label;
    }
    return _hintLabel;
}
#else
- (UIImageView*) imageView {
    if (!_imageView) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        NSMutableArray* imageFrames = [NSMutableArray arrayWithCapacity: 70];
        
        for (int i = 0; i < 61; i ++) {
            NSString* imageName = [NSString stringWithFormat: @"cooldown_%05d", i];
            UIImage* image = [UIImage imageNamed_sy: imageName];
            [imageFrames addObject: image];
        }
        
        imageView.animationImages = imageFrames;
        imageView.animationDuration = 3.0f;
        imageView.animationRepeatCount = 0;
        
        _imageView = imageView;
    }
    return _imageView;
}
#endif
@end
