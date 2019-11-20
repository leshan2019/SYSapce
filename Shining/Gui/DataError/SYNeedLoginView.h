//
//  SYNeedLoginView.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/24.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYNeedLoginView : UIView

- (instancetype)initWithFrame:(CGRect)frame withTipImage:(NSString *)image withTipStr:(NSString *)tip;

- (void)updateTipText:(NSString *)tipText;

-(void)updateForLoginTip:(nullable id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
