//
//  SYLoginViewController.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/6/19.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLoginViewController : UIViewController
- (instancetype)initWithTempToken:(NSString *)tempToken;
@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, assign)NSInteger vendor;  //第三方标识，1：微信 3:letv,默认为letv

@end

NS_ASSUME_NONNULL_END
