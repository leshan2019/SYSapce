//
//  SYImageCutter.m
//  Shining
//
//  Created by 杨玄 on 2019/5/15.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYImageCutter.h"

@implementation SYImageCutter

+ (UIImage *)cutOriginImageToMaxSize:(UIImage *)originImage maxSize:(CGSize)maxSize {
    UIImage *newimage;
    if (!originImage) {
        return nil;
    }
    if (maxSize.width == 0 || maxSize.height == 0) {
        return originImage;
    }
    CGSize originSize = originImage.size;
    CGRect finalRect;
    if (maxSize.width / maxSize.height > originSize.width / originSize.height) {
        finalRect.size.height = maxSize.height;
        finalRect.size.width = maxSize.height*originSize.width/originSize.height;
        finalRect.origin.x = (maxSize.width - finalRect.size.width)/2;
        finalRect.origin.y = 0;
    } else {
        finalRect.size.width = maxSize.width;
        finalRect.size.height = maxSize.width*originSize.height/originSize.width;
        finalRect.origin.x = 0;
        finalRect.origin.y = (maxSize.height - finalRect.size.height)/2;
    }
    UIGraphicsBeginImageContext(maxSize);
    [originImage drawInRect:finalRect];
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}


+(UIImage *)convertToCircleWithImage:(UIImage *)rectangleImage
                             onWidth:(CGFloat)width
                             onColor:(UIColor *)color
{
    
    CGFloat imageWidth = rectangleImage.size.width + 2 * width;
    CGFloat imageHeight = rectangleImage.size.height + 2 * width;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), NO, 0.0);
    
    UIGraphicsGetCurrentContext();
    
    CGFloat radius = (rectangleImage.size.width < rectangleImage.size.height
                      ? rectangleImage.size.width : rectangleImage.size.height) * 0.5;
    
    UIBezierPath *bezierPath = [UIBezierPath
                                bezierPathWithArcCenter:CGPointMake(imageWidth * 0.5, imageHeight * 0.5)
                                radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    bezierPath.lineWidth = width;
    [color setStroke];
    [bezierPath stroke];
    [bezierPath addClip];
    
    [rectangleImage drawInRect:CGRectMake(width, width, rectangleImage.size.width, rectangleImage.size.height)];
    
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return circleImage;
}

@end
