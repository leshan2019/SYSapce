

#import "SYCategoryIndicatorView.h"
#import "SYCategoryIndicatorBackgroundView.h"
#import "SYCategoryFactory.h"

@interface SYCategoryIndicatorView()

@end

@implementation SYCategoryIndicatorView

- (void)initializeData {
    [super initializeData];

    _separatorLineShowEnabled = NO;
    _separatorLineColor = [UIColor lightGrayColor];
    _separatorLineSize = CGSizeMake(1/[UIScreen mainScreen].scale, 20);
    _cellBackgroundColorGradientEnabled = NO;
    _cellBackgroundUnselectedColor = [UIColor whiteColor];
    _cellBackgroundSelectedColor = [UIColor lightGrayColor];
}

- (void)initializeViews {
    [super initializeViews];
}

- (void)setIndicators:(NSArray<UIView<SYCategoryIndicatorProtocol> *> *)indicators {
    _indicators = indicators;

    self.collectionView.indicators = indicators;
}

- (void)refreshState {
    [super refreshState];

    CGRect selectedCellFrame = CGRectZero;
    SYCategoryIndicatorCellModel *selectedCellModel = nil;
    for (int i = 0; i < self.dataSource.count; i++) {
        SYCategoryIndicatorCellModel *cellModel = (SYCategoryIndicatorCellModel *)self.dataSource[i];
        cellModel.sepratorLineShowEnabled = self.isSeparatorLineShowEnabled;
        cellModel.separatorLineColor = self.separatorLineColor;
        cellModel.separatorLineSize = self.separatorLineSize;
        cellModel.backgroundViewMaskFrame = CGRectZero;
        cellModel.cellBackgroundColorGradientEnabled = self.isCellBackgroundColorGradientEnabled;
        cellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        cellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        if (i == self.dataSource.count - 1) {
            cellModel.sepratorLineShowEnabled = NO;
        }
        if (i == self.selectedIndex) {
            selectedCellModel = cellModel;
            selectedCellFrame = [self getTargetCellFrame:i];
        }
    }

    for (UIView<SYCategoryIndicatorProtocol> *indicator in self.indicators) {
        if (self.dataSource.count <= 0) {
            indicator.hidden = YES;
        }else {
            indicator.hidden = NO;
            SYCategoryIndicatorParamsModel *indicatorParamsModel = [[SYCategoryIndicatorParamsModel alloc] init];
            indicatorParamsModel.selectedIndex = self.selectedIndex;
            indicatorParamsModel.selectedCellFrame = selectedCellFrame;
            [indicator sy_refreshState:indicatorParamsModel];

            if ([indicator isKindOfClass:[SYCategoryIndicatorBackgroundView class]]) {
                CGRect maskFrame = indicator.frame;
                maskFrame.origin.x = maskFrame.origin.x - selectedCellFrame.origin.x;
                selectedCellModel.backgroundViewMaskFrame = maskFrame;
            }
        }
    }
}

- (void)refreshSelectedCellModel:(SYCategoryBaseCellModel *)selectedCellModel unselectedCellModel:(SYCategoryBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    SYCategoryIndicatorCellModel *myUnselectedCellModel = (SYCategoryIndicatorCellModel *)unselectedCellModel;
    myUnselectedCellModel.backgroundViewMaskFrame = CGRectZero;
    myUnselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myUnselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;

    SYCategoryIndicatorCellModel *myselectedCellModel = (SYCategoryIndicatorCellModel *)selectedCellModel;
    myselectedCellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
    myselectedCellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
}

