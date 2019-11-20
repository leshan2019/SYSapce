//
//  SYMyCoinViewController.h
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYMyCoinViewController : UIViewController

@property (nonatomic,copy) NSString *coin;
@property (nonatomic, strong) NSString *roomId; // 充值返点roomId
@property (nonatomic, copy) void (^resultBlock)(void);

/**
 初始化方法

 @param price 默认选择的价格
 @return 价格
 */
- (instancetype)initWithSelectPrice:(NSInteger)price;
- (void)requestMyCoin;

@end

NS_ASSUME_NONNULL_END
