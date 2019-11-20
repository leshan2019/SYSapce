//
//  SYVoiceRoomSexView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomSexView.h"

@interface SYVoiceRoomSexView ()

@property (nonatomic, strong) UIImageView *backgroundImage;     // 背景图
@property (nonatomic, strong) UIImageView *icon;                // 性别icon
@property (nonatomic, strong) UILabel *ageLabel;                // 年龄label

@end

@implementation SYVoiceRoomSexView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = self.sy_height / 2.f;
        [self addSubview:self.backgroundImage];
        [self addSubview:self.icon];
        [self addSubview:self.ageLabel];
    }
    return self;
}

- (void)setSex:(NSString *)sexString
        andAge:(NSInteger)age
{
    self.icon.hidden = NO;
    self.backgroundImage.hidden = NO;
    NSString *ageString = [NSString stringWithFormat:@"%ld", (long)age];
    if ([NSString sy_isBlankString:sexString] || [sexString isEqualToString:@"unknown"]) {
        self.backgroundImage.image = [UIImage imageNamed_sy:@"gender_unknown_bg"];
        if (age <= 0) {
            self.backgroundImage.image = [UIImage imageNamed_sy:@"gender_age_unknown"];
        }
        self.icon.hidden = YES;
        ageString = (age <= 0) ? @"保密": [NSString stringWithFormat:@"保密 %@",ageString];
    }else if([sexString isEqualToString:@"male"]){
        self.backgroundImage.image = [UIImage imageNamed_sy:@"gender_male_bg"];
        self.icon.image = [UIImage imageNamed_sy:@"gender_male_icon"];
    }else if([sexString isEqualToString:@"female"]){
        self.backgroundImage.image = [UIImage imageNamed_sy:@"gender_female_bg"];
        self.icon.image = [UIImage imageNamed_sy:@"gender_female_icon"];
    }
    
    CGRect rect = [ageString boundingRectWithSize:CGSizeMake(999, 12) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.ageLabel.font} context:nil];
    CGRect frame = self.ageLabel.frame;
    frame.size.width = rect.size.width;
    if ([NSString sy_isBlankString:sexString] || [sexString isEqualToString:@"unknown"]) {
        frame.origin.x = 4;
    } else {
        frame.origin.x = self.icon.sy_right + 2.f;
    }
    self.ageLabel.frame = frame;
    self.ageLabel.text = ageString;
    
    CGFloat width = CGRectGetMaxX(self.ageLabel.frame) + 4.f;
    frame = self.frame;
    frame.size.width = width;
    frame.size.height = 14;
    self.frame = frame;
    self.backgroundImage.frame = self.bounds;
}

- (UIImageView *)backgroundImage {
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImage.clipsToBounds = YES;
        _backgroundImage.layer.cornerRadius = 7;
    }
    return _backgroundImage;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(3.f, 2.f, 10.f, 10.f)];
    }
    return _icon;
}

- (UILabel *)ageLabel {
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+2, 1.f, 0, 12.f)];
        _ageLabel.textColor = [UIColor whiteColor];
        _ageLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:10];
    }
    return _ageLabel;
}

@end
