//
//  SYDatePickerView.m
//  Shining
//
//  Created by 杨玄 on 2019/3/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYDatePickerView.h"
//#import <Masonry.h>

@interface SYDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *background;             // 白色背景
@property (nonatomic, strong) UILabel *titleLabel;              // 标题
@property (nonatomic, strong) UIPickerView *pickerView;         // 日期选择控件
@property (nonatomic, strong) UIButton *cancelBtn;              // 取消
@property (nonatomic, strong) UIButton *ensureBtn;              // 确定

@property (nonatomic, strong) NSMutableArray *dataSource;       // 数据源
@property (nonatomic, strong) NSMutableArray *yearArr;          // 年arr
@property (nonatomic, strong) NSMutableArray *monthArr;         // 月arr
@property (nonatomic, strong) NSMutableArray *dayArr;           // 日arr

@property (copy, nonatomic) NSString *year;                     // 选中年 - 2007
@property (copy, nonatomic) NSString *month;                    // 选中月 - 03
@property (copy, nonatomic) NSString *day;                      // 选中日 - 11

@end

@implementation SYDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
        [self addSubview:self.background];
        [self.background addSubview:self.titleLabel];
        [self.background addSubview:self.pickerView];
        [self.background addSubview:self.cancelBtn];
        [self.background addSubview:self.ensureBtn];
        [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(291, 362));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.background);
            make.size.mas_equalTo(CGSizeMake(56, 16));
            make.top.equalTo(self.background).with.offset(30);
        }];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.background);
            make.size.mas_equalTo(CGSizeMake(291, 45*3));
        }];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(108, 37));
            make.left.equalTo(self.background).with.offset(28);
            make.bottom.equalTo(self.background).with.offset(-30);
        }];
        [self.ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(108, 37));
            make.right.equalTo(self.background).with.offset(-28);
            make.bottom.equalTo(self.background).with.offset(-30);
        }];
//        [self initYearMonthDayDefaultValueWithCurrentTime];
    }
    return self;
}

#pragma mark - Setter

