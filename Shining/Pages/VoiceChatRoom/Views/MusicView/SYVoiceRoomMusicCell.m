//
//  SYVoiceRoomMusicCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/9.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomMusicCell.h"

@interface SYVoiceRoomMusicCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *fileSizeLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SYVoiceRoomMusicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.fileSizeLabel];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.lineView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)showWithTitle:(NSString *)title
             fileSize:(long long)fileSize
            isPlaying:(BOOL)isPlaying {
    self.titleLabel.text = title;
    self.fileSizeLabel.text = [NSString stringWithFormat:@"大小%.1fM", (double)fileSize / 1024.f / 1024.f];
    if (isPlaying) {
        self.iconView.animationImages = @[[UIImage imageNamed_sy:@"voiceroom_wave_1"],
                                          [UIImage imageNamed_sy:@"voiceroom_wave_2"],
                                          [UIImage imageNamed_sy:@"voiceroom_wave_3"]];
        self.iconView.animationDuration = 1;
        [self.iconView startAnimating];
    } else {
        [self.iconView stopAnimating];
        self.iconView.image = [UIImage imageNamed_sy:@"voiceroom_icon_play"];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 11.f, 240.f, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)fileSizeLabel {
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.sy_left, self.titleLabel.sy_bottom + 4.f, self.titleLabel.sy_width, 14)];
        _fileSizeLabel.font = [UIFont systemFontOfSize:10.f];
        _fileSizeLabel.textColor = [UIColor sam_colorWithHex:@"#BAC0C5"];
    }
    return _fileSizeLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        CGFloat width = 30.f;
        CGFloat x = self.sy_width - 15.f - width;
        CGFloat y = (self.sy_height - width) / 2.f;
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, width)];
    }
    return _iconView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - 0.5, self.sy_width, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
    }
    return _lineView;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.backgroundColor = highlighted ? [UIColor colorWithWhite:0 alpha:0.1] : [UIColor clearColor];
}

@end
