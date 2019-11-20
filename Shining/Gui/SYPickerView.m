//
//  SYPickerView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPickerView.h"

@interface SYPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SYPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        [self addSubview:self.maskView];
        [self addSubview:self.toolBar];
        [self.toolBar addSubview:self.confirmButton];
        [self addSubview:self.picker];
    }
    return self;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - 200, self.sy_width, 44)];
        _toolBar.backgroundColor = [UIColor whiteColor];
    }
    return _toolBar;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(self.toolBar.sy_width - 60, 0, 60, 44);
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor sam_colorWithHex:@"#7138EF"] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirm:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIPickerView *)picker {
    if (!_picker) {
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.toolBar.sy_bottom, self.sy_width, self.sy_bottom - self.toolBar.sy_bottom)];
        picker.backgroundColor = [UIColor whiteColor];
        picker.delegate = self;
        picker.dataSource = self;
        _picker = picker;
    }
    return _picker;
}

- (void)tap:(id)sender {
    [self removeFromSuperview];
}

- (void)confirm:(id)sender {
    if (self.currentIndex >= 0) {
        if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:)]) {
            [self.delegate pickerView:self didSelectRow:self.currentIndex];
        }
    }
    [self tap:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [self.delegate pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(pickerView:titleForRow:)]) {
        return [self.delegate pickerView:self titleForRow:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentIndex = row;
}

@end
