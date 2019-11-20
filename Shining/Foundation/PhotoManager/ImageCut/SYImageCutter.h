//
//  SYImageCutter.h
//  Shining
//
//  Created by 杨玄 on 2019/5/15.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYImageCutter : NSObject

// 裁剪原图到给定尺寸
+ (UIImage *)cutOriginImageToMaxSize:(UIImage *)originImage maxSize:(CGSize)maxSize;

/* 裁剪图变成圆形
   @parma:rectangleImage 原图
   @parma:width 裁剪后的border
   @parma:width 裁剪后的color
*/
+(UIImage *)convertToCircleWithImage:(UIImage *)rectangleImage
                             onWidth:(CGFloat)width
                             onColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
