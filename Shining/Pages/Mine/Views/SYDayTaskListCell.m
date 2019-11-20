//
//  SYDayTaskListCell.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/9/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYDayTaskListCell.h"

@interface SYDayTaskListCell ()

@property (nonatomic, strong) UIImageView *leftIcon;        //左侧角标
@property (nonatomic, strong) UILabel *mainTitle;           //主标题
@property (nonatomic, strong) UILabel *progessLabel;   //进度
@property (nonatomic, strong) UILabel *subTitle; //副标题
@property (nonatomic, strong) UIButton *rightBtn;       //右侧按钮
@property (nonatomic, strong) UIView *bottomLine;           //分割线

@end

@implementation SYDayTaskListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.mainTitle];
        [self.contentView addSubview:self.progessLabel];
        [self.contentView addSubview:self.subTitle];
        [self.contentView addSubview:self.rightBtn];
        [self.contentView addSubview:self.bottomLine];
        
        [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(34, 34));
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-16);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(52, 24));
        }];

        [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftIcon.mas_right).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(20);
            make.right.equalTo(self.rightBtn.mas_left).with.offset(-10);
            make.height.mas_equalTo(24);
        }];
        
        [self.progessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainTitle.mas_left);
            make.top.equalTo(self.mainTitle.mas_bottom).with.offset(2);
            make.right.equalTo(self.rightBtn.mas_left).with.offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainTitle.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-20);
            make.right.equalTo(self.rightBtn.mas_left).with.offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

#pragma mark - Public

- (void)updateMyneListCellwithIcon:(NSString *)icon
                             title:(NSString *)title
                     progressTitle:(NSString *)progressTitle
                          subTitle:(NSString *)subTitle  {
    self.leftIcon.image = [UIImage imageNamed_sy:icon];
    self.mainTitle.text = title;
    self.progessLabel.text = progressTitle;
    self.subTitle.text = subTitle;
}

#pragma mark - LazyLoad

- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [UIImageView new];
    }
    return _leftIcon;
}

- (UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [UILabel new];
        _mainTitle.textColor = [UIColor blackColor];
        _mainTitle.font =  [UIFont fontWithName:@"PingFang-SC-Bold" size:17];
        _mainTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _mainTitle;
}

- (UILabel *)progessLabel {
    if (!_progessLabel) {
        _progessLabel = [UILabel new];
        _progessLabel.textColor = [UIColor sam_colorWithHex:@"#999999"];
        _progessLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _progessLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _progessLabel;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [UILabel new];
        _subTitle.textColor = [UIColor sam_colorWithHex:@"#999999"];
        _subTitle.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _subTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _subTitle;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        [_rightBtn setTitle:@"去完成" forState:UIControlStateNormal];
        _rightBtn.backgroundColor = [UIColor sam_colorWithHex:@"#FF40A5"];
        _rightBtn.layer.cornerRadius = 14;
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _rightBtn;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _bottomLine;
}

- (void)changeRightBtnByStatus:(SYDayTaskItemStatus)status
{
    switch (status) {
        case SYDayTaskItemStatus_Default:
            [_rightBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [_rightBtn setBackgroundColor:[UIColor sam_colorWithHex:@"#F1F1F1"]];
            [_rightBtn setTitleColor:[UIColor sam_colorWithHex:@"#888888"] forState:UIControlStateNormal];
            [_rightBtn setTitle:@"去完成" forState:UIControlStateNormal];
            _rightBtn.userInteractionEnabled = YES;
            [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(52, 24));
            }];
            break;
        case SYDayTaskItemStatus_Done_unReceived:
            [_rightBtn setBackgroundImage:nil forState:UIControlStateNormal];
            [_rightBtn setBackgroundColor:[UIColor clearColor]];
            [_rightBtn setBackgroundImage:[UIImage imageNamed_sy:@"daytask_receive_bg"] forState:UIControlStateNormal];
            [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_rightBtn setTitle:@"领取" forState:UIControlStateNormal];
            _rightBtn.userInteractionEnabled = YES;
            [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(52, 24));
            }];
            break;
        case SYDayTaskItemStatus_Done_Received:
            [_rightBtn setBackgroundImage:[UIImage imageNamed_sy:@"daytask_received"] forState:UIControlStateNormal];
            [_rightBtn setBackgroundColor:[UIColor clearColor]];
            [_rightBtn setTitle:@"" forState:UIControlStateNormal];
            _rightBtn.userInteractionEnabled = NO;
            [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(38, 38));
            }];
            break;
        case SYDayTaskItemStatus_Unknown:
            [_rightBtn setBackgroundColor:[UIColor sam_colorWithHex:@"#F1F1F1"]];
            [_rightBtn setTitleColor:[UIColor sam_colorWithHex:@"#888888"] forState:UIControlStateNormal];
            [_rightBtn setTitle:@"签到" forState:UIControlStateNormal];
            _rightBtn.userInteractionEnabled = YES;
            [_rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(52, 24));
            }];
            break;
        default:
            break;
    }
}

- (void)updateUI:(BOOL)isHasSubtitle{
    if (isHasSubtitle) {
        [self.mainTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(20);
        }];
    }else{
        [self.mainTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
    }
}

- (UIButton *)getRightBtn
{
    return self.rightBtn;
}
@end
