//
//  UILabel+SYAutoWidthAndHeight.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/3/18.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "UILabel+SYAutoWidthAndHeight.h"

@implementation UILabel (SYAutoHeightAndWidth)
+ (CGFloat)sy_getHeightByWidth:(CGFloat)width title:(NSString*)title font:(UIFont*)font
{
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0,0, width,0)];
    label.text= title;
    label.font= font;
    label.numberOfLines=0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)sy_getWidthWithTitle:(NSString*)title font:(UIFont*)font {
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,1000,0)];
    label.text= title;
    label.font= font;
    [label sizeToFit];
    return label.frame.size.width;
}

@end
