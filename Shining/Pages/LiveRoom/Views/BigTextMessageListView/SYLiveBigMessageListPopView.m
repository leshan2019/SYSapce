//
//  SYLiveBigMessageListPopView.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveBigMessageListPopView.h"

@interface SYLiveBigMessageListPopView ()

@property (nonatomic, strong) SYLiveBigTextMessageListView *messageListView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SYLiveBigMessageListPopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        [self addSubview:self.messageListView];
        [self addSubview:self.closeButton];
    }
    return self;
}

- (void)setDataSource:(id<SYVoiceTextMessageListViewDataSource>)dataSource {
    self.messageListView.dataSource = dataSource;
}

- (void)setActionDelegate:(id<SYVoiceTextMessageListViewDelegate>)actionDelegate {
    self.messageListView.delegate = actionDelegate;
}

- (SYVoiceTextMessageListView *)messageListView {
    if (!_messageListView) {
        CGFloat originY = 190.f;
        CGFloat height = self.sy_height - 50.f - originY;
        _messageListView = [[SYLiveBigTextMessageListView alloc] initWithFrame:CGRectMake(0, originY, self.bounds.size.width, height)];
    }
    return _messageListView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(10.f, self.sy_height - 20.f - 26.f, 70, 26);
        _closeButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
        _closeButton.layer.cornerRadius = 13.f;
        [_closeButton addTarget:self
                         action:@selector(close:)
               forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setTitle:@"关闭大字幕"
                      forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
    }
    return _closeButton;
}

- (void)reloadData {
    [self.messageListView reloadData];
}

- (void)close:(id)sender {
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(messageListPopViewDidClose)]) {
        [self.delegate messageListPopViewDidClose];
    }
}

@end
