

#import "SYCategoryIndicatorCell.h"
#import "SYCategoryViewDefines.h"
@class SYCategoryTitleCellModel;

@interface SYCategoryTitleCell : SYCategoryIndicatorCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *maskTitleLabel;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterX;
@property (nonatomic, strong) NSLayoutConstraint *titleLabelCenterY;
@property (nonatomic, strong) NSLayoutConstraint *maskTitleLabelCenterX;

- (SYCategoryCellSelectedAnimationBlock)preferredTitleZoomAnimationBlock:(SYCategoryTitleCellModel *)cellModel baseScale:(CGFloat)baseScale;

- (SYCategoryCellSelectedAnimationBlock)preferredTitleStrokeWidthAnimationBlock:(SYCategoryTitleCellModel *)cellModel attributedString:(NSMutableAttributedString *)attributedString;

- (SYCategoryCellSelectedAnimationBlock)preferredTitleColorAnimationBlock:(SYCategoryTitleCellModel *)cellModel;

@end
