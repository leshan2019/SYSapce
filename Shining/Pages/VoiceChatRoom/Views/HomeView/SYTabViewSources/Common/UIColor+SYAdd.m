//
//  UIColor+SYAdd.m
//  UI系列测试
//


#import "UIColor+SYAdd.h"

@implementation UIColor (SYAdd)

- (CGFloat)sy_red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)sy_green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)sy_blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)sy_alpha {
    return CGColorGetAlpha(self.CGColor);
}

@end
