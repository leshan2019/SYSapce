//
//  SYPasswordInputView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPasswordInputView.h"

@interface SYPasswordInputView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) NSMutableArray *textFieldArray;

@end

@implementation SYPasswordInputView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textFieldArray = [NSMutableArray new];
        [self addSubview:self.maskView];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.label];
        [self.containerView addSubview:self.line];
        [self.containerView addSubview:self.confirmButton];
        
        CGFloat x = 60.f;
        CGFloat padding = 10.f;
        CGFloat width = 30.f;
        for (int i = 0; i < 4; i ++) {
            UITextField *textField = [self textFieldWithFrame:CGRectMake(x, 58.f, width, width)];
            [self.containerView addSubview:textField];
            [_textFieldArray addObject:textField];
            x += (padding + width);
        }
        UITextField *textField = [self.textFieldArray firstObject];
        [textField becomeFirstResponder];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
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

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 146)];
        CGFloat offset = 20.f;
        if (iPhone5) {
            offset = 100.f;
        }
        _containerView.center = CGPointMake(self.sy_width / 2.f, self.sy_height / 2.f - offset);
        _containerView.layer.cornerRadius = 5.f;
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30.f, self.containerView.sy_width, 18.f)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor sam_colorWithHex:@"#444444"];
        _label.text = @"请输入房间密码";
        _label.font = [UIFont systemFontOfSize:14.f];
    }
    return _label;
}

- (UIView *)line {
    if (!_line) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 96.f, self.containerView.sy_width, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
        _line = line;
    }
    return _line;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(0, self.line.sy_bottom, self.containerView.sy_width, self.containerView.sy_height - self.line.sy_bottom);
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor sam_colorWithHex:@"#999999"] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor sam_colorWithHex:@"#0B0B0B"] forState:UIControlStateSelected];
        [_confirmButton addTarget:self
                           action:@selector(confirm:)
                 forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.enabled = NO;
    }
    return _confirmButton;
}

- (UITextField *)textFieldWithFrame:(CGRect)frame {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor sam_colorWithHex:@"#F4F4F9"];
    textField.delegate = self;
    textField.textColor = [UIColor sam_colorWithHex:@"#999999"];
    textField.font = [UIFont systemFontOfSize:11.f];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.cornerRadius = 2.f;
    return textField;
}

- (void)tap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(passwordInputViewDidCancelEnter)]) {
        [self.delegate passwordInputViewDidCancelEnter];
    }
    [self removeFromSuperview];
}

- (void)confirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(passwordInputViewDidEnterPassword:)]) {
        NSString *password = @"";
        for (UITextField *textField in self.textFieldArray) {
            password = [password stringByAppendingString:textField.text];
        }
        if (password.length == 4) {
            [self.delegate passwordInputViewDidEnterPassword:password];
            [self removeFromSuperview];
        }
    }
}

- (void)moveToNextTextFieldFromTextField:(UITextField *)textField {
    NSInteger index = [self.textFieldArray indexOfObject:textField];
    index ++;
    if (index >= 0 && index < [self.textFieldArray count]) {
        UITextField *_textField = [self.textFieldArray objectAtIndex:index];
        [_textField becomeFirstResponder];
    }
    if (index == [self.textFieldArray count]) {
        [textField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.borderColor = [UIColor sam_colorWithHex:@"#7138EF"].CGColor;
    textField.layer.borderWidth = 0.5;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ((range.location + string.length) > 1) {
        return NO;
    }
    
    return YES;
}

- (void)textChanged:(id)sender {
    NSNotification *noti = (NSNotification *)sender;
    UITextField *textField = [noti object];
    if ([textField isKindOfClass:[UITextField class]] && textField.text.length == 1) {
        [self moveToNextTextFieldFromTextField:textField];
    }
    
    self.confirmButton.enabled = YES;
    self.confirmButton.selected = YES;
    for (UITextField *textField in self.textFieldArray) {
        if (textField.text.length > 0) {
            continue;
        }
        self.confirmButton.enabled = NO;
        self.confirmButton.selected = NO;
        break;
    }
}

@end
