//
//  SYPasswordInputView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/23.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SYPasswordInputViewDelegate <NSObject>

@optional
- (void)passwordInputViewDidEnterPassword:(NSString *)password;
- (void)passwordInputViewDidCancelEnter;

@end

@interface SYPasswordInputView : UIView

@property (nonatomic, weak) id <SYPasswordInputViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSString *password;

@end

NS_ASSUME_NONNULL_END
