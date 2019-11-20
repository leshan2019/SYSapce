//
//  SYVoiceRoomHomeHeaderView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomHomeHeaderView.h"

@interface SYVoiceRoomHomeHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SYVoiceRoomHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, 300, 22)];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.textColor = [UIColor sam_colorWithHex:@"#444444"];
    }
    return _titleLabel;
}

- (void)showWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
