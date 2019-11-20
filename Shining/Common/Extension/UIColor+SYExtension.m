//
//  UIColor+SYExtension.m
//  Shining
//
//  Created by letv_lzb on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "UIColor+SYExtension.h"

@implementation UIColor (SYExtension)

/**
 hexString -> UIColor
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式

 @param hexString hexString  alpha:1.0
 @return UIColor
 */
+(UIColor *)sy_colorWithHexString:(NSString *)hexString
{
    return [self sy_colorWithHexString:hexString alpha:1.0f];

}



/**
 hexString -> UIColor
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 @param hexString hexString
 @param alpha alpha
 @return UIColor
 */
+(UIColor *)sy_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

/**
 UIColor -> @"ffffff"

 @param color <#color description#>
 @return <#return value description#>
 */
+(NSString *)sy_hexValuesFromUIColor:(UIColor *)color
{

    if (!color) {
        return nil;
    }

    if (color == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }

    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;

    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);

    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];

    return returnString;

}

@end
