//
//  SYCustomSlider.m
//  Shining
//
//  Created by mengxiangjian on 2019/5/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCustomSlider.h"

@interface SYCustomSlider ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *trackView;
@property (nonatomic, strong) UIView *circleView;

//@property (nonatomic, assign) CGPoint floatBallOrigin;
@property (nonatomic, assign) CGFloat panStartCenterX;

@end

@implementation SYCustomSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.trackView];
        [self addSubview:self.circleView];
        _value = 0;
    }
    return self;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5.f, self.sy_width, 10.f)];
        _backView.layer.cornerRadius = 5.f;
        _backView.backgroundColor = [UIColor sam_colorWithHex:@"#999999"];
    }
    return _backView;
}

- (UIView *)trackView {
    if (!_trackView) {
        _trackView = [[UIView alloc] initWithFrame:CGRectMake(0, 5.f, 0, 10.f)];
        _trackView.layer.cornerRadius = 5.f;
        _trackView.backgroundColor = [UIColor sam_colorWithHex:@"#7B40FF"];
    }
    return _trackView;
}

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] initWithFrame:CGRectMake(-10, 0, 20, 20)];
        _circleView.backgroundColor = [UIColor whiteColor];
        _circleView.layer.cornerRadius = 10.f;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(pan:)];
        [_circleView addGestureRecognizer:pan];
    }
    return _circleView;
}

- (void)setValue:(CGFloat)value {
    if (value < 0 || value > 1) {
        return;
    }
    _value = value;
    self.trackView.sy_width = self.sy_width * value;
    self.circleView.sy_left = self.sy_width * value - self.circleView.sy_width / 2.f;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)pan:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.panStartCenterX = self.circleView.sy_centerX;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:self];
        CGFloat x = self.panStartCenterX + translation.x;
        if (x < 0) {
            x = 0;
        }
        if (x > self.sy_width) {
            x = self.sy_width;
        }
        [self setValue:x/self.sy_width];
    } else if (pan.state == UIGestureRecognizerStateEnded ||
               pan.state == UIGestureRecognizerStateCancelled) {
        
    }
}



@end
