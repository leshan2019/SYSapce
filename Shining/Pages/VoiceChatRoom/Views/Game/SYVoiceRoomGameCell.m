//
//  SYVoiceRoomGameCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGameCell.h"

@interface SYVoiceRoomGameCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SYVoiceRoomGameCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)showWithImage:(UIImage *)image
                title:(NSString *)title {
    self.imageView.image = image;
    self.titleLabel.text = title;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat width = 40.f;
        CGFloat x = (self.sy_width - width) / 2.f;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10.f, width, width)];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.sy_bottom + 2.f, self.sy_width, 13.f)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:10.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
