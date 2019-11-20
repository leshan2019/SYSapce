//
//  SYVoiceRoomExpressionCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/6.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomExpressionCell.h"

@interface SYVoiceRoomExpressionCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation SYVoiceRoomExpressionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)showWithTitle:(NSString *)title
                 icon:(NSString *)icon {
    [self.iconView setImageWithURL:[NSURL URLWithString:icon]];
    self.titleLabel.text = title;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        CGFloat width = 40.f;
        CGFloat x = (self.sy_width - width) / 2.f;
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, width, width)];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconView.sy_bottom + 2.f, self.sy_width, 13)];
        _titleLabel.font = [UIFont systemFontOfSize:10.f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
