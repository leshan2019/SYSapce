//
//  SYMineIDCardNumberVC.h
//  Shining
//
//  Created by 杨玄 on 2019/3/29.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYMineIDCardNumberVCDelegate <NSObject>

- (void)saveIDCardNumber:(NSString *)number;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SYMineIDCardNumberVC : UIViewController

@property (nonatomic, weak) id<SYMineIDCardNumberVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
