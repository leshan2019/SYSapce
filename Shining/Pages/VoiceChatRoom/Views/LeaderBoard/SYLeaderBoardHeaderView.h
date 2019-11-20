//
//  SYLeaderBoardHeaderView.h
//  Shining
//
//  Created by mengxiangjian on 2019/4/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYLeaderBoardUserView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYLeaderBoardHeaderView : UICollectionReusableView

+ (CGSize)sizeForHeaderWithWidth:(CGFloat)width;

+ (CGFloat)firstUserTopWithWidth:(CGFloat)width;
+ (CGFloat)secondUserTopWithWidth:(CGFloat)width;
+ (CGFloat)thirdUserTopWithWidth:(CGFloat)width;

- (void)setImageName:(NSString *)imageName;
- (void)setMusicImageName:(NSString *)imageName;

- (void)setUserViews:(NSArray <SYLeaderBoardUserView *>*)userViews;

@end

NS_ASSUME_NONNULL_END
