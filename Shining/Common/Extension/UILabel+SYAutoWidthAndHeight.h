//
//  UILabel+SYAutoWidthAndHeight.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UILabel(SYAutoHeightAndWidth)
+ (CGFloat)sy_getHeightByWidth:(CGFloat)width title:(NSString*)title font:(UIFont*)font;
+ (CGFloat)sy_getWidthWithTitle:(NSString*)title font:(UIFont*)font;
@end
