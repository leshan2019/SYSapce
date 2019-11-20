//
//  SYUtil.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/10.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYUtil : NSObject

+ (UIImage *)imageFromColor:(UIColor *)color; // size(1,1)
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

// 根据颜色绘制圆形图片
+ (UIImage *)circleImageFromColor:(UIColor *)color size:(CGSize)size;

+ (NSUInteger)ageWithBirthdayString:(NSString *)birthday;

// 身份证有效性检查
+ (BOOL)checkChinaCitizenIDCardsIsValid:(NSString *)idcard;

// 判断身份证年龄是否已满足age要求
+ (BOOL)checkChinaCitizenIdCard:(NSString *)idcard greaterThanAge:(NSInteger)age;

/**
 *  字节 转 M|G
 *  1928982B 转 12M/12G
 */
+ (NSString *)fileSizeWithInteger:(NSUInteger)size;

/**
 *  "1992-01-18" 转 "1992年01月18日"
 */
+ (NSString *)formatBirthdayWithStr:(NSString *)birthday;

/**
 *  压缩图片到指定大小
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage withTargetSize:(CGSize)targetSize;

// 生成信息体占位图
+ (UIImage *)placeholderImageWithSize:(CGSize)size;

// 120s - > @”02:00“ - 适用于60分钟内
+ (NSString *)getTimeStrWithSeconds:(NSInteger)seconds;

// 转为“00:00:00”
+ (NSString *)getHMSTimeStrWithSeconds:(NSInteger)seconds;

+ (void)getVideoLocalUrl:(PHAsset *)asset block:(void(^)(NSURL *))success;

// 获取文件的大小
+ (CGFloat)getFileSize:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
