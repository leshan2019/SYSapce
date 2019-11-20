//
//  SYCustomUITextField.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/6/19.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYCustomUITextField.h"
@interface SYCustomUITextField()

@end

@implementation SYCustomUITextField

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width-55, bounds.size.height);//更好理解些
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width-55, bounds.size.height);
    return inset;
}

-(CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+20+bounds.size.width/3, bounds.origin.y, bounds.size.width, bounds.size.height);
    return inset;
}
@end
