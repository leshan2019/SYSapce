//
//  SYScrollSegmentedControl.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/1.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYScrollSegmentedControl : UIControl

- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray <NSString *>*)titleArray;

- (void)setBorderColor:(UIColor *)color;
- (void)setSelectedTitleColor:(UIColor *)color;

@property (nonatomic, assign) NSInteger selectedSegmentIndex; // 选中的index

@end

NS_ASSUME_NONNULL_END
