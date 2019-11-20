//
//  SYLivingShowBeautifyViewController.h
//  Shining
//
//  Created by Zhang Qigang on 2019/9/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* SYFilterNullId;
@class SYLivingShowBeautifyViewController;

@protocol SYLivingShowBeautifyViewControllerDelegate <NSObject>
@optional
- (void) beautifyViewControllerClosed: (SYLivingShowBeautifyViewController*) controller;

- (CGFloat) beautifyViewControllerSmoother: (SYLivingShowBeautifyViewController*) controller;
- (CGFloat) beautifyViewControllerSlimming: (SYLivingShowBeautifyViewController*) controller;
- (CGFloat) beautifyViewControllerEyelid: (SYLivingShowBeautifyViewController*) controller;
- (CGFloat) beautifyViewControllerWhitening: (SYLivingShowBeautifyViewController*) controller;

- (NSString* _Nullable) beautifyViewControllerCurrentEffectId: (SYLivingShowBeautifyViewController*) controller;
- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setCurrentEffectId: (NSString* _Nullable) effectId;
- (CGFloat) beautifyViewController:(SYLivingShowBeautifyViewController*) controller effectValueForId: (NSString*) effectId;
- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller updateCurrentEffectId: (NSString*) effectId withValue: (CGFloat) effectValue;

- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setSmoother: (CGFloat) smoother;
- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setSlimming: (CGFloat) slimming;
- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setEyelid: (CGFloat) eyelid;
- (void) beautifyViewController: (SYLivingShowBeautifyViewController*) controller setWhitening: (CGFloat) whitening;
@end

@interface SYLivingShowBeautifyViewController : UIViewController
- (instancetype) initWithDelegate: (id<SYLivingShowBeautifyViewControllerDelegate>) delegate;
- (instancetype) init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
