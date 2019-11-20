//
//  SYPickerView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/17.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SYPickerView;

@protocol SYPickerViewDelegate <NSObject>

- (NSInteger)pickerView:(SYPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (nullable NSString *)pickerView:(SYPickerView *)pickerView titleForRow:(NSInteger)row;
- (void)pickerView:(SYPickerView *)pickerView didSelectRow:(NSInteger)row;

@end

@interface SYPickerView : UIView

@property (nonatomic, weak) id <SYPickerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
