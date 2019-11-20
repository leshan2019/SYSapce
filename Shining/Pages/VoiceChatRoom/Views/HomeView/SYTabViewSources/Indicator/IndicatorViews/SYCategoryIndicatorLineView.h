

#import "SYCategoryIndicatorComponentView.h"

typedef NS_ENUM(NSUInteger, SYCategoryIndicatorLineStyle) {
    SYCategoryIndicatorLineStyle_Normal             = 0,
    SYCategoryIndicatorLineStyle_Lengthen           = 1,
    SYCategoryIndicatorLineStyle_LengthenOffset     = 2,
};

@interface SYCategoryIndicatorLineView : SYCategoryIndicatorComponentView

@property (nonatomic, assign) SYCategoryIndicatorLineStyle lineStyle;

/**
 line滚动时x的偏移量，默认为10；
 lineStyle为SYCategoryIndicatorLineStyle_LengthenOffset有用；
 */
@property (nonatomic, assign) CGFloat lineScrollOffsetX;

@end
