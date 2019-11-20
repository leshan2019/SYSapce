//
//  SYLetterIndexerView.m
//  Shining
//
//  Created by 杨玄 on 2019/3/20.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYLetterIndexerView.h"
//#import <Masonry.h>

#define LetterWidth 12
#define LetterSpace 2
#define LetterIndicatorHeight 60

@interface SYLetterIndexerView ()
@property (nonatomic, strong) NSMutableArray *letterArr;    // 保存所有字母控件
@property (nonatomic, strong) NSArray *letterStrArr;        // 保存所有字符
@property (nonatomic, assign) NSInteger selectedIndex;      // 当前选中的字母索引
@property (nonatomic, strong) UIButton *letterIndicator;    // 索引按钮
@property (nonatomic, assign) NSUInteger scrollIndex;       // 滑动手势的时候的索引
@end

@implementation SYLetterIndexerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.letterArr = [NSMutableArray array];
        [self addSubview:self.letterIndicator];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

#pragma mark - Public

- (void)updateIndexerViewWithLetters:(NSArray *)array {
    _scrollIndex = -1;
    _selectedIndex = -1;
    if (self.letterArr && self.letterArr.count > 0) {
        for (int i = 0; i < self.letterArr.count; i++) {
            UIButton *btn = [self.letterArr objectAtIndex:i];
            [btn removeFromSuperview];
        }
        [self.letterArr removeAllObjects];
    }
    if (!array || array.count == 0) {
        [self.letterArr removeAllObjects];
        self.letterStrArr = nil;
        return;
    }
    self.letterStrArr = [array mutableCopy];
    NSString *letterStr = @"";
    UIButton *letterBtn = nil;
    for (int i = 0; i < array.count; i++) {
        letterStr = [array objectAtIndex:i];
        letterBtn = [self createLetterBtnWithString:letterStr];
        letterBtn.tag = i;
        [self addSubview:letterBtn];
        [self.letterArr addObject:letterBtn];
        [letterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-LetterSpace);
            make.size.mas_equalTo(CGSizeMake(LetterWidth, LetterWidth));
            if (i == 0) {
                make.top.equalTo(self).with.offset(LetterSpace);
            } else {
                UIButton *beforeBtn = [self.letterArr objectAtIndex:(i-1)];
                make.top.equalTo(beforeBtn.mas_bottom).with.offset(LetterSpace*2);
            }
        }];
    }
    NSInteger letterCount = array.count;
    CGFloat lettersHeight = letterCount*(LetterWidth + LetterSpace*2);
    CGRect frame = self.frame;
    frame.size.height = lettersHeight;
    self.frame = frame;
}

- (void)updateSelectedIndexWithIndex:(NSInteger)index {
    self.selectedIndex = index;
}

#pragma mark - UIPanGestureRecognizer

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint locationPoint = CGPointZero;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        locationPoint = [gesture locationInView:self];
        [self changeSelectedLetterWithPoint:locationPoint];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        locationPoint = [gesture locationInView:self];
        [self changeSelectedLetterWithPoint:locationPoint];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.scrollIndex = -1;
        [self hideLetterIndicator];
    }
}

- (void)changeSelectedLetterWithPoint:(CGPoint)point {
    NSInteger section = floorf(point.y/(LetterWidth + LetterSpace*2));
    if (section < 0) {
        section = 0;
    }
    if (section >= self.letterArr.count) {
        section = self.letterArr.count-1;
    }

    if (self.scrollIndex == section) {  // 避免重复回调
        return;
    }
    self.scrollIndex = section;
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSYLetterIndexerScrollWithIndex:)]) {
        [self.delegate handleSYLetterIndexerScrollWithIndex:section];
    }
    [self showLetterIndicatorWithIndex:section disAppear:NO];
    self.selectedIndex = section;
}

#pragma mark - Setter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) return;
    NSInteger letterCount = self.letterArr.count;
    if (letterCount == 0) {
        return;
    }
    if (selectedIndex < 0 && selectedIndex >= letterCount) {
        return;
    }
    UIButton *btn = nil;
    btn = [self.letterArr objectAtIndex:_selectedIndex];
    // 取消选中态
    [btn setTitleColor:RGBACOLOR(68, 68, 68, 1) forState:UIControlStateNormal];
    [btn setTitleColor:RGBACOLOR(68, 68, 68, 1) forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor clearColor];
    _selectedIndex = selectedIndex;
    btn = [self.letterArr objectAtIndex:_selectedIndex];
    // 添加选中态
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.backgroundColor = RGBACOLOR(113, 56, 239, 1);
}

#pragma mark - Private

// 创建字母控件
- (UIButton *)createLetterBtnWithString:(NSString *)letterStr {
    UIButton *letterBtn = [UIButton new];
    [letterBtn setTitle:letterStr forState:UIControlStateNormal];
    [letterBtn setTitleColor:RGBACOLOR(68, 68, 68, 1) forState:UIControlStateNormal];
    [letterBtn setTitleColor:RGBACOLOR(68, 68, 68, 1) forState:UIControlStateHighlighted];
    letterBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:10];
    letterBtn.clipsToBounds = YES;
    letterBtn.layer.cornerRadius = LetterWidth/2;
    [letterBtn addTarget:self action:@selector(handleLetterBtnClickEventWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    return letterBtn;
}

// 字母控件点击
- (void)handleLetterBtnClickEventWithBtn:(UIButton *)btn {
    NSInteger index = btn.tag;
    self.selectedIndex = index;
    [self showLetterIndicatorWithIndex:index disAppear:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSYLetterIndexerScrollWithIndex:)]) {
        [self.delegate handleSYLetterIndexerScrollWithIndex:index];
    }
}

- (void)showLetterIndicatorWithIndex:(NSInteger)index disAppear:(BOOL)disappear {
    if (!self.letterStrArr || self.letterStrArr.count == 0 || index > self.letterStrArr.count || index < 0) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLetterIndicator) object:nil];
    self.letterIndicator.alpha = 1;
    NSString *letter = [self.letterStrArr objectAtIndex:index];
    UIButton *letterBtn = [self.letterArr objectAtIndex:index];
    [self.letterIndicator setTitle:letter forState:UIControlStateNormal];
    [self.letterIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(LetterIndicatorHeight, LetterIndicatorHeight));
        make.right.equalTo(self).with.offset(-46);
        make.top.equalTo(letterBtn).with.offset(-(LetterIndicatorHeight/2 - 8));
    }];

    if (disappear) {
        [self performSelector:@selector(hideLetterIndicator) withObject:nil afterDelay:0.1];
    }
}

- (void)hideLetterIndicator {
    [UIView animateWithDuration:0.1 animations:^{
        self.letterIndicator.alpha = 0;
    }];
}

- (UIButton *)letterIndicator {
    if (!_letterIndicator) {
        _letterIndicator = [UIButton new];
        _letterIndicator.backgroundColor = RGBACOLOR(141, 96, 242, 1);
        [_letterIndicator setTitle:@"A" forState:UIControlStateNormal];
        _letterIndicator.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:40];
        [_letterIndicator setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _letterIndicator.clipsToBounds = YES;
        _letterIndicator.layer.cornerRadius = LetterIndicatorHeight/2;
    }
    return _letterIndicator;
}

@end
