//
//  SYOptionListView.m
//  Shining
//
//  Created by mengxiangjian on 2019/5/11.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYOptionListView.h"

#define SYOptionListViewButtonStartTag 39233

@interface SYOptionListView ()

@property (nonatomic, strong) NSArray <NSString *>*options;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation SYOptionListView

- (instancetype)initWithOptions:(NSArray<NSString *> *)options {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _options = options;
        [self addSubview:self.maskView];
    }
    return self;
}

- (void)showInView:(UIView *)view
        arrowPoint:(CGPoint)point {
    self.frame = view.bounds;
    self.maskView.frame = self.bounds;
    NSInteger count = [self.options count];
    CGFloat width = 80.f;
    CGFloat height = 32.f;
    CGFloat x = point.x - width / 2.f;
    CGFloat y = point.y - count * height - 6.f;
    for (int i = 0; i < count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, width, height);
        [button setTitle:[self.options objectAtIndex:i]
                forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor sam_colorWithHex:@"#E42112"]
                     forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(chooseOption:)
         forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        button.backgroundColor = [UIColor sam_colorWithHex:@"#27262C"];
        button.tag = SYOptionListViewButtonStartTag + i;
        [self addSubview:button];
        y += height;
    }
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(point.x - 5.f, y, 10.f, 6.f)];
    arrow.image = [UIImage imageNamed_sy:@"voiceroom_prop_arrow_b"];
    [self addSubview:arrow];
    [view addSubview:self];
}

- (void)chooseOption:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - SYOptionListViewButtonStartTag;
    if ([self.delegate respondsToSelector:@selector(optionListViewDidChooseOptionAtIndex:option:)]) {
        if (index >= 0 && index < [self.options count]) {
            [self.delegate optionListViewDidChooseOptionAtIndex:index
                                                         option:[self.options objectAtIndex:index]];
        }
    }
    [self tap:nil];
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (void)tap:(id)sender {
    [self removeFromSuperview];
}

@end
