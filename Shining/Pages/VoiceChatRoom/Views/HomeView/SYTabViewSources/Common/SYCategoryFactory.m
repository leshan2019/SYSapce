

#import "SYCategoryFactory.h"
#import "UIColor+SYAdd.h"

@implementation SYCategoryFactory

+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat red = [self interpolationFrom:fromColor.sy_red to:toColor.sy_red percent:percent];
    CGFloat green = [self interpolationFrom:fromColor.sy_green to:toColor.sy_green percent:percent];
    CGFloat blue = [self interpolationFrom:fromColor.sy_blue to:toColor.sy_blue percent:percent];
    CGFloat alpha = [self interpolationFrom:fromColor.sy_alpha to:toColor.sy_alpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