- (void)setDefaultDate:(NSString *)defaultDate {
    if ([NSString sy_isBlankString:defaultDate]) {
        defaultDate = @"2000-01-01";
    }
    NSArray *dateArr = [defaultDate componentsSeparatedByString:@"-"];
    self.year = [NSString sy_safeString:[dateArr objectAtIndex:0]];
    self.month = [NSString sy_safeString:[dateArr objectAtIndex:1]];
    self.day = [NSString sy_safeString:[dateArr objectAtIndex:2]];
    [self updateDaysArr];
    [self.pickerView selectRow:[self.yearArr indexOfObject:self.year] inComponent:0 animated:YES];
    [self.pickerView selectRow:[self.monthArr indexOfObject:self.month] inComponent:1 animated:YES];
    [self.pickerView selectRow:[self.dayArr indexOfObject:self.day] inComponent:2 animated:YES];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dataSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSource[component] count];
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.dataSource[component] objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *titleLbl;
    if (!view) {
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 32)];
        titleLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = RGBACOLOR(62,74,89,1);
    } else {
        titleLbl = (UILabel *)view;
    }
    titleLbl.text = [self.dataSource[component] objectAtIndex:row];
    return titleLbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            NSString *selectYear = [self.yearArr objectAtIndex:row];
            self.year = selectYear;
            [self updateDaysArr];
        }
            break;
        case 1:
        {
            NSString *selectMonth = [self.monthArr objectAtIndex:row];
            self.month = selectMonth;
            [self updateDaysArr];
        }
            break;
        case 2:
        {
            NSString *selectDay = [self.dayArr objectAtIndex:row];
            self.day = selectDay;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private

// 获取当前日期 - 初始化self.year self.month self.day
- (void)initYearMonthDayDefaultValueWithCurrentTime {
    NSDate *date=[NSDate date];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [format stringFromDate:date];
    NSArray *dateArr = [dateStr componentsSeparatedByString:@"-"];
    self.year = [NSString sy_safeString:[dateArr objectAtIndex:0]];
    self.month = [NSString sy_safeString:[dateArr objectAtIndex:1]];
    self.day = [NSString sy_safeString:[dateArr objectAtIndex:2]];
    [self updateDaysArr];
    [self.pickerView selectRow:[self.yearArr indexOfObject:self.year] inComponent:0 animated:YES];
    [self.pickerView selectRow:[self.monthArr indexOfObject:self.month] inComponent:1 animated:YES];
    [self.pickerView selectRow:[self.dayArr indexOfObject:self.day] inComponent:2 animated:YES];
}

// 获取某年某月有多少天
- (NSString *)getDayWithYear:(NSInteger)year withMonth:(NSInteger)month {
    NSArray *days = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    if (2 == month && 0 == (year % 4) && (0 != (year % 100) || 0 == (year % 400))) {
        return @"29";
    }
    return days[month - 1];
}

// 更新天数数组 - 不同年，不同月，天数是不一样的
- (void)updateDaysArr {
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger maxDay = [self getDayWithYear:self.year.integerValue withMonth:self.month.integerValue].integerValue;
    for (int i = 1; i < maxDay + 1; i ++) {
        NSString *dayStr;
        if (i < 10 ) {
            dayStr = [NSString stringWithFormat:@"0%d",i];
        } else {
            dayStr = [NSString stringWithFormat:@"%d",i];
        }
        [arr addObject:dayStr];
    }
    self.dayArr = arr;
    [self.dataSource replaceObjectAtIndex:2 withObject:arr];
    [self.pickerView reloadComponent:2];
}

#pragma mark - 点击弹窗空白处

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark - LazyLoad

- (UIButton *)background {
    if (!_background) {
        _background = [UIButton new];
        _background.clipsToBounds = YES;
        _background.layer.cornerRadius = 11;
        _background.backgroundColor = [UIColor whiteColor];
    }
    return _background;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _titleLabel.textColor = RGBACOLOR(62,74,89,1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"选择日期";
    }
    return _titleLabel;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGBACOLOR(126, 69, 253, 1) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _cancelBtn.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        _cancelBtn.clipsToBounds = YES;
        _cancelBtn.layer.cornerRadius = 18.5;
        [_cancelBtn addTarget:self action:@selector(handleCancelBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)ensureBtn {
    if (!_ensureBtn) {
        _ensureBtn = [UIButton new];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ensureBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:16];
        _ensureBtn.backgroundColor = RGBACOLOR(126, 69, 253, 1);
        _ensureBtn.clipsToBounds = YES;
        _ensureBtn.layer.cornerRadius = 18.5;
        [_ensureBtn addTarget:self action:@selector(handleEnsureBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureBtn;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:self.yearArr];
        [_dataSource addObject:self.monthArr];
        [_dataSource addObject:self.dayArr];
    }
    return _dataSource;
}

- (NSMutableArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
        for (int i = 1960; i < 2008; i ++) {
            [_yearArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _yearArr;
}

- (NSMutableArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
        for (int i = 1; i <= 12; i ++) {
            NSString *str = [NSString stringWithFormat:@"0%d",i];
            if (i >= 10) {
                str = [NSString stringWithFormat:@"%d",i];
            }
            [_monthArr addObject:str];
        }
    }
    return _monthArr;
}

- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSMutableArray array];
        for (int i = 1; i <= 30; i ++) {
            NSString *dayStr;
            if (i < 10 ) {
                dayStr = [NSString stringWithFormat:@"0%d",i];
            } else {
                dayStr = [NSString stringWithFormat:@"%d",i];
            }
            [_dayArr addObject:dayStr];
        }
    }
    return _dayArr;
}

#pragma mark - BtnClick

- (void)handleCancelBtnClickEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSYDatePickerViewCancelBtn)]) {
        [self.delegate handleSYDatePickerViewCancelBtn];
    }
    [self removeFromSuperview];
}

- (void)handleEnsureBtnClickEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSYDatePickerViewEnsureBtnWithDateStr:)]) {
        NSString *date = [NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,self.day];
        [self.delegate handleSYDatePickerViewEnsureBtnWithDateStr:date];
    }
    [self removeFromSuperview];
}

@end
