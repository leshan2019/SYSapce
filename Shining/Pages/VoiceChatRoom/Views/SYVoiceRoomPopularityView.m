//
//  SYVoiceRoomPopularityView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomPopularityView.h"

@interface SYVoiceRoomPopularityView ()

@property (nonatomic, strong) UILabel *popLabel;

@end

@implementation SYVoiceRoomPopularityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addSubview:self.popLabel];
    }
    return self;
}

- (void)setPopularity:(NSString *)popularity {
    NSString *text = [NSString stringWithFormat:@"人气：%@", popularity];
    self.popLabel.text = text;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(999, self.bounds.size.height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.popLabel.font}
                                     context:nil];
    self.popLabel.frame = CGRectMake(10.f, 0, rect.size.width, self.bounds.size.height);
    CGRect frame = self.frame;
    frame.size.width = CGRectGetMaxX(self.popLabel.frame) + 14.f;
    self.frame = frame;
    
    CGFloat radius = self.bounds.size.height / 2.f;
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.bounds
                              byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                              cornerRadii:CGSizeMake(radius, radius)
                              ];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (UILabel *)popLabel {
    if (!_popLabel) {
        _popLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _popLabel.font = [UIFont systemFontOfSize:10.f];
        _popLabel.textColor = [UIColor whiteColor];
    }
    return _popLabel;
}

@end
