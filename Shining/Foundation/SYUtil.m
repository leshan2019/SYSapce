//
//  SYUtil.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYUtil.h"

@implementation SYUtil

+ (UIImage *)imageFromColor:(UIColor *)color {
    return [self imageFromColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)circleImageFromColor:(UIColor *)color size:(CGSize)size{
    UIImage *tempImage = [SYUtil imageFromColor:color size:size];
    UIGraphicsBeginImageContextWithOptions(size, NO, 2);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(ref, rect);
    CGContextClip(ref);
    [tempImage drawInRect:rect];
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return circleImage;
}

+ (NSUInteger)ageWithBirthdayString:(NSString *)birthday {
    if (!birthday) {
        return 20;
    }
    NSArray *birthArray = [birthday componentsSeparatedByString:@"-"];
    if ([birthArray count] != 3) {
        return 20;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *today = [formatter stringFromDate:[NSDate date]];
    NSArray *todayArray = [today componentsSeparatedByString:@"-"];
    if ([todayArray count] == 3) {
        NSString *year = todayArray[0];
        NSString *month = todayArray[1];
        NSString *day = todayArray[2];
        
        NSString *birthYear = birthArray[0];
        NSString *birthMonth = birthArray[1];
        NSString *birthDay = birthArray[2];
        
        NSInteger ret = [year integerValue] - [birthYear integerValue] - 1;
        if ([month integerValue] > [birthMonth integerValue]) {
            ret ++;
        } else if ([month integerValue] == [birthMonth integerValue]) {
            if ([day integerValue] > [birthDay integerValue]) {
                ret ++;
            }
        }
        return ret;
    }
    return 0;
}

+ (BOOL)checkChinaCitizenIDCardsIsValid:(NSString *)idcard {
    NSString *value = [idcard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if (!value) {
        return NO;
    } else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length != 15 && length != 18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }
    if (!areaFlag) {
        return NO;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;

    int year = 0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6, 2)].intValue + 1900;
            if (year %4 == 0 || (year %100 == 0 && year %4 == 0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];
            } else {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"options:NSRegularExpressionCaseInsensitive error:nil];
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            if (numberofMatch > 0) {
                return YES;
            } else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6, 4)].intValue;
            if (year %4 == 0 || (year %100 == 0 && year %4 == 0)) {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];
            } else {
                //测试出生日期的合法性
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$" options:NSRegularExpressionCaseInsensitive error:nil];
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];

            if (numberofMatch > 0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                int S = [value substringWithRange:NSMakeRange(0, 1)].intValue * 7 + [value substringWithRange:NSMakeRange(10, 1)].intValue * 7 + [value substringWithRange:NSMakeRange(1, 1)].intValue * 9 + [value substringWithRange:NSMakeRange(11, 1)].intValue * 9 + [value substringWithRange:NSMakeRange(2, 1)].intValue * 10 + [value substringWithRange:NSMakeRange(12, 1)].intValue * 10 + [value substringWithRange:NSMakeRange(3, 1)].intValue * 5 + [value substringWithRange:NSMakeRange(13, 1)].intValue * 5 + [value substringWithRange:NSMakeRange(4, 1)].intValue * 8 + [value substringWithRange:NSMakeRange(14, 1)].intValue * 8 + [value substringWithRange:NSMakeRange(5, 1)].intValue * 4 + [value substringWithRange:NSMakeRange(15,1)].intValue * 4 + [value substringWithRange:NSMakeRange(6, 1)].intValue * 2 + [value substringWithRange:NSMakeRange(16, 1)].intValue * 2 + [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 + [value substringWithRange:NSMakeRange(8, 1)].intValue * 6 + [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                //3：获取校验位
                M = [JYM substringWithRange:NSMakeRange(Y, 1)];
                NSString *lastStr = [value substringWithRange:NSMakeRange(17, 1)];
                NSLog(@"%@",M);
                NSLog(@"%@",[value substringWithRange:NSMakeRange(17, 1)]);
                //4：检测ID的校验位
                if ([lastStr isEqualToString:@"x"]) {
                    if ([M isEqualToString:@"X"]) {
                        return YES;
                    } else {
                        return NO;
                    }
                } else {
                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17, 1)]]) {
                        return YES;
                    } else {
                        return NO;
                    }
                }
            } else {
                return NO;
            }
        default:
            return NO;
    }
}

+ (BOOL)checkChinaCitizenIdCard:(NSString *)idcard greaterThanAge:(NSInteger)age {
    //年
    NSString *year = [idcard substringWithRange:NSMakeRange(6,4)];
    NSInteger birthdayYear = [year integerValue];
    //月
    NSString *month = [idcard substringWithRange:NSMakeRange(10,2)];
    NSInteger birthdayMonth = [month integerValue];
    //日
    NSString *day = [idcard substringWithRange:NSMakeRange(12,2)];
    NSInteger birthdayDay = [day integerValue];

    //获取当前时间，日期：
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSRange range0 = [dateString rangeOfString:@"/"];
    //年
    NSString *year0 = [dateString substringToIndex:range0.location];
    NSInteger nowYear = [year0 integerValue];
    //月
    NSString *month0 = [dateString substringWithRange:NSMakeRange(5, 2)];
    NSInteger nowMonth = [month0 integerValue];
    //日
    NSString *day0 = [dateString substringWithRange:NSMakeRange(8, 2)];
    NSInteger nowDay = [day0 integerValue];

    //年
    if (nowYear - birthdayYear < age){
        return NO;
    }else if (nowYear - birthdayYear == age){
        //月
        if (nowMonth < birthdayMonth){
            return NO;
        }else if (nowMonth == birthdayMonth){
            //日
            if (nowDay < birthdayDay){
                return NO;
            }
        }
    }
    return YES;
}

