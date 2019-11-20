//
//  SYLoginGiftBagViewCell.m
//  Shining
//
//  Created by 杨玄 on 2019/8/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLoginGiftBagViewCell.h"

@interface SYLoginGiftBagViewCell ()
@property (nonatomic, strong) UIImageView *giftImageView;       //gift图片
@property (nonatomic, strong) UILabel *giftNameLabel;           //gift标题
@end

@implementation SYLoginGiftBagViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.giftImageView];
        [self.contentView addSubview:self.giftNameLabel];

        [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(56);
        }];

        [self.giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.giftImageView.mas_bottom).with.offset(6);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

#pragma mark - Public

- (void)updateSyLoginGiftBagViewCell:(NSString *)giftUrl withTitle:(NSString *)giftName {
    [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftUrl] placeholderImage:nil];
    self.giftNameLabel.text = giftName;
}

#pragma mark - LazyLoad

- (UIImageView *)giftImageView {
    if (!_giftImageView) {
        _giftImageView = [UIImageView new];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _giftImageView.backgroundColor = RGBACOLOR(255, 244, 244, 1);
        _giftImageView.clipsToBounds = YES;
        _giftImageView.layer.cornerRadius = 8;
    }
    return _giftImageView;
}

- (UILabel *)giftNameLabel {
    if (!_giftNameLabel) {
        _giftNameLabel = [UILabel new];
        _giftNameLabel.textColor = RGBACOLOR(11, 11, 11, 1);
        _giftNameLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _giftNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _giftNameLabel;
}

@end
