

#import <UIKit/UIKit.h>
#import "SYCategoryBaseCellModel.h"

@interface SYCategoryIndicatorCellModel : SYCategoryBaseCellModel

@property (nonatomic, assign, getter=isSepratorLineShowEnabled) BOOL sepratorLineShowEnabled;

@property (nonatomic, strong) UIColor *separatorLineColor;

@property (nonatomic, assign) CGSize separatorLineSize;

@property (nonatomic, assign) CGRect backgroundViewMaskFrame;   //底部指示器的frame转换到cell的frame

@property (nonatomic, assign, getter=isCellBackgroundColorGradientEnabled) BOOL cellBackgroundColorGradientEnabled;

@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;

@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;

@end
