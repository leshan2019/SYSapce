//
//  NSString+SYExtension.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/11.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "NSString+SYExtension.h"
#import "NSObject+SYObjectEmpty.h"

#define CC_MD5_DIGEST_LENGTH    16            /* digest length in bytes */
#define CC_MD5_BLOCK_BYTES        64            /* block size in bytes */
#define CC_MD5_BLOCK_LONG       (CC_MD5_BLOCK_BYTES / sizeof(CC_LONG))

@implementation NSString (SYStringExtensions)

- (NSString *)sy_trim
{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}

- (NSString *)sy_subStringBegin:(NSString *)beginStr end:(NSString *)endStr{
    NSRange range1 = [self rangeOfString:beginStr options:NSCaseInsensitiveSearch];
    NSRange range2 = [self rangeOfString: endStr options:NSCaseInsensitiveSearch];
    
    if (range1.location == NSNotFound || range2.location == NSNotFound)
    {
        return nil;
    }
    
    NSRange range3 = {range1.location + range1.length, range2.location - range1.location - range1.length };
    NSString *key = [self substringWithRange: range3];
    
    return [key sy_trim];
}

- (NSString *)sy_subStringTrimEnd:(NSString *)endStr{
    NSRange range = [self rangeOfString:endStr options:NSCaseInsensitiveSearch | NSBackwardsSearch];
    if (range.location == NSNotFound)
    {
        return nil;
    }
    
    NSRange rangeKey = {0, range.location};
    NSString *key = [self substringWithRange:rangeKey];
    
    //    return [key trim];
    return key;
}

- (NSString *)sy_substringFromString:(NSString *)str{
    
    NSRange range = [self rangeOfString:str options:NSCaseInsensitiveSearch];
    if (range.location == NSNotFound)
    {
        return nil;
    }
    
    NSInteger tIndex = range.location + range.length;
    
    return [self substringFromIndex:tIndex];
    
}

- (NSString *)sy_substringToString:(NSString *)str{
    
    NSRange range = [self rangeOfString:str options:NSCaseInsensitiveSearch];
    if (range.location == NSNotFound)
    {
        return nil;
    }
    
    NSInteger tIndex = range.location;
    
    if (tIndex < 0) {
        return @"";
    }
    
    return [self substringToIndex:tIndex];
    
}

+ (NSString*)sy_safeString:(NSString*)srcStr{
    
    if ([NSObject sy_empty:srcStr]) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@", srcStr];
    
}


+ (NSString*)sy_safeStringForStatistic:(NSString*)srcStr{
    
    if ([NSObject sy_empty:srcStr]) {
        return @"-";
    }
    
    return [NSString stringWithFormat:@"%@", srcStr];
    
}


- (NSString *)sy_stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]];
    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}

- (NSString *)sy_stringByTrimmingLeadingWhitespaceAndNewlineCharacters {
    return [self sy_stringByTrimmingLeadingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)sy_stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:rangeOfLastWantedCharacter.location + 1]; // Non-inclusive
}

- (NSString *)sy_stringByTrimmingTrailingWhitespaceAndNewlineCharacters {
    return [self sy_stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)sy_stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters {
    return [[self sy_stringByTrimmingLeadingWhitespaceAndNewlineCharacters]
            sy_stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
}
- (BOOL)sy_isHaveFoundString:(NSString *)str
{
    if ([NSString sy_isBlankString:self]) {
        return NO;
    }
    if ([NSString sy_isBlankString:self] && [NSString sy_isBlankString:str]) {
        return YES;
    }
    if ([self rangeOfString:str].location == NSNotFound) {
        return NO;
    }
    return YES;
}
- (CGSize)sy_costomSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode{
    CGSize retSize=CGSizeZero;
    CGRect rect=[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    retSize=rect.size;
    
    return retSize;
}

- (CGSize)sy_adaptSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode{
    CGSize retSize=CGSizeZero;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = mode;
    
    CGRect rect=[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:style} context:nil];
    retSize=rect.size;
    
    return retSize;
}

- (CGSize)sy_adaptSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode lineSpacing:(CGFloat)lineSpacing {
    CGSize retSize=CGSizeZero;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = mode;
    style.lineSpacing = lineSpacing;
    
    CGRect rect=[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:style} context:nil];
    retSize=rect.size;
    
    return retSize;
}

+ (NSString *)sy_solveNumberFormatter:(NSString *)channelId{
    if ([NSString sy_isBlankString:channelId]) {
        return @"";
    }
    NSInteger  channelIdInt =  [channelId integerValue];
    int   k = 1;
    while (channelIdInt/10 >= 1) {
        k++;
        channelIdInt = channelIdInt/10;
        
    }
    if(k == 1){
        return [NSString stringWithFormat:@"0%d",channelIdInt];
    }
    else{
        return channelId;
    }
    
}

+ (NSDictionary *)sy_dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
