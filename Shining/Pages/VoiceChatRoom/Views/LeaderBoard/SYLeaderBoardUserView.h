//
//  SYLeaderBoardUserView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYLeaderBoardUserView : UIView

- (void)showWithRank:(NSInteger)rank
                name:(NSString *)name
              avatar:(NSString *)avatar
       isBroadcaster:(NSInteger)isBroadcaster
    broadcasterLevel:(NSInteger)broadcasterLevel
                 vip:(NSInteger)vip
              gender:(NSString *)gender
                 age:(NSInteger)age
                 sum:(NSString *)sum;

- (void)setAvatarSize:(CGSize)size
                 left:(CGFloat)left
               bottom:(CGFloat)bottom;

- (void)setNameColor:(UIColor *)color
            sumColor:(UIColor *)sumColor;

@end

NS_ASSUME_NONNULL_END
