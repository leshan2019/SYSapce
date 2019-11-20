//
//  SYVoiceRoomInputUserIdView.m
//  Shining
//
//  Created by 杨玄 on 2019/3/14.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomInputUserIdView.h"
//#import <Masonry.h>

@interface SYVoiceRoomInputUserIdView () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *bottomBaseView;       // 底部白色view
@property (nonatomic, strong) UILabel *inputIdTipLabel;     // 请输入要添加的用户id
@property (nonatomic, strong) UITextField *inputIdControl;  // 输入文本框
@property (nonatomic, strong) UIView *inputFieldLine;       // 文本框下面的下划线
@property (nonatomic, strong) UIView *divisionHorizonLine;  // 水平分割线
@property (nonatomic, strong) UIView *divisionVerticalLine; // 垂直分割线
@property (nonatomic, strong) UIButton *cancelBtn;          // 取消按钮
@property (nonatomic, strong) UIButton *addBtn;             // 添加按钮

@end

@implementation SYVoiceRoomInputUserIdView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.75);
        [self addSubview: self.bottomBaseView];
        [self.bottomBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.size.mas_equalTo(CGSizeMake(270, 152));
        }];
        [self.inputIdTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBaseView).with.offset(20);
            make.centerX.equalTo(self.bottomBaseView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(238, 16));
        }];
        [self.inputIdControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputIdTipLabel.mas_bottom).with.offset(21);
            make.centerX.equalTo(self.bottomBaseView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(130, 14));
        }];
        [self.inputFieldLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputIdControl.mas_bottom).with.offset(5);
            make.centerX.equalTo(self.bottomBaseView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(136, 1));
        }];
        [self.divisionHorizonLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomBaseView);
            make.right.equalTo(self.bottomBaseView);
            make.top.equalTo(self.bottomBaseView).with.offset(102);
            make.height.mas_equalTo(0.5);
        }];
        [self.divisionVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0.5, 25));
            make.centerX.equalTo(self.bottomBaseView.mas_centerX);
            make.top.equalTo(self.divisionHorizonLine.mas_bottom).with.offset(13);
        }];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(270/2, 50));
            make.bottom.equalTo(self.bottomBaseView);
            make.left.equalTo(self.bottomBaseView);
        }];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(270/2, 50));
            make.bottom.equalTo(self.bottomBaseView);
            make.right.equalTo(self.bottomBaseView);
        }];
    }
    return self;
}

- (NSString *)userId {
    return _inputIdControl.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_inputIdControl resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}

#pragma mark - LazyLoad

- (UIButton *)bottomBaseView {
    if (!_bottomBaseView) {
        _bottomBaseView = [UIButton new];
        _bottomBaseView.backgroundColor = [UIColor whiteColor];
        _bottomBaseView.clipsToBounds = YES;
        _bottomBaseView.layer.cornerRadius = 5;
        [_bottomBaseView addSubview:self.inputIdTipLabel];
        [_bottomBaseView addSubview:self.inputIdControl];
        [_bottomBaseView addSubview:self.inputFieldLine];
        [_bottomBaseView addSubview:self.divisionHorizonLine];
        [_bottomBaseView addSubview:self.divisionVerticalLine];
        [_bottomBaseView addSubview:self.cancelBtn];
        [_bottomBaseView addSubview:self.addBtn];
    }
    return _bottomBaseView;
}

- (UILabel *)inputIdTipLabel {
    if (!_inputIdTipLabel) {
        _inputIdTipLabel = [UILabel new];
        _inputIdTipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _inputIdTipLabel.textColor = RGBACOLOR(68, 68, 68, 1);
        _inputIdTipLabel.textAlignment = NSTextAlignmentCenter;
        _inputIdTipLabel.text = @"请输入要添加的用户ID";
    }
    return _inputIdTipLabel;
}

- (UITextField *)inputIdControl {
    if (!_inputIdControl) {
        _inputIdControl = [[UITextField alloc]init];
        _inputIdControl.backgroundColor = [UIColor clearColor];
        _inputIdControl.placeholder = @"请输入ID";
        _inputIdControl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _inputIdControl.textColor = RGBACOLOR(153, 153, 153, 1);
        _inputIdControl.clearButtonMode = UITextFieldViewModeNever;
        _inputIdControl.textAlignment = NSTextAlignmentCenter;
        _inputIdControl.autocorrectionType = UITextAutocorrectionTypeNo;
        _inputIdControl.clearsOnBeginEditing = YES;
        _inputIdControl.keyboardType = UIKeyboardTypeNumberPad;
        _inputIdControl.delegate = self;
    }
    return _inputIdControl;
}

- (UIView *)inputFieldLine {
    if (!_inputFieldLine) {
        _inputFieldLine = [UIView new];
        _inputFieldLine.backgroundColor = RGBACOLOR(204, 204, 204, 1);
    }
    return _inputFieldLine;
}

- (UIView *)divisionHorizonLine {
    if (!_divisionHorizonLine) {
        _divisionHorizonLine = [UIView new];
        _divisionHorizonLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _divisionHorizonLine;
}

- (UIView *)divisionVerticalLine {
    if (!_divisionVerticalLine) {
        _divisionVerticalLine = [UIView new];
        _divisionVerticalLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.08);
    }
    return _divisionVerticalLine;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGBACOLOR(102, 102, 102, 1) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_cancelBtn addTarget:self action:@selector(handleCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton new];
        _addBtn.backgroundColor = [UIColor clearColor];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addBtn setTitleColor:RGBACOLOR(11, 11, 11, 1) forState:UIControlStateNormal];
        _addBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_addBtn addTarget:self action:@selector(handleAddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (void)handleCancelBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleInputUserIdViewCancelBtnClick)]) {
        [self.delegate handleInputUserIdViewCancelBtnClick];
    }
}

- (void)handleAddBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleInputUserIdViewAddBtnClick)]) {
        [self.delegate handleInputUserIdViewAddBtnClick];
    }
}

@end
