//
//  SYPersonHomepageMarqueeView.m
//  Shining
//
//  Created by yangxuan on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageMarqueeView.h"

#define SpaceX 50

#define ScrollDuration 3
#define ScrollDelay 2

@interface SYPersonHomepageMarqueeView ()

@property (nonatomic, strong) UILabel *firstRoomLabel;        // 房间name1
@property (nonatomic, strong) UILabel *secondRoomLabel;       // 房间name2

@property (nonatomic, assign) CGFloat nameWidth;

@end

@implementation SYPersonHomepageMarqueeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - Public

- (void)updateText:(NSString *)text {
    [self.firstRoomLabel.layer removeAllAnimations];
    [self.secondRoomLabel.layer removeAllAnimations];
    if (text.length == 0) {
        self.firstRoomLabel.hidden = YES;
        self.secondRoomLabel.hidden = YES;
        return;
    }
    self.firstRoomLabel.hidden = NO;
    self.secondRoomLabel.hidden = NO;
    self.firstRoomLabel.text = text;
    self.secondRoomLabel.text = text;
    NSDictionary *dict = @{NSFontAttributeName:self.firstRoomLabel.font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 14) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    self.nameWidth = rect.size.width;
    self.firstRoomLabel.sy_width = self.nameWidth;
    self.secondRoomLabel.sy_width = self.nameWidth;
    [self startAnimation];
}

#pragma mark - Private

- (void)initSubviews {
    self.clipsToBounds = YES;
    [self addSubview:self.firstRoomLabel];
    [self addSubview:self.secondRoomLabel];
}

- (void)startAnimation {
    CGFloat offSet = self.nameWidth + SpaceX;
    self.firstRoomLabel.sy_x = 0;
    self.secondRoomLabel.sy_x = offSet;
    [UIView animateWithDuration:ScrollDuration animations:^{
        self.firstRoomLabel.sy_x = -offSet;
        self.secondRoomLabel.sy_x = 0;
    } completion:^(BOOL finished) {
        self.firstRoomLabel.sy_x = offSet;
        if (finished) {
            [UIView animateWithDuration:ScrollDuration delay:ScrollDelay options:0 animations:^{
                self.secondRoomLabel.sy_x = -offSet;
                self.firstRoomLabel.sy_x = 0;
            } completion:^(BOOL finished) {
                self.secondRoomLabel.sy_x = offSet;
                if (finished) {
                    [self reStartAnimation];
                }
            }];
        }
    }];
}

- (void)reStartAnimation {
    CGFloat offSet = self.nameWidth + SpaceX;
    self.firstRoomLabel.sy_x = 0;
    self.secondRoomLabel.sy_x = offSet;
    [UIView animateWithDuration:ScrollDuration delay:ScrollDelay options:0 animations:^{
        self.firstRoomLabel.sy_x = -offSet;
        self.secondRoomLabel.sy_x = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.firstRoomLabel.sy_x = offSet;
            [UIView animateWithDuration:ScrollDuration delay:ScrollDelay options:0 animations:^{
                self.secondRoomLabel.sy_x = -offSet;
                self.firstRoomLabel.sy_x = 0;
            } completion:^(BOOL finished) {
                self.secondRoomLabel.sy_x = offSet;
                if (finished) {
                    [self reStartAnimation];
                }
            }];
        }
    }];
}

#pragma mark - Lazyload

- (UILabel *)firstRoomLabel {
    if (!_firstRoomLabel) {
        _firstRoomLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _firstRoomLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _firstRoomLabel.textColor = [UIColor whiteColor];
        _firstRoomLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _firstRoomLabel;
}

- (UILabel *)secondRoomLabel {
    if (!_secondRoomLabel) {
        _secondRoomLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _secondRoomLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _secondRoomLabel.textColor = [UIColor whiteColor];
        _secondRoomLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _secondRoomLabel;
}

@end
