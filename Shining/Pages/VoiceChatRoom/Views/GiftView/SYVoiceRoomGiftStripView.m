//
//  SYVoiceRoomGiftStripView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/8.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGiftStripView.h"

@interface SYVoiceRoomGiftStripView ()

@property (nonatomic, strong) UIView *giftInfoContainer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSMutableArray *giftModelArray;
@property (nonatomic, assign) BOOL isGiftInfoScrolling;

@end

@implementation SYVoiceRoomGiftStripView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _giftModelArray = [NSMutableArray new];
        _isGiftInfoScrolling = NO;
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = self.bounds;
        layer.colors = @[(__bridge id)[UIColor sam_colorWithHex:@"#844ACA"].CGColor,
                         (__bridge id)[UIColor sam_colorWithHex:@"#591FC0"].CGColor];
        layer.startPoint = CGPointMake(0, 0.5);
        layer.endPoint = CGPointMake(1, 0.5);
        [self.layer addSublayer:layer];
        
        [self addSubview:self.giftInfoContainer];
        [self.giftInfoContainer addSubview:self.label];
        
        self.hidden = YES;
    }
    return self;
}

- (void)addGiftInfo:(SYVoiceTextMessageViewModel *)giftViewModel {
    
    [self.giftModelArray addObject:giftViewModel];
    if (!self.isGiftInfoScrolling) {
        [self showNext];
    }
}

- (void)showNext {
    SYVoiceTextMessageViewModel *viewModel = [self.giftModelArray firstObject];
    if (viewModel) {
        [self.giftModelArray removeObject:viewModel];
        self.label.text = [NSString stringWithFormat:@"%@ 送给 %@", viewModel.username, viewModel.receiverUsername];
        self.hidden = NO;
        self.isGiftInfoScrolling = YES;
        self.giftInfoContainer.sy_left = self.sy_width;
        [UIView animateWithDuration:5.f
                         animations:^{
                             self.giftInfoContainer.sy_left = - self.sy_width;
                         } completion:^(BOOL finished) {
                             self.isGiftInfoScrolling = NO;
                             self.hidden = YES;
                             [self showNext];
                         }];
    }
}

- (UIView *)giftInfoContainer {
    if (!_giftInfoContainer) {
        _giftInfoContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, self.sy_height)];
    }
    return _giftInfoContainer;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.giftInfoContainer.sy_width, self.giftInfoContainer.sy_height)];
        _label.font = [UIFont systemFontOfSize:11.f];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

@end
