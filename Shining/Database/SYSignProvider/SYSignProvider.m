//
//  SYSignProvider.m
//  Shining
//
//  Created by Zhang Qigang on 2019/3/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSignProvider.h"

@implementation SYSignProvider
+ (instancetype) shared {
    static dispatch_once_t onceToken;
    static SYSignProvider* _shared;
    dispatch_once(&onceToken, ^{
        _shared = [[SYSignProvider alloc] init];
    });
    
    return _shared;
}


- (NSString* _Nullable) signOfDateString: (NSString*) string {
    NSInteger md = [self parseDate: string];
    if (md == 0) {
        return nil;
    } else {
        return [self signOfMonthDay: md];
    }
}

- (NSInteger) parseDate: (NSString*) date {
    NSScanner* scanner = [NSScanner scannerWithString: date];
    NSInteger year = 0;
    NSInteger month = 0;
    NSInteger day = 0;
    [scanner scanInteger: &year];
    [scanner scanString: @"-" intoString: nil];
    [scanner scanInteger: &month];
    [scanner scanString: @"-" intoString: nil];
    [scanner scanInteger: &day];
    
    return month * 100 + day;
}

- (NSString*) signOfMonthDay: (NSInteger) md {
    if (md >= 321 && md <= 420) {
        return @"白羊座";
    } else if (md >= 421 && md <= 520) {
        return @"金牛座";
    } else if (md >= 521 && md <= 621) {
        return @"双子座";
    } else if (md >= 622 && md <= 722) {
        return @"巨蟹座";
    } else if (md >= 723 && md <= 822) {
        return @"狮子座";
    } else if (md >= 823 && md <= 922) {
        return @"处女座";
    } else if (md >= 923 && md <= 1022) {
        return @"天称座";
    } else if (md >= 1023 && md <= 1121) {
        return @"天蝎座";
    } else if (md >= 1122 && md <= 1221) {
        return @"射手座";
    } else if (md >= 1222 && md <= 1231) {
        return @"摩羯座";
    } else if (md >= 0 && md <= 119) {
        return @"摩羯座";
    } else if (md >= 120 && md <= 218) {
        return @"水瓶座";
    } else if (md >= 219 && md <= 320) {
        return @"双鱼座";
    } else {
        return nil;
    }
}
@end
