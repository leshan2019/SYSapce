//
//  SYVoiceRoomGiftItemCell.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGiftItemCell.h"

@interface SYVoiceRoomGiftItemCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *levelView;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *minusLabel;
@property (nonatomic, strong) UIImageView *minusBgView;
@end

@implementation SYVoiceRoomGiftItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.levelView];
        [self.levelView addSubview:self.levelLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.minusBgView];
        [self.minusBgView addSubview:self.minusLabel];
        self.layer.cornerRadius = 4.f;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)showWithGiftImageURL:(NSString *)url
                       title:(NSString *)title
                       price:(NSString *)price
                    vipLevel:(NSString *)vipLevel
                 needShowNum:(BOOL)needShowNum
                         num:(NSInteger)num
                    minusNum:(NSInteger)minusNum
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    self.titleLabel.text = title;
    self.priceLabel.text = price;
    if (needShowNum) {
        self.levelView.hidden = NO;
        self.levelView.image = [UIImage imageNamed_sy:@"voiceroom_gift_num"];
        self.levelLabel.text = [NSString stringWithFormat:@"x%ld", (long)num];
    } else {
        self.levelView.image = [UIImage imageNamed_sy:@"voiceroom_gift_vip"];
        self.levelView.hidden = [NSString sy_isBlankString:vipLevel];
        self.levelLabel.text = vipLevel;
    }
    self.minusLabel.hidden = (minusNum>=0);
    self.minusBgView.hidden = (minusNum>=0);
    if (minusNum<0) {
        self.minusLabel.text = [NSString stringWithFormat:@"%ld", (long)minusNum];
        self.levelView.hidden = YES;
    }
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat x = 10.f;
        CGFloat width = self.sy_width - 2 * x;
        CGFloat ratio = 70.f / 50.f;
        CGFloat height = width / ratio;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 5, width, height)];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.sy_bottom, self.sy_width, 12.f)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.sy_bottom, self.sy_width, 12.f)];
        _priceLabel.font = [UIFont systemFontOfSize:9.f];
        _priceLabel.textColor = [UIColor sam_colorWithHex:@"#DDDDDD"];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (UIImageView *)levelView {
    if (!_levelView) {
        CGFloat width = 28.f;
        _levelView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sy_width - width - 2.f, 2.f, width, 12.f)];
        _levelView.image = [UIImage imageNamed_sy:@"voiceroom_gift_vip"];
    }
    return _levelView;
}

- (UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] initWithFrame:self.levelView.bounds];
        _levelLabel.font = [UIFont systemFontOfSize:7.f weight:UIFontWeightSemibold];
        _levelLabel.textColor = [UIColor whiteColor];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _levelLabel;
}

- (UIImageView *)minusBgView {
    if (!_minusBgView) {
        CGFloat width = 36.f;
        _minusBgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sy_width - width - 4.f, 4.f, width, 12.f)];
        _minusBgView.image = [[UIImage imageNamed_sy:@"voiceroom_gift_minus_bg"]stretchableImageWithLeftCapWidth:8 topCapHeight:0];

    }
    return _minusBgView;
}

- (UILabel *)minusLabel {
    if (!_minusLabel) {
        _minusLabel = [[UILabel alloc] initWithFrame:self.minusBgView.bounds];
        _minusLabel.font = [UIFont systemFontOfSize:8.f];
        _minusLabel.textColor = [UIColor sy_colorWithHexString:@"#1BC3EB" alpha:1.0];
        _minusLabel.textAlignment = NSTextAlignmentCenter;
        _minusLabel.hidden = YES;
//        UIColor *color = [UIColor colorWithPatternImage:[[UIImage imageNamed_sy:@"voiceroom_gift_minus_bg"]stretchableImageWithLeftCapWidth:8 topCapHeight:0]];
//
//        _minusLabel.backgroundColor = color;
    }
    return _minusLabel;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.layer.borderColor = [UIColor sam_colorWithHex:@"#FF4CBE"].CGColor;
        self.layer.borderWidth = 1.f;
    } else {
        self.layer.borderColor = [UIColor sam_colorWithHex:@"#FF4CBE"].CGColor;
        self.layer.borderWidth = 0.f;
    }
}

@end
