//
//  SYTestWebViewController.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/5/31.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dsbridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYTestWebViewController : UIViewController <WKNavigationDelegate>
- (instancetype)initWithURL:(NSString *)url andTitle:(NSString *)title;

- (instancetype)initWithURL:(NSString *)url andTitle:(NSString *)title andRoomId:(NSString *)roomId;

- (void)rechargeCallbackMethod;
@end

NS_ASSUME_NONNULL_END
