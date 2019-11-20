//
//  SYLiveRoomLiveToolCell.m
//  Shining
//
//  Created by leeco on 2019/9/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomLiveToolCell.h"
@interface SYLiveRoomLiveToolCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation SYLiveRoomLiveToolCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];
    }
    return self;
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        _iconView.backgroundColor =[UIColor orangeColor];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8.f, self.sy_width - 20 , 13.f)];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor whiteColor];
//        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconView.sy_top = 6*dp;
    self.iconView.sy_left = (self.sy_width-40)/2.f;
    self.titleLabel.sy_top = self.iconView.sy_bottom+6*dp;
}
- (void)setIcon:(UIImage *)image andTitle:(NSString *)title{
    [self.iconView setImage:image];
    [self.titleLabel setText:title];
}
@end
