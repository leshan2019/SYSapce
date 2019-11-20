//
//  SYVerticalPageView.m
//  ShiningBed
//
//  Created by Zhang Qigang on 2019/11/11.
//  Copyright © 2019 Zhang Qigang. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "SYVerticalPageView.h"

@interface SYVerticalPageView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, assign, readwrite) NSInteger currentPageIndex;
@property (nonatomic, assign, readwrite) NSInteger nextPageIndex;

@property (nonatomic, assign, readonly) CGRect currentVisibleRect;

@property (nonatomic, strong) NSMutableArray* dequeuePages;
@property (nonatomic, strong) Class pageClass;
@property (nonatomic, assign, readwrite) NSInteger maxCountOfPages;

// 缓存当前 visible 的 pages
@property (nonatomic, strong) NSMutableDictionary* workingRangePages;

@property (nonatomic, strong)  UIView* currentPageView;

@property (nonatomic, assign) BOOL isDragging;
@end

@implementation SYVerticalPageView
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self addSubview: self.scrollView];
        CGRect r = self.bounds;
        _currentPageIndex = -1;
        self.scrollView.frame = r;
        [self setupUI];
    }
    return self;
}

- (void) setFrame: (CGRect) frame {
    [super setFrame: frame];
    self.scrollView.frame = self.bounds;
    CGRect r = self.currentVisibleRect;
    if (self.maxCountOfPages > 0) {
        CGFloat width = r.size.width;
        CGFloat height = r.size.height;
        [self.scrollView setContentSize: CGSizeMake(width, height * self.maxCountOfPages)];
        // 重新计算布局
        [self.workingRangePages enumerateKeysAndObjectsUsingBlock:^(NSNumber* key, UIView* obj, BOOL * _Nonnull stop) {
            NSInteger index = [key integerValue];
            obj.frame = CGRectMake(0, index * height, width, height);
        }];
    }
}

- (void) registerClass:(Class)pageClass {
    self.pageClass = pageClass;
}

- (UIView*) dequeueReusablePage {
    UIView* view = [self.dequeuePages lastObject];
    if (view) {
        [self.dequeuePages removeObject: view];
        return view;
    }
    
    Class klass = self.pageClass;
    if (klass == nil) {
        @throw [NSException exceptionWithName: @"page class not found" reason: @"page class not found" userInfo: nil];
        return nil;
    } else {
        view = [[klass alloc] initWithFrame: CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
        // TODO: set view's identifier
        return view;
    }
}

- (UIView*) getPageWithIndex: (NSInteger) index {
    if ([self.delegate respondsToSelector: @selector(verticalPageView:pageAtIndex:)]) {
        return [self.delegate verticalPageView: self pageAtIndex: index];
    } else {
        @throw [NSException exceptionWithName: @"Can't create page" reason: @"no delegate" userInfo: nil];
        return nil;
    }
}

- (void) updateWorkrange: (NSArray*) indexes {
    CGRect visibleRect = self.currentVisibleRect;
    CGFloat height = visibleRect.size.height;
    CGFloat width = visibleRect.size.width;
    
    for (NSNumber* n in indexes) {
        if ([self.workingRangePages objectForKey: n] != nil) {
            // 有 View， 不管
        } else {
            NSInteger index = [n integerValue];
            UIView* view = [self getPageWithIndex: index];
            view.frame = CGRectMake(0, height * index, width,  height);
            [self.scrollView addSubview: view];
            [self.workingRangePages setObject: view forKey: n];
        }
    }
    NSMutableArray* keys = [NSMutableArray arrayWithArray: [self.workingRangePages allKeys]];
    [keys removeObjectsInArray: indexes];
    
    [self.workingRangePages enumerateKeysAndObjectsUsingBlock:^(NSNumber* key, UIView* obj, BOOL * _Nonnull stop) {
        if ([indexes containsObject: key]) {
        } else {
            [self.dequeuePages addObject: obj];
            [obj removeFromSuperview];
        }
    }];
    [self.workingRangePages removeObjectsForKeys: keys];
}

- (void) setupUI {
    CGRect visibleRect = self.currentVisibleRect;
    CGFloat height = visibleRect.size.height;
    CGFloat width = visibleRect.size.width;
    
    if ([self.delegate respondsToSelector: @selector(numberOfPagesInPageView:)]) {
        self.maxCountOfPages = [self.delegate numberOfPagesInPageView: self];
    } else {
        self.maxCountOfPages = 0;
    }
    
    if (self.maxCountOfPages > 0) {
        NSInteger index = self.currentPageIndex;
        if (index < 0) {
            index = 0;
        }
        
        [self.scrollView setContentSize: CGSizeMake(width, height * self.maxCountOfPages)];
        if (index >= 0 && index < self.maxCountOfPages) {
            [self updateWorkrange: @[@(index)]];
            self.currentPageIndex = index;
        }
    }
}

#pragma mark -

- (void) reloadData {
    [self setupUI];
}

- (void) setCurrentPageIndex: (NSInteger) index animated: (BOOL) animated {
    // 滚动到某个页面。设置 visibleRect
    CGRect visibleRect = self.currentVisibleRect;
    CGFloat height = visibleRect.size.height;
    CGFloat width = visibleRect.size.width;
    [self.scrollView scrollRectToVisible: CGRectMake(0, height * index, width, height) animated: animated];
    self.currentPageIndex = index;
}

- (void) setDelegate: (id<SYVerticalPageViewDelegate>) delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        [self setupUI];
    }
}

#pragma mark -

