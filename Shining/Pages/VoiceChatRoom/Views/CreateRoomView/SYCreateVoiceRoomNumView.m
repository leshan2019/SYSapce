//
//  SYCreateVoiceRoomNumView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateVoiceRoomNumView.h"

@interface SYCreateVoiceRoomNumView ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation SYCreateVoiceRoomNumView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _count = -1;
        [self addSubview:self.button];
    }
    return self;
}

- (void)reset {
    self.count = -1;
    [self.button setTitle:@"请选择" forState:UIControlStateNormal];
    self.button.enabled = YES;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = self.bounds;
        _button.backgroundColor = [UIColor sam_colorWithHex:@"#F4F4F9"];
        [_button setTitleColor:[UIColor sam_colorWithHex:@"#999999"]
                      forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_button setTitle:@"请选择" forState:UIControlStateNormal];
        [_button addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
        _button.clipsToBounds = YES;
        _button.layer.cornerRadius = 4.f;
        _button.enabled = NO;
    }
    return _button;
}

- (void)setCount:(NSInteger)count {
    _count = count;
    [self.button setTitle:[NSString stringWithFormat:@"%ld", (long)count]
                 forState:UIControlStateNormal];
}

- (void)buttonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(createVoiceRoomNumViewDidSelectNumButton)]) {
        [self.delegate createVoiceRoomNumViewDidSelectNumButton];
    }
}

@end
