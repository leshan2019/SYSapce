//
//  UIColor+SYExtension.h
//  Shining
//
//  Created by letv_lzb on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SYExtension)

+(UIColor *)sy_colorWithHexString:(NSString *)hexString;
+(UIColor *)sy_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+(NSString *)sy_hexValuesFromUIColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
