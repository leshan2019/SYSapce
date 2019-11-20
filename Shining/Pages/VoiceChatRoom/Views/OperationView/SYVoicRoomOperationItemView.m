//
//  SYVoicRoomOperationItemView.m
//  Shining
//
//  Created by 杨玄 on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoicRoomOperationItemView.h"
#import "SYPageControl.h"

#define itemWidth 46
#define itemHeight 46

@interface SYVoicRoomOperationItemView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) operationClick clickBlock;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SYPageControl *pageControl;
@property (nonatomic, strong) NSTimer *scrollTimer;     // 自动滚动timer
@property (nonatomic, assign) NSUInteger currentIndex;  // 索引
@property (nonatomic, assign) NSUInteger itemCount;     // 总数

@property (nonatomic, assign) BOOL scrollByDrag;        // 手动拖动

@end

@implementation SYVoicRoomOperationItemView

- (instancetype)initWithFrame:(CGRect)frame withItems:(NSArray *)items withClickBlock:(operationClick)click {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.items = items;
    self.clickBlock = click;
    return self;
}

#pragma mark - Private

- (void)setItems:(NSArray *)items {
    _items = items;
    if (items && items.count > 0) {
        self.itemCount = items.count;
        SYVoiceRoomOperationViewModel *model = nil;
        if (self.itemCount == 1) {
            model = [items objectAtIndex:0];
            UIImageView *imageView = [UIImageView new];
            imageView.userInteractionEnabled = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake((self.sy_width - itemWidth) / 2.0f, 0, itemWidth, itemHeight);
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.iconURL] placeholderImage:[SYUtil placeholderImageWithSize:imageView.sy_size]];
            [self.scrollView addSubview:imageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(handleClickItem)];
            [imageView addGestureRecognizer:tap];
            [self addSubview:imageView];
            self.currentIndex = 0;
        } else {
            self.currentIndex = 1;
            [self addSubview:self.scrollView];
            NSInteger totalCount = self.itemCount + 2;
            CGFloat leftMargin = (self.sy_width - itemWidth) / 2.0f;
            for (int i = 0; i < totalCount; i++) {
                model = [items objectAtIndex:[self realIndex: i]];
                UIImageView *imageView = [UIImageView new];
                imageView.userInteractionEnabled = YES;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.frame = CGRectMake(leftMargin, 0, itemWidth, itemHeight);
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.iconURL] placeholderImage:[SYUtil placeholderImageWithSize:imageView.sy_size]];
                [self.scrollView addSubview:imageView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleClickItem)];
                [imageView addGestureRecognizer:tap];
                leftMargin += self.sy_width;
            }
            [self addSubview:self.pageControl];
            self.pageControl.numberOfPages = self.itemCount;
            self.pageControl.currentPage = 0;
            self.scrollView.contentSize = CGSizeMake(self.sy_width * totalCount, self.sy_height);
            [self.scrollView setContentOffset:CGPointMake(self.currentIndex *self.sy_width, 0)];
            [self startTimer];
        }
    } else {
        self.itemCount = 0;
    }
}

- (NSUInteger)realIndex:(NSUInteger)currentIndex {
    if (self.itemCount == 1) {
        return currentIndex;
    }
    if (currentIndex == 0) {
        return self.itemCount - 1;
    }
    if (currentIndex == self.itemCount + 1) {
        return 0;
    }
    return currentIndex - 1;
}

- (NSUInteger)scrollToIndexWithNoAnimation:(NSUInteger)currentIndex {
    if (self.itemCount == 1) {
        return currentIndex;
    }
    if (currentIndex == 0) {
        return self.itemCount;
    }
    if (currentIndex == self.itemCount + 1) {
        return 1;
    }
    return currentIndex;
}

#pragma mark - click

- (void)handleClickItem {
    SYVoiceRoomOperationViewModel *model = [self.items objectAtIndex:[self realIndex:self.currentIndex]];
    if (self.clickBlock) {
        self.clickBlock(model);
    }
}

#pragma mark - Timer

- (void)startTimer {
    [self stopTimer];
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.f
                                                  target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.scrollTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if ([self.scrollTimer isKindOfClass:[NSTimer class]] &&
        [self.scrollTimer isValid]) {
        [self.scrollTimer invalidate];
    }
    self.scrollTimer = nil;
}

- (void)timerAction:(id)sender {
    NSUInteger scrollToIndex = self.currentIndex + 1;
    [self.scrollView setContentOffset:CGPointMake(scrollToIndex * self.scrollView.sy_width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollByDrag) {
        CGFloat floatIndex = scrollView.contentOffset.x / scrollView.sy_width;
        BOOL leftScroll = floatIndex >= self.currentIndex;
        if (leftScroll) {
            NSInteger newIndex = floorf(floatIndex);
            if (self.currentIndex != newIndex) {
                scrollView.panGestureRecognizer.enabled = NO;
                self.scrollByDrag = NO;
                self.currentIndex = newIndex;
                NSUInteger scrollToIndex = [self scrollToIndexWithNoAnimation:newIndex];
                self.pageControl.currentPage = [self realIndex:scrollToIndex];
                if (newIndex != scrollToIndex) {
                    [self.scrollView setContentOffset:CGPointMake(scrollToIndex * self.scrollView.sy_width, 0) animated:NO];
                    self.currentIndex = scrollToIndex;
                }
            }
        } else {
            if (floatIndex <= self.currentIndex - 1) {
                scrollView.panGestureRecognizer.enabled = NO;
                NSInteger newIndex = --self.currentIndex;
                NSUInteger scrollToIndex = [self scrollToIndexWithNoAnimation:newIndex];
                self.pageControl.currentPage = [self realIndex:scrollToIndex];
                if (newIndex != scrollToIndex) {
                    [self.scrollView setContentOffset:CGPointMake(scrollToIndex * self.scrollView.sy_width, 0) animated:NO];
                    self.currentIndex = scrollToIndex;
                }
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.scrollTimer && self.itemCount > 1) {
        [self startTimer];
    }
    NSUInteger index = scrollView.contentOffset.x / scrollView.sy_width;
    NSUInteger scrollToIndex = [self scrollToIndexWithNoAnimation:index];
    self.pageControl.currentPage = [self realIndex:scrollToIndex];
    if (index != scrollToIndex) {
        [self.scrollView setContentOffset:CGPointMake(scrollToIndex * self.scrollView.sy_width, 0) animated:NO];
    }
    self.currentIndex = scrollToIndex;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.scrollByDrag = YES;
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.scrollByDrag = NO;
    scrollView.panGestureRecognizer.enabled = YES;
    [self startTimer];
}

#pragma mark - Lazyload

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (SYPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[SYPageControl alloc] initWithFrame:CGRectMake(0, 50, self.sy_width, 5)];
        _pageControl.enabled = NO;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.space = 5;
        UIImage *activeImage = [SYUtil circleImageFromColor:RGBACOLOR(255, 255, 255, 0.8) size:CGSizeMake(5, 5)];
        UIImage *inactiveImage = [SYUtil circleImageFromColor:RGBACOLOR(186,192,197,0.5) size:CGSizeMake(5, 5)];
        [_pageControl refreshPageControlActiveImage:activeImage inactiveImage:inactiveImage];
    }
    return _pageControl;
}

@end
