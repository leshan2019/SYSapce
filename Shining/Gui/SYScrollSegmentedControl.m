//
//  SYScrollSegmentedControl.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYScrollSegmentedControl.h"

@interface SYScrollSegmentedControl ()

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIView *floatMask;
@property (nonatomic, assign) NSInteger titleCount;
@property (nonatomic, strong) UIView *backView;

@end

@implementation SYScrollSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray <NSString *>*)titleArray {
    self = [super initWithFrame:frame];
    if (self) {
        _buttonArray = [NSMutableArray new];
        _titleCount = [titleArray count];
        self.layer.cornerRadius = self.sy_height / 2.f;
        [self addSubview:self.backView];
        [self addSubview:self.floatMask];
        [self drawWithTitiles:titleArray];
    }
    return self;
}

- (void)drawWithTitiles:(NSArray *)titles {
    NSInteger count = [titles count];
    CGFloat x = 0;
    CGFloat width = self.sy_width / (CGFloat)count;
    for (int i = 0; i < count; i ++) {
        NSString *title = titles[i];
        CGRect frame = CGRectMake(x, 0, width, self.sy_height);
        UIButton *button = [self buttonWithFrame:frame title:title];
        [button addTarget:self action:@selector(buttonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        if (i == 0) {
            button.selected = YES;
        }
        x += width;
    }
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.layer.cornerRadius = self.sy_height / 2.f;
        _backView.layer.borderWidth = 1.f;
        _backView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _backView;
}

- (UIView *)floatMask {
    if (!_floatMask) {
        _floatMask = [[UIView alloc] initWithFrame:CGRectMake(1, 1, self.sy_width / self.titleCount - 1.f, self.sy_height - 2.f)];
        _floatMask.layer.cornerRadius = self.sy_height / 2.f - 1.f;
        _floatMask.backgroundColor = [UIColor whiteColor];
    }
    return _floatMask;
}

- (void)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    self.selectedSegmentIndex = [self.buttonArray indexOfObject:button];
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title];
    [string addAttribute:NSForegroundColorAttributeName
                   value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:12.f weight:UIFontWeightRegular]
                   range:NSMakeRange(0, title.length)];
    [button setAttributedTitle:string forState:UIControlStateNormal];
    NSMutableAttributedString *selectedString = [[NSMutableAttributedString alloc] initWithString:title];
    [selectedString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [selectedString addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:12.f weight:UIFontWeightMedium]
                           range:NSMakeRange(0, title.length)];
    [button setAttributedTitle:selectedString forState:UIControlStateSelected];
    return button;
}

- (void)setBorderColor:(UIColor *)color {
    self.backView.layer.borderColor = color.CGColor;
}

- (void)setSelectedTitleColor:(UIColor *)color {
    for (UIButton *button in self.buttonArray) {
        NSString *title = button.titleLabel.text;
        NSMutableAttributedString *selectedString = [[NSMutableAttributedString alloc] initWithString:title];
        [selectedString addAttribute:NSForegroundColorAttributeName
                               value:color range:NSMakeRange(0, title.length)];
        [selectedString addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:12.f weight:UIFontWeightMedium]
                               range:NSMakeRange(0, title.length)];
        [button setAttributedTitle:selectedString forState:UIControlStateSelected];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    if (_selectedSegmentIndex != selectedSegmentIndex) {
        _selectedSegmentIndex = selectedSegmentIndex;
        NSInteger count = [self.buttonArray count];
        for (int i = 0; i < count; i ++) {
            UIButton *_button = self.buttonArray[i];
            _button.selected = (_selectedSegmentIndex == i);
        }
        CGFloat width = self.sy_width / self.titleCount;
        CGFloat x = selectedSegmentIndex * width + 1.f;
        [UIView animateWithDuration:.3f
                         animations:^{
                             self.floatMask.sy_left = x;
                         }];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
