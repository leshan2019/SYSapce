//
//  NSMutableAttributedString+SYAttrStr.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/28.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SYAttributedInsertType) {
    SYAttributedInsertTypeFirst,
    SYAttributedInsertTypeLast
};

@interface NSMutableAttributedString (SYAttrStr)
///文本最前面或最后面插入图片
- (instancetype)initWithImageName:(NSString *)imageName andStringWithContentString:(NSString *)contentString andWithAttributedInsertType:(SYAttributedInsertType) type andLabel:(UILabel *)label;
///文本最前面或最后面插入图片
+ (instancetype)attributedWithImageName:(NSString *)imageName andStringWithContentString:(NSString *)contentString andWithAttributedInsertType:(SYAttributedInsertType) type andLabel:(UILabel *)label;
///发送图片
- (instancetype)initWithImg:(UIImage *)image;
///发送图片
+ (instancetype)attributedWithImg:(UIImage *)image;

///回复内容改变指定文字的颜色
- (instancetype)initwithColorString:(NSString *)colorString andColor:(UIColor *)color andContentString:(NSString *)contentString;
///回复内容改变指定文字的颜色
+ (instancetype)attributedWithColorString:(NSString *)colorString Color:(UIColor *)color andContentString:(NSString *)contentString;
///根据文字内容修改指定的文字的颜色
- (instancetype)initwithContent:(NSString *)content andColor:(UIColor *)color andColorString:(NSString *)colorString;
///根据文字内容修改指定的文字的颜色
+ (instancetype)attributedWithContent:(NSString *)content andColor:(UIColor *)color andColorString:(NSString *)colorString;
@end

NS_ASSUME_NONNULL_END

//用于调整副本显示的位置
@interface SYTextAttachment : NSTextAttachment

@end

@interface NSString (SYEmoji)
///带图的文本内容
- (NSAttributedString *)emojiAttributedString;
@end
