//
//  NSString+SYExtension.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/11.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+SYHTTPExtensions.h"

@interface NSString (SYStringExtensions)
- (NSString *)sy_trim;
- (NSString *)sy_subStringBegin:(NSString *)beginStr end:(NSString *)endStr;
- (NSString *)sy_subStringTrimEnd:(NSString *)endStr;
- (NSString *)sy_substringFromString:(NSString *)str;
- (NSString *)sy_substringToString:(NSString *)str;
+ (NSString*)sy_safeString:(NSString*)srcStr;
+ (NSString*)sy_safeStringForStatistic:(NSString*)srcStr;
- (NSString *)sy_stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters;
- (BOOL)sy_isHaveFoundString:(NSString *)str;
- (CGSize)sy_costomSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode;
- (CGSize)sy_adaptSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode;
- (CGSize)sy_adaptSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)mode lineSpacing:(CGFloat)lineSpacing;
+ (NSString *)sy_solveNumberFormatter:(NSString *)channelId;
+(NSString*)sy_getCodeStrWithIphoneStr:(NSString*)iphoneCode  withIpadStr:(NSString*)ipadCode;
//获取tablist缓存跟目录
+(NSString*)sy_getTabListCachePath;
+(NSString*)sy_getNewStringWithStrs:(NSArray*)strs;
+ (NSString*)sy_getPreferredLanguage;
+(NSString *)sy_getLangCode:(NSString *)lang;//根据手机设置语言获得语种编码
+(NSString *)sy_getAudioTrackCode:(NSString *)lang;//根据手机设置语言获得音轨编码

// 从webview加载的地址解析出vid
+ (NSString *)sy_getVidFromWebUrlString:(NSString*)urlString;
+ (NSString *)sy_getAppIdFromAdUrlString:(NSString *)adUrlString;

+ (NSDictionary *)sy_dictionaryWithJsonString:(NSString *)jsonString;
@end
