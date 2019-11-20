//
//  SYDataEmptyView.h
//  Shining
//
//  Created by 杨玄 on 2019/3/30.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Bee语音 - 无数据提示
 */
@interface SYDataEmptyView : UIView

@property (strong, nonatomic, readonly) UILabel *tipLabel;

// init
- (instancetype)initWithFrame:(CGRect)frame
                 withTipImage:(NSString *)image
                    withTipStr:(NSString *)tip;

- (void)updateTipText:(NSString *)tipText;

- (void)updateForNoImage;

- (void)updataForBtn:(nullable id)target action:(SEL)action;

-(void)updateForLoginTip:(nullable id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
