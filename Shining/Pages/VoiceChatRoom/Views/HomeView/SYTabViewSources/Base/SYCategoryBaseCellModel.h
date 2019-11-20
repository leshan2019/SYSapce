

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYCategoryViewDefines.h"

@interface SYCategoryBaseCellModel : NSObject

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, assign) CGFloat cellSpacing;

@property (nonatomic, assign, getter=isCellWidthZoomEnabled) BOOL cellWidthZoomEnabled;

@property (nonatomic, assign) CGFloat cellWidthNormalZoomScale;

@property (nonatomic, assign) CGFloat cellWidthCurrentZoomScale;

@property (nonatomic, assign) CGFloat cellWidthSelectedZoomScale;

@property (nonatomic, assign, getter=isSelectedAnimationEnabled) BOOL selectedAnimationEnabled;

@property (nonatomic, assign) NSTimeInterval selectedAnimationDuration;

@property (nonatomic, assign) SYCategoryCellSelectedType selectedType;

@property (nonatomic, assign, getter=isTransitionAnimating) BOOL transitionAnimating;

@end