+ (NSString *)fileSizeWithInteger:(NSUInteger)size {
    if (size < 1024 * 1024 * 1024) {
        CGFloat aFloat = size/(1024.0f * 1024.0f);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    } else {
        CGFloat aFloat = size/(1024.0f * 1024.0f * 1024.0f);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

+ (NSString *)formatBirthdayWithStr:(NSString *)birthday {
    if ([NSString sy_isBlankString:birthday]) {
        return @"";
    }
    NSArray *dateArr = [birthday componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@年%@月%@日",[dateArr objectAtIndex:0],[dateArr objectAtIndex:1],[dateArr objectAtIndex:2]];
}

+ (UIImage *)compressImage:(UIImage *)sourceImage withTargetSize:(CGSize)targetSize {
    CGSize imageSize = sourceImage.size;
    CGFloat factorW = targetSize.width/imageSize.width;
    CGFloat factorH = targetSize.height/imageSize.height;
    CGFloat minFactor = MIN(factorW, factorH);
    if (minFactor > 1) {
        return sourceImage;
    }
    CGFloat finalWidth = imageSize.width*minFactor;
    CGFloat finalHeight = imageSize.height*minFactor;
    UIGraphicsBeginImageContext(CGSizeMake(finalWidth, finalHeight));
    [sourceImage drawInRect:CGRectMake(0,0, finalWidth, finalHeight)];
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)placeholderImageWithSize:(CGSize)size {
    NSString *logoName = @"entrance_placeholder";
    UIColor *_backgroundColor = [UIColor sam_colorWithHex:@"F2F2F2"];
    UIImage *image1 = [UIImage imageNamed_sy:logoName];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [_backgroundColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    CGFloat top = (size.height - image1.size.height) / 2.f;
    CGFloat left = (size.width - image1.size.width) / 2.f;
    [image1 drawInRect:CGRectMake(left, top, image1.size.width,image1.size.height)];
    UIImage *ZImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ZImage;
}

+ (NSString *)getTimeStrWithSeconds:(NSInteger)seconds {
    if (seconds <= 0) {
        return @"00:00";
    }
    NSInteger min = floorf(seconds / 60.f);
    NSInteger second = seconds % 60;
    NSString *minStr = @"00";
    if (min > 9) {
        minStr = [NSString stringWithFormat:@"%ld",min];
    } else {
        minStr = [NSString stringWithFormat:@"0%ld",min];
    }
    NSString *secondStr = @"00";
    if (second > 9) {
        secondStr = [NSString stringWithFormat:@"%ld",second];
    } else {
        secondStr = [NSString stringWithFormat:@"0%ld",second];
    }
    NSString *showTime = [NSString stringWithFormat:@"%@:%@",minStr,secondStr];
    return showTime;
}

+ (NSString *)getHMSTimeStrWithSeconds:(NSInteger)seconds {
    if (seconds <= 0) {
        return @"00:00:00";
    }
    
    NSInteger hour = seconds / 3600;
    NSString *hourStr = @"00";
    if (hour > 9) {
        hourStr = [NSString stringWithFormat:@"%ld",hour];
    } else {
        hourStr = [NSString stringWithFormat:@"0%ld",hour];
    }
    
    seconds -= hour * 3600;
    NSInteger min = floorf(seconds / 60.f);
    NSInteger second = seconds % 60;
    NSString *minStr = @"00";
    if (min > 9) {
        minStr = [NSString stringWithFormat:@"%ld",min];
    } else {
        minStr = [NSString stringWithFormat:@"0%ld",min];
    }
    
    NSString *secondStr = @"00";
    if (second > 9) {
        secondStr = [NSString stringWithFormat:@"%ld",second];
    } else {
        secondStr = [NSString stringWithFormat:@"0%ld",second];
    }
    NSString *showTime = [NSString stringWithFormat:@"%@:%@:%@",hourStr,minStr,secondStr];
    return showTime;
}

+ (void)getVideoLocalUrl:(PHAsset *)asset block:(void(^)(NSURL *))success {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:asset
                                options:options
                          resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                          // asset 类型为 AVURLAsset  为此资源的fileURL
                          // <AVURLAsset: 0x283386e60, URL = file:///var/mobile/Media/DCIM/100APPLE/IMG_0049.MOV>
                            AVURLAsset *urlAsset = (AVURLAsset *)asset;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (success) {
                                    success(urlAsset.URL);
                                }
                            });
                        }];
    });
}

+ (CGFloat)getFileSize:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

@end
