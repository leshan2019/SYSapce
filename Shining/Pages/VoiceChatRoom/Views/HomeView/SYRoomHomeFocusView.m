//
//  SYVoiceRoomHomeFocusView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYRoomHomeFocusView.h"
#import "SYPageControl.h"
#define kSYHomeFocusStartTag 323312

@interface SYRoomHomeFocusView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SYPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPositionIndex; // 初始为2
@property (nonatomic, assign) NSInteger totalFocusCount; // 全部的数量
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat spec;
@end

@implementation SYRoomHomeFocusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.spec = 13.f;
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.f
                                                  target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if ([self.timer isKindOfClass:[NSTimer class]] &&
        [self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)timerAction:(id)sender {
    NSInteger index = MIN(self.currentPositionIndex + 1, self.totalFocusCount + 3);
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.sy_width, 0) animated:YES];
}

- (void)reloadData {
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.scrollView setContentOffset:CGPointZero];
    if ([self.delegate respondsToSelector:@selector(homeFocusImageCount)]) {
        NSInteger count = [self.delegate homeFocusImageCount];
        if (count > 0 ) {
            if ([self.delegate respondsToSelector:@selector(homeFocusResetFrame)]) {
                [self.delegate homeFocusResetFrame];
            }
            self.totalFocusCount = count;
            self.pageControl.numberOfPages = count;
            self.currentPositionIndex = 0;
            NSInteger pageCount = count;
            if (count > 1) {
                [self startTimer];
                pageCount = count + 4;
                self.currentPositionIndex = 2;
            }
            self.scrollView.contentSize = CGSizeMake(self.scrollView.sy_width * pageCount, self.scrollView.sy_height);
                    
            CGFloat x = 0;
                    
            for (int i = 0; i < pageCount; i ++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, self.scrollView.sy_width, self.scrollView.sy_height)];
                imageView.clipsToBounds = YES;
                imageView.layer.cornerRadius = 6.f;
                if ([self.delegate respondsToSelector:@selector(homeFocusImageURLAtIndex:)]) {
                    NSString *url = [self.delegate homeFocusImageURLAtIndex:[self trueIndexWithPositionIndex:i]];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[SYUtil placeholderImageWithSize:imageView.sy_size]];
                }
                [self.scrollView addSubview:imageView];
                imageView.userInteractionEnabled = YES;
            //            imageView.tag = kSYHomeFocusStartTag + i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(tap:)];
                [imageView addGestureRecognizer:tap];
                x += self.scrollView.sy_width;
            }
            
            [self.scrollView setContentOffset:CGPointMake(self.currentPositionIndex * self.scrollView.sy_width, 0)
                                 animated:NO];
        
            if ([self.delegate respondsToSelector:@selector(homeFocusDidShowImageAtIndex:)]) {
                [self.delegate homeFocusDidShowImageAtIndex:0];
            }
            
        }else {
            if ([self.delegate respondsToSelector:@selector(homeFocusResetFrame)]) {
                [self.delegate homeFocusResetFrame];
            }
        }
    }
}
- (void)resetSpec:(CGFloat)newSpec{
    self.spec = newSpec;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(self.spec, 0, self.sy_width - self.spec*2, self.sy_height);
    self.pageControl.frame = CGRectMake(self.sy_width - 50, self.sy_height - 20.f, 50, 20.f);
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.spec, 0, self.sy_width - self.spec*2, self.sy_height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (SYPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[SYPageControl alloc] initWithFrame:CGRectMake(self.sy_width - 50, self.sy_height - 20.f, 50, 20.f)];
        _pageControl.enabled = NO;
        _pageControl.backgroundColor = [UIColor clearColor];
//        [_pageControl addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

//- (void)changeIndex:(id)sender {
//    [self.scrollView setContentOffset:CGPointMake(self.sy_width * self.pageControl.currentPage, 0) animated:YES];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.totalFocusCount > 1) {
        [self startTimer];
    }
    NSInteger index = scrollView.contentOffset.x / scrollView.sy_width;
    NSInteger trueIndex = [self trueIndexWithPositionIndex:index];
    self.pageControl.currentPage = trueIndex;
    NSInteger exchangeIndex = [self exchangePageWithPositionIndex:index];
    if (exchangeIndex != index) {
        [self.scrollView setContentOffset:CGPointMake(exchangeIndex * self.scrollView.sy_width, 0) animated:NO];
    }
    self.currentPositionIndex = exchangeIndex;
    
    if ([self.delegate respondsToSelector:@selector(homeFocusDidShowImageAtIndex:)]) {
        NSInteger trueIndex = [self trueIndexWithPositionIndex:self.currentPositionIndex];
        [self.delegate homeFocusDidShowImageAtIndex:trueIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)tap:(id)sender {
    NSInteger trueIndex = [self trueIndexWithPositionIndex:self.currentPositionIndex];
    if ([self.delegate respondsToSelector:@selector(homeFocusDidTapImageAtIndex:)]) {
        [self.delegate homeFocusDidTapImageAtIndex:trueIndex];
    }
}

#pragma mark - private

- (void)scrollToPage:(NSInteger)page {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.sy_width * page, 0) animated:YES];
    self.currentPositionIndex = page;
}

- (NSInteger)trueIndexWithPositionIndex:(NSInteger)positionIndex {
    if (self.totalFocusCount <= 1) {
        return positionIndex;
    }
    if (positionIndex == 0) {
        return self.totalFocusCount - 2;
    } else if (positionIndex == 1) {
        return self.totalFocusCount - 1;
    } else if (positionIndex == self.totalFocusCount + 2) {
        return 0;
    } else if (positionIndex == self.totalFocusCount + 3) {
        return 1;
    }
    return positionIndex - 2;
}

- (NSInteger)exchangePageWithPositionIndex:(NSInteger)positionIndex {
    if (self.totalFocusCount <= 1) {
        return positionIndex;
    }
    if (positionIndex == 0) {
        return self.totalFocusCount;
    } else if (positionIndex == 1) {
        return self.totalFocusCount + 1;
    } else if (positionIndex == self.totalFocusCount + 2) {
        return 2;
    } else if (positionIndex == self.totalFocusCount + 3) {
        return 3;
    }
    return positionIndex;
}

@end
