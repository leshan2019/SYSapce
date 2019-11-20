//
//  SYDistrictPickerView.m
//  Shining
//
//  Created by 杨玄 on 2019/4/2.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYDistrictPickerView.h"
#import "SYDistrictProvider.h"

@interface SYDistrictPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *background;             // 白色背景
@property (nonatomic, strong) UILabel *titleLabel;              // 标题
@property (nonatomic, strong) UIPickerView *pickerView;         // 日期选择控件
@property (nonatomic, strong) UIButton *cancelBtn;              // 取消
@property (nonatomic, strong) UIButton *ensureBtn;              // 确定

@property (nonatomic, strong) NSMutableArray<NSArray *> *dataSource;       // 数据源
@property (nonatomic, strong) NSMutableArray *provinceArr;      // 省
@property (nonatomic, strong) NSMutableArray *districtArr;      // 行政区

@property (copy, nonatomic) NSString *selectProvince;           // 选中省 - 北京市
@property (copy, nonatomic) NSString *selectDistrict;           // 选中市 - 朝阳区

@end

@implementation SYDistrictPickerView

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
    }
    return self;
}

#pragma mark - Private

- (void)updateDistricts {
    self.districtArr = [[[SYDistrictProvider shared] getAllDistrictsByProvinceName:self.selectProvince] mutableCopy];
    [self.dataSource replaceObjectAtIndex:1 withObject:self.districtArr];
    [self.pickerView reloadComponent:1];
    [self.pickerView selectRow:0 inComponent:1 animated:YES];
    self.selectDistrict = [self.districtArr objectAtIndex:0];
}

#pragma mark - Setter

- (void)setDistrict_id:(NSInteger)district_id {
    SYDistrict *district = [[SYDistrictProvider shared]districtOfId:district_id];
    // 9.2 - 完善district_id异常的情况
    if ([NSObject sy_empty:district]) {
        district_id = 0;
        district = [[SYDistrictProvider shared]districtOfId:district_id];
    }
    self.selectProvince = [NSString sy_safeString:district.provinceName];
    self.selectDistrict = [NSString sy_safeString:district.districtName];
    self.districtArr = [[[SYDistrictProvider shared] getAllDistrictsByProvinceName:self.selectProvince] mutableCopy];
    [self.dataSource replaceObjectAtIndex:1 withObject:self.districtArr];
    [self.pickerView reloadComponent:1];
    [self.pickerView selectRow:[self.provinceArr indexOfObject:self.selectProvince] inComponent:0 animated:YES];
    [self.pickerView selectRow:[self.districtArr indexOfObject:self.selectDistrict] inComponent:1 animated:YES];
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
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 291/2, 32)];
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
            self.selectProvince = [self.provinceArr objectAtIndex:row];
            [self updateDistricts];
        }
            break;
        case 1:
        {
            self.selectDistrict = [self.districtArr objectAtIndex:row];
        }
            break;
        default:
            break;
    }
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
        _titleLabel.text = @"选择地区";
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
        [_dataSource addObject:self.provinceArr];
        [_dataSource addObject:self.districtArr];
    }
    return _dataSource;
}

- (NSMutableArray *)provinceArr {
    if (!_provinceArr) {
        _provinceArr = [[[SYDistrictProvider shared] getAllProvinces] mutableCopy];
    }
    return _provinceArr;
}

- (NSMutableArray *)districtArr {
    if (!_districtArr) {
        _districtArr = [[[SYDistrictProvider shared] getAllDistrictsByProvinceName:@"北京市"] mutableCopy];
    }
    return _districtArr;
}

#pragma mark - BtnClick

- (void)handleCancelBtnClickEvent {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSYDistrictPicerViewCancelBtn)]) {
        [self.delegate handleSYDistrictPicerViewCancelBtn];
    }
}

- (void)handleEnsureBtnClickEvent {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSYDistrictPickerViewEnsureBtnwithDistrictId:)]) {
        NSInteger districtId = [[SYDistrictProvider shared] getDistrictIdByProvinceName:self.selectProvince withDistrictName:self.selectDistrict];
        [self.delegate handleSYDistrictPickerViewEnsureBtnwithDistrictId:districtId];
    }
}


@end
