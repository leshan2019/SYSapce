//
//  MyPageCollectionView.m
//  MyCollectionView
//
//  Created by leeco on 2019/10/21.
//  Copyright © 2019 letv. All rights reserved.
//

#import "SYCategoryPageCollectionView.h"

@implementation SYCategoryPageCollectionView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.gestureDelegate && [self.gestureDelegate respondsToSelector:@selector(pageCollectionViewGestureRecognizerShouldBegin:gestureRecognizer:)]) {
        return [self.gestureDelegate pageCollectionViewGestureRecognizerShouldBegin:self gestureRecognizer:gestureRecognizer];
    }else {
        if (self.isNestEnabled) {
            if ([gestureRecognizer isMemberOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
                CGFloat velocityX = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view].x;
                //x大于0就是往右滑
                if (velocityX > 0) {
                    if (self.contentOffset.x == 0) {
                        return NO;
                    }
                }else if (velocityX < 0) {
                    //x小于0就是往左滑
                    if (self.contentOffset.x + self.bounds.size.width == self.contentSize.width) {
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.gestureDelegate && [self.gestureDelegate respondsToSelector:@selector(pageCollectionViewGestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [self.gestureDelegate pageCollectionViewGestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    return  NO;
}

@end
