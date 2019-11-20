//
//  SYVoiceRoomIDView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomIDView.h"

@interface SYVoiceRoomIDView ()

@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SYVoiceRoomIDView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self addSubview:self.imageView];
        [self addSubview:self.idLabel];
    }
    return self;
}

- (void)setID:(NSString *)roomID {
    CGRect rect = [roomID boundingRectWithSize:CGSizeMake(999, 16)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: self.idLabel.font}
                                       context:nil];
    CGRect frame = self.idLabel.frame;
    frame.size.width = rect.size.width;
    self.idLabel.frame = frame;
    
    CGFloat width = CGRectGetMaxX(self.idLabel.frame);
    width += 14.f;
    
    frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
    self.idLabel.text = roomID;
    
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

- (UILabel *)idLabel {
    if (!_idLabel) {
        _idLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 4.f, 4.f, 0, 16.f)];
        _idLabel.font = [UIFont systemFontOfSize:12.f];
        _idLabel.textColor = [UIColor whiteColor];
    }
    return _idLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 5.f, 13.f, 13.f)];
        _imageView.image = [UIImage imageNamed_sy:@"voiceroom_id"];
    }
    return _imageView;
}

@end
