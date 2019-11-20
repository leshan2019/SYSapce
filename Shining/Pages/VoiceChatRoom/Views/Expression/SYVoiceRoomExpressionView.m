//
//  SYVoiceRoomExpressionView.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/5.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomExpressionView.h"
#import "SYVoiceRoomExpressionViewModel.h"
#import "SYVoiceRoomExpressionCell.h"

@interface SYVoiceRoomExpressionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SYVoiceRoomExpressionViewModel *viewModel;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIView *disableView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SYVoiceRoomExpressionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewModel = [[SYVoiceRoomExpressionViewModel alloc] init];
        _viewArray = [NSMutableArray new];
//        [self addSubview:self.collectionView];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.disableView];
        _currentPage = 0;
    }
    return self;
}

- (UICollectionView *)collectionViewWithIndex:(NSInteger)index {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(index * self.scrollView.sy_width, 0, self.scrollView.sy_width, self.scrollView.sy_height)
                                         collectionViewLayout:layout];
    [_collectionView registerClass:[SYVoiceRoomExpressionCell class]
        forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    return _collectionView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, 150)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.sy_height - 10, self.sy_width, 10.f)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 1;
        _pageControl.enabled = NO;
        _pageControl.hidden = YES;
    }
    return _pageControl;
}

- (UIView *)disableView {
    if (!_disableView) {
        _disableView = [[UIView alloc] initWithFrame:self.bounds];
        _disableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        _disableView.hidden = YES;
    }
    return _disableView;
}

- (void)loadExpressions {
    
    [self.viewModel requestExpressionListWithBlock:^(BOOL success) {
        for (UIView *view in self.viewArray) {
            [view removeFromSuperview];
        }
        [self.viewArray removeAllObjects];
        
        NSInteger pageCount = [self.viewModel expressionPageCount];
        for (int i = 0; i < pageCount; i ++) {
            UICollectionView *collectionView = [self collectionViewWithIndex:i];
            [self.scrollView addSubview:collectionView];
            [self.viewArray addObject:collectionView];
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.sy_width * pageCount, self.scrollView.sy_height);
        
        if ([self.viewModel expressionPageCount] > 1) {
            self.pageControl.hidden = NO;
            self.pageControl.numberOfPages = [self.viewModel expressionPageCount];
            self.pageControl.currentPage = self.currentPage;
        } else {
            self.pageControl.hidden = YES;
        }
    }];
}

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f
                                                  target:self
                                                selector:@selector(timerAction:)
                                                userInfo:nil
                                                 repeats:NO];
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
    self.disableView.hidden = YES;
    [self stopTimer];
}

#pragma mark -

- (NSInteger)collectionViewPageWithCollectionView:(UICollectionView *)collectionView {
    return [self.viewArray indexOfObject:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger page = [self collectionViewPageWithCollectionView:collectionView];
    return [self.viewModel expressionCountWithPage:page];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger page = [self collectionViewPageWithCollectionView:collectionView];
    SYVoiceRoomExpressionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                                forIndexPath:indexPath];
    [cell showWithTitle:[self.viewModel expressionNameWithPage:page index:indexPath.item]
                   icon:[self.viewModel expressionIconWithPage:page index:indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(voiceRoomExpressionViewDidSelectExpressionWithId:)]) {
        NSInteger page = [self collectionViewPageWithCollectionView:collectionView];
        NSInteger expressionId = [self.viewModel expressionIdWithPage:page index:indexPath.item];
        if (expressionId > 0) {
            [self.delegate voiceRoomExpressionViewDidSelectExpressionWithId:expressionId];
            [self startTimer];
            self.disableView.hidden = NO;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.sy_width / (CGFloat)VoiceRoomExpressionCountPerRow;
    return CGSizeMake(width, collectionView.sy_height / 2.f);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.scrollView) {
        return;
    }
    NSInteger page = scrollView.contentOffset.x / scrollView.sy_width + 0.5;
    if (page != self.currentPage) {
        self.currentPage = page;
        self.pageControl.currentPage = self.currentPage;
    }
}

@end
