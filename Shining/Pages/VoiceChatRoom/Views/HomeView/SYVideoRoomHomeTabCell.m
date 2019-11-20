//
//  SYVideoRoomHomeTabCell.m
//  Shining
//
//  Created by leeco on 2019/9/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVideoRoomHomeTabCell.h"
@interface SYVideoRoomHomeTabCell()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *highlightedIcon;
@property (nonatomic, strong) NSString *icon;
@end
@implementation SYVideoRoomHomeTabCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DEFAULT_THEME_BG_COLOR;
        self.contentView.backgroundColor = DEFAULT_THEME_BG_COLOR;

//        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.iconView];
//        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:self.bounds];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [_iconView setImage:[UIImage imageNamed_sy:@"homepage_tab_placeHolder"]];

    }
    return _iconView;
}
- (UIView *)bgView{
    if (!_bgView) {
        UIView*bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, self.sy_height)];
        bg.layer.cornerRadius = self.sy_height/2.f;
        bg.backgroundColor = [UIColor sy_colorWithHexString:@"#F5F5F5"];
        bg.layer.cornerRadius = self.sy_height/2.f;
        _bgView = bg;
    }
    return _bgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.sy_right + 5.f, 8.f, 50, 17.f)];
        _titleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightSemibold];
        _titleLabel.textColor = [UIColor sy_colorWithHexString:@"#7843F2"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.iconView setImageWithURL:[NSURL URLWithString:self.highlightedIcon]
                      placeholderImage:[UIImage imageNamed_sy:@"homepage_tab_placeHolder_selected"]];
    } else {
        self.titleLabel.textColor = [UIColor sy_colorWithHexString:@"#7843F2"];
        [self.iconView setImageWithURL:[NSURL URLWithString:self.icon]
                      placeholderImage:[UIImage imageNamed_sy:@"homepage_tab_placeHolder"]];

    }
}
- (void)showWithIconURL:(NSString *)iconURL
      highlighteIconURL:(NSString *)highlighteIconURL
                  title:(NSString *)title {
    self.icon = iconURL;
    self.highlightedIcon = highlighteIconURL;
    [self.iconView setImageWithURL:[NSURL URLWithString:iconURL]
                  placeholderImage:[UIImage imageNamed_sy:@"homepage_tab_placeHolder"]];
    self.titleLabel.text = title;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.iconView setFrame:self.bounds];
}
@end
