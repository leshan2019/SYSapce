//
//  NSMutableAttributedString+SYAttrStr.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "NSMutableAttributedString+SYAttrStr.h"

@implementation NSMutableAttributedString (SYAttrStr)
///文本插入图片
- (instancetype)initWithImageName:(NSString *)imageName andStringWithContentString:(NSString *)contentString andWithAttributedInsertType:(SYAttributedInsertType) type andLabel:(UILabel *)label {
    //根据附件生成富文本
    self = [[NSMutableAttributedString alloc] initWithString:contentString];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed_sy:imageName];
    //设置（图片）字体大小
    CGFloat attachmentH = label?label.font.lineHeight:15;
    attachment.bounds = CGRectMake(0, -3, 15, attachmentH);
    
    NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:attachment];
    if (type == SYAttributedInsertTypeFirst) {
        [self insertAttributedString:attString atIndex:0];
    } else {
        [self insertAttributedString:attString atIndex:contentString.length];
    }
    
    return self;
}
///文本插入图片
+ (instancetype)attributedWithImageName:(NSString *)imageName andStringWithContentString:(NSString *)contentString andWithAttributedInsertType:(SYAttributedInsertType) type andLabel:(UILabel *)label {
    return [[self alloc] initWithImageName:imageName andStringWithContentString:contentString andWithAttributedInsertType: type andLabel:label];
}
///发送图片
- (instancetype)initWithImg:(UIImage *)image {
    //根据附件生成富文本
    self = [[NSMutableAttributedString alloc] init];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    //设置（图片）字体大小
    NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [self insertAttributedString:attString atIndex:0];
    return self;
}
///发送图片
+ (instancetype)attributedWithImg:(UIImage *)image {
    return [[self alloc ] initWithImg:image];
}
///改变指定文字的颜色
- (instancetype)initwithColorString:(NSString *)colorString andColor:(UIColor *)color andContentString:(NSString *)contentString {
    NSString *ContentStr = [NSString stringWithFormat:@"%@:%@",colorString,contentString];
    
    NSMutableAttributedString *ContentAttStr = [[NSMutableAttributedString alloc] initWithString:ContentStr];
    NSRange range = [ContentStr rangeOfString:[NSString stringWithFormat:@"%@:",colorString]];
    [ContentAttStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return ContentAttStr;
}
///改变指定文字的颜色
+ (instancetype)attributedWithColorString:(NSString *)colorString Color:(UIColor *)color andContentString:(NSString *)contentString {
    return [[self alloc] initwithColorString:colorString andColor:color andContentString:contentString];
}

///根据文字内容修改指定的文字的颜色
- (instancetype)initwithContent:(NSString *)content andColor:(UIColor *)color andColorString:(NSString *)colorString {
    NSMutableAttributedString *ContentAttStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange range = [content rangeOfString:colorString];
    [ContentAttStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return ContentAttStr;
}
///根据文字内容修改指定的文字的颜色
+ (instancetype)attributedWithContent:(NSString *)content andColor:(UIColor *)color andColorString:(NSString *)colorString{
    return [[self alloc] initwithContent:content andColor:color andColorString:colorString];
}
@end

//根据Label的字体大小自适应图片的显示大小
@implementation SYTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    return CGRectMake(0,-lineFrag.size.height * 0.2, lineFrag.size.height,lineFrag.size.height);
}
@end

@implementation NSString (SYEmoji)
///带图的文本内容
- (NSAttributedString *)emojiAttributedString {
    NSArray *plistArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoticon.plist" ofType:nil]];
    
    //可变的属性文本
    NSMutableAttributedString *attContent = [[NSMutableAttributedString alloc] initWithString:self];
    
    //  1.通过正则表达式取出表情图片的名称
    NSString *pattern = @"\\[\\w+?\\]";
    NSError *error = nil;
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"%@",error);
        return attContent;
    }
    
    // 获的匹配结果
    //  __block NSString *emoticonName;
    
    NSArray<NSTextCheckingResult *> *results = [regx matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult *result in results) {
        NSString *resultStr = [self substringWithRange:result.range];
        
        [plistArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *desStr = obj[@"des"];
            //取出字符串对应的名字
            if ([desStr isEqualToString:resultStr]) {
                
                NSString *emoticonName = obj[@"name"];
                
                SYTextAttachment *attachment = [[SYTextAttachment alloc] init];
                attachment.image = [UIImage imageNamed_sy:[NSString stringWithFormat:@"%@@2x.gif",emoticonName]];
                
                NSAttributedString *emojiStr = [NSAttributedString attributedStringWithAttachment:attachment];
                
                [attContent replaceCharactersInRange:result.range withAttributedString:emojiStr];
            }
        }];
        
    }
    return attContent;
}
@end
