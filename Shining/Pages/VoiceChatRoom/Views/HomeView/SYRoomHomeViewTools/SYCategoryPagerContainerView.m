//
//  MyPagerContainerView.m
//  MyCollectionView
//
//  Created by leeco on 2019/10/21.
//  Copyright © 2019 letv. All rights reserved.
//

#import "SYCategoryPagerContainerView.h"
#import "SYCategoryPageCollectionView.h"
#import "SYCategoryBgTableView.h"
@interface SYCategoryPagerContainerView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) SYCategoryPageCollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end
@implementation SYCategoryPagerContainerView
- (instancetype)initWithDelegate:(id<SYCategoryPageContainerViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _delegate = delegate;
        [self initializeViews];
    }
    return self;
}
- (void)initializeViews {
    
    [self addSubview:self.collectionView];
}
- (SYCategoryPageCollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        SYCategoryPageCollectionView * myCollectionView= [[SYCategoryPageCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        myCollectionView.showsHorizontalScrollIndicator = NO;
        myCollectionView.showsVerticalScrollIndicator = NO;
        myCollectionView.pagingEnabled = YES;
        myCollectionView.scrollsToTop = NO;
        myCollectionView.bounces = NO;
        myCollectionView.delegate = self;
        myCollectionView.dataSource = self;
        [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        if (@available(iOS 10.0, *)) {
            myCollectionView.prefetchingEnabled = NO;
        }
        if (@available(iOS 11.0, *)) {
            myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView = myCollectionView;
    }
    return _collectionView;
}
- (void)layoutSubviews {
    [super layoutSubviews];

    self.collectionView.frame = self.bounds;
    if (self.selectedIndexPath != nil && [self.delegate pageContainer_numberOfRowsInListContainerView:self] >= self.selectedIndexPath.item + 1) {
        [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}
- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate pageContainer_numberOfRowsInListContainerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIView *listView = [self.delegate pageContainer_listContainerView:self listViewInRow:indexPath.item];
    listView.frame = cell.bounds;
    [cell.contentView addSubview:listView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate pageContainer_listContainerView:self willDisplayCellAtRow:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate pageContainer_listContainerView:self didEndDisplayingCellAtRow:indexPath.item];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.mainTableView.scrollEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.mainTableView.scrollEnabled = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.mainTableView.scrollEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isTracking || scrollView.isDecelerating) {
        self.mainTableView.scrollEnabled = NO;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}
@end
