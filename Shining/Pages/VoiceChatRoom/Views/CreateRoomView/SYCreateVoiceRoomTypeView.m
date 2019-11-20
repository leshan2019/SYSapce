//
//  SYCreateVoiceRoomTypeView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCreateVoiceRoomTypeView.h"
#define kCreateVoiceRoomTypeButtonTag 493030

@interface SYCreateVoiceRoomTypeView ()

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *typeArray;

@end

@implementation SYCreateVoiceRoomTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)showWithCategoryNames:(NSArray *)names {
    _typeArray = names;
    CGFloat padding = 20.f;
    CGFloat width = (self.sy_width - 18.f - 20.f - 2 * padding) / 3.f;
    CGFloat height = 28.f;
    for (int i = 0; i < [_typeArray count]; i ++) {
        CGFloat x = 18.f + (i % 3) * (width + padding);
        CGFloat y = (i / 3) * (height + 8.f);
        UIButton *button = [self buttonWithFrame:CGRectMake(x, y, width, height)
                                           title:_typeArray[i]
                                           index:i];
        [self addSubview:button];
        if (i == [_typeArray count] - 1) {
            self.sy_height = button.sy_bottom;
        }
    }
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                        index:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:[SYUtil imageFromColor:[UIColor sam_colorWithHex:@"#F4F4F9"]]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[SYUtil imageFromColor:[UIColor sam_colorWithHex:@"#7138EF"]]
                      forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor sam_colorWithHex:@"#999999"]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateSelected];
    button.tag = kCreateVoiceRoomTypeButtonTag + index;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:11.f];
    button.layer.cornerRadius = CGRectGetHeight(frame) / 2.f;
    [button addTarget:self action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - kCreateVoiceRoomTypeButtonTag;
    if (index >= 0 && index < [self.typeArray count]) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *_button = (UIButton *)view;
                _button.selected = NO;
            }
        }
        button.selected = YES;
        self.selectedIndex = index;
    }
}

@end
