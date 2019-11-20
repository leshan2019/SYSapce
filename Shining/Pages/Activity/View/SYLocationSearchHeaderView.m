//
//  SYLocationSearchHeaderView.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLocationSearchHeaderView.h"

@interface SYLocationSearchHeaderView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;

@end

@implementation SYLocationSearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backView];
        [self addSubview:self.iconView];
        [self addSubview:self.textField];
        [self addSubview:self.label];
    }
    return self;
}

- (UIView *)backView {
    if (!_backView) {
        CGFloat x = 15;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(x, 13.f, self.sy_width - 2 * x, 36)];
        _backView.backgroundColor = [UIColor sam_colorWithHex:@"#F7F7F7"];
        _backView.layer.cornerRadius = 18.f;
    }
    return _backView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(30.f, 22, 18, 18)];
        _iconView.image = [UIImage imageNamed_sy:@"crateActivity_location_search"];
    }
    return _iconView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(55, 21, self.sy_width - 100.f, 20.f)];
        _textField.delegate = self;
        _textField.textColor = [UIColor blackColor];
        _textField.placeholder = @"搜索附近位置";
        _textField.returnKeyType = UIReturnKeySearch;
    }
    return _textField;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20, self.backView.sy_bottom + 11.f, 100, 20)];
        _label.textColor = [UIColor sam_colorWithHex:@"#909090"];
        _label.font = [UIFont systemFontOfSize:14.f];
        _label.text = @"附近地点";
    }
    return _label;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(locationSearchHeaderViewDidSearchKeyword:)]) {
            [self.delegate locationSearchHeaderViewDidSearchKeyword:textField.text];
        }
    }
    return YES;
}

@end
