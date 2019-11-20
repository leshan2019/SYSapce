//
//  SYSegmentControl.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSegmentedControl.h"

@interface SYSegmentedControl ()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation SYSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray <NSString *>*)titleArray {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedSegmentIndex = 0;
        _buttonArray = [NSMutableArray new];
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
                   value:[UIFont systemFontOfSize:14.f weight:UIFontWeightLight]
                   range:NSMakeRange(0, title.length)];
    [button setAttributedTitle:string forState:UIControlStateNormal];
    NSMutableAttributedString *selectedString = [[NSMutableAttributedString alloc] initWithString:title];
    [selectedString addAttribute:NSForegroundColorAttributeName
                   value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [selectedString addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:14.f weight:UIFontWeightMedium]
                   range:NSMakeRange(0, title.length)];
    [button setAttributedTitle:selectedString forState:UIControlStateSelected];
    return button;
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    if (_selectedSegmentIndex != selectedSegmentIndex) {
        _selectedSegmentIndex = selectedSegmentIndex;
        NSInteger count = [self.buttonArray count];
        for (int i = 0; i < count; i ++) {
            UIButton *_button = self.buttonArray[i];
            _button.selected = (_selectedSegmentIndex == i);
        }
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
