//
//  MyShineIncomeView.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "MyShineIncomeView.h"
@interface MyShineIncomeView()
@property(nonatomic,strong)UILabel *shine_dayIncomeLabel;
@property(nonatomic,strong)UILabel *shine_dayMsgLabel;
@property(nonatomic,strong)UILabel *shine_weekIncomeLabel;
@property(nonatomic,strong)UILabel *shine_weekMsgLabel;
@property(nonatomic,strong)UIView *separatorLine;
@end

@implementation MyShineIncomeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shine_dayIncomeLabel];
        [self addSubview:self.shine_dayMsgLabel];
        [self addSubview:self.shine_weekIncomeLabel];
        [self addSubview:self.shine_weekMsgLabel];
        [self addSubview:self.separatorLine];
        
        [self.shine_dayIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(frame.size.width/2, 18));
        }];
        
        [self.shine_dayMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self.shine_dayIncomeLabel.mas_bottom).with.offset(2);
            make.size.mas_equalTo(CGSizeMake(frame.size.width/2, 14));
        }];
        
        [self.shine_weekIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(frame.size.width/2, 18));
        }];
        
        
        [self.shine_weekMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self.shine_weekIncomeLabel.mas_bottom).with.offset(2);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.width/2, 14));
        }];
        
        [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.shine_dayIncomeLabel.mas_right);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(0.5,17));
        }];
        
    }
    return self;
}

- (UILabel *)shine_dayIncomeLabel {
    if (!_shine_dayIncomeLabel) {
        _shine_dayIncomeLabel = [UILabel new];
        _shine_dayIncomeLabel.backgroundColor = [UIColor clearColor];
        _shine_dayIncomeLabel.textAlignment =NSTextAlignmentCenter;
        _shine_dayIncomeLabel.textColor = [UIColor sam_colorWithHex:@"#7138EF"];
        _shine_dayIncomeLabel.font = [UIFont fontWithName:@"ArialMT" size:16];
        _shine_dayIncomeLabel.text= @"0";

    }
    return _shine_dayIncomeLabel;
}

- (UILabel *)shine_weekIncomeLabel {
    if (!_shine_weekIncomeLabel) {
        _shine_weekIncomeLabel = [UILabel new];
        _shine_weekIncomeLabel.backgroundColor = [UIColor clearColor];
        _shine_weekIncomeLabel.textAlignment =NSTextAlignmentCenter;
        _shine_weekIncomeLabel.textColor = [UIColor sam_colorWithHex:@"#7138EF"];
        _shine_weekIncomeLabel.font = [UIFont fontWithName:@"ArialMT" size:16];
        _shine_weekIncomeLabel.text= @"0";
    }
    return _shine_weekIncomeLabel;
}

- (UILabel *)shine_dayMsgLabel {
    if (!_shine_dayMsgLabel) {
        _shine_dayMsgLabel = [UILabel new];
        _shine_dayMsgLabel.backgroundColor = [UIColor clearColor];
        _shine_dayMsgLabel.textAlignment =NSTextAlignmentCenter;
        _shine_dayMsgLabel.textColor = [UIColor sam_colorWithHex:@"#6F6F6F"];
        _shine_dayMsgLabel.text = @"今日收到蜜糖";
        _shine_dayMsgLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    }
    return _shine_dayMsgLabel;
}

- (UILabel *)shine_weekMsgLabel {
    if (!_shine_weekMsgLabel) {
        _shine_weekMsgLabel = [UILabel new];
        _shine_weekMsgLabel.backgroundColor = [UIColor clearColor];
        _shine_weekMsgLabel.textAlignment =NSTextAlignmentCenter;
        _shine_weekMsgLabel.textColor = [UIColor sam_colorWithHex:@"#6F6F6F"];
        _shine_weekMsgLabel.text = @"本周收到蜜糖";
        _shine_weekMsgLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    }
    return _shine_weekMsgLabel;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [UIView new];
        _separatorLine.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _separatorLine;
}

- (void)setDayIncomeCount:(NSInteger)dayIncome
{
    self.shine_dayIncomeLabel.text = [NSString stringWithFormat:@"%ld",(long)dayIncome];
}

- (void)setWeekIncomeCount:(NSInteger)weekIncome
{
    self.shine_weekIncomeLabel.text = [NSString stringWithFormat:@"%ld",(long)weekIncome];
}
@end
