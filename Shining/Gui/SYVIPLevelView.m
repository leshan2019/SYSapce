//
//  SYVIPLevelView.m
//  Shining
//
//  Created by mengxiangjian on 2019/5/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVIPLevelView.h"

@interface SYVIPLevelView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation SYVIPLevelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sy_size = CGSizeMake(34.f, 14.f);
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}

- (void)showWithVipLevel:(NSInteger)level {
    self.imageView.image = [self imageWithLevel:level];
    self.label.text = [NSString stringWithFormat:@"%ld", (long)level];
}

- (void)makeBiger {
    self.sy_size = CGSizeMake(44.f, 18.f);
    self.label.font = [UIFont boldSystemFontOfSize:13];
    self.label.sy_left = 15;
    self.label.sy_height = self.sy_height;
    self.imageView.frame = self.bounds;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 0, self.sy_width - 12, self.sy_height)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:10];
    }
    return _label;
}

- (UIImage *)imageWithLevel:(NSInteger)level {
    if (level == 0) {
        return [UIImage imageNamed_sy:@"voiceroom_vip_0"];
    } else if (level >= 1 && level <= 20) {
        return [UIImage imageNamed_sy:@"voiceroom_vip_1"];
    } else if (level >= 21 && level <= 40) {
        return [UIImage imageNamed_sy:@"voiceroom_vip_5"];
    } else if (level >= 41 && level <= 60) {
        return [UIImage imageNamed_sy:@"voiceroom_vip_10"];
    } else {
        return [UIImage imageNamed_sy:@"voiceroom_vip_14"];
    }
}

@end
