//
//  SYBroadcasterLevelView.m
//  Shining
//
//  Created by mengxiangjian on 2019/6/20.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYBroadcasterLevelView.h"

@interface SYBroadcasterLevelView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation SYBroadcasterLevelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.sy_size = CGSizeMake(34.f, 14.f);
        [self addSubview:self.imageView];
        [self addSubview:self.label];
    }
    return self;
}

- (void)showWithBroadcasterLevel:(NSInteger)level {
    self.label.text = [NSString stringWithFormat:@"%ld", (long)level];
    self.imageView.image = [UIImage imageNamed_sy:@"voiceroom_broadcaster_level"];
    self.imageView.frame = self.bounds;
}

- (void)makeBiger {
    self.sy_size = CGSizeMake(44.f, 18.f);
    self.label.font = [UIFont boldSystemFontOfSize:13];
    self.label.sy_left = 15;
    self.label.sy_height = self.sy_height;
    self.imageView.frame = self.bounds;
}

- (void)showWithSuperAdmin {
    self.sy_size = CGSizeMake(34.f, 14.f);
    self.label.text = @"";
    self.imageView.image = [UIImage imageNamed_sy:@"voiceroom_superadmin"];
    self.imageView.frame = self.bounds;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed_sy:@"voiceroom_broadcaster_level"];
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

@end
