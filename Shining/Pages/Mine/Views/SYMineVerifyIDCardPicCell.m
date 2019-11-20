//
//  SYMineVerifyIDCardPicCell.m
//  Shining
//
//  Created by 杨玄 on 2019/3/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYMineVerifyIDCardPicCell.h"

@interface SYMineVerifyIDCardPicCell ()

@property (nonatomic, strong) UILabel *mainTitle;           // 主标题
@property (nonatomic, strong) UILabel *subTitle;            // 副标题
@property (nonatomic, strong) UIImageView *addImage;        // 添加图片
@property (nonatomic, strong) UIView *bottomView;           // 底部分割线

@end

@implementation SYMineVerifyIDCardPicCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:self.addImage];
        [self.contentView addSubview:self.mainTitle];
        [self.contentView addSubview:self.subTitle];
        [self.contentView addSubview:self.bottomView];


        [self.addImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(17);
        }];

        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addImage.mas_right).with.offset(12);
            make.top.equalTo(self.contentView).with.offset(35);
            make.size.mas_equalTo(CGSizeMake(90, 15));
        }];

        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addImage.mas_right).with.offset(12);
            make.top.equalTo(self.mainTitle.mas_bottom).with.offset(4);
            make.size.mas_equalTo(CGSizeMake(74, 16));
        }];

        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];

    }
    return self;
}

#pragma mark - Public

- (void)updateCellWithType:(SYMineVerifyIDCardCellType)type withTitle:(NSString *)title withSubtitle:(NSString *)subTitle showBottomLine:(BOOL)show{
    self.mainTitle.text = title;
    self.subTitle.text = subTitle;
    self.bottomView.hidden = !show;
}

- (void)updateCellImage:(UIImage *)image {
    self.addImage.image = image;
}

#pragma mark - LazyLoad

- (UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [UILabel new];
        _mainTitle.textColor = RGBACOLOR(11, 11, 11, 1);
        _mainTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _mainTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _mainTitle;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [UILabel new];
        _subTitle.textColor = RGBACOLOR(153, 153, 153, 1);
        _subTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _subTitle.textAlignment = NSTextAlignmentRight;
    }
    return _subTitle;
}

- (UIImageView *)addImage {
    if (!_addImage) {
        _addImage = [UIImageView new];
        _addImage.image = [UIImage imageNamed_sy:@"mine_add_idcard"];
        _addImage.clipsToBounds = YES;
        _addImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _addImage;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomView;
}

@end
