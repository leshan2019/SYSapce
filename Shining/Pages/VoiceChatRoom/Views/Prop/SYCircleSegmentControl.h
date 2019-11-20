//
//  SYCircleSegmentControl.h
//  Shining
//
//  Created by 杨玄 on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SYCircleSegmentControlBlock)(NSInteger postion);

NS_ASSUME_NONNULL_BEGIN

@interface SYCircleSegmentControl : UIView

- (instancetype)initSYCircleSegmentControl:(CGRect)frame
                                withTitles:(NSArray *)titles
                            withClickBlock:(SYCircleSegmentControlBlock)block;

- (void)updateLeftTitle:(NSString *)title;
- (void)updateRightTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
