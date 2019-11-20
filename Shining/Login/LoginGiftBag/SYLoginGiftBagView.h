//
//  SYLoginGiftBagView.h
//  Shining
//
//  Created by 杨玄 on 2019/8/16.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapLoginBlock)(void);

NS_ASSUME_NONNULL_BEGIN

// 未登录 - 礼包
@interface SYLoginGiftBagView : UIView

// init
- (instancetype)initWithFrame:(CGRect)frame withBlock:(tapLoginBlock)block;

// 礼物数据
- (void)updateGiftBags:(NSArray *)gifts;

@end

NS_ASSUME_NONNULL_END
