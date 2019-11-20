//
//  NSString+SYHTTPExtensions.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/11.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "NSString+SYHTTPExtensions.h"
#import "NSObject+SYObjectEmpty.h"

@implementation NSString (SYHTTPExtensions)
- (BOOL)sy_isHTTPContentType:(NSString *)prefixStr
{
    BOOL    result;
    NSRange foundRange;
    
    result = NO;
    
    foundRange = [self rangeOfString:prefixStr options:NSAnchoredSearch | NSCaseInsensitiveSearch];
    if (foundRange.location != NSNotFound) {
        assert(foundRange.location == 0);
        if (foundRange.length == self.length) {
            result = YES;
        } else {
            unichar nextChar;
            
            nextChar = [self characterAtIndex:foundRange.length];
            result = nextChar <= 32 || nextChar >= 127 || (strchr("()<>@,;:\\<>/[]?={}", nextChar) != NULL);
        }
        
    }
    return result;
}
+ (BOOL)sy_isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if (    [string isEqual:nil]
        ||  [string isEqual:Nil]){
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (0 == [string length]){
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if([string isEqualToString:@"(null)"]){
        return YES;
    }
    
    return NO;
    
}


-(NSString *)sy_URLdecodeString {

    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];

    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,

                                                                                                                     (__bridge CFStringRef)self,

                                                                                                                     CFSTR(""),

                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));

    return decodedString;
}


- (NSString *)sy_URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                  (CFStringRef)[self mutableCopy],
                                                                                  NULL,
                                                                                  CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),
                                                                                  encoding));
}

- (NSString *)sy_URLEncodedString
{
    return [self sy_URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}

- (NSString *)sy_encodedURLString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,                   // characters to leave unescaped (NULL = all escaped sequences are replaced)
                                                                                             CFSTR("?=&+"),          // legal URL characters to be escaped (NULL = all legal characters are replaced)
                                                                                             kCFStringEncodingUTF8)); // encoding
    return result;
}
- (NSString *)sy_encodedURLParameterString {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (NSString *)sy_encodedURLParameterStringWithPoint {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR(":/=,!$&'()*+;[]@#?."),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (NSString *)sy_prp_URLEncodedFormStringUsingEncoding:(NSStringEncoding)enc {
    
    NSString *escapedStringWithSpaces = [self sy_prp_percentEscapedStringWithEncoding:enc
                                                              additionalCharacters:@"&=+"
                                                                 ignoredCharacters:nil];
    
    return escapedStringWithSpaces;
}

- (NSString *)sy_prp_percentEscapedStringWithEncoding:(NSStringEncoding)enc
                              additionalCharacters:(NSString *)add
                                 ignoredCharacters:(NSString *)ignore {
    
    CFStringEncoding convertedEncoding = CFStringConvertNSStringEncodingToEncoding(enc);
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 (CFStringRef)ignore,
                                                                                 (CFStringRef)add,
                                                                                 convertedEncoding));
}

- (NSString *)sy_subStringByRemoveMutableParams{
    
    NSString *strResult = [NSString stringWithString:self];
    
    NSArray *arrayMutableParams = @[@"markid", @"pcode", @"version"];
    NSArray *arraySeparatorPair = @[@"/",    // 静态地址参数连接符
                                    @"&"];
    NSArray *arraySeparatorKeyValueStr = @[@"/", // 静态地址参数/值连接符
                                           @"="];
    
    for (NSString *keyParams in arrayMutableParams){
        for (int i= 0; i < 2; i++) {
            NSString *strToRemove = @"";
            
            NSString *separatorPairStr = arraySeparatorPair[i];
            NSString *separatorKeyValueStr = arraySeparatorKeyValueStr[i];
            NSString *strKey = [NSString stringWithFormat:
                                @"%@%@%@",
                                separatorPairStr,
                                keyParams,
                                separatorKeyValueStr];
            NSRange rangeKey = [strResult rangeOfString:strKey];
            if (rangeKey.length > 0) {
                NSString *strContainsKey = [strResult substringFromIndex:rangeKey.location];
                
                NSString *strAfterKey = [strContainsKey substringFromIndex:rangeKey.length];
                NSRange rangeEnd = [strAfterKey rangeOfString:separatorPairStr];
                if (rangeEnd.length > 0) {
                    strToRemove = [strContainsKey substringWithRange:NSMakeRange(0, rangeKey.length + rangeEnd.location)];
                }
                else{
                    strToRemove = strContainsKey;
                }
                if (![NSString sy_isBlankString:strToRemove]) {
                    NSRange rangeMove = [strResult rangeOfString:strToRemove];
                    strResult = [NSString stringWithFormat:
                                 @"%@%@",
                                 [strResult substringToIndex:rangeMove.location],
                                 [strResult substringFromIndex:rangeMove.location + rangeMove.length]
                                 ];
                }
            }
            
        }
    }
    
    return strResult;
}

+ (NSString *)sy_replaceTmString:(NSString *)originURL TmValue:(NSString *)tmValue
{
    if ([NSString sy_isBlankString:originURL]) {
        return @"";
    }
    NSArray *array =[originURL componentsSeparatedByString:@"&"];
    if (array.count<=0) {
        return originURL;
    }
    BOOL isFound = NO;
    for(NSString *str in array){
        NSRange range =[str rangeOfString:@"tm"];
        if (range.location!=NSNotFound) {
            NSString *tarStr =[NSString stringWithFormat:@"tm=%@",tmValue];
            originURL =[originURL stringByReplacingOccurrencesOfString:str withString:tarStr];
            isFound = YES;
            break;
        }
    }
    if (!isFound){
        originURL = [originURL stringByAppendingFormat:@"&tm=%@",tmValue];
    }
    return originURL;
    
}

+ (NSString *)sy_replaceString:(NSString *)originURL keyword:(NSString *)keyword toValue:(NSString *)toValue {
    if ([NSString sy_empty:keyword] || [NSString sy_empty:toValue]) {
        return originURL;
    }
    
    
    NSString *keywordTemp = [NSString stringWithFormat:@"%@=", keyword];
    
    NSArray *array =[originURL componentsSeparatedByString:@"&"];
    if (array.count <= 0) {
        return originURL;
    }
    
    BOOL isFound = NO;
    
    for (NSString *str in array) {
        NSRange range = [str rangeOfString:keywordTemp];
        if (range.location != NSNotFound) {
            NSString *tarStr =[NSString stringWithFormat:@"%@%@", keywordTemp, toValue];
            originURL =[originURL stringByReplacingOccurrencesOfString:str withString:tarStr];
            isFound = YES;
            break;
        }
    }
    
    if (!isFound){
        originURL = [originURL stringByAppendingFormat:@"&%@%@", keywordTemp, toValue];
    }
    
    return originURL;
}

@end