- (void)contentOffsetOfContentScrollViewDidChanged:(CGPoint)contentOffset {
    [super contentOffsetOfContentScrollViewDidChanged:contentOffset];
    
    CGFloat ratio = contentOffset.x/self.contentScrollView.bounds.size.width;
    if (ratio > self.dataSource.count - 1 || ratio < 0) {
        //超过了边界，不需要处理
        return;
    }
    ratio = MAX(0, MIN(self.dataSource.count - 1, ratio));
    NSInteger baseIndex = floorf(ratio);
    if (baseIndex + 1 >= self.dataSource.count) {
        //右边越界了，不需要处理
        return;
    }
    CGFloat remainderRatio = ratio - baseIndex;

    CGRect leftCellFrame = [self getTargetCellFrame:baseIndex];
    CGRect rightCellFrame = [self getTargetCellFrame:baseIndex + 1];

    SYCategoryIndicatorParamsModel *indicatorParamsModel = [[SYCategoryIndicatorParamsModel alloc] init];
    indicatorParamsModel.selectedIndex = self.selectedIndex;
    indicatorParamsModel.leftIndex = baseIndex;
    indicatorParamsModel.leftCellFrame = leftCellFrame;
    indicatorParamsModel.rightIndex = baseIndex + 1;
    indicatorParamsModel.rightCellFrame = rightCellFrame;
    indicatorParamsModel.percent = remainderRatio;
    if (remainderRatio == 0) {
        for (UIView<SYCategoryIndicatorProtocol> *indicator in self.indicators) {
            [indicator sy_contentScrollViewDidScroll:indicatorParamsModel];
        }
    }else {
        SYCategoryIndicatorCellModel *leftCellModel = (SYCategoryIndicatorCellModel *)self.dataSource[baseIndex];
        leftCellModel.selectedType = SYCategoryCellSelectedTypeUnknown;
        SYCategoryIndicatorCellModel *rightCellModel = (SYCategoryIndicatorCellModel *)self.dataSource[baseIndex + 1];
        rightCellModel.selectedType = SYCategoryCellSelectedTypeUnknown;
        [self refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:remainderRatio];

        for (UIView<SYCategoryIndicatorProtocol> *indicator in self.indicators) {
            [indicator sy_contentScrollViewDidScroll:indicatorParamsModel];
            if ([indicator isKindOfClass:[SYCategoryIndicatorBackgroundView class]]) {
                CGRect leftMaskFrame = indicator.frame;
                leftMaskFrame.origin.x = leftMaskFrame.origin.x - leftCellFrame.origin.x;
                leftCellModel.backgroundViewMaskFrame = leftMaskFrame;

                CGRect rightMaskFrame = indicator.frame;
                rightMaskFrame.origin.x = rightMaskFrame.origin.x - rightCellFrame.origin.x;
                rightCellModel.backgroundViewMaskFrame = rightMaskFrame;
            }
        }

        SYCategoryBaseCell *leftCell = (SYCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex inSection:0]];
        [leftCell reloadData:leftCellModel];
        SYCategoryBaseCell *rightCell = (SYCategoryBaseCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:baseIndex + 1 inSection:0]];
        [rightCell reloadData:rightCellModel];
    }
}

- (BOOL)selectCellAtIndex:(NSInteger)index selectedType:(SYCategoryCellSelectedType)selectedType {
    NSInteger lastSelectedIndex = self.selectedIndex;
    BOOL result = [super selectCellAtIndex:index selectedType:selectedType];
    if (!result) {
        return NO;
    }

    CGRect clickedCellFrame = [self getTargetSelectedCellFrame:index selectedType:selectedType];
    
    SYCategoryIndicatorCellModel *selectedCellModel = (SYCategoryIndicatorCellModel *)self.dataSource[index];
    selectedCellModel.selectedType = selectedType;
    for (UIView<SYCategoryIndicatorProtocol> *indicator in self.indicators) {
        SYCategoryIndicatorParamsModel *indicatorParamsModel = [[SYCategoryIndicatorParamsModel alloc] init];
        indicatorParamsModel.lastSelectedIndex = lastSelectedIndex;
        indicatorParamsModel.selectedIndex = index;
        indicatorParamsModel.selectedCellFrame = clickedCellFrame;
        indicatorParamsModel.selectedType = selectedType;
        [indicator sy_selectedCell:indicatorParamsModel];
        if ([indicator isKindOfClass:[SYCategoryIndicatorBackgroundView class]]) {
            CGRect maskFrame = indicator.frame;
            maskFrame.origin.x = maskFrame.origin.x - clickedCellFrame.origin.x;
            selectedCellModel.backgroundViewMaskFrame = maskFrame;
        }
    }

    SYCategoryIndicatorCell *selectedCell = (SYCategoryIndicatorCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [selectedCell reloadData:selectedCellModel];

    return YES;
}

@end

@implementation SYCategoryIndicatorView (UISubclassingIndicatorHooks)

- (void)refreshLeftCellModel:(SYCategoryBaseCellModel *)leftCellModel rightCellModel:(SYCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    if (self.isCellBackgroundColorGradientEnabled) {
        //处理cell背景色渐变
        SYCategoryIndicatorCellModel *leftModel = (SYCategoryIndicatorCellModel *)leftCellModel;
        SYCategoryIndicatorCellModel *rightModel = (SYCategoryIndicatorCellModel *)rightCellModel;
        if (leftModel.isSelected) {
            leftModel.cellBackgroundSelectedColor = [SYCategoryFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            leftModel.cellBackgroundUnselectedColor = [SYCategoryFactory interpolationColorFrom:self.cellBackgroundSelectedColor to:self.cellBackgroundUnselectedColor percent:ratio];
            leftModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
        if (rightModel.isSelected) {
            rightModel.cellBackgroundSelectedColor = [SYCategoryFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        }else {
            rightModel.cellBackgroundUnselectedColor = [SYCategoryFactory interpolationColorFrom:self.cellBackgroundUnselectedColor to:self.cellBackgroundSelectedColor percent:ratio];
            rightModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        }
    }

}

@end
