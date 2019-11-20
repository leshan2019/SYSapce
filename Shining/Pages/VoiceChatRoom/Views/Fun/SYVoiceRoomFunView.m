//
//  SYVoiceRoomFunView.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomFunView.h"
#import "SYVoiceRoomGameView.h"
#import "SYVoiceRoomExpressionView.h"

@interface SYVoiceRoomFunView () <SYVoiceRoomGameViewDelegate, SYVoiceRoomExpressionViewDelegate>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *expressionButton;
@property (nonatomic, strong) UIButton *gameButton;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) SYVoiceRoomGameView *gameView;
@property (nonatomic, strong) SYVoiceRoomExpressionView *expressionView;

@end

@implementation SYVoiceRoomFunView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.maskView];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.expressionButton];
        [self.containerView addSubview:self.gameButton];
        [self.containerView addSubview:self.separator];
        self.expressionButton.selected = YES;
        
        [self.containerView addSubview:self.expressionView];
        [self.containerView addSubview:self.gameView];
        self.gameView.hidden = YES;
        [self.containerView addSubview:self.line];
    }
    return self;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)containerView {
    if (!_containerView) {
        CGFloat height = 223.f;
        if (iPhoneX) {
            height += 34.f;
        }
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - height, self.sy_width, height)];
        _containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    }
    return _containerView;
}

- (UIButton *)expressionButton {
    if (!_expressionButton) {
        _expressionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _expressionButton.frame = CGRectMake(8.f, 0, 60, 45.f);
        [_expressionButton addTarget:self
                              action:@selector(showExpression:)
                    forControlEvents:UIControlEventTouchUpInside];
        [_expressionButton setTitle:@"表情" forState:UIControlStateNormal];
        [_expressionButton setTitleColor:[UIColor sam_colorWithHex:@"#FFF974"]
                                forState:UIControlStateSelected];
        [_expressionButton setTitleColor:[UIColor sam_colorWithHex:@"#999999"]
                                forState:UIControlStateNormal];
        _expressionButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _expressionButton;
}

- (UIButton *)gameButton {
    if (!_gameButton) {
        _gameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gameButton.frame = CGRectMake(68.f, 0, 70, 45.f);
        [_gameButton addTarget:self
                              action:@selector(showGame:)
                    forControlEvents:UIControlEventTouchUpInside];
        [_gameButton setTitle:@"小游戏" forState:UIControlStateNormal];
        [_gameButton setTitleColor:[UIColor sam_colorWithHex:@"#FFF974"]
                                forState:UIControlStateSelected];
        [_gameButton setTitleColor:[UIColor sam_colorWithHex:@"#999999"]
                                forState:UIControlStateNormal];
        _gameButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    }
    return _gameButton;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] initWithFrame:CGRectMake(68, 17.f, 1, 12)];
        _separator.backgroundColor = [UIColor sam_colorWithHex:@"#979797"];
    }
    return _separator;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 45.f, self.sy_width, .5f)];
        _line.backgroundColor = [UIColor sam_colorWithHex:@"#575757"];
    }
    return _line;
}

- (SYVoiceRoomExpressionView *)expressionView {
    if (!_expressionView) {
        _expressionView = [[SYVoiceRoomExpressionView alloc] initWithFrame:CGRectMake(0, 45.f, self.sy_width, 178.f)];
        _expressionView.delegate = self;
    }
    return _expressionView;
}

- (SYVoiceRoomGameView *)gameView {
    if (!_gameView) {
        _gameView = [[SYVoiceRoomGameView alloc] initWithFrame:CGRectMake(0, 45.f, self.sy_width, 103.f)];
        _gameView.delegate = self;
    }
    return _gameView;
}

- (void)showExpression:(id)sender {
    [self unselectButton];
    self.expressionButton.selected = YES;
    self.gameView.hidden = YES;
    self.expressionView.hidden = NO;
    [self.expressionView loadExpressions];
}

- (void)showGame:(id)sender {
    [self unselectButton];
    self.gameButton.selected = YES;
    self.gameView.hidden = NO;
    self.expressionView.hidden = YES;
}

- (void)unselectButton {
    for (UIButton *button in @[self.expressionButton, self.gameButton]) {
        button.selected = NO;
    }
}

- (void)tap:(id)sender {
    [self removeFromSuperview];
}

- (void)setGameEntranceHidden:(BOOL)hidden {
    [self showExpression:nil];
    self.gameButton.hidden = hidden;
    self.separator.hidden = hidden;
}

- (void)refreshData {
    [self.expressionView loadExpressions];
}

#pragma mark -

- (void)voiceRoomExpressionViewDidSelectExpressionWithId:(NSInteger)expressionId {
    if ([self.delegate respondsToSelector:@selector(voiceRoomFunViewDidSelectExpression:)]) {
        [self.delegate voiceRoomFunViewDidSelectExpression:expressionId];
    }
}

- (void)voiceRoomGameViewDidSelectGame:(SYVoiceRoomGameType)game {
    if ([self.delegate respondsToSelector:@selector(voiceRoomFunViewDidSelectGame:)]) {
        [self.delegate voiceRoomFunViewDidSelectGame:game];
    }
}

@end
