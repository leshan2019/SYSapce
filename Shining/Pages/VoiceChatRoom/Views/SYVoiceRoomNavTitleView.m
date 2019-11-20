//
//  SYVoiceRoomNavTitleView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomNavTitleView.h"

@interface SYVoiceRoomNavTitleView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation SYVoiceRoomNavTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.typeLabel];
        [self addSubview:self.contentLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
            type:(NSString *)type
          roomID:(NSString *)roomID
             hot:(NSString *)hot {
    self.titleLabel.text = title;
    self.typeLabel.text = type;
    self.contentLabel.text = [NSString stringWithFormat:@"ID：%@  人气：%@", roomID, hot];
    CGRect rect = [type boundingRectWithSize:CGSizeMake(999, self.typeLabel.sy_height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: self.typeLabel.font}
                                     context:nil];
    self.typeLabel.sy_width = rect.size.width + 16.f;
    
    rect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(999, self.contentLabel.sy_height)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: self.contentLabel.font}
                                                context:nil];
    self.contentLabel.sy_width = rect.size.width;
    
    CGFloat totalWidth = self.typeLabel.sy_width + self.contentLabel.sy_width + 10.f;
    CGFloat left = (self.sy_width - totalWidth) / 2.f;
    self.typeLabel.sy_left = left;
    self.contentLabel.sy_left = self.typeLabel.sy_right + 10.f;
}

- (void)updateHot:(NSInteger)hot {
    NSString *string = self.contentLabel.text;
    NSRange range = [string rangeOfString:@"人气："];
    NSInteger index = range.location + range.length;
    string = [string substringToIndex:index];
    NSString *hotString = [NSString stringWithFormat:@"%ld", (long)hot];
    string = [string stringByAppendingString:hotString];
    self.contentLabel.text = string;
    
    CGRect rect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(999, self.contentLabel.sy_height)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: self.contentLabel.font}
                                                context:nil];
    self.contentLabel.sy_width = rect.size.width;
    
    CGFloat totalWidth = self.typeLabel.sy_width + self.contentLabel.sy_width + 10.f;
    CGFloat left = (self.sy_width - totalWidth) / 2.f;
    self.typeLabel.sy_left = left;
    self.contentLabel.sy_left = self.typeLabel.sy_right + 10.f;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, 24.f)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.f, self.titleLabel.sy_bottom + 2.f, 34.f, 15)];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:10.f];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.clipsToBounds = YES;
        _typeLabel.layer.cornerRadius = 7.5;
        _typeLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    }
    return _typeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.sy_right + 10.f, self.typeLabel.sy_top, 150.f, 16.f)];
        _contentLabel.textColor = [UIColor sam_colorWithHex:@"#BAC0C5"];
        _contentLabel.font = [UIFont systemFontOfSize:11.f];
    }
    return _contentLabel;
}

@end
