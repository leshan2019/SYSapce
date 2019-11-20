//
//  SYVoiceRoomHomeListCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomHomeListCell.h"

@interface SYVoiceRoomHomeListCell ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SYVoiceRoomHomeListCell

+ (CGSize)cellSizeWithWidth:(CGFloat)width {
    CGFloat cellWidth = (width - 2 * 10.f - 2 * 4.f) / 3.f;
    CGFloat cellHeight = cellWidth + 40.f;
    return CGSizeMake(cellWidth, cellHeight);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)showWithTitle:(NSString *)title
            avatarURL:(NSString *)avatarURL {
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatarURL]];
    self.titleLabel.text = title;
}

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, self.sy_width)];
        _avatarView.layer.cornerRadius = 8.f;
        _avatarView.clipsToBounds = YES;
    }
    return _avatarView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.avatarView.sy_bottom + 8.f, self.avatarView.sy_width, 18.f)];
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
        _titleLabel.textColor = [UIColor sam_colorWithHex:@"#333333"];
    }
    return _titleLabel;
}

@end
