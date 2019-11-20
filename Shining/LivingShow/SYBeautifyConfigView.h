//
//  SYBeautifyConfigView.h
//  Shining
//
//  Created by Zhang Qigang on 2019/9/19.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
extern NSString* SYFilterNullId;

@protocol SYBeautifyConfigDelegate <NSObject>
@required
@property(nonatomic, assign) CGFloat smoother;
@property(nonatomic, assign) CGFloat slimming;
@property(nonatomic, assign) CGFloat eyelid;
@property(nonatomic, assign) CGFloat whitening;

@property(nonatomic, copy) NSString* _Nullable effectId;
- (CGFloat) valueForEffectId: (NSString*) effectId;
- (void) updateEffectValue: (CGFloat) value forEffectId: (NSString*) effectId;
@end


@interface SYBeautifyConfigView : UIView
@property (nonatomic, weak) id<SYBeautifyConfigDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
