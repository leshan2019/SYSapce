//
//  SYLiveRoomPopularityView.m
//  Shining
//
//  Created by mengxiangjian on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomPopularityView.h"

@interface SYLiveRoomPopularityView ()

@property (nonatomic, strong) UILabel *popLabel;

@end

@implementation SYLiveRoomPopularityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:self.popLabel];
        self.layer.cornerRadius = self.sy_height / 2.f;
    }
    return self;
}

- (void)setPopularity:(NSInteger)popularity {
    NSString *text = [NSString stringWithFormat:@"人气：%ld", (long)popularity];
    self.popLabel.text = text;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(999, self.bounds.size.height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.popLabel.font}
                                     context:nil];
    self.popLabel.frame = CGRectMake(10.f, 0, rect.size.width, self.bounds.size.height);
    CGRect frame = self.frame;
    frame.size.width = CGRectGetMaxX(self.popLabel.frame) + 14.f;
    self.frame = frame;
}

- (UILabel *)popLabel {
    if (!_popLabel) {
        _popLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _popLabel.font = [UIFont systemFontOfSize:12.f];
        _popLabel.textColor = [UIColor whiteColor];
        _popLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _popLabel;
}

@end
