//
//  SYDatePickerView.h
//  Shining
//
//  Created by 杨玄 on 2019/3/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYDatePickerViewDelegate <NSObject>

- (void)handleSYDatePickerViewCancelBtn;
- (void)handleSYDatePickerViewEnsureBtnWithDateStr:(NSString *)date;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 * 日期选择器 （1993-03-11）
 */
@interface SYDatePickerView : UIView

@property (nonatomic, weak) id<SYDatePickerViewDelegate> delegate;

/**
 *  默认显示@"2000-01-01"
 */
@property (nonatomic, copy) NSString *defaultDate;

@end

NS_ASSUME_NONNULL_END
