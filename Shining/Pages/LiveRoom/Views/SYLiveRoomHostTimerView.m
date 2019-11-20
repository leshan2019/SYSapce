//
//  SYLiveRoomHostTimerView.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomHostTimerView.h"

@interface SYLiveRoomHostTimerView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation SYLiveRoomHostTimerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconView];
        [self addSubview:self.label];
    }
    return self;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20.f, 20.f)];
        _iconView.image = [UIImage imageNamed_sy:@"liveRoom_play"];
    }
    return _iconView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.sy_right + 4.f, 0, 100, 20)];
        _label.font = [UIFont systemFontOfSize:12.f];
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}


- (void)setTime:(NSInteger)seconds {
    self.label.text = [SYUtil getHMSTimeStrWithSeconds:seconds];
}

@end
