

#import <UIKit/UIKit.h>
#import "SYCategoryIndicatorProtocol.h"
@class SYCategoryCollectionView;

@protocol SYCategoryCollectionViewGestureDelegate <NSObject>
@optional
- (BOOL)categoryCollectionView:(SYCategoryCollectionView *)collectionView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)categoryCollectionView:(SYCategoryCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end

@interface SYCategoryCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <UIView<SYCategoryIndicatorProtocol> *> *indicators;
@property (nonatomic, weak) id<SYCategoryCollectionViewGestureDelegate> gestureDelegate;

@end
