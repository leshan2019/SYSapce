//
//  UIImage+SYBunldeImg.m
//  ShiningSdk
//
//  Created by letv_lzb on 2019/4/10.
//  Copyright © 2019 leshan. All rights reserved.
//

#import "UIImage+SYBunldeImg.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (SYBunldeImg)
/*
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSEL = @selector(imageNamed_sy:);
        SEL objectSEL = @selector(imageNamed_sy:);
        Class objectClass = self;
        Method originalMethod = class_getClassMethod(objectClass, originalSEL);
        Method replaceMethod = class_getClassMethod(objectClass, objectSEL);
        if (originalMethod == NULL || replaceMethod == NULL) {
            NSLog(@"\n.\tWarning! SY_ExchangeClassMethod 失败!  [%@及其SuperClasses] 均未实现方法 [%@]\n.",objectClass,originalMethod == NULL ? NSStringFromSelector(originalSEL) : NSStringFromSelector(objectSEL));
            return;
        }
        /// 交换实例方法的写法在这失效了，所以直接进行了method_exchangeImplementations，待研究
        method_exchangeImplementations(originalMethod, replaceMethod);
    });
}
 */

+ (UIImage *)imageNamed_sy:(NSString *)name  {
#ifdef ShiningSdk
    NSString *tempName = name;
    if (![name hasPrefix:@"ShiningResource.bundle"]) {
        tempName = [NSString stringWithFormat:@"ShiningResource.bundle/%@",name];
    }
    UIImage *image = [self imageNamed:tempName];
    if (image == nil) {
        image = [self imageNamed:name];
    }
    if (image == nil) {
        NSLog(@"\nWarning! 图片加载失败!  imageName:%@",name);
    }
    return image;
#else
    return [self imageNamed:name];
#endif
}

+ (UIImage *)gifImageNamed_sy:(NSString *)name {
#ifdef ShiningSdk
    NSString *tempName = name;
    if (![name hasPrefix:@"ShiningResource.bundle"]) {
        tempName = [NSString stringWithFormat:@"ShiningResource.bundle/%@",name];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:tempName
                                                     ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    if (image == nil) {
        NSLog(@"\nWarning! GIF加载失败!  imageName:%@",name);
    }
    return image;
#else
    NSDataAsset *fireAsset = [[NSDataAsset alloc] initWithName:name];
    UIImage *image = [UIImage sd_animatedGIFWithData:fireAsset.data];
    return image;
#endif
}
/**
 *  根据图片url获取网络图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    
    if (imageSourceRef) {
        
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        
        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}
@end
