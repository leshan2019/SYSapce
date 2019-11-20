//
//  SYPlaceholderTextView.h
//  Shining
//
//  Created by mengxiangjian on 2019/3/18.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYPlaceholderTextView;

@protocol SYPlaceholderTextViewDelegate <NSObject>

- (void)placeholderTextViewDidBeginEditingWithTextView:(SYPlaceholderTextView *)textView;
- (void)placeholderTextView:(SYPlaceholderTextView *)textView
          didFinishWithText:(NSString *)text;
- (void)textViewDidOutLimitedLength:(SYPlaceholderTextView *)textView
                  limitedTextLength:(NSInteger)limitedTextLength;

@end

@interface SYPlaceholderTextView : UITextView

@property (nonatomic, weak) id <SYPlaceholderTextViewDelegate> textDelegate;
@property (nonatomic, assign, readonly) BOOL hasContent;

- (instancetype)initWithFrame:(CGRect)frame
            limitedTextLength:(NSInteger)limitedTextLength;

- (void)setPlaceholderFont:(UIFont *)font
                 textColor:(UIColor *)textColor
                      text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
