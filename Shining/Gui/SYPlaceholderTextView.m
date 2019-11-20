//
//  SYPlaceholderTextView.m
//  Shining
//
//  Created by mengxiangjian on 2019/3/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPlaceholderTextView.h"

@interface SYPlaceholderTextView () <UITextViewDelegate>

@property (nonatomic, assign) NSInteger limitedLength;
@property (nonatomic, assign) BOOL hasContent;
@property(nonatomic, strong)UILabel *placeHolder;

@end

@implementation SYPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame
            limitedTextLength:(NSInteger)limitedTextLength {
    self = [super initWithFrame:frame];
    if (self) {
        _hasContent = NO;
        _limitedLength = limitedTextLength;
        self.textColor = [UIColor sam_colorWithHex:@"#999999"];
        self.font = [UIFont systemFontOfSize:12];
//        self.text = [NSString stringWithFormat:@"%ld个字以内",(long)limitedTextLength];
        self.delegate = self;
        [self addSubview:self.placeHolder];
//        self.returnKeyType = UIReturnKeyDone;
    }
    return self;
}


// 给textView添加一个UILabel子控件
- (UILabel *)placeHolder {
    if (!_placeHolder) {
        _placeHolder =  [[UILabel alloc] initWithFrame:CGRectMake(4, 6, self.bounds.size.width, 20)];
        _placeHolder.text =  [NSString stringWithFormat:@"%ld个字以内",(long)self.limitedLength];
        _placeHolder.textColor = [UIColor sam_colorWithHex:@"#999999"];
        _placeHolder.font =  [UIFont systemFontOfSize:12];
        _placeHolder.numberOfLines = 0;
        _placeHolder.contentMode = UIViewContentModeTopLeft;
        _placeHolder.backgroundColor = [UIColor clearColor];
    }
    return _placeHolder;
}

- (void)setPlaceholderFont:(UIFont *)font
                 textColor:(UIColor *)textColor
                      text:(NSString *)text {
    self.placeHolder.font = font;
    self.placeHolder.textColor = textColor;
    self.placeHolder.text = text;
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    if (delegate != self) {
        return;
    }
    [super setDelegate:delegate];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    if ([textView.text isEqualToString:[NSString stringWithFormat:@"%ld个字以内",(long)self.limitedLength]]) {
//        textView.text = @"";
//    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(placeholderTextViewDidBeginEditingWithTextView:)]) {
        [self.textDelegate placeholderTextViewDidBeginEditingWithTextView:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSString *content = textView.text;
//    if ([NSString sy_isBlankString:textView.text]) {
//        textView.text = [NSString stringWithFormat:@"%ld个字以内",(long)self.limitedLength];
//        content = @"";
//    }
    
    self.hasContent = ![NSString sy_isBlankString:content];
    
    if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(placeholderTextView:didFinishWithText:)]) {
        [self.textDelegate placeholderTextView:self
                             didFinishWithText:content];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *content = textView.text;
//    if ([NSString sy_isBlankString:textView.text]) {
//        textView.text = [NSString stringWithFormat:@"%ld个字以内",(long)self.limitedLength];
//        content = @"";
//    }
    if (!textView.text.length) {
        self.placeHolder.alpha = 1;
    } else {
        self.placeHolder.alpha = 0;
    }
    self.hasContent = ![NSString sy_isBlankString:content];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *otext = [[NSMutableString alloc] initWithString:textView.text];
    [otext replaceCharactersInRange:range withString:text];
    if (otext.length > self.limitedLength) {
        if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textViewDidOutLimitedLength:limitedTextLength:)]) {
            [self.textDelegate textViewDidOutLimitedLength:self limitedTextLength:self.limitedLength];
        }
        return NO;
    }
    NSLog(@"动态发布已输入：%lu",(unsigned long)otext.length);
    return YES;
}

@end
