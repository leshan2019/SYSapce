

#import "SYCategoryIndicatorComponentView.h"

@implementation SYCategoryIndicatorComponentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _componentPosition = SYCategoryComponentPosition_Bottom;
        _scrollEnabled = YES;
        _verticalMargin = 0;
        _scrollAnimationDuration = 0.25;
        _indicatorWidth = SYCategoryViewAutomaticDimension;
        _indicatorWidthIncrement = 0;
        _indicatorHeight = 3;
        _indicatorCornerRadius = SYCategoryViewAutomaticDimension;
        _indicatorColor = [UIColor redColor];
        _scrollStyle = SYCategoryIndicatorScrollStyleSimple;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSAssert(NO, @"Use initWithFrame");
    }
    return self;
}

- (CGFloat)indicatorWidthValue:(CGRect)cellFrame {
    if (self.indicatorWidth == SYCategoryViewAutomaticDimension) {
        return cellFrame.size.width + self.indicatorWidthIncrement;
    }
    return self.indicatorWidth + self.indicatorWidthIncrement;
}

- (CGFloat)indicatorHeightValue:(CGRect)cellFrame {
    if (self.indicatorHeight == SYCategoryViewAutomaticDimension) {
        return cellFrame.size.height;
    }
    return self.indicatorHeight;
}

- (CGFloat)indicatorCornerRadiusValue:(CGRect)cellFrame {
    if (self.indicatorCornerRadius == SYCategoryViewAutomaticDimension) {
        return [self indicatorHeightValue:cellFrame]/2;
    }
    return self.indicatorCornerRadius;
}

#pragma mark - SYCategoryIndicatorProtocol

- (void)sy_refreshState:(SYCategoryIndicatorParamsModel *)model {

}

- (void)sy_contentScrollViewDidScroll:(SYCategoryIndicatorParamsModel *)model {

}

- (void)sy_selectedCell:(SYCategoryIndicatorParamsModel *)model {
    
}

@end
