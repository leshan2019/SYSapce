//
//  SYWebViewController.h
//  Shining
//
//  Created by mengxiangjian on 2019/5/13.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYWebViewController : UIViewController

- (instancetype)initWithURL:(NSString *)url;

- (instancetype)initWithURL:(NSString *)url andTitle:(NSString *)webtitle;

- (instancetype)initWithURL:(NSString *)url andTitle:(NSString *)title andRoomId:(NSString *)roomId;

- (void)rechargeCallbackMethod;
- (void)checkLogin;
- (void)openUserPageWithUid:(NSString *)uid;
- (void)receiveBeansWithBlock:(void (^)(BOOL, NSInteger))block;

@end

NS_ASSUME_NONNULL_END
