//
//  MyPageCollectionView.h
//  MyCollectionView
//
//  Created by leeco on 2019/10/21.
//  Copyright © 2019 letv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SYCategoryPageCollectionView;
@protocol MyPageCollectionViewGestureDelegate <NSObject>
@optional
- (BOOL)pageCollectionViewGestureRecognizerShouldBegin:(SYCategoryPageCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)pageCollectionViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end
@interface SYCategoryPageCollectionView : UICollectionView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isNestEnabled;
@property (nonatomic, weak) id<MyPageCollectionViewGestureDelegate> gestureDelegate;
@end

