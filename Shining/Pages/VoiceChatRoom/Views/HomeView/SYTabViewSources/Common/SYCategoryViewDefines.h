

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const CGFloat SYCategoryViewAutomaticDimension = -1;

typedef void(^SYCategoryCellSelectedAnimationBlock)(CGFloat percent);

typedef NS_ENUM(NSUInteger, SYCategoryComponentPosition) {
    SYCategoryComponentPosition_Bottom,
    SYCategoryComponentPosition_Top,
};

// cell被选中的类型
typedef NS_ENUM(NSUInteger, SYCategoryCellSelectedType) {
    SYCategoryCellSelectedTypeUnknown,          //未知，不是选中（cellForRow方法里面、两个cell过渡时）
    SYCategoryCellSelectedTypeClick,            //点击选中
    SYCategoryCellSelectedTypeCode,             //调用方法`- (void)selectItemAtIndex:(NSInteger)index`选中
    SYCategoryCellSelectedTypeScroll            //通过滚动到某个cell选中
};

typedef NS_ENUM(NSUInteger, SYCategoryTitleLabelAnchorPointStyle) {
    SYCategoryTitleLabelAnchorPointStyleCenter,
    SYCategoryTitleLabelAnchorPointStyleTop,
    SYCategoryTitleLabelAnchorPointStyleBottom,
};

typedef NS_ENUM(NSUInteger, SYCategoryIndicatorScrollStyle) {
    SYCategoryIndicatorScrollStyleSimple,                   //简单滚动，即从当前位置过渡到目标位置
    SYCategoryIndicatorScrollStyleSameAsUserScroll,         //和用户左右滚动列表时的效果一样
};

#define SYCategoryViewDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)
