//
//  MyCoinCollectionViewCell.m
//  Shining
//
//  Created by letv_lzb on 2019/3/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "MyCoinCollectionViewCell.h"
#import "SYCoinPackageModel.h"

@interface MyCoinCollectionViewCell ()

@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIImageView *shineIcon;
@property (nonatomic, strong)UILabel *coinLbl;
@property (nonatomic, strong)UILabel *moneyLbl;
@property (nonatomic, strong)UIImageView *selectArrowView;

@property (nonatomic, strong) UILabel *rechareLabel;

@property (nonatomic, strong)id model;

@end

@implementation MyCoinCollectionViewCell

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    if (!self.bgView) {}
    if (!self.shineIcon) {}
    if (!self.coinLbl) {}
    if (!self.moneyLbl) {}
    if (!self.selectArrowView) {}
    if (!self.rechareLabel) {}
}


- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.borderColor = [UIColor sy_colorWithHexString:@"#BAC0C5"].CGColor;
        _bgView.layer.borderWidth = 1;
    }
    if (!_bgView.superview) {
        [self.contentView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).with.offset(12);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _bgView;
}

- (UIImageView *)shineIcon
{
    if (!_shineIcon) {
        _shineIcon = [UIImageView new];
        _shineIcon.backgroundColor = [UIColor clearColor];
    }
    if (!_shineIcon.superview) {
        [self.bgView addSubview:_shineIcon];
        UIImage *img = [UIImage imageNamed_sy:@"voiceroom_note"];
        [_shineIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat leftPadding = (97 - (img.size.width + 60))/2;
            make.left.mas_equalTo(self.bgView).with.offset(leftPadding);
            make.top.mas_equalTo(self.bgView.mas_top).with.offset(4);
            make.size.mas_equalTo(img.size);
        }];
        [_shineIcon setImage:img];
    }
    return _shineIcon;
}

- (UILabel *)coinLbl
{
    if (!_coinLbl) {
        _coinLbl = [UILabel new];
        _coinLbl.backgroundColor = [UIColor clearColor];
        _coinLbl.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        _coinLbl.textColor = [UIColor sy_colorWithHexString:@"#7B40FF"];
        _coinLbl.textAlignment = NSTextAlignmentLeft;
    }
    if (!_coinLbl.superview) {
        [self.bgView addSubview:_coinLbl];
        [_coinLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.shineIcon.mas_right).with.offset(2);
            make.top.equalTo(self.bgView).with.offset(4);
            CGSize size = CGSizeMake(60, 18);
            make.size.mas_equalTo(size);
        }];
    }
    return _coinLbl;
}

- (UILabel *)moneyLbl
{
    if (!_moneyLbl) {
        _moneyLbl = [UILabel new];
        _moneyLbl.backgroundColor = [UIColor clearColor];
        _moneyLbl.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
        _moneyLbl.textColor = [UIColor sy_colorWithHexString:@"#444444"];
        _moneyLbl.textAlignment = NSTextAlignmentCenter;
    }
    if (!_moneyLbl.superview) {
        [self.bgView addSubview:_moneyLbl];
        [_moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.bgView.mas_centerX);
            make.bottom.mas_equalTo(self.bgView.mas_bottom).with.offset(-3);
            make.size.mas_equalTo(CGSizeMake(77 , 18));
        }];
    }
    return _moneyLbl;
}

- (UIImageView *)selectArrowView
{
    if (!_selectArrowView) {
        _selectArrowView = [UIImageView new];
        _selectArrowView.backgroundColor = [UIColor clearColor];
        _selectArrowView.hidden = YES;
    }
    if (!_selectArrowView.superview) {
        [self.bgView addSubview:_selectArrowView];
        UIImage *img = [UIImage imageNamed_sy:@"coin_arrow"];
        [_selectArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView);
            make.bottom.equalTo(self.bgView);
            make.size.mas_equalTo(img.size);
        }];
        [_selectArrowView setImage:img];
    }
    return _selectArrowView;
}

- (UILabel *)rechareLabel {
    if (!_rechareLabel) {
        _rechareLabel = [UILabel new];
        _rechareLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
        _rechareLabel.textColor = [UIColor whiteColor];
        _rechareLabel.textAlignment = NSTextAlignmentCenter;
        if (!_rechareLabel.superview) {
            [self.contentView addSubview:_rechareLabel];
            _rechareLabel.hidden = YES;
            [_rechareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView);
                make.bottom.equalTo(self.bgView.mas_top).with.offset(4);
                make.size.mas_equalTo(CGSizeMake(0, 16));
            }];
        }
    }
    return _rechareLabel;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.selectArrowView.hidden = NO;
        self.bgView.layer.borderColor = [UIColor sy_colorWithHexString:@"#7B40FF"].CGColor;
    }else{
        self.selectArrowView.hidden = YES;
        self.bgView.layer.borderColor = [UIColor sy_colorWithHexString:@"#BAC0C5"].CGColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted
{

}

- (void)bindData:(id)item
{
    if (self.model == item) {
        return;
    }
    self.model = item;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    SYCoinPackageModel *item = self.model;
    if (!item) {
        return;
    }
    self.coinLbl.text = item.coin;

    CGFloat shineIconW = CGRectGetWidth(self.shineIcon.frame);
    if (shineIconW <= 0 && self.shineIcon.image) {
        shineIconW = self.shineIcon.image.size.width;
    }

    CGSize coinSize = [item.coin boundingRectWithSize:CGSizeMake(97 - shineIconW - 10, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.coinLbl.font} context:nil].size;
    coinSize.width += 1;
    CGFloat coinStartX = (97 - shineIconW - coinSize.width - 10)/2;
    [self.shineIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).with.offset(coinStartX);
    }];
    [self.coinLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(coinSize);
    }];
    self.moneyLbl.text = item.price;

    // 更新首冲label
    [self updateRechareLabelState];
}

- (void)updateRechareLabelState {
    SYCoinPackageModel *item = self.model;
    if (item) {
        self.rechareLabel.hidden = NO;
        NSString *title = @"";
        if (item.first_give_coin > 0) {
            self.rechareLabel.backgroundColor = RGBACOLOR(240,115,0,1);
            title = [NSString stringWithFormat:@"首充送%ld",item.first_give_coin];
            [self updateReChargeLabelText:title];
        } else if (item.normal_give_coin > 0) {
            self.rechareLabel.backgroundColor = RGBACOLOR(113,56,239,1);
            title = [NSString stringWithFormat:@"充值送%ld",item.normal_give_coin];
            [self updateReChargeLabelText:title];
        } else {
            self.rechareLabel.hidden = YES;
            self.rechareLabel.layer.mask = nil;
        }
    } else {
        self.rechareLabel.hidden = YES;
    }
}

- (void)updateReChargeLabelText:(NSString *)title {
    CGFloat width = [title sizeWithAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:10]}].width + 12;
    [self.rechareLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    CGRect bounds = CGRectMake(0, 0, width, 16);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    self.rechareLabel.layer.mask = maskLayer;
    self.rechareLabel.text = title;
}

@end
