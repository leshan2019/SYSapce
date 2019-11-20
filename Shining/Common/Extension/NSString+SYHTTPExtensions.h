//
//  NSString+SYHTTPExtensions.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/11.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SYHTTPExtensions)
- (BOOL)sy_isHTTPContentType:(NSString *)prefixStr;
+ (BOOL)sy_isBlankString:(NSString *)string;
- (NSString *)sy_URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
- (NSString *)sy_URLEncodedString;
- (NSString *)sy_encodedURLString;
- (NSString *)sy_encodedURLParameterString;
- (NSString *)sy_encodedURLParameterStringWithPoint;
- (NSString *)sy_prp_URLEncodedFormStringUsingEncoding:(NSStringEncoding)enc;
- (NSString *)sy_prp_percentEscapedStringWithEncoding:(NSStringEncoding)enc
                              additionalCharacters:(NSString *)add
                                 ignoredCharacters:(NSString *)ignore;
- (NSString *)sy_subStringByRemoveMutableParams;
+ (NSString *)sy_replaceTmString:(NSString *)originURL TmValue:(NSString *)tmValue;
+ (NSString *)sy_getNewURL:(NSString *)originalUrl tmValue:(NSString *)tmValue streamId:(NSString *)streamId;

- (NSString *)sy_URLdecodeString;

@end
