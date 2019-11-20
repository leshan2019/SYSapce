//
//  SYCustomActionSheet.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYCustomActionSheet.h"

#define CustomActionSheetActionTag 9090
#define CustomActionSheetButtonShadowTag 9190

@interface SYCustomActionSheet ()

@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, copy) void(^selectBlock)(NSInteger index);
@property (nonatomic, copy) void(^cancelBlock)(void);

@property (nonatomic, strong) UIView *backMask;

@end

@implementation SYCustomActionSheet

- (void)dealloc {
    self.selectBlock = nil;
    self.cancelBlock = nil;
}

- (instancetype)initWithActions:(NSArray <NSString *>*)actions
                    cancelTitle:(NSString *)cancelTitle
                    selectBlock:(void(^)(NSInteger index))selectBlock
                    cancelBlock:(void(^)(void))cancelBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _actions = actions;
        _cancelTitle = cancelTitle;
        _selectBlock = selectBlock;
        _cancelBlock = cancelBlock;
    }
    return self;
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window) {
        self.frame = window.bounds;
        [window addSubview:self];
        [self addSubview:self.backMask];
        self.backMask.frame = self.bounds;
        
        NSInteger actionCount = [self.actions count];
        if (self.cancelTitle) {
            actionCount ++;
        }
        CGFloat top = CGRectGetHeight(self.frame) - (actionCount * 52.f + 5.f);
        if (iPhoneX) {
            top -= 34.f;
        }
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.sy_width, 0)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        for (int i = 0; i < actionCount - 1; i ++) {
            NSString *action = self.actions[i];
            BOOL needLine = YES;
            if (i == actionCount - 2) {
                needLine = NO;
            }
            UIButton *button = [self actionButtonWithTop:top
                                                   width:CGRectGetWidth(self.frame)
                                                     tag:(CustomActionSheetActionTag + i)
                                                  action:action
                                                needLine:needLine
                                                  cancel:NO];
            [self addSubview:button];
            top += 52.f;
            backView.sy_height += 52;
        }
        
        if (self.cancelTitle) {
            UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, top, self.sy_width, 5.f)];
            lineLabel.backgroundColor = [UIColor sy_colorWithHexString:@"#000000" alpha:0.04/1.0];
            [self addSubview:lineLabel];
            top += 5.f;
            backView.sy_height += 5;

            UIButton *button = [self actionButtonWithTop:top
                                                   width:CGRectGetWidth(self.frame)
                                                     tag:(CustomActionSheetActionTag + [self.actions count])
                                                  action:self.cancelTitle
                                                needLine:NO
                                                  cancel:YES];
            [self addSubview:button];
            top += 52.f;
            backView.sy_height += 52;
        }
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:backView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer * layer = [[CAShapeLayer alloc]init];
        layer.frame = backView.bounds;
        layer.path = path.CGPath;
        backView.layer.mask = layer;

        if (iPhoneX) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, top, CGRectGetWidth(self.frame), 34.f)];
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
        }
    }
}

- (UIButton *)actionButtonWithTop:(CGFloat)top
                            width:(CGFloat)width
                              tag:(NSInteger)tag
                           action:(NSString *)action
                         needLine:(BOOL)needLine
                           cancel:(BOOL)isCancel {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, top, width, 52);
//    [button setBackgroundImage:[SYUtil imageFromColor:[UIColor whiteColor]]
//                      forState:UIControlStateNormal];
    [button setTitle:action forState:UIControlStateNormal];
    UIColor *color = [[UIColor sam_colorWithHex:@"#666666"] colorWithAlphaComponent:0.8];
    [button setTitleColor:color
                 forState:UIControlStateNormal];
    if (isCancel) {
        color = [[UIColor sam_colorWithHex:@"#0B0B0B"] colorWithAlphaComponent:0.8];
        [button setTitleColor:color
                     forState:UIControlStateNormal];
    }
    button.tag = tag;
    [button addTarget:self
               action:@selector(action:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button addTarget:self
               action:@selector(touchUp:)
     forControlEvents:UIControlEventTouchUpOutside];
    
    [button addTarget:self
               action:@selector(touchDown:)
     forControlEvents:UIControlEventTouchDown];
//    [button addTarget:self
//               action:@selector(action:)
//     forControlEvents:UIControlEventTouchUpInside];
    
    if (needLine) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(button.bounds) - 0.5, width, 0.5)];
        line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
        [button addSubview:line];
    }
    return button;
}

- (void)action:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    NSInteger index = tag - CustomActionSheetActionTag;
    
    if (index == [self.actions count]) {
        // cancel
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    } else {
        // action
        if (self.selectBlock) {
            self.selectBlock(index);
        }
    }
    [self removeFromSuperview];
}

- (void)touchDown:(id)sender {
    UIButton *button = (UIButton *)sender;
    UIView *shadow = [[UIView alloc] initWithFrame:button.bounds];
    shadow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    shadow.tag = CustomActionSheetButtonShadowTag;
    [button addSubview:shadow];
}

- (void)touchUp:(id)sender {
    UIButton *button = (UIButton *)sender;
    UIView *shadow = [button viewWithTag:CustomActionSheetButtonShadowTag];
    [shadow removeFromSuperview];
}

- (UIView *)backMask {
    if (!_backMask) {
        _backMask = [[UIView alloc] initWithFrame:CGRectZero];
        _backMask.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_backMask addGestureRecognizer:tap];
    }
    return _backMask;
}

- (void)tap:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
}

@end
