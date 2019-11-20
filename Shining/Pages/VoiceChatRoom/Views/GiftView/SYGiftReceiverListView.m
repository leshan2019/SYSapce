//
//  SYGiftReceiverListView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/25.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYGiftReceiverListView.h"
//#import <SDWebImage/UIButton+WebCache.h>

#define GiftReceiverButtonStartTag 3932

@interface SYGiftReceiverListView ()

@property (nonatomic, strong) NSMutableArray <NSNumber *>*selectIndexArray;
@property (nonatomic, strong) NSMutableArray <UIButton *>*buttonArray;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) UIButton *allMicButton;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation SYGiftReceiverListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.rewardLabel];
        [self addSubview:self.allMicButton];
        [self addSubview:self.scrollView];
        _selectIndexArray = [NSMutableArray new];
        _buttonArray = [NSMutableArray new];
    }
    return self;
}

- (void)setUserAvatarURLArray:(NSArray *)urls highlightedIndex:(NSInteger)index {
    if ([urls count] == 0) {
        return;
    }
    if ([urls count] == 1) {
        // 如果赠送对象数量为1，去掉全麦按钮
        [self.allMicButton removeFromSuperview];
        self.scrollView.sy_left = self.allMicButton.sy_left;
        self.scrollView.sy_width = self.sy_width - self.scrollView.sy_left;
    }
    BOOL specifySomeone = NO;
    if (index >= 0 && index < [urls count]) {
        specifySomeone = YES;
    }
    CGFloat x = 1.5;
    CGFloat width = 32.f;
    for (int i = 0; i < [urls count]; i ++) {
        NSString *url = [urls objectAtIndex:i];
        UIButton *button = [self receiverButtonWithIndex:i
                                                   frame:CGRectMake(x, 7.f, width, width)
                                                     url:url];
        [self.scrollView addSubview:button];
        if (specifySomeone) {
            if (i == index) {
                [_selectIndexArray addObject:@(i)];
                [self setButtonSelected:YES button:button];
            } else {
                [self setButtonSelected:NO button:button];
            }
        } else {
            [self setButtonSelected:YES button:button];
            [_selectIndexArray addObject:@(i)];
        }
        x += (width + 16.f);
        self.scrollView.contentSize = CGSizeMake(x, self.sy_height);
        [self.buttonArray addObject:button];
    }
    if (specifySomeone && [urls count] > 1) {
        self.allMicButton.selected = NO;
    }
}

- (UIButton *)receiverButtonWithIndex:(NSInteger)index
                                frame:(CGRect)frame
                                  url:(NSString *)url {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    button.frame = frame;
    button.tag = index + GiftReceiverButtonStartTag;
    button.layer.cornerRadius = CGRectGetHeight(frame) / 2.f;
    if ([NSString sy_isBlankString:url]) {
        [button setBackgroundImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]
                          forState:UIControlStateNormal];
    } else {
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:url]
                                    forState:UIControlStateNormal];
    }
    button.layer.borderColor = [UIColor sam_colorWithHex:@"#FF4CBE"].CGColor;
    button.layer.borderWidth = 1.5;
    [button addTarget:self
               action:@selector(changeReceiverState:)
     forControlEvents:UIControlEventTouchUpInside];
    button.selected = YES;
    return button;
}

- (void)changeReceiverState:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        [_selectIndexArray removeObject:@(button.tag - GiftReceiverButtonStartTag)];
    } else {
        [_selectIndexArray addObject:@(button.tag - GiftReceiverButtonStartTag)];
    }
    [self setButtonSelected:!button.selected button:button];
    if ([self.selectIndexArray count] == [self.buttonArray count]) {
        self.allMicButton.selected = YES;
    } else {
        self.allMicButton.selected = NO;
    }
    if ([self.delegate respondsToSelector:@selector(giftReceiverListViewSelectIndexesChanged)]) {
        [self.delegate giftReceiverListViewSelectIndexesChanged];
    }
}

- (void)setButtonSelected:(BOOL)selected button:(UIButton *)button {
    button.selected = selected;
    if (selected) {
        CGPoint point = button.center;
        button.sy_size = CGSizeMake(35, 35);
        button.center = point;
        button.layer.borderColor = [UIColor sam_colorWithHex:@"#FF4CBE"].CGColor;
        button.layer.borderWidth = 1.5;
    } else {
//        button.layer.borderColor = [UIColor sam_colorWithHex:@"#B391FF"].CGColor;
        CGPoint point = button.center;
        button.sy_size = CGSizeMake(32, 32);
        button.center = point;
        button.layer.borderWidth = 0.f;
    }
    button.layer.cornerRadius = button.sy_width / 2.f;
}

- (void)selectAllMic:(id)sender{
    if (self.allMicButton.selected) {
        [_selectIndexArray removeAllObjects];
        for (int i = 0; i < [self.buttonArray count]; i++) {
            UIButton *button = [self.buttonArray objectAtIndex:i];
            [self setButtonSelected:NO button:button];
        }
    } else {
        [_selectIndexArray removeAllObjects];
        for (int i = 0; i < [self.buttonArray count]; i++) {
            [_selectIndexArray addObject:@(i)];
            UIButton *button = [self.buttonArray objectAtIndex:i];
            [self setButtonSelected:YES button:button];
        }
    }
    self.allMicButton.selected = !self.allMicButton.selected;
    if ([self.delegate respondsToSelector:@selector(giftReceiverListViewSelectIndexesChanged)]) {
        [self.delegate giftReceiverListViewSelectIndexesChanged];
    }
}

- (UILabel *)rewardLabel {
    if (!_rewardLabel) {
        _rewardLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 13, 28, 17)];
        _rewardLabel.textColor = [UIColor whiteColor];
        _rewardLabel.font = [UIFont systemFontOfSize:12];
        _rewardLabel.text = @"打赏";
    }
    return _rewardLabel;
}

- (UIButton *)allMicButton {
    if (!_allMicButton) {
        _allMicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _allMicButton.frame = CGRectMake(self.rewardLabel.sy_right + 12.f, 10.f, 44.f, 20.f);
        [_allMicButton setImage:[UIImage imageNamed_sy:@"voiceroom_allMic"]
                                 forState:UIControlStateNormal | UIControlStateHighlighted];
        [_allMicButton setImage:[UIImage imageNamed_sy:@"voiceroom_allMic_h"]
                                 forState:UIControlStateSelected | UIControlStateHighlighted];
        [_allMicButton setBackgroundImage:[UIImage imageNamed_sy:@"voiceroom_allMic"] forState:UIControlStateNormal];
        [_allMicButton setBackgroundImage:[UIImage imageNamed_sy:@"voiceroom_allMic_h"] forState:UIControlStateSelected];
//        _allMicButton.selected = YES;
        [_allMicButton addTarget:self
                          action:@selector(selectAllMic:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _allMicButton;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.allMicButton.sy_right + 18.f, 0, self.sy_width - (self.allMicButton.sy_right + 18.f), self.sy_height)];
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

@end
