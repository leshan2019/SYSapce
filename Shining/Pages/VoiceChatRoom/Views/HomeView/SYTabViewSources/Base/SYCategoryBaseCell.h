

#import <UIKit/UIKit.h>
#import "SYCategoryBaseCellModel.h"
#import "SYCategoryViewAnimator.h"
#import "SYCategoryViewDefines.h"

@interface SYCategoryBaseCell : UICollectionViewCell

@property (nonatomic, strong, readonly) SYCategoryBaseCellModel *cellModel;
@property (nonatomic, strong, readonly) SYCategoryViewAnimator *animator;

- (void)initializeViews NS_REQUIRES_SUPER;

- (void)reloadData:(SYCategoryBaseCellModel *)cellModel NS_REQUIRES_SUPER;

- (BOOL)checkCanStartSelectedAnimation:(SYCategoryBaseCellModel *)cellModel;

- (void)addSelectedAnimationBlock:(SYCategoryCellSelectedAnimationBlock)block;

- (void)startSelectedAnimationIfNeeded:(SYCategoryBaseCellModel *)cellModel;
@end
