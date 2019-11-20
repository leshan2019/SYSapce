//
//  SYPersonHomepageCountView.m
//  Shining
//
//  Created by yangxuan on 2019/10/31.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageCountView.h"


@interface SYPersonHomepageCountView ()

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation SYPersonHomepageCountView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(0,0,0,0.5);
        [self addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)updateCount:(NSString *)text {
    self.countLabel.text = text;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
        _countLabel.textColor = RGBACOLOR(255,255,255,1);
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

@end
