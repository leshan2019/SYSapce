//
//  SYActivityLocationView.m
//  Shining
//
//  Created by mengxiangjian on 2019/10/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYActivityLocationView.h"
#define SY_LocationView_Address_placeholder @"获取位置"

@interface SYActivityLocationView ()

@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation SYActivityLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addLineViewWithY:0];
        [self addLineViewWithY:self.sy_height - 1];
        [self addSubview:self.locationImageView];
        [self addSubview:self.addressLabel];
        [self addSubview:self.closeButton];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(id)sender{
    if ([self.delegate respondsToSelector:@selector(activityLocationViewDidChooseChangeAddress)]) {
        [self.delegate activityLocationViewDidChooseChangeAddress];
    }
}

- (void)addLineViewWithY:(CGFloat)y {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.sy_width, 1)];
    line.backgroundColor = [UIColor sam_colorWithHex:@"#F2F2F2"];
    [self addSubview:line];
}

- (UIImageView *)locationImageView {
    if (!_locationImageView) {
        CGFloat height = 17.f;
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, (self.sy_height - height) / 2.f, 14.f, height)];
        _locationImageView.image = [UIImage imageNamed_sy:@"crateActivity_location"];
    }
    return _locationImageView;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.locationImageView.sy_right + 10.f, 0, 200.f, self.sy_height)];
        _addressLabel.font = [UIFont systemFontOfSize:14.f];
        _addressLabel.textColor = [UIColor sam_colorWithHex:@"#606060"];
        _addressLabel.text = SY_LocationView_Address_placeholder;
    }
    return _addressLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = 44.f;
        CGFloat height = 44.f;
        _closeButton.frame = CGRectMake(self.sy_width - width - 10.f, (self.sy_height - height) / 2.f, width, height);
//        _closeButton.backgroundColor = [UIColor redColor];
        [_closeButton setImage:[UIImage imageNamed_sy:@"createActivity_location_delete"]
                      forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(close:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)close:(id)sender {
    self.address = nil;
}

- (void)setAddress:(NSString *)address {
    _address = address;
    self.addressLabel.text = address ?: SY_LocationView_Address_placeholder;
}

@end
