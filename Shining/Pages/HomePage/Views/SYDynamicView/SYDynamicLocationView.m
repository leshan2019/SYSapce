//
//  SYDynamicLocationView.m
//  Shining
//
//  Created by yangxuan on 2019/10/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYDynamicLocationView.h"

@interface SYDynamicLocationView ()

@property (nonatomic, strong) UIImageView *locationIcon;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation SYDynamicLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

#pragma mark - Public

- (void)updateLocation:(NSString *)location {
    CGRect rect = [location boundingRectWithSize:CGSizeMake(999, 17) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.addressLabel.font} context:nil];
    CGRect frame = self.addressLabel.frame;
    frame.size.width = rect.size.width;
    self.addressLabel.frame = frame;
    self.addressLabel.text = location;
    
    CGFloat width = CGRectGetMaxX(self.addressLabel.frame) + 10.f;
    frame = self.frame;
    frame.size.width = width;
    frame.size.height = 22;
    self.frame = frame;
}

#pragma mark - Private

- (void)initSubViews {
    self.backgroundColor = RGBACOLOR(240, 240, 240, 1);;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 11;
    [self addSubview:self.locationIcon];
    [self addSubview:self.addressLabel];
}

#pragma mark - Lazyload

- (UIImageView *)locationIcon {
    if (!_locationIcon) {
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 12, 14)];
        _locationIcon.image = [UIImage imageNamed_sy:@"homepage_dynamic_location"];
    }
    return _locationIcon;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 3, 78, 17)];
        _addressLabel.textColor = RGBACOLOR(136,136,136,1);
        _addressLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}

@end
