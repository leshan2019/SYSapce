//
//  SYPersonHomepageFansView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapFansBlock)(NSString * _Nonnull userId);
typedef void(^TapArrowBlock)(void);

NS_ASSUME_NONNULL_BEGIN

/**
 *  粉丝贡献View
 */
@interface SYPersonHomepageFansView : UIView

- (instancetype)initFansContributionView:(CGRect)frame
                                tapFans:(TapFansBlock)tapFans
                                tapArrow:(TapArrowBlock)tapArrow;

- (void)updateFansView:(NSArray *)fansData;

@end

NS_ASSUME_NONNULL_END
