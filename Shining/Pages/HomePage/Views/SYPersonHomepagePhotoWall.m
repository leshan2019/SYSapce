//
//  SYPersonHomepagePhotoWall.m
//  Shining
//
//  Created by 杨玄 on 2019/4/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepagePhotoWall.h"
#import "SYPersonHomepageCountView.h"

#define PhotoWallWidth __MainScreen_Width
#define PhotoWallHeight 200

@interface SYPersonHomepagePhotoWall ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView *lastImageView;
@property (nonatomic, strong) SYPersonHomepageCountView *countView;

@property (nonatomic, copy)   NSString *videoUrl;           // 视频url
@property (nonatomic, strong) UIButton *videoMask;          // 视频蒙层
@property (nonatomic, strong) UIImageView *videoPlayIcon;   // 视频playicon

@end

@implementation SYPersonHomepagePhotoWall

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.countView];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(46);
        }];
        [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 15));
            make.right.equalTo(self).with.offset(-15);
            make.bottom.equalTo(self).with.offset(-5);
        }];
    }
    return self;
}

- (void)updatePhotoWallWithPhotos:(NSArray<NSString *> *)photoArr videoImage:(nonnull NSString *)videoImageUrl videoUrl:(nonnull NSString *)videoUrl{
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self removeAllPhotos];
    self.videoUrl = videoUrl;
    NSMutableArray *mulPhotoArr = [NSMutableArray arrayWithArray:photoArr];
    BOOL hasVideo = ![NSString sy_isBlankString:videoImageUrl] && ![NSString sy_isBlankString:videoUrl];
    if (hasVideo) {
        [mulPhotoArr addObject:[NSString sy_safeString:videoImageUrl]];
    }
    if (mulPhotoArr.count == 0) {
        return;
    }
    NSString *photoUrl = @"";
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < mulPhotoArr.count; i++) {
        photoUrl = mulPhotoArr[i];
        UIImageView *photoImage = [UIImageView new];
        photoImage.clipsToBounds = YES;
        photoImage.contentMode = UIViewContentModeScaleAspectFill;
        [photoImage sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed_sy:@"homepage_photo_wall_default"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];
        [self.scrollView addSubview:photoImage];
        [photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            if (weakSelf.lastImageView) {
                make.left.equalTo(weakSelf.lastImageView.mas_right);
            } else {
                make.left.equalTo(weakSelf.scrollView);
            }
            make.top.equalTo(weakSelf.scrollView);
            make.size.mas_equalTo(CGSizeMake(self.scrollView.sy_width, self.scrollView.sy_height));
        }];
        self.lastImageView = photoImage;
        if (i == mulPhotoArr.count - 1 && hasVideo) {
            photoImage.userInteractionEnabled = YES;
            [photoImage addSubview:self.videoMask];
            [photoImage addSubview:self.videoPlayIcon];
            [self.videoMask mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(photoImage);
            }];
            [self.videoPlayIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(photoImage);
                make.size.mas_equalTo(CGSizeMake(44, 44));
            }];
        }
    }
    self.scrollView.contentSize = CGSizeMake(mulPhotoArr.count * self.scrollView.sy_width, self.scrollView.sy_height);
    self.pageControl.numberOfPages = mulPhotoArr.count;
    self.pageControl.currentPage = 0;
    if (mulPhotoArr.count <= 1) {
        self.countView.hidden = YES;
    } else {
        self.countView.hidden = NO;
        [self.countView updateCount:[NSString stringWithFormat:@"%d/%ld",1,mulPhotoArr.count]];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offX = scrollView.contentOffset.x;
    NSInteger num = offX/self.sy_width;
    self.pageControl.currentPage = num;
    [self.countView updateCount:[NSString stringWithFormat:@"%ld/%ld",(num+1),self.pageControl.numberOfPages]];
}

#pragma mark - PrivateMethod

// 移除所有照片
- (void)removeAllPhotos {
    for (UIView * subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    self.lastImageView = nil;
}

#pragma mark - LazyLoad

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.frame = self.bounds;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.currentPageIndicatorTintColor = RGBACOLOR(255,255,255,0.8);
        _pageControl.pageIndicatorTintColor = RGBACOLOR(255,255,255,0.3);
        _pageControl.hidesForSinglePage = YES;
        _pageControl.enabled = NO;
    }
    return _pageControl;
}

- (SYPersonHomepageCountView *)countView {
    if (!_countView) {
        _countView = [[SYPersonHomepageCountView alloc] initWithFrame:CGRectZero];
        _countView.layer.cornerRadius = 7;
    }
    return _countView;
}

- (UIButton *)videoMask {
    if (!_videoMask) {
        _videoMask = [UIButton new];
        _videoMask.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        [_videoMask addTarget:self action:@selector(handleVideoClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoMask;
}

- (UIImageView *)videoPlayIcon {
    if (!_videoPlayIcon) {
        _videoPlayIcon = [UIImageView new];
        _videoPlayIcon.image = [UIImage imageNamed_sy:@"homepage_dynamic_play"];
    }
    return _videoPlayIcon;
}

- (void)handleVideoClickEvent {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleSYPersonHomepagePhotoWallVideoClick:)]) {
        [self.delegate handleSYPersonHomepagePhotoWallVideoClick:self.videoUrl];
    }
}

@end