#pragma mark getter
- (NSMutableArray*) dequeuePages {
    if (!_dequeuePages) {
        NSMutableArray* a = [NSMutableArray arrayWithCapacity: 4];
        _dequeuePages = a;
    }
    return _dequeuePages;
}

- (NSMutableDictionary*) workingRangePages {
    if (!_workingRangePages) {
        NSMutableDictionary* d = [NSMutableDictionary dictionaryWithCapacity: 4];
        _workingRangePages = d;
    }
    return _workingRangePages;
}
- (UIScrollView*) scrollView {
    
    if (!_scrollView) {
        UIScrollView* pageView = [[UIScrollView alloc] initWithFrame: CGRectZero];
        pageView.delegate = self;
        pageView.scrollsToTop = NO;
        pageView.showsVerticalScrollIndicator = NO;
        pageView.showsHorizontalScrollIndicator = NO;
        pageView.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            pageView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView = pageView;
    }
    
    return _scrollView;
}


- (CGRect) currentVisibleRect {
    return CGRectApplyAffineTransform(self.scrollView.bounds, CGAffineTransformMakeScale(1.0 / self.scrollView.zoomScale, 1.0 / self.scrollView.zoomScale));
}

#pragma mark setter
- (void) setCurrentPageIndex: (NSInteger) currentPageIndex {
    if (_currentPageIndex != currentPageIndex) {
        NSInteger oldIndex = _currentPageIndex;
        _currentPageIndex = currentPageIndex;
        
        if (currentPageIndex >= 0 && [self.delegate respondsToSelector: @selector(verticalPageView:didDisplayPage:atIndex:)]) {
            UIView* view = [self.workingRangePages objectForKey: @(currentPageIndex)];
            [self.delegate verticalPageView: self didDisplayPage: view atIndex: currentPageIndex];
        }
        if (oldIndex >=0 && [self.delegate respondsToSelector: @selector(verticalPageView:didEndDisplayPage: atIndex:)]) {
            UIView* view = [self.workingRangePages objectForKey: @(oldIndex)];
            [self.delegate verticalPageView: self didEndDisplayPage: view atIndex: oldIndex];
        }
    }
}

- (void) setNextPageIndex: (NSInteger) nextPageIndex {
    if (_nextPageIndex != nextPageIndex) {
        if (nextPageIndex >= 0 && [self.delegate respondsToSelector: @selector(verticalPageView:willDisplayPage:atIndex:)]) {
            UIView* view = [self.workingRangePages objectForKey: @(nextPageIndex)];
            [self.delegate verticalPageView: self willDisplayPage: view atIndex: nextPageIndex];
        }
        
        if (_nextPageIndex >= 0 && [self.delegate respondsToSelector: @selector(verticalPageView:willEndDisplayPage:atIndex:)]) {
            UIView* view = [self.workingRangePages objectForKey: @(_nextPageIndex)];
            [self.delegate verticalPageView: self willEndDisplayPage: view atIndex: _nextPageIndex];
        }
        _nextPageIndex = nextPageIndex;
    }
}

- (void) setIsDragging: (BOOL) isDragging {
    if (_isDragging != isDragging) {
        _isDragging = isDragging;
        if (_isDragging && [self.delegate respondsToSelector: @selector(verticalPageViewWillBeginDragging:)]) {
            [self.delegate performSelector: @selector(verticalPageViewWillBeginDragging:) withObject: self];
        }
        if (!_isDragging && [self.delegate respondsToSelector: @selector(verticalPageViewDidEndDragging:)]) {
            [self.delegate performSelector: @selector(verticalPageViewDidEndDragging:) withObject: self];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDragging = YES;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGRect visibleRect = self.currentVisibleRect;
        CGFloat height = visibleRect.size.height;
        self.currentPageIndex = floor((visibleRect.origin.y - height / 2) / height) + 1;
        
        self.isDragging = NO;
        // 结束切换 结束检查
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect visibleRect = self.currentVisibleRect;
    CGFloat height = visibleRect.size.height;
    NSInteger index = self.currentPageIndex;
    NSInteger next = index;
    NSInteger index1 = visibleRect.origin.y / height;
    NSInteger index2 = (visibleRect.origin.y + visibleRect.size.height) / height;
    
    // 加载两个 view / 缓存等
    //NSLog(@"loading: %ld, %ld", index1, index2);
    NSMutableSet* set = [NSMutableSet setWithCapacity: 3];
    if (index1 >= 0 && index1 < self.maxCountOfPages) {
        [set addObject: @(index1)];
    }
    
    if (index2 >= 0 && index2 < self.maxCountOfPages) {
        [set addObject: @(index2)];
    }
    
    if (index >= 0 && index < self.maxCountOfPages) {
        [set addObject: @(index)];
    }
    
    NSArray* indexes = set.allObjects;
    [self updateWorkrange: indexes];

    if (index1 == index || index2 == index) {
        // TODO: 优化, 这里存在连续滑动，不能使用这种方式.
        next = (index1 == index ? index2 : index1);
        next = next < 0 ? -1 : (next < ((NSInteger) self.maxCountOfPages - 1) ? next : -1);
        self.nextPageIndex = next;
    } else {
        //NSLog(@"?????");
    }
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGRect visibleRect = self.currentVisibleRect;
    CGFloat height = visibleRect.size.height;
    self.currentPageIndex = floor((visibleRect.origin.y + height / 2) / height);
    NSLog(@"decelerate: %ld", self.currentPageIndex);
    self.isDragging = NO;
}
@end
