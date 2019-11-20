//
//  SYLeaderBoardHeaderView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLeaderBoardHeaderView.h"

@interface SYLeaderBoardHeaderView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *musicView;
@property (nonatomic, strong) NSArray *viewArray;

@end

@implementation SYLeaderBoardHeaderView

+ (CGSize)sizeForHeaderWithWidth:(CGFloat)width {
    CGFloat ratio = 375.f / 227.f;
    CGFloat height = width / ratio;
    return CGSizeMake(width, height + 60.f);
}

+ (CGFloat)firstUserTopWithWidth:(CGFloat)width {
    CGFloat ratio = 375.f / width;
    return (60.f + 12.f / ratio);
}

+ (CGFloat)secondUserTopWithWidth:(CGFloat)width {
    CGFloat ratio = 375.f / width;
    return (60 + 64.f / ratio);
}

+ (CGFloat)thirdUserTopWithWidth:(CGFloat)width {
    CGFloat ratio = 375.f / width;
    return (60 + 88.f / ratio);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.musicView];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName {
    self.imageView.image = [UIImage imageNamed_sy:imageName];
}

- (void)setMusicImageName:(NSString *)imageName {
    self.musicView.image = [UIImage imageNamed_sy:imageName];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat ratio = 375.f / 227.f;
        CGFloat height = self.sy_width / ratio;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.sy_height - height, self.sy_width, height)];
    }
    return _imageView;
}

- (UIImageView *)musicView {
    if (!_musicView) {
        CGFloat width = 148.f;
        CGFloat height = 82.f;
        _musicView = [[UIImageView alloc] initWithFrame:CGRectMake((self.sy_width - width) / 2.f, 0, width, height)];
    }
    return _musicView;
}

- (void)setUserViews:(NSArray <SYLeaderBoardUserView *>*)userViews {
    for (UIView *view in self.viewArray) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in userViews) {
        [self addSubview:view];
    }
    self.viewArray = userViews;
}

@end
